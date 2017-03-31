//
//  EnterAccount.m
//  Ubate
//
//  Created by sunbin on 2016/12/12.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "EnterAccount.h"
#import "EnterAccountView.h"

#import "VerificationCode.h"

@interface EnterAccount ()<EnterAccountViewDelegate>

@end

@implementation EnterAccount
{
    EnterAccountView *container ;

}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];

}

- (void)initView{
    
    container = [EnterAccountView LoadEnterAccountView];
    container.frame = SCREEN_RECT;
    container.delegate = self;
    [self.view addSubview:container];
    __weak typeof(self) ws = self;
    
    container.enterAccountHandler = ^(NSInteger accountType ,NSDictionary *dic ,NSString *requestUrl){
        [ws enterAccount:accountType parms:dic request:requestUrl];
    };
}


/**************************判断账号类型**************************************/
- (void)enterAccount:(NSInteger )type parms:(NSDictionary *)dic request:(NSString *)requesrAPI{


    WEAKSELF;
    [self requestWithUrl:requesrAPI params:dic isCache:NO showHUD:YES myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg) {
        if (state == Succeed) {
            VerificationCode *verification = [[VerificationCode alloc] init];
            verification.params       = dic;
            verification.requestUrl   = requesrAPI;
            verification.finfPwdType  = type;
            verification.isFindPwd    = YES;
            [weakSelf presentVc:verification completion:^{
                [verification.view showLoadFinish:msg];
            }];

        }else{
            [weakSelf.view showLoadFinish:msg];
        }
    }];
    
}

- (void)navBtnIdex{
    
    [NHUtils presentViewController:@"LoginController" currentController:self modalTransitionStyle:UIModalTransitionStyleCrossDissolve];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
