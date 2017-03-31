//
//  AlipayManage.m
//  Ubate
//
//  Created by sunbin on 2017/2/10.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "AlipayManage.h"
#import "YScanPay.h"

@implementation AlipayManage
single_implementation(AlipayManage);

- (void)doAlipayPay:(NSString *)subject money:(NSString *)total_amount store_id:(NSString *)store_id ctl:(YScanPay *)ctl myBlock:(void (^)(NSDictionary *requestResultDic ,NSString *trade_id))states{
    
    NSString *appScheme = @"Ubate";
    
    NSDictionary *parm = @{@"uid"     :@([YConfig getOwnID]) ,
                           @"store_id":store_id ,
                           @"amount"  :[NSString stringWithFormat:@"%.2f" ,[total_amount floatValue]] ,
                           @"subject" :subject ,
                           @"body"    :@"subject" ,
                           @"sign":[YConfig getSign]};
    [YNetworking postRequestWithUrl:baofuCreateTrade params:parm cache:NO successBlock:^(id returnData, int code, NSString *msg) {
        
        
        if (code == 1) {
            // NOTE: 调用支付结果开始支付orderString
            [[AlipaySDK defaultService] payOrder:IF_NULL_TO_STRING([returnData objectForKey:@"data"]) fromScheme:appScheme callback:^(NSDictionary *resultDic) {
#pragma make 无获取结果 获取 trade_ids
                NSString *trade_ids = IF_NULL_TO_STRING([returnData objectForKey:@"trade_id"]);
                states(resultDic ,trade_ids);
            }];
        } if(code == 201){
            
            [ctl.view showSuccess:@"登录过期，请重新登录"];
            
            dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
            dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                [YConfig outlog];
            });
            
        }else if(code == 202){
            
            [ctl.view showSuccess:@"您的帐号在另一处登录，请重新登录"];
            
            dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
            dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                [YConfig outlog];
            });
            
        }
        else{
            states(nil ,nil);
        }
    } failureBlock:^(NSError *error) {
        states(nil ,nil);
        
    } showHUD:NO];
}


- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = SOURCESTR;
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}




@end
