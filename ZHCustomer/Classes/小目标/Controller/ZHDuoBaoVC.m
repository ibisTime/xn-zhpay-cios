//
//  ZHDuoBaoVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/20.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "ZHDuoBaoVC.h"
#import "ZHDuoBaoCell.h"
#import "ZHAwardAnnounceView.h"

@interface ZHDuoBaoVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<ZHAwardAnnounceView *> *awardViewRooms;
@end

@implementation ZHDuoBaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小目标";
    
    TLTableView *tableView = [TLTableView tableViewWithframe:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) delegate:self dataSource:self];
    [self.view addSubview:tableView];
    tableView.rowHeight = 145;
    tableView.backgroundColor = [UIColor zh_backgroundColor];
    tableView.placeHolderView = [TLPlaceholderView placeholderViewWithText:@"暂无商品"];
    
    //头部
    tableView.tableHeaderView = [self tableViewHeaderView];
}

- (UIView *)tableViewHeaderView {

    UIView *headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
    headerBgView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *hintImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 17, 46, 50)];
    hintImageView.image = [UIImage imageNamed:@"分秒实况"];
    [headerBgView addSubview:hintImageView];
    
    //线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor zh_lineColor];
    [headerBgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hintImageView.mas_right).offset(17);
        make.width.mas_equalTo(@1);
        make.height.mas_equalTo(@(50));
        make.centerY.equalTo(headerBgView.mas_centerY);
    }];
    
    //
    self.awardViewRooms = [[NSMutableArray alloc] initWithCapacity:3];
    for (NSInteger i = 0; i < 3 ; i++) {
        
        ZHAwardAnnounceView *awardV = [[ZHAwardAnnounceView alloc] initWithFrame:CGRectMake(hintImageView.xx + 18 + 10, 13.5 + i*(15 + 6), SCREEN_WIDTH - line.xx, 15)];
        [headerBgView addSubview:awardV];
        
    }
    
    
    return headerBgView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;

}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *zhDuoBaoCellId = @"ZHDuoBaoCell";
    ZHDuoBaoCell *cell = [tableView dequeueReusableCellWithIdentifier:zhDuoBaoCellId];
    if (!cell) {
        
        cell = [[ZHDuoBaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhDuoBaoCellId];
        
    }
    cell.type = [NSString stringWithFormat:@"%ld",indexPath.row  + 1];
    return cell;
    
    
}


@end
