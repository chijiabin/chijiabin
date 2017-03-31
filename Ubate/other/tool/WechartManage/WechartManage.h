//
//  WechartManage.h
//  Ubate
//
//  Created by sunbin on 2017/2/10.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YScanPay;
@interface WechartManage : NSObject

@property (nonatomic,strong)UIView *view;

single_interface(WechartManage);
- (void)jumpToWechart:(NSString *)content money:(NSString *)moneyValue store_id:(NSString *)store_id ctl:(YScanPay *)ctl myBlock:(void (^)(BOOL isError  , NSString *trade_id))states;

@end
