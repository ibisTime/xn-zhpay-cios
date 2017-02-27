//
//  TLHTMLStrVC.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/27.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>




typedef NS_ENUM(NSUInteger, ZHHTMLType) {
    ZHHTMLTypeAboutUs = 0,
    ZHHTMLTypeRegProtocol,
    ZHHTMLTypeDBIntroduce,
    ZHHTMLTypeSendBrebireMoneyIntroduce,
    ZHHTMLTypeShakeItOfIntroduce
};

@interface TLHTMLStrVC : UIViewController

@property (nonatomic, assign) ZHHTMLType type;


@end
