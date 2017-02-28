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
        @"-11" : @"取现",
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
        @"-40" : @"参与小目标",
        @"41" : @"夺宝流标",
        @"42" : @"确认收货，商户收钱",
        @"50" : @"红包兑分润",
        @"52" : @"红包业绩兑分润",
        @"54" : @"红包业绩兑贡献值",
        @"56" : @"分润兑人民币",
        @"58" : @"贡献值兑人民币",
        @"60" : @"发送得红包",
        @"61" : @"领取红包",
        @"62" : @"小目标中奖",
        @"-64" : @"参与小目标",
        @"65" : @"小目标中奖"


    };
    
    return dict[self.bizType];
    
}
//
//edit:AJ_DUOBAO("-40", "参与小目标")   add :  AJ_FSDHB("60", "发送得红包"), AJ_LQHB("61", "领取红包"), AJ_XMB(
//                                                                                               "62", "小目标中奖");

- (CGFloat)dHeightValue {

    CGSize size = [self.bizNote calculateStringSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) font:FONT(14)];
    return size.height - [FONT(14) lineHeight] + 3;

}

//AJ_CZ("11", "充值"), AJ_QX("-11", "取现"), AJ_LB("19", "蓝补"),
//AJ_HC("-19", "红冲"), AJ_GMHZB( "-36", "购买汇赚宝"), AJ_GMHZBFC("37", "购买汇赚宝分成"),
//AJ_YYJL("38", "汇赚宝摇一摇奖励"), AJ_YYFC("39", "摇一摇分成"), AJ_HB2FR("50", "红包兑分润"), AJ_HBYJ2FR("52", "红包业绩兑分润"), AJ_HBYJ2GXJL("54", "红包业绩兑贡献值"),
//AJ_FR2RMB("56","分润兑人民币"), AJ_GXJL2RMB("58", "贡献值兑人民币"),
//AJ_FSDHB("60", "发送得红包"), AJ_LQHB(
//"61", "领取红包"), AJ_DUOBAO("-64", "参与小目标"), AJ_DUOBAO_PRIZE("65",
//                                                                                                                                                                                                                                                                                                                                                            "小目标中奖");

@end
