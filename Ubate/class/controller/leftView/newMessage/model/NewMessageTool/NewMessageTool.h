//
//  NewMessageTool.h
//  Ubate
//
//  Created by sunbin on 2017/1/25.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewMessageTool : NSObject

/**
 *
 *tool 数据库工具
 *tradingid    交易id
 *money        交易金额
 *type         交易类型
 *add_time     交易时间
 *isRead       是否读取
 *issuccessful 提现是否成功
 */
+ (void)newMessageTool:(BQLDBTool *)tool insertData:(NSString *)record_id money:(NSString *)money type:(NSString *)type add_time:(NSString *)add_time isRead:(NSString *)isRead issuccessful:(NSString *)issuccessful;

@end
