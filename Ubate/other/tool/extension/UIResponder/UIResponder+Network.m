//
//  UIResponder+Network.m
//  Ubate
//
//  Created by sunbin on 2017/2/5.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "UIResponder+Network.h"
#import "CardManage.h"

@implementation UIResponder (Network)

- (void)requestWithUrl:(NSString *)url
                params:(NSDictionary *)params isCache:(BOOL)cache showHUD:(BOOL)showHUD myBlock:(void (^)(responseState state,NSDictionary * responseResults, NSString* msg))states{

    [YNetworking postRequestWithUrl:url params:params cache:cache successBlock:^(id returnData, int code, NSString *msg) {
        if (code == 1) {
            states(Succeed ,(NSDictionary *)returnData ,msg);
        }else{
            states(Error ,(NSDictionary *)returnData ,msg);
        }

    } failureBlock:^(NSError *error) {
        states(Error ,nil ,error.localizedDescription);
    } showHUD:showHUD];

}




- (void)bingCardManage:(void (^)(BingMethodMethod bingCardCount ,NSMutableArray *bingCardNumAry ,NSMutableArray *nobingCardNumAry ))states{
    
    YUserInfo *userInfor  = [YConfig myProfile];
    
    NSString *baofu_status  = userInfor.baofu_status;
    NSString *wechat_status = userInfor.wechat_status;
    NSString *bank_status   = userInfor.bank_status;
    
    
    [[CardManage sharedCardManage] checkAccountState:baofu_status wechat:wechat_status bank:bank_status myBlock:^(BingMethodMethod bingCardCount, NSMutableArray *bingCardNumAry, NSMutableArray *nobingCardNumAry) {
        states(bingCardCount ,bingCardNumAry ,nobingCardNumAry);
    }];
}

@end
