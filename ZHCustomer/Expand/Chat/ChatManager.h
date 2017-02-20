//
//  ChatManager.h
//  IMChat
//
//  Created by  tianlei on 2016/11/29.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChatViewController;
@class ConversationListVC;
@class EMError;

//#define UNREAD_MSG_COUNT_CHANGE_NOTIFICATION @"setupUnreadMessageCountNotification"


@interface ChatManager : NSObject

+(instancetype)defaultManager;

//当前会话Id
@property (nonatomic,copy) NSString *currentConversionId;

@property (nonatomic,strong) ConversationListVC *conversationListVC;
@property (nonatomic,assign) BOOL isHaveKefuUnredMsg;


//登录为同步
- (BOOL)loginWithUserName:(NSString *)userName;
- (BOOL )loginWithUserName:(NSString *)userName pwd:(NSString *)password;

- (void)chatLoginOut;
- (void)getAllConversionFromDB;

- (NSInteger)unreadMsgCount;

@end

//未读消息的Key     BOOL -- Value
FOUNDATION_EXTERN NSString *const kKefuUnreadMsgKey;
FOUNDATION_EXTERN NSString *const kKefuID;


//未读消息变化的通知--
FOUNDATION_EXTERN NSString *const kUnreadMsgChangeNotification;
FOUNDATION_EXTERN NSString *const kKefuUnreadMsgChangeNotification;



