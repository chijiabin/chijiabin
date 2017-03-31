//
//  YConfig.m
//  Ubate-UV
//
//  Created by sunbin on 2017/1/22.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "YConfig.h"
#import "UserDefaultsHeader.h"
#import "LoginController.h"

@implementation YConfig

+ (void)saveOwnAccount:(NSString *)account andPassword:(NSString *)password
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:account ?: @"" forKey:kAccount];
    
    [userDefaults synchronize];
    [SSKeychain setPassword:password ?: @"" forService:kService account:account];
}




+ (NSArray *)getOwnAccountAndPassword
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *account = [userDefaults objectForKey:kAccount];
    NSString *password = [SSKeychain passwordForService:kService account:account] ?: @"";
    
    if (account) {return @[account, password];}
    return nil;
}

#pragma mark - user profile
+ (void)saveProfile:(YUserInfo *)user
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:user.uid forKey:UID];
    [userDefaults setObject:user.phone_status forKey:PHONE_STATUS];
    [userDefaults setObject:user.id_status forKey:ID_STATUS];
    [userDefaults setObject:user.email_status forKey:EMAIL_STATUS];
    [userDefaults setObject:user.account_status forKey:ACCOUNT_STATUS];
    [userDefaults setObject:user.credit_status forKey:CREDIC_STATUS];
    [userDefaults setObject:user.safequestion_status forKey:SAFEQUESTION_STATUS];
    [userDefaults setObject:user.baofu_status forKey:BAOFU_STATUS];
    [userDefaults setObject:user.nickname forKey:NICKNAME];
    [userDefaults setObject:user.province forKey:PROVINCE];
    [userDefaults setObject:user.city forKey:CITY];
    [userDefaults setObject:user.area forKey:AREA];
    [userDefaults setObject:user.user_type forKey:USER_TYPE];
    [userDefaults setObject:user.member_id forKey:MEMBER_ID];
    [userDefaults setObject:user.sex forKey:SEX];
    [userDefaults setObject:user.user_phone forKey:USER_PHONE];
    [userDefaults setObject:user.user_email forKey:USER_EMAIL];
    [userDefaults setObject:user.is_ban forKey:IS_BAN];
    [userDefaults setObject:user.is_freeze forKey:IS_FREEZE];
    [userDefaults setObject:user.is_read_email forKey:IS_READ_EMAIL];
    [userDefaults setObject:user.real_name forKey:REAL_NAME];
    [userDefaults setObject:user.idcard forKey:IDCARD];
    [userDefaults setObject:user.user_img forKey:USER_IMG];
    [userDefaults setObject:user.address forKey:ADDRESS];
    [userDefaults setObject:user.account_money forKey:ACCOUNT_MONEY];
    [userDefaults setObject:user.collect_money forKey:COLLECT_MONEY];
    [userDefaults setObject:user.freeze_money forKey:FREEZE_MONEY];
    [userDefaults setObject:user.sponsorID forKey:SPONSORID];
    [userDefaults setObject:user.share_count forKey:SHARE_COUNT];
    
    [userDefaults setObject:user.bank_status forKey:BANK_STATUS];
    [userDefaults setObject:user.wechat_status forKey:WECHAT_STATUS];
    
    [userDefaults setObject:user.baofu_account forKey:BAOFU_ACCOUNT];
    [userDefaults setObject:user.wechat_account forKey:WECHAT_ACCOUNT];
    [userDefaults setObject:user.bank_account forKey:BANK_ACCOUNT];
    
    [userDefaults setObject:user.bank_name forKey:BANK_NAME];
    [userDefaults setObject:user.bank_img forKey:BANK_IMG];
    [userDefaults setObject:user.bank_code forKey:BANK_CODE];
    [userDefaults setObject:user.storeID forKey:STOREID];
    
    
    [userDefaults synchronize];
}


/**
 *  加载所有个人信息
 */

+ (YUserInfo *)myProfile
{
    YUserInfo *user = [YUserInfo new];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    user.uid = [userDefaults objectForKey:UID];
    user.phone_status = [userDefaults objectForKey:PHONE_STATUS];
    user.id_status = [userDefaults objectForKey:ID_STATUS];
    user.email_status = [userDefaults objectForKey:EMAIL_STATUS];
    user.account_status = [userDefaults objectForKey:ACCOUNT_STATUS];
    user.credit_status = [userDefaults objectForKey:CREDIC_STATUS];
    user.safequestion_status = [userDefaults objectForKey:SAFEQUESTION_STATUS];
    user.baofu_status = [userDefaults objectForKey:BAOFU_STATUS];
    user.nickname = [userDefaults objectForKey:NICKNAME];
    user.province = [userDefaults objectForKey:PROVINCE];
    user.city = [userDefaults objectForKey:CITY];
    user.area = [userDefaults objectForKey:AREA];
    user.user_type = [userDefaults objectForKey:USER_TYPE];
    user.member_id = [userDefaults objectForKey:MEMBER_ID];
    user.sex = [userDefaults objectForKey:SEX];
    user.user_phone = [userDefaults objectForKey:USER_PHONE];
    user.user_email = [userDefaults objectForKey:USER_EMAIL];
    user.is_ban = [userDefaults objectForKey:IS_BAN];
    user.is_freeze = [userDefaults objectForKey:IS_FREEZE];
    user.is_read_email = [userDefaults objectForKey:IS_READ_EMAIL];
    user.real_name = [userDefaults objectForKey:REAL_NAME];
    user.idcard = [userDefaults objectForKey:IDCARD];
    user.user_img = [userDefaults objectForKey:USER_IMG];
    user.address = [userDefaults objectForKey:ADDRESS];
    user.account_money = [userDefaults objectForKey:ACCOUNT_MONEY];
    user.collect_money = [userDefaults objectForKey:COLLECT_MONEY];
    user.freeze_money = [userDefaults objectForKey:FREEZE_MONEY];
    user.sponsorID = [userDefaults objectForKey:SPONSORID];
    user.share_count = [userDefaults objectForKey:SHARE_COUNT];
    
    
    user.bank_status = [userDefaults objectForKey:BANK_STATUS];
    user.wechat_status = [userDefaults objectForKey:WECHAT_STATUS];
    
    user.baofu_account = [userDefaults objectForKey:BAOFU_ACCOUNT];
    user.wechat_account = [userDefaults objectForKey:WECHAT_ACCOUNT];
    user.bank_account = [userDefaults objectForKey:BANK_ACCOUNT];
    user.bank_name = [userDefaults objectForKey:BANK_NAME];
    
    user.bank_img = [userDefaults objectForKey:BANK_IMG];
    user.bank_code = [userDefaults objectForKey:BANK_CODE];
    user.storeID = [userDefaults objectForKey:STOREID];
    
    
    if ([NHUtils isBlankString:user.nickname]) {
        user.nickname = [[self getOwnAccountAndPassword] firstObject];
    }
    
    return user;
}


