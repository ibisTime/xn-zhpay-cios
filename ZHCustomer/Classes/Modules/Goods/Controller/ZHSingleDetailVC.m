//
//  ZHSingleDetailVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/27.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHSingleDetailVC.h"
#import "ZHTextDetailCell.h"
#import "ZHImageCell.h"
#import "TLHeader.h"

@interface ZHSingleDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ZHSingleDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *goodsDetailTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - [DeviceUtil top64] - [DeviceUtil bottom49]) style:UITableViewStylePlain];
    goodsDetailTV.delegate = self;
    goodsDetailTV.dataSource = self;
    goodsDetailTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:goodsDetailTV];
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
        if (indexPath.row == 0) {
            return [self.goods detailHeight];
        }
        
        return [self.goods.imgHeights[indexPath.row - 1] floatValue];
    
//
//    else {
//    
////        if (indexPath.row == 0) {
////            return [self.treasure detailHeight];
////        }
////        
////        return [self.treasure.imgHeights[indexPath.row - 1] floatValue];
//    
//    }

}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (self.treasure) {
//        
//        return [self.treasure.descriptionPic componentsSeparatedByString:@"||"].count + 1;
//        
//    } else { //拍一通
//    
//
//    }
    
    return self.goods.pics.count + 1;

    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
        
        if (indexPath.row == 0) {
            
            static  NSString *detailCellId = @"ZHTextDetailCell";
            ZHTextDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellId];
            if (!cell) {
                
                cell = [[ZHTextDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailCellId];
                
            }
            
            
            cell.detailLbl.text = self.goods.desc;

//            if (self.goods) {
//                
//
//            } else {
//            
//                cell.detailLbl.text = self.treasure.descriptionText;
//
//            }
            return cell;
            
        } else {
            
            static  NSString *imgCellId = @"imgCellId";
            ZHImageCell *cell = [tableView dequeueReusableCellWithIdentifier:imgCellId];
            if (!cell) {
                
                cell = [[ZHImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imgCellId];
                
            }
            
            
            cell.url = self.goods.pics[indexPath.row - 1];

//            if (self.goods) {
//                
//
//            } else {
//                cell.url = self.treasure.pics[indexPath.row - 1];
//
//            
//            }
            return cell;
            
        }
    
    
}


@end
