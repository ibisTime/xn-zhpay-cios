//
//  ZHAddressChooseVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/29.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHAddressChooseVC.h"
#import "ZHAddressCell.h"
#import "ZHAddAddressVC.h"

NSString *const kEditCurrentChooseAddressSuccess = @"kEditCurrentChooseAddressSuccess";

@interface ZHAddressChooseVC ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) TLTableView *addressTableView;
@property (nonatomic,strong) NSMutableArray <ZHReceivingAddress *>*addressRoom;


@end

@implementation ZHAddressChooseVC

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    if (!self.addressRoom) {
        
        [self.addressTableView beginRefreshing];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收货地址";
    TLTableView *addressTableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) delegate:self dataSource:self];
    [self.view addSubview:addressTableView];
    self.addressTableView = addressTableView;
    addressTableView.rowHeight = 140;
    addressTableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无收货地址"];
    //增加
    UIButton *addBtn = [UIButton zhBtnWithFrame:CGRectZero title:@"添加新地址"];
    addBtn.layer.cornerRadius = 0;
    addBtn.titleLabel.font = FONT(18);
    [self.view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(@49);
        
    }];
    
    
        [addressTableView addRefreshAction:^{
            
            TLNetworking *http = [TLNetworking new];
            http.code = @"805165";
            http.parameters[@"userId"] = [ZHUser user].userId;
            http.parameters[@"token"] = [ZHUser user].token;
            //    http.parameters[@"isDefault"] = @"0"; //是否为默认收货地址
            [http postWithSuccess:^(id responseObject) {
                
                [self.addressTableView endRefreshHeader];

                NSArray *adderssRoom = responseObject[@"data"];
                
                self.addressRoom = [ZHReceivingAddress tl_objectArrayWithDictionaryArray:adderssRoom];

                if (self.selectedAddrCode) {
                    [self.addressRoom enumerateObjectsUsingBlock:^(ZHReceivingAddress * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.code isEqualToString:self.selectedAddrCode]) {
                            
                            obj.isSelected = YES;
                        }
                        
                    }];
                } else {
                
                    [self.addressRoom enumerateObjectsUsingBlock:^(ZHReceivingAddress * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                            obj.isSelected = NO;
                        
                    }];
                }
                
                
                [self.addressTableView reloadData_tl];
                
            } failure:^(NSError *error) {
                
                [self.addressTableView endRefreshHeader];
                
            }];
            
        }];
    
}

- (void)addAddress {

    
    ZHAddAddressVC *address = [[ZHAddAddressVC alloc] init];
    address.addAddress = ^(ZHReceivingAddress *address){
        
        if (self.isDisplay) {//个人主页进入的界面
            
            [self.addressTableView beginRefreshing];

        } else {
        
            address.isSelected = NO;
//            [self.addressRoom addObject:address];
            [self.addressTableView beginRefreshing];

            
        }

    };
    [self.navigationController pushViewController:address animated:YES];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.addressRoom.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 10;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isDisplay) {
        
        
        return;
    }

    ZHReceivingAddress *selectedAddr = self.addressRoom[indexPath.section];
    
//    if (selectedAddr.isSelected == YES) {
//        
//        
//    } else {
    
    [self.addressRoom enumerateObjectsUsingBlock:^(ZHReceivingAddress *addr, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (![addr isEqual:selectedAddr]) {
                addr.isSelected = NO;
            }
            
     }];
     selectedAddr.isSelected = YES;
     if (self.chooseAddress) {
            
         self.chooseAddress(selectedAddr);
            
      }
    
//    }
 
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhAddressCellId = @"ZHAddressCellId";
    ZHAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:zhAddressCellId];
    if (!cell) {
        
        cell = [[ZHAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhAddressCellId];
        cell.isDisplay = self.isDisplay;
        
        __weak typeof(self) weakSelf = self;
        cell.deleteAddr = ^(UITableViewCell *cell){
        
            NSInteger idx = [tableView indexPathForCell:cell].section;
            [TLAlert alertWithTitle:nil Message:@"确认删除该收货地址" confirmMsg:@"删除" CancleMsg:@"取消" cancle:^(UIAlertAction *action) {
                
            } confirm:^(UIAlertAction *action) {
                
                TLNetworking *http = [TLNetworking new];
                http.showView = self.view;
                http.code = @"805161";
                http.parameters[@"code"] = weakSelf.addressRoom[idx].code;
                http.parameters[@"token"] = [ZHUser user].token;
                [http postWithSuccess:^(id responseObject) {
                    
                    [TLAlert alertWithHUDText:@"删除成功"];
                    
                    [self.addressRoom removeObjectAtIndex:idx];
                    [weakSelf.addressTableView reloadData_tl];
                    
                } failure:^(NSError *error) {
                    
                }];

                
            }];
        
        };
        
        cell.editAddr = ^(UITableViewCell *cell){
        
            
            NSInteger idx = [tableView indexPathForCell:cell].section;
            ZHAddAddressVC *editAddVC = [[ZHAddAddressVC alloc] init];
            editAddVC.address = weakSelf.addressRoom[idx];
            
            editAddVC.editSuccess = ^(ZHReceivingAddress *address){
            
                if ([address.code isEqualToString:self.selectedAddrCode]) {
                    //通知界面切换
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kEditCurrentChooseAddressSuccess object:nil userInfo:@{@"key" : address }];

                }
                [weakSelf.addressTableView beginRefreshing];
                
            };
            
            [weakSelf.navigationController pushViewController:editAddVC animated:YES];
            
        };
    }
    cell.address = self.addressRoom[indexPath.section];
    return cell;

}


@end