#pragma make 个人uid
+ (void )saveOwnID:(NSString *)uid{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:uid forKey:UID];
    [userDefaults synchronize];
}


+ (int64_t)getOwnID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:UID];
}


//保存用户sign
+ (void)saveSign:(NSString *)Sing{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:Sing  forKey:SIGn];
    [userDefaults synchronize];
}

+ (NSString *)getSign{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:SIGn];
    
    return name;
}



+ (void)outlog{

    LoginController *loginController = [[LoginController alloc] init];
    kAppDelegate.window.rootViewController = loginController;

}


+ (void)loginWitAccount:(NSString *)account password:(NSString *)pwd
                 success:(void (^)(NSDictionary * loginresults, NSString* loginRequestmsg))loginSuccess
                 failure:(void (^)(NSDictionary * loginresults, NSString *resMake, NSString* loginRequestError))loginFailed
{

    NSDictionary *params = @{@"user_name":account ,
                             @"pwd":[pwd md5String],
                             };
     [YNetworking postRequestWithUrl:userLogin params:params cache:YES successBlock:^(id returnData, int code, NSString *msg) {
         
         
     } failureBlock:^(NSError *error) {
         
         
     } showHUD:YES];
    
    
}







#pragma make 清理操作
+ (void)clearProfile{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults removeObjectForKey:kAccount];
    [userDefaults removeObjectForKey:UID];
    [userDefaults removeObjectForKey:PHONE_STATUS];
    [userDefaults removeObjectForKey:ID_STATUS];
    [userDefaults removeObjectForKey:EMAIL_STATUS];
    [userDefaults removeObjectForKey:ACCOUNT_STATUS];
    [userDefaults removeObjectForKey:CREDIC_STATUS];
    [userDefaults removeObjectForKey:SAFEQUESTION_STATUS];
    [userDefaults removeObjectForKey:BAOFU_STATUS];
    [userDefaults removeObjectForKey:NICKNAME];
    [userDefaults removeObjectForKey:PROVINCE];
    [userDefaults removeObjectForKey:CITY];
    [userDefaults removeObjectForKey:AREA];
    [userDefaults removeObjectForKey:USER_TYPE];
    [userDefaults removeObjectForKey:MEMBER_ID];
    [userDefaults removeObjectForKey:SEX];
    [userDefaults removeObjectForKey:USER_PHONE];
    [userDefaults removeObjectForKey:USER_EMAIL];
    [userDefaults removeObjectForKey:IS_BAN];
    [userDefaults removeObjectForKey:IS_FREEZE];
    [userDefaults removeObjectForKey:IS_READ_EMAIL];
    [userDefaults removeObjectForKey:REAL_NAME];
    [userDefaults removeObjectForKey:IDCARD];
    [userDefaults removeObjectForKey:USER_IMG];
    [userDefaults removeObjectForKey:ADDRESS];
    [userDefaults removeObjectForKey:ACCOUNT_MONEY];
    [userDefaults removeObjectForKey:COLLECT_MONEY];
    [userDefaults removeObjectForKey:FREEZE_MONEY];
    [userDefaults removeObjectForKey:SPONSORID];
    [userDefaults removeObjectForKey:SHARE_COUNT];
    
    [userDefaults removeObjectForKey:BAOFU_STATUS];
    [userDefaults removeObjectForKey:BAOFU_ACCOUNT];
    [userDefaults removeObjectForKey:WECHAT_STATUS];
    [userDefaults removeObjectForKey:WECHAT_ACCOUNT];
    [userDefaults removeObjectForKey:BANK_STATUS];
    [userDefaults removeObjectForKey:BANK_ACCOUNT];
    [userDefaults removeObjectForKey:BANK_NAME];
    
    [userDefaults removeObjectForKey:BANK_IMG];
    [userDefaults removeObjectForKey:BANK_CODE];
    [userDefaults removeObjectForKey:STOREID];
    
    
    
    
    [userDefaults synchronize];
}



#pragma make 激光推送处理 激光RegistrationID

+ (void)saveRegistrationID:(NSString*)registID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:registID forKey:REGISTIONID];
    [defaults synchronize];
    
}


+ (NSString *)registrationID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults stringForKey:REGISTIONID];
}




+ (void)clearCookie
{
    
    [QCNetworkCache clearDownloadData];
    [QCNetworkCache clearAllCache];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"sessionCookies"];
    
    [defaults removeObjectForKey:REGISTIONID];
    
}



@end
