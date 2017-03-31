//
//  YConfig.h
//  Ubate-UV
//
//  Created by sunbin on 2017/1/22.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YConfig : NSObject

/**
 *  保存用户的账号与密码
 */
+ (void)saveOwnAccount:(NSString *)account andPassword:(NSString *)password;
/**
 *  获取用户的账号与密码
 */
+ (NSArray *)getOwnAccountAndPassword;


/**
 *  保存用户的model
 */
+ (void)saveProfile:(YUserInfo *)user;
/**
 *  获取用户的model
 */
+ (YUserInfo *)myProfile;


/**
 *  保存用户的UID
 */
+ (void )saveOwnID:(NSString *)uid;
/**
 *  得到用户的UID
 */
+ (int64_t)getOwnID;


//保存用户的Sing
+ (void)saveSign:(NSString *)Sing;
//得到用户的Sing
+ (NSString *)getSign;


/**
 *  保存用户注册激光id 上线通知
 */
+ (void)saveRegistrationID:(NSString*)registID;
/**
 *  得到用户注册激光id 上线通知
 */
+ (NSString *)registrationID;


/**
 *  清理操作-个人model信息清理
 */
+ (void)clearProfile;
/**
 *  缓存清理
 */
+ (void)clearCookie;


//过期
+ (void)outlog;


+ (void)loginWitAccount:(NSString *)account password:(NSString *)pwd
                success:(void (^)(NSDictionary * loginresults, NSString* loginRequestmsg))loginSuccess
                failure:(void (^)(NSDictionary * loginresults, NSString *resMake, NSString* loginRequestError))loginFailed;

@end
