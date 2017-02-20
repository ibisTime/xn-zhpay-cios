//
//  ZHEvaluateModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/7.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface ZHEvaluateModel : TLBaseModel

@property (nonatomic,copy) NSString *interactDatetime;
@property (nonatomic,copy) NSString *interacter;
@property (nonatomic,strong) NSDictionary *interacterUser;
@property (nonatomic,copy) NSString *jewelCode;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *evaluateType;



@end


//{
//    id = 4;
//    interactDatetime = "Feb 7, 2017 2:12:11 PM";
//    interacter = U2017011704242588411;
//    interacterUser =                 {
//        nickname = "\U9690\U9690\U7ea6\U7ea6";
//        userId = U2017011704242588411;
//    };
//    jewelCode = CP201701171432017385;
//    systemCode = "CD-CZH000001";
//    type = 1;
//}
