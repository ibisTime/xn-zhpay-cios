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
#import "ZHPayVC.h"
#import "ZHNewPayVC.h"
#import "ZHShareView.h"
#import "ZHUserLoginVC.h"
#import "ZHDBHistoryModel.h"
#import "ZHDBHistoryRecordVC.h"
#import "AppConfig.h"
#import "TLHTMLStrVC.h"
#import <WebKit/WebKit.h>


NSString * const kRefreshDBListNotificationName = @"kRefreshDBListNotificationName";

@interface ZHDuoBaoDetailVC ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate>

@property (nonatomic, strong) TLBannerView *bannerView;

@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *numberLbl;

@property (nonatomic, strong) ZHProgressView *progressView;

@property (nonatomic, strong) UILabel *maxNumLbl; //最大 数目
@property (nonatomic, strong) UILabel *totalCountLbl; //总需
@property (nonatomic, strong) UILabel *surplusCountLbl; //剩余
@property (nonatomic, strong) ZHStepView *countChangeView; //剩余

@property (nonatomic, strong) TLTableView *detailTableView; //剩余
@property (nonatomic, strong) UILabel *advText;

@property (nonatomic,strong) UIView *recordHeaderView;
@property (nonatomic,strong) UILabel *timeLbl;
@property (nonatomic,strong) UIView *buyToolView;
@property (nonatomic,strong) UILabel *totalPriceLbl;
@property (nonatomic, assign) BOOL isFirst;
//@property (nonatomic, assign) NSInteger start;

@property (nonatomic, strong) NSMutableArray <ZHDBHistoryModel *>*dbHistoryRooms;


@end


@implementation ZHDuoBaoDetailVC

- (void)dealloc {


}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    if (self.isFirst) {
        
       [self loadMoreRecorder];
        self.isFirst = NO;
        
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirst = YES;
    
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    self.detailTableView = tableView;
    tableView.rowHeight = 145;
    tableView.backgroundColor = [UIColor zh_backgroundColor];
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无商品"];
    
    
    __weak typeof(self) weakSelf = self;
    //刷新控件
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"615025";
    helper.parameters[@"jewelCode"] = self.dbModel.code;
//    helper.parameters[@"start"] = [NSString stringWithFormat:@"%ld",self.start];
//    helper.parameters[@"limit"] = @"20";
    helper.parameters[@"status"] = @"payed";
    
    helper.tableView = tableView;
    [helper modelClass:[ZHDBHistoryModel class]];
    
    //
    
    [self.detailTableView addRefreshAction:^{
        
        //刷新详情
        [weakSelf refreshDetail];
        
        //历史记录查询
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
           weakSelf.dbHistoryRooms = objs;
           [weakSelf.detailTableView reloadData];
               
        } failure:^(NSError *error) {
            
            
        }];
        
    }];

    
    [self.detailTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.dbHistoryRooms = objs;
            [weakSelf.detailTableView reloadData];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    

    
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
       weakself.totalPriceLbl.attributedText = [ZHCurrencyHelper totalRMBWithPrice:weakself.dbModel.price count:count];
    
    };
    
    __weak ZHStepView *weakSelfCountChangeView = self.countChangeView;
    
    self.countChangeView.buyAllAction = ^(){
    
//        NSInteger count = [weakself.dbModel getSurplusPeople];
//        weakself.countChangeView.count = count;
        weakself.totalPriceLbl.attributedText = [ZHCurrencyHelper totalRMBWithPrice:weakself.dbModel.price count:weakSelfCountChangeView.count];
        
    };
    
    [self data];
    self.totalPriceLbl.attributedText = [ZHCurrencyHelper totalRMBWithPrice:weakself.dbModel.price count:1];
    

}

- (NSMutableArray<ZHDBHistoryModel *> *)dbHistoryRooms {

    if (!_dbHistoryRooms) {
        
        _dbHistoryRooms = [[NSMutableArray alloc] init];
        
    }
    return _dbHistoryRooms;

}

