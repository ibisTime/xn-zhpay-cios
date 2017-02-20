//
//  TLImagePicker.h
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/16.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLImagePicker : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,copy)  void(^pickFinish)(NSDictionary *info);

- (instancetype)initWithVC:(UIViewController *)ctrl;
@property (nonatomic,assign) BOOL allowsEditing;

- (void)picker;

@end
