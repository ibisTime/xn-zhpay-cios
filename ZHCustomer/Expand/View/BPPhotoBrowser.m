//
//  BPPhotoBrowser.m
//  MOOM
//
//  Created by 田磊 on 16/5/19.
//  Copyright © 2016年 田磊. All rights reserved.
//

#import "BPPhotoBrowser.h"
#import "UIImageView+WebCache.h"

@interface BPPhotoBrowser ()<UIScrollViewDelegate>

@property (nonatomic,weak) UIImageView *imageView;


//@property (nonatomic,weak) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic,weak) UIScrollView *myScrollView;
@end

@implementation BPPhotoBrowser

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        //
        UIScrollView *sv = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:sv];
        _myScrollView = sv;
        
        _myScrollView.minimumZoomScale = 1.0;
        _myScrollView.maximumZoomScale = 6.0;
        _myScrollView.delegate = self;
      
        UITapGestureRecognizer *tapBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBack)];
        [_myScrollView addGestureRecognizer:tapBack];
        
        //进度
       // XNProgressView *pv = [[XNProgressView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        //[self addSubview:pv];
       // pv.center = self.center;
        //_progressView = pv;
        
//        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] init];
//        activity.center = self.center;
//        _activityIndicatorView = activity;
//        [self insertSubview:_activityIndicatorView atIndex:0];
//        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        
        
        //
        UIImageView *iv = [[UIImageView alloc] init];
        iv.userInteractionEnabled = YES;
        _imageView = iv;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_myScrollView addSubview:iv];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_imageView addGestureRecognizer:tap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [_imageView addGestureRecognizer:doubleTap];
        
        //区别单击和双击
        [tap requireGestureRecognizerToFail:doubleTap];
        
    }
    
    return self;
    
}

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    
    NSURL *url = [NSURL URLWithString:_imageUrl];
//    [_activityIndicatorView startAnimating];
    
    [_imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"logo"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        // [_progressView removeFromSuperview];
        //        [_activityIndicatorView removeFromSuperview];
        CGFloat scale = image.size.height/image.size.width;
        
        _imageView.frame = CGRectMake(0, 0, self.width, self.width*scale);
        self.myScrollView.contentSize = _imageView.frame.size;
        
        [self contentInsert];
        
    }];
    
//    [_imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"logo"] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        
//       // _progressView.progress = receivedSize*1.00/expectedSize;
//        
//        
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//       // [_progressView removeFromSuperview];
////        [_activityIndicatorView removeFromSuperview];
//        CGFloat scale = image.size.height/image.size.width;
//        
//        _imageView.frame = CGRectMake(0, 0, self.width, self.width*scale);
//        self.myScrollView.contentSize = _imageView.frame.size;
//        
//        [self contentInsert];
//        
//    }];
    
    
}

- (void)setImage:(UIImage *)image {

    if (!image) {
        return;
    }
    
    _image = image;
    
    self.imageView.image = _image;
    
    CGFloat scale = image.size.height/image.size.width;
    
    _imageView.frame = CGRectMake(0, 0, self.width, self.width*scale);
    self.myScrollView.contentSize = _imageView.frame.size;
    
    [self contentInsert];
    
    
}

#pragma mark -- 手势方法
//点击背景退出
- (void)tapBack
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}

- (void)doubleTap:(UITapGestureRecognizer *)doubleTap
{

    if (self.myScrollView.zoomScale > 1) {
        
        [self.myScrollView setZoomScale:1 animated:YES];
        
    }else {
        
        CGRect zoomRect = [self zoomRectForScale:6 withCenter:[doubleTap locationInView:doubleTap.view]];
        //放大指定区域
        [self.myScrollView zoomToRect:zoomRect animated:YES];
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    //  sqrtf(scale)  求出放大区域的宽和高
    
    zoomRect.size.height = self.frame.size.height / sqrtf(scale);
    zoomRect.size.width  = self.frame.size.width  / sqrtf(scale);
    
    //求出放大区域的坐标原点
    zoomRect.origin.x   =   center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y   =   center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
    //  [self zoomToRect:zoomRect animated:YES];
}

//缩小
- (void)tap:(UITapGestureRecognizer *)tap
{

    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}

//放大
//- (void)doubleTap:(UITapGestureRecognizer *)doubleTap
//{
//    
////    [self setZoomScale:4 animated:YES];
////    float newScale = [self zoomScale] * 3;
//    CGRect zoomRect = [self zoomRectForScale:6 withCenter:[doubleTap locationInView:doubleTap.view]];
//    [self.myScrollView zoomToRect:zoomRect animated:YES];
//    
//}

#pragma mark -- scrollView  代理方法
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self contentInsert];
}

#pragma mark -- 调节contentSize始终居中显示
- (void)contentInsert
{
    
    CGRect frame = self.imageView.frame;
    
    CGFloat top = 0, left = 0;
    
    if (self.myScrollView.contentSize.width < self.myScrollView.bounds.size.width) {
        left = (self.bounds.size.width - self.myScrollView.contentSize.width) * 0.5f;
    }
    
    if (self.myScrollView.contentSize.height < self.myScrollView.bounds.size.height) {
        top = (self.bounds.size.height - self.myScrollView.contentSize.height) * 0.5f;
    }
    
    top = top - frame.origin.y;
    left = left - frame.origin.x;
    
    self.myScrollView.contentInset = UIEdgeInsetsMake(top, left, top, left);
}

@end

