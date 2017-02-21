//
//  ZHDuoBaoDetailVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/21.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHDuoBaoDetailVC.h"
#import "ZHProgressView.h"
#import "ZHStepView.h"
#import "ZHDuoBaoInfoCell.h"
#import "ZHDuoBaoRecordCell.h"
#import "ZHIntroduceVC.h"


@interface ZHDuoBaoDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TLBannerView *bannerView;

@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *numberLbl;

@property (nonatomic, strong) ZHProgressView *progressView;
@property (nonatomic, strong) UILabel *totalCountLbl; //总需
@property (nonatomic, strong) UILabel *surplusCountLbl; //剩余
@property (nonatomic, strong) ZHStepView *countChangeView; //剩余

@property (nonatomic, strong) TLTableView *detailTableView; //剩余

@property (nonatomic,strong) UIView *recordHeaderView;
@property (nonatomic,strong) UILabel *timeLbl;

@property (nonatomic,strong) UIView *buyToolView;

@property (nonatomic,strong) UILabel *totalPriceLbl;

@end


@implementation ZHDuoBaoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    self.detailTableView = tableView;
    tableView.rowHeight = 145;
    tableView.backgroundColor = [UIColor zh_backgroundColor];
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无商品"];
    
    //底部工具栏
//    ZHBuyToolView *buyToolView = [[ZHBuyToolView alloc] initWithFrame:CGRectMake(0, tableView.yy, SCREEN_WIDTH, 49)];
//    buyToolView.type = ZHBuyTypeLookForTreasure;
    
    self.buyToolView.y = tableView.yy;
    [self.view addSubview:self.buyToolView];
    
    
    //头部
    [self tableViewHeaderView];
    
    //
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
                                               
    //
    __weak typeof(self) weakself = self;
    self.countChangeView.countChange = ^(NSUInteger count){
    
        //
       weakself.totalPriceLbl.text = @"开始计算价格";
    
    };
    
    self.countChangeView.buyAllAction = ^(){
    
        weakself.totalPriceLbl.text = @"买光";

    };
    
    [self data];
    
}

//-----//
- (void)data {

    self.bannerView.imgUrls = @[@"http://pic.35pic.com/normal/09/36/49/4499633_230627095337_2.jpg"];
    self.priceLbl.text = @"1000分润";
    self.numberLbl.text = @"期号：382409283094";
    self.progressView.progress  = 0.433;
    self.totalCountLbl.text = @"总需100人次";
    self.surplusCountLbl.text = @"剩余 20";
    

}

#pragma mark- 分享
- (void)share {

    

}

//购买行文
- (void)buyAction {

    self.totalPriceLbl.text = @"点击购买";

}
#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            ZHIntroduceVC *vc = [[ZHIntroduceVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {
        
        
        }

    }

}

- (UIView *)buyToolView {

    if (!_buyToolView) {
        
        _buyToolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - 49, SCREEN_WIDTH, 49)];
        _buyToolView.backgroundColor = [UIColor whiteColor];
        
//        //
        UILabel *hintLbl = [UILabel labelWithFrame:CGRectMake(15, 0, 50, _buyToolView.height)
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor whiteColor]
                                          font:FONT(16)
                                     textColor:[UIColor zh_textColor]];
        [_buyToolView addSubview:hintLbl];
        hintLbl.text = @"金额:";
//        [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_buyToolView.mas_left).offset(15);
//            make.height.equalTo(_buyToolView.mas_height);
//            
//        }];
//
        //按钮
        UIButton *buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 135, 0, 135, _buyToolView.height) title:@"参与" backgroundColor:[UIColor zh_themeColor]];
        [_buyToolView addSubview:buyBtn];
        [buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
        
//        //价格
        UILabel *priceLbl = [UILabel labelWithFrame:CGRectMake(hintLbl.xx + 22, 0, SCREEN_WIDTH - hintLbl.xx - 22 - buyBtn.width, _buyToolView.height)
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor clearColor]
                                              font:FONT(16)
                                         textColor:[UIColor zh_textColor]];
        [_buyToolView addSubview:priceLbl];
        self.totalPriceLbl = priceLbl;
        
   
        
//        //约束
//        [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(hintLbl.mas_right).offset(22);
//            make.top.equalTo(_buyToolView.mas_top);
//            make.bottom.equalTo(_buyToolView.mas_bottom);
//            make.right.equalTo(buyBtn.mas_left);
//        }];
//        
//        [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.top.bottom.equalTo(_buyToolView);
//            make.width.mas_equalTo(135);
//            make.left.equalTo(_buyToolView.mas_right);
//            
//        }];
        
        
    }

    return _buyToolView;
}

