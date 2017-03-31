//
//  ResetPwd.m
//  Ubate
//
//  Created by sunbin on 2016/12/12.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "ResetPwd.h"
#import "ResetPwdView.h"
#import "LoginController.h"
#import "EnterAccount.h"
@interface ResetPwd ()<ResetPwdViewDelegate>

@end

@implementation ResetPwd
{
    ResetPwdView *container ;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    container = [ResetPwdView LoadResetPwdView];
    container.frame = SCREEN_RECT;
    container.delegate = self;
    [self.view addSubview:container];
    __weak typeof(self) ws = self;
    container.ResetPwdViewHandler = ^(NSString *newPwd ,NSString *pwd){
        [ws confimPwd:newPwd newPwd:pwd];
    
    };

}

- (void)confimPwd:(NSString *)pwd newPwd:(NSString *)newPwd{

    NSDictionary *params;
    if (_finfPwdType == 0) {
        params = @{@"newpwd":[newPwd md5String] ,@"pwd":[pwd md5String] ,@"phone":_account ,@"sign":SIGN};
    }
    
    if (_finfPwdType == 1) {
        params = @{@"newpwd":[newPwd md5String] ,@"pwd":[pwd md5String] ,@"email":_account ,@"sign":SIGN};
 
    }
    
    
    WEAKSELF;
    
    [self requestWithUrl:_requestUrl params:params isCache:NO showHUD:NO myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg) {
        if (state == Succeed) {
            LoginController *log = [[LoginController alloc] init];
            log.account = _account;
            [weakSelf presentVc:log completion:^{
                [weakSelf.view showLoadFinish:msg];
            }];

        }else{
            [weakSelf.view showLoadFinish:msg];

        }
    }];
    

}


- (void)navBtnIdex{
    [NHUtils presentViewController:@"EnterAccount" currentController:self modalTransitionStyle:UIModalTransitionStyleCrossDissolve];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
