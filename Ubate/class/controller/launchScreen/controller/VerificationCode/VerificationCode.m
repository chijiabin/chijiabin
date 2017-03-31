//
//  VerificationCode.m
//  Ubate
//
//  Created by sunbin on 2016/12/11.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "VerificationCode.h"
#import "VerificationCodeView.h"
#import "LoginController.h"
#import "ResetPwd.h"
#import "RegisteredPhone.h"
@interface VerificationCode ()<VerificationCodeViewDelegate>

@end

@implementation VerificationCode
{
    VerificationCodeView *container ;

    
}
- (void)viewDidLoad {
    [super viewDidLoad];


    [self initView];
}

- (void)initView{
    container = [VerificationCodeView LoadVerificationCodeView];
    container.frame = SCREEN_RECT;
    container.delegate = self;
    [self.view addSubview:container];
    __weak typeof(self) ws = self;
    container.VerificationCodeHandler = ^(NSString *scode){
        [ws submitScode:scode];
    };
}

- (void)submitScode:(NSString *)scode{

    NSDictionary *Dic;
    NSString *responseDataStr;
    NSString *account;
    
    if (_isFindPwd) {
        if (_finfPwdType == 0) {
            Dic = @{@"phone" : [_params objectForKey:@"phone"],
                            @"act"   : @(1),
                            @"scode" : scode,
                            @"sign":[YConfig getSign]
                            };
            account = [_params objectForKey:@"phone"];
        }
        
        if (_finfPwdType == 1) {
            Dic = @{@"email" : [_params objectForKey:@"email"],
                            @"scode" : scode,
                            @"act"   : @(1),
                            @"sign":[YConfig getSign]
                            };
            account = [_params objectForKey:@"email"];

        }
        responseDataStr = _requestUrl;

    }else{
        responseDataStr = phoneReg;
        Dic = @{@"phone" : [_params objectForKey:@"phone"],
                        @"scode" : scode,
                        @"txtpwd": [_pwd md5String],
                        @"sign":[YConfig getSign]
                        };

    }
    
    WEAKSELF;
    
     [YNetworking postRequestWithUrl:responseDataStr params:Dic cache:YES successBlock:^(id returnData, int code, NSString *msg) {
         if (code == 1) {
             if (_isFindPwd) {
                 
                 ResetPwd *resetPwd   = [[ResetPwd alloc] init];
                 resetPwd.finfPwdType = _finfPwdType;
                 resetPwd.requestUrl  = _requestUrl;
                 resetPwd.account     = account;
                 
                 [weakSelf presentVc:resetPwd completion:^{
                     [weakSelf.view showLoadFinish:msg];
                     
                 }];
             }else{
                 LoginController *log = [[LoginController alloc] init];
                 log.account = [_params objectForKey:@"phone"];
                 [weakSelf presentVc:log completion:^{
                     [weakSelf.view showLoadFinish:msg];
                     
                 }];
             }
         }else if(code == 201){
             
             [self.view showSuccess:@"登录过期，请重新登录"];
             
             dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
             dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                 [YConfig outlog];
             });
             
         }else if(code == 202){
             
             [self.view showSuccess:@"您的帐号在另一处登录，请重新登录"];
             
             dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
             dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                 [YConfig outlog];
             });
             
         }
         
         else{
             [weakSelf.view showLoadFinish:msg];
         }

     } failureBlock:^(NSError *error) {
         
     } showHUD:YES];
    
//    [self requestWithUrl:responseDataStr params:Dic isCache:NO showHUD:NO myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg) {
//        
//        if (state == Succeed) {
//                
//                if (_isFindPwd) {
//                    
//                    ResetPwd *resetPwd   = [[ResetPwd alloc] init];
//                    resetPwd.finfPwdType = _finfPwdType;
//                    resetPwd.requestUrl  = _requestUrl;
//                    resetPwd.account     = account;
//                    
//                    [weakSelf presentVc:resetPwd completion:^{
//                        [weakSelf.view showLoadFinish:msg];
//                        
//                    }];
//                }else{
//                    LoginController *log = [[LoginController alloc] init];
//                    log.account = [_params objectForKey:@"phone"];
//                    [weakSelf presentVc:log completion:^{
//                        [weakSelf.view showLoadFinish:msg];
//                        
//                    }];
//                }
// 
//            }else{
//                [weakSelf.view showLoadFinish:msg];
//            }
//    }];
    }


- (void)listToCountDown:(UIButton *)sender{
    
    NSString *responseDataStr;
    if (_isFindPwd) {
        responseDataStr = _requestUrl;
    }else{
        responseDataStr = phoneReg;
    }
    
    [YNetworking postRequestWithUrl:responseDataStr params:_params cache:YES successBlock:^(id returnData, int code, NSString *msg) {
        if (code == 1) {
            [sender startTime:59 title:@"重新发送" waitTittle:@"秒" respond:^(BOOL isPlayComple) {
                
                if(isPlayComple){
                    [sender setLayerCornerRadius:7.f borderWidth:0.f borderColor:nil];
                    [sender setBackgroundColor:[UIColor py_colorWithHexString:@"208dcf"] forState:UIControlStateNormal];
                    
                }else{
                    [sender setLayerCornerRadius:7.f borderWidth:1.f borderColor:[UIColor py_colorWithHexString:@"999999"]];
                    [sender setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
                }
                
            }];
        }else if(code == 201){
            
            [self.view showSuccess:@"登录过期，请重新登录"];
            
            dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
            dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                [YConfig outlog];
            });
            
        }else if(code == 202){
            
            [self.view showSuccess:@"您的帐号在另一处登录，请重新登录"];
            
            dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
            dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                [YConfig outlog];
            });
            
        }else{
            [self.view showLoadFinish:msg];
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:YES];
    
    
//    [self requestWithUrl:responseDataStr params:_params isCache:NO showHUD:NO myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg) {
//        if (state == Succeed) {
//            [sender startTime:59 title:@"重新发送" waitTittle:@"秒" respond:^(BOOL isPlayComple) {
//                
//                if(isPlayComple){
//                    [sender setLayerCornerRadius:7.f borderWidth:0.f borderColor:nil];
//                    [sender setBackgroundColor:[UIColor py_colorWithHexString:@"208dcf"] forState:UIControlStateNormal];
//                    
//                }else{
//                    [sender setLayerCornerRadius:7.f borderWidth:1.f borderColor:[UIColor py_colorWithHexString:@"999999"]];
//                    [sender setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
//                }
//                
//            }];
//        }else{
//        
//        }
//        [self.view showLoadFinish:msg];
//
//    }];
    }

- (void)navBtnIdex{
    
    NSString *ctlName;
    if (_isFindPwd) {
        ctlName = @"LoginController";
    }else{
        ctlName = @"RegisteredPhone";
    }
    [NHUtils presentViewController:ctlName currentController:self modalTransitionStyle:UIModalTransitionStyleCrossDissolve];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