#pragma mark - 刷新详情
- (void)refreshDetail {

    __weak typeof(self) weakSelf = self;
    //加载 -- 夺宝详情
    TLNetworking *http = [TLNetworking new];
    http.code = @"615016";
    http.parameters[@"code"] = self.dbModel.code;
    [http postWithSuccess:^(id responseObject) {
        
        self.dbModel = [ZHDBModel tl_objectWithDictionary:responseObject[@"data"]];
//        [weakSelf.detailTableView endRefreshHeader];
        [weakSelf data];
        
    } failure:^(NSError *error) {
        
//        [weakSelf.detailTableView endRefreshHeader];
        
        
    }];
}

#pragma mark- 获得参与记录
- (void)loadMoreRecorder {

    __weak typeof(self) weakSelf = self;
    
    TLNetworking *http = [TLNetworking new];
    http.code = @"808315";
    http.parameters[@"jewelCode"] = self.dbModel.code;
    http.parameters[@"start"] = @"1";
    http.parameters[@"limit"] = @"20";
    http.parameters[@"status"] = @"payed";
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *arr = responseObject[@"data"][@"list"];
        if (arr.count > 0) {
           
            [weakSelf.dbHistoryRooms addObjectsFromArray:[ZHDBHistoryModel tl_objectArrayWithDictionaryArray:arr]];
            
            weakSelf.timeLbl.text = [weakSelf.dbHistoryRooms[0].investDatetime convertToDetailDate];
            

            [weakSelf.detailTableView endRefreshFooter];
            [weakSelf.detailTableView reloadData];
//            self.start ++;
            
        } else {
        
           [weakSelf.detailTableView endRefreshingWithNoMoreData_tl];

        }
        
        
    } failure:^(NSError *error) {
        
        [weakSelf.detailTableView endRefreshFooter];
//        [weakSelf.detailTableView reloadData];
        
        
    }];

}


//-----//
- (void)data {

    NSArray <NSString *>*shortUrls = [self.dbModel.advPic componentsSeparatedByString:@"||"];
    NSMutableArray <NSString *>*longUrls = [[NSMutableArray alloc] initWithCapacity:shortUrls.count];
    [shortUrls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
      [longUrls addObject: [obj convertImageUrl]];
        
    }];
    self.bannerView.imgUrls = longUrls;
    
//  @[@"http://pic.35pic.com/normal/09/36/49/4499633_230627095337_2.jpg"];
    
    
    //计算单人最大投资
    self.countChangeView.maxCount = [self.dbModel.maxNum integerValue] < [self.dbModel getSurplusPeople] ? [self.dbModel.maxNum integerValue] : [self.dbModel getSurplusPeople];
    
    self.priceLbl.text = [self.dbModel getPriceDetail];
    self.advText.text =  self.dbModel.slogan;
    
    self.numberLbl.text = [NSString  stringWithFormat:@"期号: %@",self.dbModel.periods];
    
    self.progressView.progress  = [self.dbModel getProgress];
    
//    self.totalCountLbl.text = [NSString stringWithFormat:@"总需 %@ 人次",self.dbModel.totalNum];
//
//    self.surplusCountLbl.text = [NSString stringWithFormat:@"剩余 %ld",[self.dbModel getSurplusPeople]];
    

    NSString *animStr = [NSString stringWithFormat:@"总需 %@ 人次",self.dbModel.totalNum];
    self.totalCountLbl.attributedText = [self convertStrWithStr:animStr value:@{NSForegroundColorAttributeName : [UIColor zh_themeColor]} range:NSMakeRange(3, [NSString stringWithFormat:@"%@",self.dbModel.totalNum].length)];
    
    //单人最大投资
    NSString *maxStr = [NSString stringWithFormat:@"%@",self.dbModel.maxNum];
    
    self.maxNumLbl.attributedText = [self convertStrWithStr:[NSString stringWithFormat:@"单人最大投资 %@ 次",maxStr] value:@{NSForegroundColorAttributeName : [UIColor zh_themeColor]}
                                                      range:NSMakeRange(7, maxStr.length)];
    
    self.surplusCountLbl.attributedText =  [self convertStrWithStr:[NSString stringWithFormat:@"剩余 %ld",[self.dbModel getSurplusPeople]] value:@{NSForegroundColorAttributeName : [UIColor zh_themeColor]}
                                                                                       range:NSMakeRange(3, [NSString stringWithFormat:@"%ld",[self.dbModel getSurplusPeople]].length)];

}

