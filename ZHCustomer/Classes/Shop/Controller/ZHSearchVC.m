//
//  ZHShopSearchVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/17.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHSearchVC.h"
#import "ZHShopCell.h"
#import "ZHShop.h"
#import "ZHGoodsModel.h"
//#import "ZHTreasureModel.h"
#import "ZHShopDetailVC.h"
//#import "ZHLookForTreasureCell.h"
#import "ZHGoodsDetailVC.h"
#import "ZHGoodsCell.h"

@interface ZHSearchVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

//搜索店铺结果
@property (nonatomic,strong) NSMutableArray <ZHShop *>*shops;

//普通商品搜索
@property (nonatomic,strong) NSMutableArray <ZHGoodsModel *>*goods;

//一元夺宝搜索
//@property (nonatomic,strong) NSMutableArray <ZHTreasureModel *>*treasures;

@property (nonatomic,strong) TLTableView *searchTableView;

@end


@implementation ZHSearchVC
- (void)loadView
{
    [super loadView];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    

    
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    searchBar.delegate = self;
    searchBar.backgroundColor = [UIColor zh_backgroundColor];
    searchBar.placeholder = @"输入关键字搜索";
    searchBar.barStyle = UIBarStyleDefault;
    searchBar.searchBarStyle = UISearchBarStyleProminent;
    [self.view addSubview:searchBar];
    [searchBar becomeFirstResponder];
    
    //
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40) delegate:self dataSource:self];
    [self.view addSubview:tableView];
//    tableView.backgroundColor = [UIColor whiteColor];
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无结果"];
    self.searchTableView = tableView;
    
    if (self.type == ZHSearchVCTypeShop) {
        
        self.title = @"店铺搜索";
        tableView.rowHeight = [ZHShopCell rowHeight];
        
    } else if(self.type == ZHSearchVCTypeYYDB) {
        
        self.title = @"夺宝搜索";
        tableView.rowHeight = 140;

        
    } else if(self.type == ZHSearchVCTypeDefaultGoods) { //店铺支付
        
        self.title = @"商品搜索";
        tableView.rowHeight = [ZHGoodsCell rowHeight];
        
    }
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    if (self.type == ZHSearchVCTypeShop) {
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808217";
        http.parameters[@"start"] = @"1";
        http.parameters[@"limit"] = @"10000";
        http.parameters[@"name"] = searchBar.text;
        http.parameters[@"status"] = @"2";
        if (self.lat) {
            http.parameters[@"longitude"] = self.lon;
            http.parameters[@"latitude"] = self.lat;
        }
        [http postWithSuccess:^(id responseObject) {
            
            self.shops = [ZHShop tl_objectArrayWithDictionaryArray:responseObject[@"data"][@"list"]];
            [self.searchTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];

        
    }  else if(self.type == ZHSearchVCTypeDefaultGoods) { //
        
        TLNetworking *http = [TLNetworking new];
        http.showView = self.view;
        http.code = @"808028";
        http.parameters[@"status"] = @"3";
        http.parameters[@"name"] = searchBar.text;
        http.parameters[@"start"] = @"1";
        http.parameters[@"limit"] = @"10000";
        http.isDeliverCompanyCode = NO;
        [http postWithSuccess:^(id responseObject) {
            
            self.goods = [ZHGoodsModel tl_objectArrayWithDictionaryArray:responseObject[@"data"]];
            [self.searchTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];


    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.type == ZHSearchVCTypeShop) {
        
        ZHShopDetailVC *detailVC = [[ZHShopDetailVC alloc] init];
        detailVC.shop = self.shops[indexPath.row];
        //
        [self.navigationController pushViewController:detailVC animated:YES];
        
        
    } else if(self.type == ZHSearchVCTypeYYDB) {
        
        
//        ZHGoodsDetailVC *vc = [[ZHGoodsDetailVC alloc] init];
//        vc.detailType = ZHGoodsDetailTypeLookForTreasure;
//        vc.treasure = self.treasures[indexPath.row];
//        [self.navigationController pushViewController:vc animated:YES];
        
    } else if(self.type == ZHSearchVCTypeDefaultGoods) { //
        
        
        ZHGoodsDetailVC *detailVC = [[ZHGoodsDetailVC alloc] init];
        detailVC.goods = self.goods[indexPath.row];
        detailVC.detailType = ZHGoodsDetailTypeDefault;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


#pragma mark- dasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.type == ZHSearchVCTypeShop) {
        
        
        return self.shops.count;

    } else  { //店铺搜索
        
        return self.goods.count;

    }
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (self.type == ZHSearchVCTypeShop) {
        
        static NSString *zhShopCellId = @"zhShopCellId";
        ZHShopCell *cell = [tableView dequeueReusableCellWithIdentifier:zhShopCellId];
        if (!cell) {
            
            cell = [[ZHShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhShopCellId];
            
        }
        cell.shop = self.shops[indexPath.row];
        return cell;
        
    }  else  { 
        
        static NSString *zhGoodsCellId = @"ZHGoodsCell";
        ZHGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:zhGoodsCellId];
        if (!cell) {
            
            cell = [[ZHGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhGoodsCellId];
            
        }
        cell.goods = self.goods[indexPath.row];
        return cell;
        
    }

}


@end
