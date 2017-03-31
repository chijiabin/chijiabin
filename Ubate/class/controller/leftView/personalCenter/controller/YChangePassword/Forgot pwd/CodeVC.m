//
//  CodeVC.m
//  Ubate
//
//  Created by 池先生 on 17/3/20.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "CodeVC.h"
#import "NewPwd.h"
#import "ForgotTableViewCell.h"
@interface CodeVC ()<UITextFieldDelegate>{

    YUserInfo *userInfor;
}
//验证码
@property (weak, nonatomic) IBOutlet UILabel *codelable;
//输入框
@property (weak, nonatomic) IBOutlet UITextField *codetextfile;
//验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
//分割线
@property (weak, nonatomic) IBOutlet UIView *lineview;
//确认
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation CodeVC


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = NSLocalizedString(@"忘记密码", @"Forgot_paway");
    userInfor = [YConfig myProfile];
    
    self.confirmBtn.enabled = NO;
    self.confirmBtn.alpha = 0.4;
    [self.confirmBtn setLayerCornerRadius:5.0f borderWidth:0.5f borderColor:[UIColor borderColor]];
    
    [self.codeBtn startTime:59 title:@"重新发送" waitTittle:@"秒" respond:^(BOOL isPlayComple)
     {
         if (isPlayComple) {
             
            [self.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
             [self.codeBtn setLayerCornerRadius:7.f borderWidth:0.f borderColor:nil];
             [self.codeBtn setBackgroundColor:[UIColor py_colorWithHexString:@"208dcf"] forState:UIControlStateNormal];
         }else{
             [self.codeBtn setLayerCornerRadius:7.f borderWidth:1.f borderColor:[UIColor py_colorWithHexString:@"999999"]];
             [self.codeBtn setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
         }
     }];

    
    [_codetextfile addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void) textFieldDidChange:(id) sender {
    
    if (self.codetextfile.text.length == 0) {
        self.confirmBtn.enabled = NO;
        self.confirmBtn.alpha = 0.4;
    }else{
        self.confirmBtn.enabled = YES;
        self.confirmBtn.alpha = 1;
    }
}



//输入框
- (IBAction)Textfildcode:(UITextField *)sender {
    
}

//确认
- (IBAction)confirm:(UIButton *)sender {
    
    NewPwd *new = [[NewPwd alloc]init];
    NSDictionary *Dic;
    NSString *responseDataStr;

    if (_type == VerifyPasswordStylePhone) {
        
        Dic = @{@"phone" : userInfor.user_phone,
                @"act"   : @(1),
                @"scode" : self.codetextfile.text,
                @"sign":[YConfig getSign]
                };
        responseDataStr = phoneResetPwd;
        
    }else if (_type == VerifyPasswordStyleEmail){
    
    
        Dic = @{@"email" : userInfor.user_email,
                @"act"   : @(1),
                @"scode" : self.codetextfile.text,
                @"sign":[YConfig getSign]
                };
        responseDataStr = emailResetPwd;
    
    }
    
     [YNetworking postRequestWithUrl:responseDataStr params:Dic cache:YES successBlock:^(id returnData, int code, NSString *msg) {
         
         if (code == 1) {
            [self.navigationController pushViewController:new animated:YES];
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
             [NHUtils alertAction:@selector(pwdSpecification) alertControllerWithTitle:@"错误" Message:msg Vctl:self Cancel:NO];
         }
         
     } failureBlock:^(NSError *error) {
         
     } showHUD:YES];
    
    
//    [self requestWithUrl:responseDataStr params:Dic isCache:NO showHUD:NO myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg) {
//        if (state == Succeed) {
//        [self.navigationController pushViewController:new animated:YES];
//            
//        }else{
//        [NHUtils alertAction:@selector(pwdSpecification) alertControllerWithTitle:@"错误" Message:msg Vctl:self Cancel:NO];
//        }
//    }];
    
}

- (void)pwdSpecification{};

//发送验证码
- (IBAction)codeBtn:(UIButton *)sender {
    
    NSDictionary *dic;
    NSString     *requestUrl;

    if (_type == VerifyPasswordStylePhone)
    {
        dic = @{@"phone":userInfor.user_phone ,@"send":@(1),@"sign":[YConfig getSign] };
        requestUrl = phoneResetPwd;
        
    }if (_type == VerifyPasswordStyleEmail)
    {
        dic = @{@"email":userInfor.user_email ,@"send":@(1),@"sign":[YConfig getSign]};
        requestUrl = emailResetPwd;
    }
    [YNetworking postRequestWithUrl:requestUrl params:dic cache:YES successBlock:^(id returnData, int code, NSString *msg) {
        if (code == 1) {
            [sender startTime:59 title:@"重新发送" waitTittle:@"秒" respond:^(BOOL isPlayComple) {
                if(isPlayComple){
                    [sender setLayerCornerRadius:7.f borderWidth:0.f borderColor:[UIColor py_colorWithHexString:@"#999999"]];
                    [self.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [sender setBackgroundColor:[UIColor py_colorWithHexString:@"208dcf"] forState:UIControlStateNormal];
                }else{
                    
                    [self.codeBtn setTitleColor:[UIColor py_colorWithHexString:@"208dcf"] forState:UIControlStateNormal];
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
            
        }

        
        
        else{
            
        }
        [self.view showLoadFinish:msg];

    } failureBlock:^(NSError *error) {
    } showHUD:YES];
    
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
