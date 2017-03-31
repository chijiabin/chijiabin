//
//  SenderEmail.m
//  Ubate
//
//  Created by sunbin on 2016/12/13.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "SenderEmail.h"
#import "SenderEmailView.h"
#import "LoginController.h"
@interface SenderEmail ()<SenderEmailViewDelegate>

@end

@implementation SenderEmail
{
    SenderEmailView *container;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    container = [SenderEmailView loadSendEmailAdress:[_dic objectForKey:@"email"]];
    container.frame = SCREEN_RECT;
    container.delegate = self;
    [self.view addSubview:container];


}

- (void)navBtnIdex:(NSInteger)idex{
    if (idex == 7) {
        LoginController *log = [[LoginController alloc] init];
        log.account =  IF_NULL_TO_STRING([_dic objectForKey:@"email"]);
        [self presentVc:log];
        return;
    }

    if (idex == 8) {
        WEAKSELF;
        
        [YNetworking postRequestWithUrl:emailReg params:_dic cache:YES successBlock:^(id returnData, int code, NSString *msg) {
            if (code == 1) {
            [weakSelf.view showLoadFinish:msg];
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

        } failureBlock:^(NSError *error) {
            
        } showHUD:YES];
        
//        [self requestWithUrl:emailReg params:_dic isCache:NO showHUD:NO myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg) {
//            [weakSelf.view showLoadFinish:msg];
//
//        }];

        return;
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
