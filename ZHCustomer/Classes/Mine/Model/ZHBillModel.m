//
//  ZHBillModel.m
//  ZHBusiness
//
//  Created by  tianlei on 2016/12/24.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHBillModel.h"

@implementation ZHBillModel


- (NSString *)getBizName {
    NSDictionary *dict = @{
    
        @"11" : @"充值",
        @"19" : @"蓝补",
        @"-19": @"红冲",
        @"-30" : @"购物",
        @"30" : @"购物退款",
        @"-31": @"店铺消费",
        @"-32": @"购买折扣券",
        @"32" : @"销售折扣券",
        @"33" : @"购买福利月卡",
        @"34" : @"福利月卡分成",
        @"35" : @"福利月卡返还",
        @"-36" : @"购买汇赚宝",
        @"37" : @"购买汇赚宝分成",
        @"38" : @"汇赚宝摇一摇奖励",
        @"39" : @"摇一摇分成",
        @"-40" : @"一元夺宝",
        @"41" : @"夺宝流标",
        @"42" : @"确认收货，商户收钱",
        @"50" : @"红包兑分润",
        @"52" : @"红包业绩兑分润",
        @"54" : @"红包业绩兑贡献奖励",
        @"56" : @"分润兑人民币",
        @"58" : @"贡献奖励兑人民币"
    
    };
    
    return dict[self.bizType];
    
}



- (CGFloat)dHeightValue {

    CGSize size = [self.bizNote calculateStringSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) font:FONT(14)];
    return size.height - [FONT(14) lineHeight] + 3;

}

//AJ_CZ("11", "充值"), AJ_QX("-11", "取现"), AJ_LB("19", "蓝补"), AJ_HC("-19", "红冲"), AJ_GW("-30", "购物"),
//AJ_QRSH("42", "确认收货，商户收钱"), AJ_DPXF("-31", "店铺消费"),
//AJ_GMZKQ("-32", "购买折扣券"), AJ_GMFLYK("-33", "购买福利月卡"),
//AJ_FLYKFC("34","福利月卡分成"), AJ_FLYKHH("35", "福利月卡返还"),
//AJ_GMHZB("-36", "购买汇赚宝"), AJ_GMHZBFC("37", "购买汇赚宝分成"), AJ_YYJL("38", "汇赚宝摇一摇奖励"), AJ_YYFC("39", "摇一摇分成"), AJ_DUOBAO("-40", "一元夺宝"), AJ_DBFLOW("41", "夺宝流标"), AJ_HB2FR("50", "红包兑分润"), AJ_HBYJ2FR("52", "红包业绩兑分润"), AJ_HBYJ2GXJL("54", "红包业绩兑贡献奖励"), AJ_FR2RMB("56",
//"分润兑人民币"), AJ_GXJL2RMB("58", "贡献奖励兑人民币");
@end