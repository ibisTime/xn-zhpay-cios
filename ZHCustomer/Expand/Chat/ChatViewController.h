/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#define KNOTIFICATIONNAME_DELETEALLMESSAGE @"RemoveAllMessages"

#import "EaseMessageViewController.h"

@interface ChatViewController : EaseMessageViewController <EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>

@property (nonatomic,copy) NSString *oppositeAvatarUrlPath;
@property (nonatomic,copy) NSString *mineAvatarUrlPath;

//默认用户图片
@property (nonatomic,copy) NSString *defaultUserAvatarName;

//客服模式
//@property (nonatomic, assign) BOOL isKefu;


- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType;


@end
