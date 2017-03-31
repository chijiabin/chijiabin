//
//  RegisteredEmail.m
//  Ubate
//
//  Created by sunbin on 2016/12/12.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "RegisteredEmail.h"
#import "RegisterContainerView.h"

#import "RegisteredPhone.h"
#import "Launch.h"
#import "LoginController.h"
#import "TermsWeb.h"

@interface RegisteredEmail ()<RegisterContainerViewDelegate>
@end

@implementation RegisteredEmail
{
    RegisterContainerView *container ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView{
    
    container = [RegisterContainerView RegisterView:Registeremail];
    container.frame = SCREEN_RECT;
    container.delegate = self;
    [self.view addSubview:container];
    __weak typeof(self) ws = self;
    
    container.registerHandler = ^(NSString *account,NSString *pwd){
        [ws registerAccount:account Pwd:pwd];

    };

}

- (void)registerAccount:(NSString *)account Pwd:(NSString *)pwd{
    NSDictionary *params = @{@"email":account ,
                             @"send":@(1) ,
                             @"sign":[YConfig getSign],
                             @"txtpwd":[pwd md5String]
                             };
    WEAKSELF;

    [YNetworking postRequestWithUrl:MyNews params:params cache:YES successBlock:^(id returnData, int code, NSString *msg) {
        
        [weakSelf.view showLoadFinish:msg];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (code == 1) {
                LoginController *log = [[LoginController alloc] init];
                log.account = account;
                [weakSelf presentVc:log completion:^{
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

        });
        

    } failureBlock:^(NSError *error) {
        
    } showHUD:YES];
    
    
//    [self requestWithUrl:emailReg params:params isCache:NO showHUD:YES myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg) {
//        [weakSelf.view showLoadFinish:msg];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (state == Succeed) {
//            LoginController *log = [[LoginController alloc] init];
//            log.account = account;
//            [weakSelf presentVc:log completion:^{
//            }];
//        }
//    });
//}];
    
}




- (void)terms:(NSInteger)termsMake{
    TermsWeb *web = [[TermsWeb alloc] initWithNibName:@"TermsWeb" bundle:nil];
    web.index = termsMake;
    
    [self presentVc:web completion:^{
    }];

}


- (void)navBtnIdex:(NSInteger)index{
    
    [NHUtils presentViewController:@[@"Launch" ,@"RegisteredPhone"][index-5] currentController:self modalTransitionStyle:index == 5?UIModalTransitionStyleCrossDissolve:UIModalTransitionStyleFlipHorizontal ];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
