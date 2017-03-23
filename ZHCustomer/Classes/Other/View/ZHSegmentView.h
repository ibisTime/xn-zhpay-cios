//
//  ZHSegmentView.h
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/30.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZHSegmentViewDelegate <NSObject>

- (BOOL)segmentSwitch:(NSInteger)idx;

@end

@interface ZHSegmentView : UIView

@property (nonatomic,copy) NSArray *tagNames;
@property (nonatomic,weak) id<ZHSegmentViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;

//更新tagName
- (void)reloadTagNameWithArray:(NSArray *)tagNames;
//@property (nonatomic,copy) BOOL (^switchAction)(NSInteger idx);

@end
