//
//  AlipayManage.h
//  Ubate
//
//  Created by sunbin on 2017/2/10.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YScanPay.h"

@interface AlipayManage : NSObject
single_interface(AlipayManage);
- (void)doAlipayPay:(NSString *)subject money:(NSString *)total_amount store_id:(NSString *)store_id ctl:(YScanPay *)ctl myBlock:(void (^)(NSDictionary *requestResultDic ,NSString *trade_id))states;

@end
