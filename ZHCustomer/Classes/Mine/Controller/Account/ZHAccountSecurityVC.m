//
//  ZHAccountSecurityVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/28.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHAccountSecurityVC.h"
#import "ZHChangeMobileVC.h"
#import "ZHPwdRelatedVC.h"
#import "ChatManager.h"
#import "ZHRealNameAuthVC.h"
#import "ZHChangeNickNameVC.h"

#define LEFT_W 100
@interface ZHAccountSecurityVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *names;

@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *mobileLbl;
@property (nonatomic,strong) UILabel *realNameLbl;


@end

@implementation ZHAccountSecurityVC
- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户安全";
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:tableV];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.backgroundColor = [UIColor zh_backgroundColor];
    
    self.names = @[@"昵称",@"手机号",@"实名认证",@"修改登录密码",@"支付密码"];
    
    self.nameLbl.text = [ZHUser user].nickname;
    self.mobileLbl.text = [ZHUser user].mobile;
    if ([ZHUser user].realName) {
        
      self.realNameLbl.text = [ZHUser user].realName;

    }
    
    //退出登录按钮
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    
    UIButton *loginOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 44) title:@"退出登录" backgroundColor:[UIColor whiteColor]];
    [bgView addSubview:loginOutBtn];
    [loginOutBtn setTitleColor:[UIColor zh_themeColor] forState:UIControlStateNormal];
    [loginOutBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];

    tableV.tableFooterView = bgView;
    
    //用户信息变更
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserInfoChange object:nil];
    //用户登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo) name:kUserLoginNotification object:nil];
}


- (void)changeInfo {

    self.nameLbl.text = [ZHUser user].nickname;
    self.mobileLbl.text = [ZHUser user].mobile;
    self.realNameLbl.text = [ZHUser user].realName;

}
//---//---//
- (void)loginOut {

    [[ZHUser user] loginOut];
    [[ChatManager defaultManager] chatLoginOut];

    [self.navigationController popToRootViewControllerAnimated:YES ];


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginOutNotification object:nil];
//        UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//        tab.selectedIndex = 2;
        
    });
    

    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
        case 0: {
            
            ZHChangeNickNameVC *nickNameVC = [[ZHChangeNickNameVC alloc] init];
            [self.navigationController pushViewController:nickNameVC animated:YES];
        
        }
            
            break;
        case 1:{
            
            ZHChangeMobileVC *mobileVc = [[ZHChangeMobileVC alloc] init];
            mobileVc.changeMobileSuccess = ^(NSString *mobile){
                
                self.mobileLbl.text = mobile;
                
            };
            [self.navigationController pushViewController:mobileVc animated:YES];
        
        }
            
            break;
        case 2:{ //实名认证
        
            ZHRealNameAuthVC *vc = [[ZHRealNameAuthVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        
        }
            
            break;
        case 3:{ //登录密码
            
            ZHPwdRelatedVC *vc = [[ZHPwdRelatedVC alloc] initWith:ZHPwdTypeReset];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            
        break;
        case 4: {//支付密码
            
            ZHPwdRelatedVC *vc = [[ZHPwdRelatedVC alloc] initWith:ZHPwdTypeTradeReset];
            [self.navigationController pushViewController:vc animated:YES];
        
        }
        break;
            
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UILabel *)nameLbl {

    if (!_nameLbl) {
        
        _nameLbl = [self lbl];
    }
    
    return _nameLbl;
}

- (UILabel *)mobileLbl {
    
    if (!_mobileLbl) {
        
        _mobileLbl = [self lbl];
        
    }
    
    return _mobileLbl;
}

- (UILabel *)realNameLbl{

    if (!_realNameLbl) {
        _realNameLbl = [self lbl];
    }
    return _realNameLbl;
}


- (UILabel *)lbl {

    UILabel *lbl = [UILabel labelWithFrame:CGRectMake(LEFT_W, 0, SCREEN_WIDTH - LEFT_W - 30, 44)
                            textAligment:NSTextAlignmentRight
                         backgroundColor:[UIColor whiteColor]
                                    font:FONT(15)
                               textColor:[UIColor zh_textColor2]];
    lbl.xx_size = SCREEN_WIDTH - 35;

    return lbl;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.names.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *zhAccountSecurityId = @"ZHSettingUpCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:zhAccountSecurityId];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhAccountSecurityId];
        cell.textLabel.textColor = [UIColor zh_textColor];
        cell.textLabel.font = [UIFont secondFont];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
       
    }
    
    if (indexPath.row == 0) {
        [cell addSubview:self.nameLbl];
    } else if (indexPath.row == 1) {
        
        [cell addSubview:self.mobileLbl];

    } else if(indexPath.row == 2) {
        
        [cell addSubview:self.realNameLbl];
    }
    
    
    cell.textLabel.text = self.names[indexPath.row];
    return cell;

    

}
@end
