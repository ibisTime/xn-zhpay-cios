//
//  ConversationListVC.m
//  IMChat
//
//  Created by  tianlei on 2016/11/29.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ConversationListVC.h"
#import "EaseMessageViewController.h"
#import "ChatViewController.h"
#import "ChatManager.h"


@interface ConversationListVC ()<EaseConversationListViewControllerDelegate,EaseConversationListViewControllerDataSource>

@end

@implementation ConversationListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [ChatManager defaultManager].conversationListVC = self;
    
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    [self tableViewDidTriggerHeaderRefresh];
    
}

#pragma mark -  点击会 话列表 的回调
- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel{

    if(conversationModel){
        EMConversation *conversation =  conversationModel.conversation;
        
        if(conversation){
            

     //chatView 父类中将未读消息置为已读
     ChatViewController *chatController = [[ChatViewController alloc]
                                           initWithConversationChatter:conversation.conversationId
                                           conversationType:conversation.type];
            
            chatController.title = conversationModel.title;
            //设置头像
            chatController.defaultUserAvatarName = @"xiaomi.png";
            chatController.mineAvatarUrlPath = @"http://v1.qzone.cc/avatar/201404/10/09/30/5345f41e670ec580.jpg%21200x200.jpg";
            
            //对方的？？？？
            if(conversationModel.avatarURLPath || conversationModel.avatarURLPath.length > 0){
                
                chatController.oppositeAvatarUrlPath = conversationModel.avatarURLPath;

            }
            
            [self.navigationController pushViewController:chatController animated:YES];
            
        }
    
        //改变未读消息
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCountNotification" object:nil];
        
        //如果该会话有未读消息，刷新列表
        [self.tableView reloadData];
    
    }

}


#pragma mark -获取数据源
- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation
{
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    
    //思路1，从服务端获取，配合本地数据库缓存 缺点不及时
    //思路2，夹在消息中的ext,及时。不用配合本地数据库
    //选择思路2
    if(conversation.ext){
    //把ext 带有的用户信息存到数据库
        
    }
    
    
    
    //根据conversion 的 ext属性,获取用户的 头像 和昵称 这个需要事先约定好
    model.avatarURLPath = @"http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg";
    //对方昵称
    
    model.avatarImage = [UIImage imageNamed:@"xiaomi.png"];
    model.title = conversation.conversationId;
    return model;
    
}


- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.type == EMConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations isDeleteMessages:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