- (NSMutableAttributedString *)convertStrWithStr:(NSString *)str value:(NSDictionary <NSString *, id>*)keyAttrValue range:(NSRange )range {

    
    NSMutableAttributedString *attrstr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrstr addAttributes:keyAttrValue range:range];
    
    return attrstr;

}

#pragma mark- 分享
- (void)share {

    ZHShareView *shareView = [[ZHShareView alloc] init];
    shareView.wxShare = ^(BOOL isSuccess, int code){
    
        if (isSuccess) {
            
          [TLAlert alertWithHUDText:@"分享成功"];

        }
        
    };
    
    shareView.title = @"小目标大玩法";
    shareView.content = @"正汇钱包邀您一元夺宝";
    shareView.shareUrl = [NSString stringWithFormat:@"%@/share/share-db.html?code=%@",[AppConfig config].shareBaseUrl,self.dbModel.code];
    
    [shareView show];
    

}

#pragma mark- 购买行为
- (void)buyAction {

    if (![ZHUser user].isLogin) {
        
        ZHUserLoginVC *loginVC = [[ZHUserLoginVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        loginVC.loginSuccess = ^(){
        };
        return;
    }
    
    //mask
    UIControl *maskCtrl = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [maskCtrl addTarget:self action:@selector(deleteMask:) forControlEvents:UIControlEventTouchUpInside];
    maskCtrl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
    [[UIApplication sharedApplication].keyWindow addSubview:maskCtrl];
    
    //title
    UILabel *titleLbl = [UILabel labelWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 30)
                                          textAligment:NSTextAlignmentCenter
                                       backgroundColor:[UIColor clearColor]
                                                  font:FONT(17)
                                             textColor:[UIColor whiteColor]];
    titleLbl.text = @"免责声明";
    [maskCtrl addSubview:titleLbl];
    
    //webView
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    http.code = @"807717";
    http.parameters[@"ckey"] = @"treasure_statement";
    
    [http postWithSuccess:^(id responseObject) {
        
        WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
        
        WKWebView *webV = [[WKWebView alloc] initWithFrame:CGRectMake(0, titleLbl.yy + 20, SCREEN_WIDTH, SCREEN_HEIGHT - titleLbl.yy - 85 - 20 - 35) configuration:webConfig];
        [maskCtrl addSubview:webV];
        webV.backgroundColor = [UIColor clearColor];
        webV.opaque = NO;
        webV.navigationDelegate = self;
        NSString *styleStr = @"<style type=\"text/css\"> *{color:white; font-size:30px;}</style>";
        NSString *htmlStr = responseObject[@"data"][@"note"];
        [webV loadHTMLString:[NSString stringWithFormat:@"%@%@",htmlStr,styleStr] baseURL:nil];
        
    } failure:^(NSError *error) {
        
    }];
    
    
    UIButton *readBtn = [UIButton zhBtnWithFrame:CGRectMake(20, SCREEN_HEIGHT - 85, SCREEN_WIDTH - 40, 45) title:@"我已阅读"];
    [readBtn addTarget:self action:@selector(readed:) forControlEvents:UIControlEventTouchUpInside];
    [maskCtrl addSubview:readBtn];
    

}


- (void)readed:(UIButton *)btn {

    [(UIControl *)btn.nextResponder removeFromSuperview];
    
//    ZHPayVC *payVC = [[ZHPayVC alloc] init];
//    payVC.type = ZHPayVCTypeNewYYDB;

    ZHNewPayVC *payVC = [[ZHNewPayVC alloc] init];
    payVC.type = ZHPayViewCtrlTypeNewYYDB;
    
    self.dbModel.count = self.countChangeView.count;
    payVC.dbModel = self.dbModel;
    payVC.amoutAttr = self.totalPriceLbl.attributedText; //展示
    payVC.orderAmount = @([self.dbModel.price longLongValue]*self.countChangeView.count);
    payVC.paySucces = ^(){
        
        //刷新详情
        [self.detailTableView beginRefreshing];
        //刷新外部列表
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshDBListNotificationName object:nil];
        

    };
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:payVC];
    
    [self presentViewController:nav animated:YES completion:nil];


}

