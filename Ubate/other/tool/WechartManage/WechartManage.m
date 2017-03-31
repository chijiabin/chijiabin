//
//  WechartManage.m
//  Ubate
//
//  Created by sunbin on 2017/2/10.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "WechartManage.h"
#import "YScanPay.h"
#import "WXApiObject.h"
#import "WXApi.h"

#import <UIKit/UIKit.h>

@implementation WechartManage
single_implementation(WechartManage);
- (void)jumpToWechart:(NSString *)content money:(NSString *)moneyValue store_id:(NSString *)store_id ctl:(YScanPay *)ctl myBlock:(void (^)(BOOL isError  ,NSString *trade_id))states{
    if (![WXApi isWXAppInstalled])
    {
        [ctl.navigationController.view showError:@"没有安装微信"];
        
    }else if (![WXApi isWXAppSupportApi])
    {
        [ctl.navigationController.view showError:@"不支持微信支付"];
    }
    NSLog(@"安装了微信，而且微信支持支付");
    CGFloat money = [moneyValue floatValue];
    NSDictionary *params = @{
                             @"uid"     :@([YConfig getOwnID]),
                             @"store_id": store_id,
                             @"money"   :[NSString stringWithFormat:@"%.2f" ,money],
                             @"body"    :content,
                             @"sign":[YConfig getSign]
                             };
    
    [YNetworking postRequestWithUrl:wechatCreateTrade params:params cache:NO successBlock:^(id returnData, int code, NSString *msg) {
        
        if(code == 201){
            
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
            
        }else if(code == 1){
        
            
            NSDictionary *dict = (NSDictionary *)returnData;
            NSDictionary *data = [dict objectForKey:@"data"];
            NSLog(@"%@" ,data);
            NSString *trade_id = IF_NULL_TO_STRING([returnData objectForKey:@"trade_id"]);
            
            
            if(data != nil)
            {
                //调起微信支付
                PayReq* req = [[PayReq alloc] init];
                
                req.partnerId = [data objectForKey:@"partnerid"];
                req.prepayId  = [data objectForKey:@"prepayid"];
                req.nonceStr  = [data objectForKey:@"noncestr"];
                NSMutableString *stamp = [data objectForKey:@"timestamp"];
                req.timeStamp =  stamp.intValue;
                req.package   = [data objectForKey:@"package"];
                req.sign      = [data objectForKey:@"sign"];
                
                BOOL isPaySuss =  [WXApi sendReq:req];
                
                states(NO ,trade_id);
        
        }

        
       
            
//            if (isPaySuss) {
//                states(NO ,trade_id);
//                [ctl.view showError:@"支付成功"];
//                
//            }else{
//                states(YES ,nil);
//                [ctl.view showError:@"支付失败"];
//                
//            }
//            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
            
        }else{
            [ctl.view showError:msg];
            
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"服务器返回错误%@",error);
        [ctl.view showError:error.localizedDescription];
    } showHUD:NO];
    
    
    
}

@end
