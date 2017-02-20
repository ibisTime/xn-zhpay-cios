//
//  ChatManager.m
//  IMChat
//
//  Created by  tianlei on 2016/11/29.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ChatManager.h"

#import <HyphenateLite/HyphenateLite.h>
#import "EMCDDeviceManager.h"
//#import "ChatViewController.h"
#import "ConversationListVC.h"


#define IM_PWD @"888888"


NSString *const kKefuUnreadMsgKey = @"kKefuUnreadMsgKey";
NSString *const kKefuID = @"ioskefu";

NSString *const kUnreadMsgChangeNotification = @"setupUnreadMessageCountNotification";
NSString *const kKefuUnreadMsgChangeNotification = @"setupKefuUnreadMessageCountNotification_tl";



static ChatManager *manager = nil;
@interface ChatManager()<EMChatManagerDelegate>

+(instancetype)defaultManager;
@property (nonatomic,strong) NSDate *lastPlaySoundDate;

@end

@implementation ChatManager

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


+(instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ChatManager alloc] init];
        [[EMClient sharedClient].chatManager addDelegate:manager delegateQueue:nil];
        [[NSNotificationCenter defaultCenter] addObserver:manager selector:@selector(kefuUnreadMsgChange:) name:kKefuUnreadMsgChangeNotification object:nil];
    });
    
    return manager;
}

- (ConversationListVC *)conversationListVC
{
    if(!_conversationListVC){
    
        _conversationListVC = [[ConversationListVC alloc] init];
    }
    
    return _conversationListVC;
}

#pragma mark - 记录客服未读消息
- (void)kefuUnreadMsgChange:(NSNotification *)notification {

    self.isHaveKefuUnredMsg = [notification.userInfo[kKefuUnreadMsgKey] boolValue];
    
}

#pragma mark -  EMChatManagerDelegate
- (void)conversationListDidUpdate:(NSArray *)aConversationList{
    
    //处理未读消息
    [self.conversationListVC refreshAndSortView];
    //刷新会话列表
//  NSLog(@"收到了消息");

}

- (void)messagesDidReceive:(NSArray *)aMessages{

    BOOL isRefreshCons = YES;
    for(EMMessage *message in aMessages){//---------遍历开始

        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        
        //根据不同的状态，进行不同的行为
#if !TARGET_IPHONE_SIMULATOR
            switch (state) {
                case UIApplicationStateActive:
                    
                    [self playSoundAndVibration];  break;
                   
                case UIApplicationStateInactive:
                    [self playSoundAndVibration]; break;
                    
                case UIApplicationStateBackground:
                    
                    //push 推送暂时不实现
//                    [self showNotificationWithMessage:message];
                 break;
                   
                default:   break;
                   
            }
#endif
        
        //1. 应用在后台
        //2. 在前台，但是没有聊天
        //3. 正在聊天，但不是和消息所属人料
        //以上情况都需要产生未读消息
        BOOL background = state == UIApplicationStateBackground;
        BOOL foregroundChating = self.currentConversionId != nil;
        BOOL foregroundChatNotThisMan = message.conversationId != self.currentConversionId;
        
        if(background ||  !foregroundChating  || foregroundChatNotThisMan){
            
            break;
        }
        
        //4.前台与当前会话人聊天
        if(foregroundChating){
            isRefreshCons = NO;
        }
    
    }//----------遍历结束
    
    //需要刷新会话列表 并且处理未读消息
    if(isRefreshCons){
        //1.进行刷新操作
        [self.conversationListVC refreshAndSortView];
        //2.处理未读消息
        [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMsgChangeNotification object:nil];
    }
    
}

//构造透传消息
//SDK 提供的一种特殊类型的消息，即 CMD，不会存 db，也不会走 APNS 推送，类似一种指令型的消息。比如您的服务器要通知客户端做某些操作，您可以服务器和客户端提前约定好某个字段，当客户端收到约定好的字段时，执行某种特殊操作。

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < 3.0) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
    
}

- (BOOL)loginWithUserName:(NSString *)userName {

  return  [self loginWithUserName:userName pwd:IM_PWD];

}

- (BOOL)loginWithUserName:(NSString *)userName pwd:(NSString *)password{

    EMError *error = [[EMClient sharedClient] loginWithUsername:userName password:password];
    
    if(!error){
        
        [[EMClient sharedClient].options setIsAutoLogin:YES];
        
        //获取数据库 会话缓存???? 是应该异步获取吗
        [self getAllConversionFromDB];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMsgChangeNotification object:nil];
        
        return YES;
        
    } else {
        
        switch (error.code)
        {
            case EMErrorNetworkUnavailable:
                NSLog(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                break;
            case EMErrorServerNotReachable:
                NSLog(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                break;
            case EMErrorUserAuthenticationFailed:
                
                NSLog(@"%@",error.errorDescription);
                break;
                
            case EMErrorServerTimeout:
                NSLog(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                break;
            case EMErrorServerServingForbidden:
                NSLog(NSLocalizedString(@"servingIsBanned", @"Serving is banned"));
                break;
            default:
                NSLog(NSLocalizedString(@"login.fail", @"Login failure"));
                break;
        }

    
        return NO;

    }
    
}

- (void)chatLoginOut{
    
    self.conversationListVC = nil;
    self.currentConversionId = nil;
    self.isHaveKefuUnredMsg = NO;
    [[EMClient sharedClient] logout:YES];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}


- (NSInteger)unreadMsgCount{

    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;

    }
    return unreadCount;
}

- (void)getAllConversionFromDB{
    
  NSArray *array = [[EMClient sharedClient].chatManager getAllConversations];
//    NSArray *array = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    
    [array enumerateObjectsUsingBlock:^(EMConversation *conversation, NSUInteger idx, BOOL *stop){
        
        if(conversation.latestMessage == nil){
            
         [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId isDeleteMessages:NO completion:nil];
        }
        
    }];

}

@end