- (UIView *)recordHeaderView {

    if (!_recordHeaderView) {
        
        _recordHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        _recordHeaderView.backgroundColor = [UIColor whiteColor];
        
        //title'
       UILabel *titleLbl  = [UILabel labelWithFrame:CGRectMake(15, 0, 100, 45)
                                  textAligment:NSTextAlignmentLeft
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(16)
                                     textColor:[UIColor zh_textColor]];
        [_recordHeaderView addSubview:titleLbl];
        titleLbl.text = @"所有参与记录";

        
        //时间
        self.timeLbl = [UILabel labelWithFrame:CGRectMake(titleLbl.xx, 0, SCREEN_WIDTH - titleLbl.xx - 15, _recordHeaderView.height)
                                  textAligment:NSTextAlignmentRight
                               backgroundColor:[UIColor clearColor]
                                          font:FONT(12)
                                     textColor:[UIColor colorWithHexString:@"#999999"]];
        [_recordHeaderView addSubview:self.timeLbl];
        self.timeLbl.text = @"2017-33-23 :开始";

        
        
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(_recordHeaderView.mas_right).offset(-15);
            make.left.equalTo(titleLbl.mas_right);
            make.centerY.equalTo(_recordHeaderView.mas_centerY);
            
        }];
        //
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor zh_lineColor];
        [_recordHeaderView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_recordHeaderView.mas_left);
            make.width.equalTo(_recordHeaderView.mas_width);
            make.height.mas_equalTo(@(LINE_HEIGHT));
            make.bottom.equalTo(_recordHeaderView.mas_bottom);
        }];
        
    }
    
    return _recordHeaderView;
    
}

- (void)tableViewHeaderView {

    UIView *headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400)];
    headerBgView.backgroundColor = [UIColor whiteColor];
    self.detailTableView.tableHeaderView = headerBgView;
    
    
    //轮播图
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.52)];
    self.bannerView = bannerView;
    [headerBgView addSubview:bannerView];
    
    //底线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, bannerView.yy, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor zh_lineColor];
    [headerBgView addSubview:line];
    
    //价格
    self.priceLbl = [UILabel labelWithFrame:CGRectZero
                                textAligment:NSTextAlignmentLeft
                             backgroundColor:[UIColor whiteColor]
                                        font:FONT(16)
                                   textColor:[UIColor zh_themeColor]];
    [headerBgView addSubview:self.priceLbl];
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBgView.mas_left).offset(15);
        make.top.equalTo(line.mas_bottom).offset(20);
        make.right.lessThanOrEqualTo(headerBgView.mas_right).offset(-15);
        
    }];
    
    //期号
    self.numberLbl = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(13)
                                  textColor:[UIColor colorWithHexString:@"#999999"]];
    [headerBgView addSubview:self.numberLbl];
    [self.numberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLbl.mas_left);
        make.top.equalTo(self.priceLbl.mas_bottom).offset(20);
        
    }];
    
    //进度条
    self.progressView = [[ZHProgressView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    [headerBgView addSubview:self.progressView];
    self.progressView.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
     self.progressView.forgroundView.backgroundColor = [UIColor zh_themeColor];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLbl.mas_left);
        make.right.equalTo(headerBgView.mas_right).offset(-15);

        make.top.equalTo(self.numberLbl.mas_bottom).offset(8);
        make.height.mas_equalTo(10);
    }];

    //总需
    self.totalCountLbl = [UILabel labelWithFrame:CGRectZero
                                textAligment:NSTextAlignmentLeft
                             backgroundColor:[UIColor whiteColor]
                                        font:FONT(12)
                                   textColor:[UIColor colorWithHexString:@"#999999"]];
    [headerBgView addSubview:self.totalCountLbl];
    
    //剩余
    self.surplusCountLbl = [UILabel labelWithFrame:CGRectZero
                                    textAligment:NSTextAlignmentRight
                                 backgroundColor:[UIColor whiteColor]
                                            font:FONT(12)
                                       textColor:[UIColor colorWithHexString:@"#999999"]];
    [headerBgView addSubview:self.surplusCountLbl];
    
    [self.totalCountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLbl.mas_left);
        make.top.equalTo(self.progressView.mas_bottom).offset(8);
        make.right.lessThanOrEqualTo(self.surplusCountLbl);
    }];

    
    [self.surplusCountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.totalCountLbl);
        make.top.equalTo(self.totalCountLbl);
        make.right.equalTo(self.progressView.mas_right);
    }];
    
    //数量选择
    ZHStepView *stepV = [[ZHStepView alloc] initWithFrame:CGRectZero type:ZHStepViewTypeDefault];
    self.countChangeView = stepV;
    [headerBgView addSubview:self.countChangeView];
    [self.countChangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.priceLbl.mas_left);
        make.top.equalTo(self.totalCountLbl.mas_bottom).offset(25);
        make.width.mas_equalTo(@280);
        make.height.mas_equalTo(@25);
        make.bottom.equalTo(headerBgView.mas_bottom).offset(-25);
    }];
    
    //
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 0 ? 2 : 10;

}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    return indexPath.section == 0 ? 45 : 50;
//
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return indexPath.section == 0 ? 45 : 64;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
       
        static NSString *zhDuoBaoInfoCell = @"zhDuoBaoInfoCellID";
        ZHDuoBaoInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:zhDuoBaoInfoCell];
        if (!cell) {
            
            cell = [[ZHDuoBaoInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhDuoBaoInfoCell];
            
        }
        cell.textLbl.text = indexPath.row == 0 ? @"玩法介绍" : @"往期揭晓";
        return cell;
    }
    
    
    static NSString *zhDuoBaoRecordCell = @"zhDuoBaoRecordCellId";
    ZHDuoBaoRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:zhDuoBaoRecordCell];
    if (!cell) {
        
        cell = [[ZHDuoBaoRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhDuoBaoRecordCell];
        
    }
    return cell;
    

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? 10 : 45;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 10 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 1) {
        return self.recordHeaderView;
    }
    
    return nil;
}

@end