- (void)deleteMask:(UIControl *)ctrl {

    [ctrl removeFromSuperview];

}


#pragma mark- delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            TLHTMLStrVC *vc = [[TLHTMLStrVC alloc] init];
            vc.type = ZHHTMLTypeDBIntroduce;
            vc.title = @"玩法介绍";
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {
        
            ZHDBHistoryRecordVC *vc = [[ZHDBHistoryRecordVC alloc] init];
            vc.dbModel = self.dbModel;
            [self.navigationController pushViewController:vc animated:YES];
        }

    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark- web代理
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [TLAlert alertWithHUDText:@"加载失败"];
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
        UILabel *priceLbl = [UILabel labelWithFrame:CGRectMake(hintLbl.xx + 0, 0, SCREEN_WIDTH - hintLbl.xx - 0 - buyBtn.width, _buyToolView.height)
                                      textAligment:NSTextAlignmentLeft
                                   backgroundColor:[UIColor clearColor]
                                              font:FONT(16)
                                         textColor:[UIColor zh_textColor]];
        [_buyToolView addSubview:priceLbl];
        self.totalPriceLbl = priceLbl;
        
   
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - buyBtn.width, 1)];
        line.backgroundColor = [UIColor zh_lineColor];
        [_buyToolView addSubview:line];
 
        
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

#pragma mark- 头部
- (void)tableViewHeaderView {

#warning - 该处
    UIView *headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225 + SCREEN_WIDTH*1.0/1.553)];
    headerBgView.backgroundColor = [UIColor whiteColor];
    self.detailTableView.tableHeaderView = headerBgView;
    
    
    //轮播图
    TLBannerView *bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*1.0/1.553)];
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
    
    //描述语
    self.advText = [UILabel labelWithFrame:CGRectZero
                               textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                                       font:FONT(14)
                                  textColor:[UIColor zh_textColor]];
    [headerBgView addSubview:self.advText];
    [self.advText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBgView.mas_left).offset(15);
        make.top.equalTo(self.priceLbl.mas_bottom).offset(20);
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
        make.top.equalTo(self.advText.mas_bottom).offset(20);
//        make.right.lessThanOrEqualTo();
        
    }];
    
    
    //单人最大投资
    self.maxNumLbl = [UILabel labelWithFrame:CGRectZero
                                textAligment:NSTextAlignmentRight
                             backgroundColor:[UIColor whiteColor]
                                        font:FONT(13)
                                   textColor:[UIColor colorWithHexString:@"#999999"]];
    [headerBgView addSubview:self.maxNumLbl];
    [self.maxNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(headerBgView.mas_right).offset(-15);
        make.top.equalTo(self.numberLbl.mas_top);
        
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
        make.left.equalTo(self.progressView.mas_left);
        make.top.equalTo(self.progressView.mas_bottom).offset(8);
        make.height.mas_equalTo([[UIFont systemFontOfSize:12] lineHeight]);
//        make.right.lessThanOrEqualTo(self.surplusCountLbl);
    }];

    
    [self.surplusCountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.totalCountLbl);
        make.top.equalTo(self.progressView.mas_bottom).offset(8);
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
//        make.bottom.equalTo(headerBgView.mas_bottom).offset(-20);
    }];
    
    //
    
}

#pragma mark- dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 0 ? 2 :  self.dbHistoryRooms.count;

    
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    return indexPath.section == 0 ? 45 : 50;
//
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return indexPath.section == 0 ? 45 : 67;
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
    
    cell.historyModel = self.dbHistoryRooms[indexPath.row];
    
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
