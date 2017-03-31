//
//  LoginModel.m
//  Ubate
//
//  Created by sunbin on 2016/11/30.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "LoginModel.h"
#import "CryptorTools.h"
@interface LoginModel()

@end
@implementation LoginModel
+ (instancetype)shareInstance
{
    static LoginModel *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}


- (void)loginWithAccount:(NSString *)account password:(NSString *)pwd
                 success:(void (^)(NSDictionary * loginresults, NSString* loginRequestmsg))loginSuccess
                 failure:(void (^)(NSDictionary * loginresults, NSString *resMake, NSString* loginRequestError))loginFailed
{
#pragma make 网络请求
    NSDictionary *params = @{@"user_name":account ,
                             @"pwd":[pwd md5String],
                             };
    [self requestWithUrl:userLogin params:params myBlock:^(BOOL state,NSString*resMake ,NSDictionary * results, NSString* requestmsg ) {
        if (state) {
            /**
             ** 登录成功 保存账号与密码 获取用户的uid且保存 在根据uid拿到用户资料*/
            [YConfig saveOwnAccount:account andPassword:[pwd md5String]];
            loginSuccess(results ,requestmsg);
            
            NSString *sign = [results objectForKey:@"sign"];
            //保存用户sign
            [YConfig saveSign:sign];
            
        }else{
            loginFailed(results ,resMake ,requestmsg);
        }
    }];
    
    
    
}

//- (void)loginWithAccount:(NSString *)account password:(NSString *)pwd
//                 success:(void (^)(NSDictionary * loginresults, NSString* loginRequestmsg))loginSuccess
//                 failure:(void (^)(NSDictionary * loginresults, NSString *resMake, NSString* loginRequestError))loginFailed
//{
//    
//#pragma make 网络请求
//    NSDictionary *params = @{@"get":@"on"};
//    [self requestWithUrl:userLogin params:params myBlock:^(BOOL state,NSString*resMake ,NSDictionary * results, NSString* requestmsg ) {
//        if (state) {
//            NSString *Sign = [results objectForKey:@"sign"];
//            //获取公钥
//            NSString *m_public_key_path = [[NSBundle mainBundle] pathForResource:@"rsacert.der" ofType:nil];
//            
//             //获取服务器的公钥
//            NSString *F_public_key_path = Sign;
//
//            
//             //公钥加密 （密码)
//            NSString *EncryptStr = [CryptorTools encryptString:[pwd md5String] publicKey:F_public_key_path];
//            
//            
//            
//            NSDictionary *Params = @{@"pwd":EncryptStr,
//                                     @"user_name":account,
//                                     @"m":m_public_key_path
//                                     };
//            
//    
//            [YNetworking postRequestWithUrl:userLogin params:params cache:YES successBlock:^(id returnData, int code, NSString *msg) {
//                
//                
//                
//                
//                
//            } failureBlock:^(NSError *error) {
//                
//            } showHUD:YES];
//            
//            
//            
//            
//            
//            //获取私钥
//            NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"p.p12" ofType:nil];
//            
//            
//            /**
//             ** 登录成功 保存账号与密码 获取用户的uid且保存 在根据uid拿到用户资料*/
//            [YConfig saveOwnAccount:account andPassword:[pwd md5String]];
//            NSString *sign = [results objectForKey:@"sign"];
//            //保存用户sign
//            [YConfig saveSign:sign];
//            
//            
//            loginSuccess(results ,requestmsg);
//            
//        }else{
//            loginFailed(results ,resMake ,requestmsg);
//        }
//    }];
//    
//    
//    
//}



#pragma make -数据请求
- (void)requestWithUrl:(NSString *)url
                params:(NSDictionary *)params
               myBlock:(void (^)(BOOL state,NSString*resMake ,NSDictionary * results, NSString* requestmsg ))states{
    
    
    [YNetworking postRequestWithUrl:url params:params cache:NO successBlock:^(id returnData, int code, NSString *msg) {
        if (code == 1) {
            NSDictionary * respondData = [returnData objectForKey:@"data"];
            states(YES,[returnData objectForKey:@"res"] ,respondData,msg);
        }else{
            NSDictionary * respondData = [returnData objectForKey:@"data"];
            if (returnData != nil && respondData.count != 0) {
                states(false,[returnData objectForKey:@"res"] ,respondData,msg);
            }else{
                states(NO ,[NSString stringWithFormat:@"%@" ,[returnData objectForKey:@"res"]] ,nil ,msg);
            
            }}
        
    } failureBlock:^(NSError *error) {
        states(false,nil ,nil,[error localizedDescription]);

        
    } showHUD:NO];
}




@end
