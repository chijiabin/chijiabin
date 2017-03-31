//
//  CardManage.m
//  Ubate
//
//  Created by sunbin on 2016/12/14.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "CardManage.h"

@implementation CardManage
single_implementation(CardManage);

- (void)checkAccountState:(NSString *)baofu_status wechat:(NSString *)wechat_status bank:(NSString *)bank_status myBlock:(void (^)(BingMethodMethod bingCardCount ,NSMutableArray *bingCardNumAry ,NSMutableArray *nobingCardNumAry ))states{

    NSInteger _bingCardCount;
    YUserInfo *userInfor = [YConfig myProfile];
    NSMutableArray *_bingCardNumAry   = [[NSMutableArray alloc] init];
    
    NSMutableArray *_nobingCardNumAry = [[NSMutableArray alloc] init];

    if ([baofu_status isEqualToString:@"1"] && [wechat_status isEqualToString:@"1"] && [bank_status isEqualToString:@"1"]) {
        _bingCardCount = 1;
        
        NSDictionary *baofu_Dic = [self strToDic:@"支付宝" icon:@"zhifubao" account:userInfor.baofu_account makeFu:@"0"];
        [_bingCardNumAry addObject:baofu_Dic];
        
        NSDictionary *wechat_Dic = [self strToDic:@"微信" icon:@"wetchat" account:userInfor.wechat_account makeFu:@"1"];
        [_bingCardNumAry addObject:wechat_Dic];
        
        NSDictionary *bank_Dic = [self strToDic:userInfor.bank_name icon:userInfor.bank_img account:userInfor.bank_account makeFu:@"2"];
        [_bingCardNumAry addObject:bank_Dic];
        
    }else if (![baofu_status isEqualToString:@"1"] && ![wechat_status isEqualToString:@"1"] && ![bank_status isEqualToString:@"1"]) {
        _bingCardCount = 0;
        
        
        _nobingCardNumAry = [NSMutableArray arrayWithArray:        @[
                                                                     [self strToDic:@"添加支付宝" icon:@"zhifubao" account:@"" makeFu:@"0"] ,
                                                                     
                                                                     [self strToDic:@"添加微信" icon:@"wetchat" account:@"" makeFu:@"1"] ,
                                                                     
                                                                     [self strToDic:@"添加银行卡" icon:@"bank" account:@"" makeFu:@"2"] ,
                                                                     
                                                                     ]];
        
        
    }else{
        _bingCardCount = 2;
        if ([baofu_status isEqualToString:@"1"]) {
            NSDictionary *baofu_Dic = [self strToDic:@"支付宝" icon:@"zhifubao" account:userInfor.baofu_account makeFu:@"0"];
            [_bingCardNumAry addObject:baofu_Dic];
            
        }else{
            [_nobingCardNumAry addObject:[self strToDic:@"添加支付宝" icon:@"zhifubao" account:@"" makeFu:@"0"]];
        }
        
        if ([wechat_status isEqualToString:@"1"]) {
            NSDictionary *wechat_Dic = [self strToDic:@"微信" icon:@"wetchat" account:userInfor.wechat_account makeFu:@"1"];
            [_bingCardNumAry addObject:wechat_Dic];
            
        }else{
            [_nobingCardNumAry addObject:[self strToDic:@"添加微信" icon:@"wetchat" account:@"" makeFu:@"1"]];
            
        }
        
        if ([bank_status isEqualToString:@"1"]) {
            NSDictionary *bank_Dic = [self strToDic:userInfor.bank_name icon:userInfor.bank_img account:userInfor.bank_account makeFu:@"2"];
            [_bingCardNumAry addObject:bank_Dic];
        }else{
            [_nobingCardNumAry addObject:[self strToDic:@"添加银行卡" icon:@"bank" account:@"" makeFu:@"2"]];
            
        }
    }

    states(_bingCardCount ,_bingCardNumAry ,_nobingCardNumAry);
}


- (NSDictionary *)strToDic:(NSString *)accountName icon:(NSString *)accountIcon account:(NSString *)accountNum makeFu:(NSString *)make{
    
    NSDictionary *dic = @{@"name":accountName ,
                          @"icon":accountIcon ,
                          @"account":accountNum ,
                          @"make":make};    
    return dic;
    
}

@end
