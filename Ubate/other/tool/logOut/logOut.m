//
//  logOut.m
//  Ubate
//
//  Created by sunbin on 2016/12/12.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "logOut.h"

@implementation logOut
single_implementation(logOut);

- (NSString *)logOutOperation{
    BQLDBTool *tool;
    tool = [BQLDBTool instantiateTool];
    

    NSString *account = [[YConfig getOwnAccountAndPassword] firstObject];
    NSInteger uid = [YConfig getOwnID];
    
    if([tool deleteDataWith:NewMessageFile]) {NSLog(@"删除成功");}
    else {NSLog(@"删除失败");}
    
    if([tool deleteDataWith:SearchRecordsFile]) {NSLog(@"删除成功");
    }
    else {NSLog(@"删除失败");
    }
    
    NSDictionary *params = @{@"uid":@(uid),
                             @"sign":[YConfig getSign]
                             };
    [YNetworking postRequestWithUrl:unRegistrationID params:params cache:NO successBlock:^(id returnData, int code, NSString *msg) {
        if (code == 1) {
            NSLog(@"解绑成功");
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"解绑失败");
    } showHUD:NO];
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
        [cookieStorage deleteCookie:cookie];
    }
    
    [YConfig clearProfile];
    [YConfig clearCookie];
    
    [NHUtils clear];
    
    kAppDelegate.userInfo = nil;
    return account;

}


@end
