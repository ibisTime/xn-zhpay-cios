//
//  ZHDBBrowserCoreView.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/28.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHDBBrowserCoreView.h"
#import "ZHAwardAnnounceView.h"

@interface ZHDBBrowserCoreView()

@property (nonatomic, strong) NSMutableArray <ZHAwardAnnounceView *>*awardViewRooms;

@end

@implementation ZHDBBrowserCoreView

- (NSMutableArray<ZHAwardAnnounceView *> *)awardViewRooms {
    
    if (!_awardViewRooms) {
        
        _awardViewRooms = [[NSMutableArray alloc] initWithCapacity:3];
    }
    
    return _awardViewRooms;
    
}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.awardViewRooms = [[NSMutableArray alloc] initWithCapacity:3];
        for (NSInteger i = 0; i < 3 ; i++) {
            
            CGFloat x = 0;
            CGFloat y = i*(15 + 6);
            
            ZHAwardAnnounceView *awardV = [[ZHAwardAnnounceView alloc] initWithFrame:CGRectMake(x, y, self.width, 15)];
            [self.awardViewRooms addObject:awardV];
            
        }
        
        
    }
    
    return self;

}



- (void)setHistoryModels:(NSMutableArray<ZHDBHistoryModel *> *)historyModels {

    _historyModels = historyModels;
    
    [self.awardViewRooms makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [_historyModels enumerateObjectsUsingBlock:^(ZHDBHistoryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //
        ZHAwardAnnounceView *announceView = self.awardViewRooms[idx];
        
        announceView.typeLbl.text = [obj getNowResultName];
        announceView.contentLbl.attributedText = [obj getNowResultContent];
        [self addSubview:announceView];
        
    }];
}

@end
