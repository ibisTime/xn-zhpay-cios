//
//  ZHShoppingCartVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/28.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHShoppingCartVC.h"
#import "ZHShoppingCartCell.h"
#import "ZHCartGoodsModel.h"
#import "ZHImmediateBuyVC.h"
#import "ZHCartManager.h"

@interface ZHShoppingCartVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TLTableView *shoopingCartTableV;
@property (nonatomic,strong) UIView *clearingView;
@property (nonatomic,strong) NSMutableArray <ZHCartGoodsModel *>*items;
@property (nonatomic,assign) BOOL isAll;
@property (nonatomic,strong) UILabel *totalPriceLbl;
@property (nonatomic,strong) UIButton *chooseAllBtn;

@property (nonatomic,assign) BOOL isFirst;

@end

@implementation ZHShoppingCartVC

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)deleteGoods:(ZHCartGoodsModel *)item {

    
    [TLAlert alertWithTitle:nil Message:@"您确定删除该商品" confirmMsg:@"删除" CancleMsg:@"取消" cancle:^(UIAlertAction *action) {
        
    } confirm:^(UIAlertAction *action) {
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808041";
//        http.parameters[@"code"] = item.code;
        http.parameters[@"token"] = [ZHUser user].token;
        http.parameters[@"cartCodeList"] = @[item.code];
        [http postWithSuccess:^(id responseObject) {
            
            [TLAlert alertWithHUDText:@"删除成功"];
            
            [self.items removeObject:item];
            [self.shoopingCartTableV reloadData_tl];
            [self caluateTotalMoney];
            
            //
            [ZHCartManager manager].count = [ZHCartManager manager].count - [item.quantity integerValue];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];


}

- (void)buy { //购买
    
    //遍历选中商品
    NSMutableArray <ZHCartGoodsModel *>*goods = [NSMutableArray array];
    [self.items enumerateObjectsUsingBlock:^(ZHCartGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            
            [goods addObject:obj];
            
        }
    }];
    
    if (goods.count <= 0) {
        [TLAlert alertWithMsg:@"您还未选择商品"];
        return;
    }
    
    ZHImmediateBuyVC *imvc = [[ZHImmediateBuyVC alloc] init];
    imvc.type = ZHIMBuyTypeAll;
    imvc.cartGoodsRoom = goods;
    imvc.placeAnOrderSuccess = ^(){
    
      __block  NSInteger count = 0;
        [goods enumerateObjectsUsingBlock:^(ZHCartGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            count += [obj.quantity integerValue];
            
        }];
        
        [ZHCartManager manager].count = [ZHCartManager manager].count - count;
//        [goods[0].quantity integerValue];
        
    };
    imvc.priceAttr = self.totalPriceLbl.attributedText;
    [self.navigationController pushViewController:imvc animated:YES];
    
}

#pragma mark- 商品数量改变触发的时间
- (void)countChange {
    
    [self caluateTotalMoney];

}

- (void)caluateTotalMoney {

    //1.全选
    //3.删除商品
    //2.更该商品数量
    
    //计算全部商品总价 3种币
   __block  long qbb = 0;
   __block  long gwb = 0;
   __block  long rmb = 0;
    
    //
   [self.items enumerateObjectsUsingBlock:^(ZHCartGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       if (obj.isSelected) {
           
           qbb += obj.totalQBB;
           gwb += obj.totalGWB;
           rmb += obj.totalRMB;
           
       }
   
    }];
    //

//    NSString *qbbStr ;
//    NSString *gwbStr ;
//    NSString *rmbStr ;
//
//    if (qbb != 0) {
//        qbbStr = [NSString stringWithFormat:@"%.f",qbb/1000.0];
//    }
//    
//    if (rmb != 0) {
//        rmbStr = [NSString stringWithFormat:@"%.f",rmb/1000.0];
//    }
//    
//    if (gwb != 0) {
//        gwbStr = [NSString stringWithFormat:@"%.f",gwb/1000.0];
//    }
    
    self.totalPriceLbl.attributedText = [ZHCurrencyHelper totalPriceAttr2WithQBB:@(qbb) GWB:@(gwb) RMB:@(rmb) bouns:CGRectMake(0, -3, 15, 15)];
    
//    [ZHCurrencyHelper totalPriceAttrWithQBB:qbbStr GWB:gwbStr RMB:rmbStr bouns:CGRectMake(0, -3, 15, 15)];
    
}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if (self.isFirst) {
        
        [self.shoopingCartTableV beginRefreshing];
        self.isFirst = NO;
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购物车";
    self.isAll = NO;
    self.isFirst = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countChange) name:kSelectedCartGoodsCountChangeNotification object:nil];
    //
    TLTableView *tableView = [TLTableView groupTableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    self.shoopingCartTableV = tableView;
    tableView.rowHeight = [ZHShoppingCartCell rowHeight];
    //结算相关
    [self.view addSubview:self.clearingView];
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"购物车还没有商品"];
    
    //
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"808045"; //分页查询
    helper.limit = 30;
    helper.parameters[@"userId"] = [ZHUser user].userId;
    helper.parameters[@"token"] = [ZHUser user].token;

    helper.tableView = self.shoopingCartTableV;
    [helper modelClass:[ZHCartGoodsModel class]];
    
    //
    __weak typeof(self) weakSelf = self;
    [self.shoopingCartTableV addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.items = objs;
            [weakSelf.shoopingCartTableV reloadData_tl];
            [weakSelf caluateTotalMoney];

            
        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.shoopingCartTableV addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.items = objs;
            [weakSelf.shoopingCartTableV reloadData_tl];
            [weakSelf caluateTotalMoney];

        } failure:^(NSError *error) {
            
            
        }];
        
    }];
    
    [self.shoopingCartTableV endRefreshingWithNoMoreData_tl];
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"innerSelectedChange" object:nil userInfo:@{
                                                                                                            @"sender": [tableView cellForRowAtIndexPath:indexPath]                                                            }];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    return self.buyerItems.count;
    return _items.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakself = self;
    static NSString *zhShoppingCartCell = @"ZHShoppingCartCellID";
    ZHShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:zhShoppingCartCell];
    if (!cell) {
        
        cell = [[ZHShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhShoppingCartCell];
        
        //删除的选项
        cell.deleteFromCart = ^(ZHCartGoodsModel *item){
        
            [weakself deleteGoods:item];
        };
    }
    cell.item = self.items[indexPath.row];
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}


