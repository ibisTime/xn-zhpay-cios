//
//  ZHEvaluateModel.h
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/7.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLBaseModel.h"

@interface ZHEvaluateModel : TLBaseModel

//@property (nonatomic,copy) NSString *interactDatetime;
//@property (nonatomic,copy) NSString *interacter;
//@property (nonatomic,strong) NSDictionary *interacterUser;
//@property (nonatomic,copy) NSString *jewelCode;
//@property (nonatomic,copy) NSString *type;
//@property (nonatomic,copy) NSString *evaluateType;

@property (nonatomic, strong) NSDictionary *user;

@property (nonatomic, copy, readonly) NSString *photo;
@property (nonatomic, copy, readonly) NSString *nickname;


//评论type传3
//actionDatetime = "Apr 6, 2017 3:53:13 PM";
//actionUser = U2017032913574410381;
//code = HD201704061553131892;
//storeCode = CP201703301648154819;
//systemCode = "CD-CZH000001";
//type = 3;
//user =                 {
//    identityFlag = 1;
//    loginName = 18984955240;
//    mobile = 18984955240;
//    nickname = 74410381;
//    photo = "ANDROID_1490874687342_0_0.jpg";
//    userId = U2017032913574410381;
//    userReferee = U2017010713451027748;
//};


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
