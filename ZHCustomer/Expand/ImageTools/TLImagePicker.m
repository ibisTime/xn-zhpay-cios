//
//  TLImagePicker.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/16.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLImagePicker.h"
#import <AVFoundation/AVFoundation.h>
#import "TLHeader.h"
#import <Photos/Photos.h>

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@interface TLImagePicker ()

@property (nonatomic,strong) UIViewController *vc;

@end

@implementation TLImagePicker

- (instancetype)initWithVC:(UIViewController *)ctrl{

    if (self = [super init]) {
        
        self.vc = ctrl;
        
    }
    return self;

}

- (void)picker {
    

    
    
    UIImagePickerController *pickCtrl = [[UIImagePickerController alloc] init];
    pickCtrl.delegate = self;
    pickCtrl.allowsEditing = self.allowsEditing;
    
    UIAlertController *chooseImageCtrl = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action00 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            //无权限
            [TLAlert alertWithTitle:nil Message:@"没有权限访问您的相机,请在设置中打开" confirmMsg:@"设置" CancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                
            } confirm:^(UIAlertAction *action) {
                
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
                
            }];
            
            return ;
        }
        
        pickCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.vc presentViewController:pickCtrl animated:YES completion:nil];
        
    }];
    
    UIAlertAction *action01 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
     
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        if (status == PHAuthorizationStatusDenied) {
            
            [TLAlert alertWithTitle:nil Message:@"没有权限访问您的相册,请在设置中打开" confirmMsg:@"设置" CancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                
            } confirm:^(UIAlertAction *action) {
                
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
                
            }];
            
            return ;
        }
        
        pickCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.vc presentViewController:pickCtrl animated:YES completion:nil];

        
    }];
    
    UIAlertAction *action02 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [chooseImageCtrl addAction:action00];
    [chooseImageCtrl addAction:action01];
    [chooseImageCtrl addAction:action02];
    [self.vc presentViewController:chooseImageCtrl animated:YES completion:nil];

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.pickFinish) {
        _pickFinish(info);
    }
}


@end