- (UIView *)clearingView {
    
    if (!_clearingView) {
        
        _clearingView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49 - 64, SCREEN_WIDTH, 49)];
        _clearingView.backgroundColor = [UIColor whiteColor];
        UIButton *chooseAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 20, 20)];
        [chooseAllBtn setImage:[UIImage imageNamed:@"address_unselected"] forState:UIControlStateNormal];
        [chooseAllBtn addTarget:self action:@selector(chooseAll) forControlEvents:UIControlEventTouchUpInside];
        chooseAllBtn.centerY = _clearingView.height/2.0;
        [_clearingView addSubview:chooseAllBtn];
        self.chooseAllBtn = chooseAllBtn;
        
        //
        UILabel *hintLbl = [UILabel labelWithFrame:CGRectMake(chooseAllBtn.xx + 10, 0, 40, _clearingView.height) textAligment:NSTextAlignmentLeft backgroundColor:[UIColor whiteColor] font:[UIFont secondFont] textColor:[UIColor zh_textColor]];
        [_clearingView addSubview:hintLbl];
        hintLbl.text = @"全选";
        hintLbl.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseAll)];
        [hintLbl addGestureRecognizer:tap];
        
        
        //结算按钮
        UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(_clearingView.width - 120, 0, 120, _clearingView.height)
                                                       title:@"结算"
                                             backgroundColor:[UIColor zh_themeColor]];
        [_clearingView addSubview:clearBtn];
        [clearBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
        
        //
        UILabel *moneyLbl = [UILabel labelWithFrame:CGRectZero
                                       textAligment:NSTextAlignmentLeft
                                    backgroundColor:[UIColor whiteColor]
                                               font:FONT(15)
                                          textColor:[UIColor zh_themeColor]];
        [_clearingView addSubview:moneyLbl];
        moneyLbl.numberOfLines = 0;
        
        self.totalPriceLbl = moneyLbl;
        [moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(hintLbl.mas_right);
            make.top.equalTo(_clearingView.mas_top);
            make.bottom.equalTo(_clearingView.mas_bottom);
            make.right.equalTo(clearBtn.mas_left).offset(-5);
        }];
        
    }
    
    return _clearingView;
    
}

#pragma mark- 全选 按时舍去
- (void)chooseAll {

    if (self.isAll) {

     [self.chooseAllBtn setImage:[UIImage imageNamed:@"address_unselected"] forState:UIControlStateNormal];

    } else {

      [self.chooseAllBtn setImage:[UIImage imageNamed:@"address_selected"] forState:UIControlStateNormal];

    }
    self.isAll = !self.isAll;
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelectedAllCartGoodsNotification object:self userInfo:@{
                                                                                                                        @"isAll" : @(self.isAll)}];
    [self caluateTotalMoney];
    
}


@end
