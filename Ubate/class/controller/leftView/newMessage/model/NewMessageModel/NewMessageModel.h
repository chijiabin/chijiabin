//
//  NewMessageModel.h
//  Ubate
//
//  Created by sunbin on 2017/1/25.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "BQLDBModel.h"

@interface NewMessageModel : BQLDBModel
@property (nonatomic) NSInteger tradingid;          // 交易编号
@property (nonatomic, copy) NSString *money;        // 交易金额
@property (nonatomic, copy) NSString *time;         // 交易时间
@property (nonatomic, copy) NSString *newmessage;   // 消息标识符
@property (nonatomic, copy) NSString *isread;       // 消息是否读取标识符0查看  1未查看
@property (nonatomic, copy) NSString *issuccessful; // 转出结果 1成功 0失败



@end
//    {"data":{"record_id":4,"money":"0.02","type":1,"add_time":"2017.02.05 18:09"},"type":"json"}
