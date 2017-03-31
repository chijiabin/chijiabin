//
//  LoginController.m
//  Ubate
//
//  Created by sunbin on 2016/11/30.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "LoginController.h"
#import "UIView+HUD.h"

#import "LoginContainerView.h"
#import "LoginModel.h"
#import "EnterAccount.h"
#import "Launch.h"
#import "SenderEmail.h"

@interface LoginController ()<LoginContainerViewDelegate>


@end

@implementation LoginController
{
    LoginContainerView *container ;
    NSString *errorMake; NSString *loginError;
    
    NSDictionary *emailDic;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self initView];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];

}


#pragma mark InitView
- (void)initView
{
    container = [LoginContainerView LoginViewAccount:_account];
    
    container.frame = SCREEN_RECT;
    container.delegate = self;
    [self.view addSubview:container];
    __weak typeof(self) ws = self;
    container.loginHandler = ^(NSString *account,NSString *pwd){
        [ws loginWithAccount:account pwd:pwd];
    };

}


#pragma mark Event Handle
- (void)loginWithAccount:(NSString *)account pwd:(NSString *)pwd
{
    
      WEAKSELF;
    [[LoginModel shareInstance] loginWithAccount:account password:pwd success:^(NSDictionary *loginresults, NSString *loginRequestmsg) {
        NSString *uid = TEXT_STRING([loginresults objectForKey:@"uid"]);
        [YConfig saveOwnID:uid];
        
        kAppDelegate.rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:kAppDelegate.rootViewController];
        [kAppDelegate.window addSubview:nav.view];
        [weakSelf.view removeFromSuperview];
        kAppDelegate.window.rootViewController = nav;
    } failure:^(NSDictionary *loginresults, NSString *resMake, NSString *loginRequestError) {
        
        loginError = loginRequestError;
        if ([resMake isEqualToString:@"-1"]) {
            emailDic = @{@"email":account ,
                         @"uid":[loginresults objectForKey:@"uid"] ,
                         @"sign":SIGN
                         };
            [weakSelf senderEmail];
        }else{
            [NHUtils alertAction:@selector(msgAlert) alertControllerWithTitle:@"提示" Message:loginError Vctl:weakSelf Cancel:NO];
        }
    }];
   }

- (void)msgAlert{

  //  container.account.text = nil;
    container.pwd.text = nil;
    container.configBtn.enabled = NO;

}

- (void)senderEmail{
    WEAKSELF;    
    SenderEmail *sender = [[SenderEmail alloc] init];
    sender.dic = emailDic;
    [weakSelf presentVc:sender completion:^{
        
    }];
    
}



- (void)navBtnIdex:(NSInteger)index{
    
    [NHUtils presentViewController:@[@"Launch" ,@"EnterAccount"][index-3] currentController:self modalTransitionStyle:index == 3?UIModalTransitionStyleCrossDissolve:UIModalTransitionStyleCoverVertical];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
