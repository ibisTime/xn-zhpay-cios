//
//  ZHShopTypeDisplayView.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/4/1.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHShopTypeDisplayView.h"

#define MARGIN 1

@interface ZHShopTypeDisplayView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation ZHShopTypeDisplayView

- (instancetype)init
{
    self = [super init];
    if (self) {
        CGFloat margin = 1;
        
        CGFloat w = (SCREEN_WIDTH - 3*margin)/4.0;
        
        CGFloat selfHeight = 2*margin + margin + 2*w;
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, selfHeight);
        self.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        
        //
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(w, w);
        
        flowLayout.minimumLineSpacing = margin;
        flowLayout.minimumInteritemSpacing = margin;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        //
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, margin, self.width, self.height - 2*margin) collectionViewLayout:flowLayout];
        [self addSubview:collectionView];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        
        
        //注册cell
        [collectionView registerClass:[ZHShopDisplayCell class] forCellWithReuseIdentifier:@"ZHShopDisplayCellID"];
        
    }
    return self;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 3;

}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    ZHShopDisplayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZHShopDisplayCellID" forIndexPath:indexPath];
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage new]];
    cell.nameLbl.text = @"美食";
    
    return cell;
}

@end





//cell
@implementation ZHShopDisplayCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //
        self.iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconImageView];
        self.backgroundColor = [UIColor whiteColor];
        
        //
        self.nameLbl = [UILabel labelWithFrame:CGRectZero
                                  textAligment:NSTextAlignmentCenter
                               backgroundColor:[UIColor clearColor]
                                          font:[UIFont thirdFont]
                                     textColor:[UIColor zh_textColor]];
        [self.contentView addSubview:self.nameLbl];
        
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(45);
            make.top.equalTo(self.contentView.mas_top).offset(14);
            make.centerX.equalTo(self.contentView.mas_centerX);

        }];
        
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.iconImageView.mas_bottom).offset(7);
            make.left.right.equalTo(self.contentView);
            
        }];
        
        
    }
    return self;
}


//UIButton *funcBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 14, 45, 45)];
//[bgView addSubview:funcBtn];
//funcBtn.centerX = bgView.width/2.0;
//[funcBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
//[funcBtn addTarget:self action:@selector(selectedAction) forControlEvents:UIControlEventTouchUpInside];
//
//CGFloat h = [[UIFont thirdFont] lineHeight];
//UILabel *nameLbl = [UILabel labelWithFrame:CGRectMake(0, funcBtn.yy + 7, bgView.width, h) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:[UIFont thirdFont] textColor:[UIColor zh_textColor]];
//nameLbl.centerX = funcBtn.centerX;
//nameLbl.text = funcName;
//[bgView addSubview:nameLbl];

@end
