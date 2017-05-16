//
//  ZHChatVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHChatVC.h"
#import "ChatViewController.h"
#import "ChatManager.h"
#import "ZHSegmentView.h"
#import "ZHChatUserCell.h"
#import "ZHChatMerchantCell.h"
#import "ZHReferralModel.h"

@interface ZHChatVC ()<UITableViewDelegate,UITableViewDataSource,ZHSegmentViewDelegate>

@property (nonatomic, strong) TLTableView *userTableV;
@property (nonatomic, strong) TLTableView *merchantTableV;
@property (nonatomic, strong) UIScrollView *switchScrollView;
@property (nonatomic, strong)  NSMutableArray <ZHReferralModel *>*userRoom;
@property (nonatomic, strong) UIView *kefuUnreadMsgHintView;
@property (nonatomic, copy) NSArray <EMConversation *>*conversations;

@property (nonatomic,assign) BOOL isFirst;

@end

@implementation ZHChatVC

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.isFirst = YES;
    self.title = @"聊聊";
    
    UIImageView *kefuImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 23)];
    kefuImageV.userInteractionEnabled = YES;
    kefuImageV.contentMode = UIViewContentModeCenter;
    
    
    CGFloat hintW = 10;
    UIView *hintView = [[UIView alloc] init];
    hintView.backgroundColor = [UIColor redColor];
    hintView.layer.cornerRadius = hintW/2.0;
    hintView.layer.masksToBounds = YES;
    [kefuImageV addSubview:hintView];
    self.kefuUnreadMsgHintView = hintView;
    self.kefuUnreadMsgHintView.hidden = YES;
    
    [hintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(hintW);
        make.height.mas_equalTo(hintW);
        make.right.equalTo(kefuImageV.mas_right);
        make.top.equalTo(kefuImageV.mas_top);
    }];
    
    
    kefuImageV.image = [UIImage imageNamed:@"客服"];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:kefuImageV];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goKefu)];
    [kefuImageV addGestureRecognizer:tap];
    
    
//    UIView *kefuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 23)];
//    kefuView.backgroundColor = [UIColor orangeColor];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:kefuView];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"客服"] style:UIBarButtonItemStylePlain target:self action:@selector(goKefu)];
    
    self.conversations = [[EMClient sharedClient].chatManager getAllConversations];
    
    //
//    ZHSegmentView *segmentV = [[ZHSegmentView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 45)];
//    [self.view addSubview:segmentV];
//    segmentV.delegate = self;
//    segmentV.tagNames = @[@"推荐的好友",@"推荐的商家"];
    
    UIScrollView *switchScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64 - 49)];
    [self.view addSubview:switchScrollV];
    switchScrollV.scrollEnabled = NO;
    switchScrollV.contentSize = CGSizeMake(SCREEN_WIDTH, switchScrollV.height);
    self.switchScrollView = switchScrollV;
    
    //用户的tableView
    self.userTableV = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, switchScrollV.height) delegate:self dataSource:self];
    [switchScrollV addSubview:self.userTableV];
    self.userTableV.rowHeight = [ZHChatUserCell rowHeight];
    
    //商家的tableView
//    self.merchantTableV = [TLTableView tableViewWithframe:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, switchScrollV.height) delegate:self dataSource:self];
//    [switchScrollV addSubview:self.merchantTableV];
//    self.merchantTableV.rowHeight = [ZHChatMerchantCell rowHeight];

    // -1上级 -2上上级  1.下级 2. 下下级
    
    __weak typeof(self) weakself = self;
    [self.userTableV addRefreshAction:^{
        
        TLNetworking *http = [TLNetworking new];
        http.code = @"805157";
        http.parameters[@"userId"] = [ZHUser user].userId;
        
        [http postWithSuccess:^(id responseObject) {
            
            NSArray *arr = responseObject[@"data"];
            weakself.userRoom = [ZHReferralModel tl_objectArrayWithDictionaryArray:arr];
            
            //为列表对象，找出会话对象
//            [weakself.userRoom enumerateObjectsUsingBlock:^(ZHReferralModel * _Nonnull user, NSUInteger idx, BOOL * _Nonnull stop) {
//                
//                [weakself.conversations enumerateObjectsUsingBlock:^(EMConversation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    
//                    if ([[user.userId lowercaseString] isEqualToString:obj.conversationId]) {
//                        *stop = YES;
//                        
//                        user.conversion = obj;
//                    }
//                    
//                }];
//                
//            }];
            
            //根据列表用户找出--会话场景
            [weakself getConversionByListUser];

            [weakself.userTableV reloadData_tl];
            [weakself.userTableV endRefreshHeader];
            
            
        } failure:^(NSError *error) {
            
            [weakself.userTableV endRefreshHeader];

        }];
        
    }];
    
    //用户登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuccess) name:kUserLoginNotification object:nil];

    //用户退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOut) name:kUserLoginOutNotification object:nil];
    
    //消息变更的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unReadMsgChange) name:kUnreadMsgChangeNotification object:nil];
    
    //客服消息变更
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kefuUnreadMsgChange:) name:kKefuUnreadMsgChangeNotification object:nil];
    
}


#pragma mark - 客服消息变更
- (void)kefuUnreadMsgChange:(NSNotification *)notification {
    
    self.kefuUnreadMsgHintView.hidden = ![notification.userInfo[kKefuUnreadMsgKey] boolValue];
    
}



