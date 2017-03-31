//
//  LoginModel.h
//  Ubate
//
//  Created by sunbin on 2016/11/30.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject
+ (instancetype)shareInstance;

- (void)loginWithAccount:(NSString *)account password:(NSString *)pwd
                 success:(void (^)(NSDictionary * loginresults, NSString* loginRequestmsg))loginSuccess
                 failure:(void (^)(NSDictionary * loginresults, NSString *resMake, NSString* loginRequestError))loginFailed;


@end
