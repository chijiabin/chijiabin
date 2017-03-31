//
//  RegisteredPhone.m
//  Ubate
//
//  Created by sunbin on 2016/12/11.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "RegisteredPhone.h"
#import "RegisterContainerView.h"
#import "VerificationCode.h"
#import "RegisteredEmail.h"
#import "Launch.h"
#import "TermsWeb.h"

@interface RegisteredPhone ()<RegisterContainerViewDelegate>

@end

@implementation RegisteredPhone
{
    RegisterContainerView *container ;

    NSInteger errorMake;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];

}


- (void)initView{
    // 接口api 手机格式做处理 因此只需核实密码是否符合要求
    container = [RegisterContainerView RegisterView:RegisterPhone];
    container.frame = SCREEN_RECT;
    container.delegate = self;
    [self.view addSubview:container];
    __weak typeof(self) ws = self;
    // block传值 账号 密码
    container.registerHandler = ^(NSString *account,NSString *pwd){
        // 核查密码是否符合要求
        if ([pwd checkPassWord]) {
            [ws registerAccount:account Pwd:pwd];
        }else{
            //密码格式错误
            errorMake = 1 ;
            [NHUtils alertAction:@selector(requestError) alertControllerWithTitle:@"提示" Message:@"密码由8位以上数字与字母组合" Vctl:ws Cancel:NO];
        }
    };
}


- (void)registerAccount:(NSString *)account Pwd:(NSString *)pwd{
    NSDictionary *params = @{@"phone":account ,
                             @"send":@(1) ,
                             @"sign":[YConfig getSign]
                             };
    WEAKSELF;

    if ([account isMobileNumberClassification]) {
        
        [YNetworking postRequestWithUrl:MyNews params:params cache:YES successBlock:^(id returnData, int code, NSString *msg) {
            if (code == 1) {
                VerificationCode *verificationCode = [[VerificationCode alloc] init];
                verificationCode.params = params;
                verificationCode.pwd = pwd;
                [weakSelf presentVc:verificationCode completion:^{
                    [verificationCode.view showLoadFinish:msg];
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
                
            }

            else{
                // 注册失败原因 弹框
                [NHUtils alertAction:@selector(requestError) alertControllerWithTitle:@"提示" Message:msg Vctl:weakSelf Cancel:NO];
            }

        } failureBlock:^(NSError *error) {
            
        } showHUD:YES];
        
        
//        [self requestWithUrl:phoneReg params:params isCache:NO showHUD:YES myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg) {
//            if (state == Succeed) {
//                VerificationCode *verificationCode = [[VerificationCode alloc] init];
//                verificationCode.params = params;
//                verificationCode.pwd = pwd;
//                [weakSelf presentVc:verificationCode completion:^{
//                    [verificationCode.view showLoadFinish:msg];
//                }];
//            }else{
//                // 注册失败原因 弹框
//                [NHUtils alertAction:@selector(requestError) alertControllerWithTitle:@"提示" Message:msg Vctl:weakSelf Cancel:NO];
//            }
//        }];
    }else{
        // 注册失败原因 弹框
        errorMake = 2 ;
        [NHUtils alertAction:@selector(requestError) alertControllerWithTitle:@"提示" Message:@"密码错误,请重新输入" Vctl:weakSelf Cancel:NO];
    }
}

- (void)requestError{
    // 密码错误
    if (errorMake == 1) {
        container.pwd.text = nil;
        [container.pwd becomeFirstResponder];
        container.configBtn.enabled = NO;
    }
    // 手机格式错误
    if (errorMake == 2) {
        container.account.text = nil;
        [container.account becomeFirstResponder];
        container.configBtn.enabled = NO;
    }

}
- (void)loadData{}


- (void)terms:(NSInteger)termsMake{
//跳转到网页
    TermsWeb *web = [[TermsWeb alloc] initWithNibName:@"TermsWeb" bundle:nil];
    web.index = termsMake;

    [self presentVc:web completion:^{
    }];

    
}

- (void)navBtnIdex:(NSInteger)index{
    
    [NHUtils presentViewController:@[@"Launch" ,@"RegisteredEmail"][index-5] currentController:self modalTransitionStyle:index == 5?UIModalTransitionStyleCrossDissolve:UIModalTransitionStyleFlipHorizontal ];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