- (void)unReadMsgChange {
    
    self.conversations = [[EMClient sharedClient].chatManager getAllConversations];

    //根据列表用户找出，
//    [self.userRoom enumerateObjectsUsingBlock:^(ZHReferralModel * _Nonnull user, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        [self.conversations enumerateObjectsUsingBlock:^(EMConversation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
////            NSLog(@"%@ %@",user.userId,obj.conversationId);
//            
//            if ([[user.userId lowercaseString] isEqualToString:obj.conversationId]) {
//                *stop = YES;
//                
//                user.conversion = obj;
//            }
//            
//        }];
//        
//    }];
    
    [self getConversionByListUser];

    [self.userTableV reloadData];

}

#pragma mark-
//进入客服也会触发消息改变事件
- (void)getConversionByListUser {

    self.conversations = [[EMClient sharedClient].chatManager getAllConversations];

    
    __weak typeof(self) weakSelf = self;
    [weakSelf.userRoom enumerateObjectsUsingBlock:^(ZHReferralModel * _Nonnull user, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [weakSelf.conversations enumerateObjectsUsingBlock:^(EMConversation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //            NSLog(@"%@ %@",user.userId,obj.conversationId);
            
            if ([[user.userId lowercaseString] isEqualToString:obj.conversationId]) {
                *stop = YES;
                
                user.conversion = obj;
            }
            
        }];
        
    }];
    
   //后台查询有无客服消息,处理客服消息的额外逻辑
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
       
       [weakSelf.conversations enumerateObjectsUsingBlock:^(EMConversation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           //            NSLog(@"%@ %@",user.userId,obj.conversationId);
//           TLLog(@"%@",obj.conversationId);
           
//           BOOL hasUnreadMsg = obj.unreadMessagesCount > 0; //有客服未读消息
//           BOOL lastHasKefuMsg = [ChatManager defaultManager].isHaveKefuUnredMsg;
//           
//           if (!((hasUnreadMsg && !lastHasKefuMsg) || (!hasUnreadMsg && lastHasKefuMsg))) {
//               return ;
//           }
 
           
          dispatch_async(dispatch_get_main_queue(), ^{
              
              if([obj.conversationId isEqualToString:kKefuID]) {
                  
                  if (obj.unreadMessagesCount > 0) {
                      [[NSNotificationCenter defaultCenter] postNotificationName:kKefuUnreadMsgChangeNotification object:nil userInfo:@{
                                                                                                                                        
                                                                                                                                        kKefuUnreadMsgKey : @(YES)
                                                                                                                                        }];
                      
                  } else {
                      
                      [[NSNotificationCenter defaultCenter] postNotificationName:kKefuUnreadMsgChangeNotification object:nil userInfo:@{
                                                                                                                                        
                                                                                                                                        kKefuUnreadMsgKey : @(NO)
                                                                                                                                        }];
                      
                  }
                  
              }

              
          });
           
           
       }];
       
       
   });


}

- (void)userLoginOut {

    
    self.userRoom = nil;
    self.conversations = nil;
    [self.userTableV beginRefreshing];

}

- (void)userLoginSuccess {

    self.userRoom = nil;
    self.conversations = nil;
    [self.userTableV reloadData_tl];
    [self.userTableV beginRefreshing];

}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    if (self.isFirst) {
        
        [self.userTableV beginRefreshing];
        self.isFirst = NO;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if ([tableView isEqual:self.userTableV]) { //用户
//        
//        return 3;
//    } else { //商家
//    
//        return 4;
//
//    }
    
    return self.userRoom.count;
}


- (BOOL)segmentSwitch:(NSInteger)idx {

    [self.switchScrollView setContentOffset:CGPointMake(idx*SCREEN_WIDTH, 0)];
    return YES;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        if ([tableView isEqual:self.userTableV]) { //用户
            
           return [ZHChatUserCell celllWithTableView:tableView indexPath:indexPath model:self.userRoom[indexPath.row]];
            
        } else { //商家
            
           return [ZHChatMerchantCell celllWithTableView:tableView indexPath:indexPath model:@""];
            
        }


}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ZHReferralModel *model = self.userRoom[indexPath.row];
    ChatViewController *vc = [[ChatViewController alloc] initWithConversationChatter:model.userId conversationType:EMConversationTypeChat];
    
    vc.title = model.nickname;
    vc.defaultUserAvatarName = @"user.png";
    if ([ZHUser user].userExt.photo) {
        
        vc.mineAvatarUrlPath = [[ZHUser user].userExt.photo convertThumbnailImageUrl];
        
    }
    
    vc.oppositeAvatarUrlPath =  [self.userRoom[indexPath.row].userExt[@"photo"] convertThumbnailImageUrl]? :nil;
    
    [self.navigationController pushViewController:vc animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMsgChangeNotification object:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    //防止环信登录失败
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[ChatManager defaultManager] loginWithUserName:[ZHUser user].userId];
        
    });
    
    //
    
    //
}


- (void)goKefu {

    ChatViewController *vc = [[ChatViewController alloc] initWithConversationChatter:kKefuID conversationType:EMConversationTypeChat];
    vc.title = @"客服";
    
    vc.defaultUserAvatarName = @"user.png";
    if ([ZHUser user].userExt.photo) {
        
         vc.mineAvatarUrlPath = [[ZHUser user].userExt.photo convertThumbnailImageUrl];
    }
   
    [self.navigationController pushViewController:vc animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMsgChangeNotification object:nil];

}

@end
