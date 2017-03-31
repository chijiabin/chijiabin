//
//  YChangePassword.m
//  Ubate
//
//  Created by sunbin on 2016/12/15.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "YChangePassword.h"

#import <SSKeychain/SSKeychain.h>

#import "MemberTableViewController.h"
#import "Forgot paway.h"
@interface YChangePassword ()

@property (weak, nonatomic) IBOutlet UITextField *oldPwd;
@property (weak, nonatomic) IBOutlet UITextField *resetPwd;

@property (weak, nonatomic) IBOutlet UIButton *configBtn;

@end

@implementation YChangePassword
{
    NSString *pwd; NSString *account;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"更改密码";

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self initView];
}


- (void)loadData{
    self.row = 2;
    pwd = [[YConfig getOwnAccountAndPassword] lastObject];
    account = [[YConfig getOwnAccountAndPassword] firstObject];
}

- (void)initView{
    [NHUtils setBtnColor:_configBtn];
    _configBtn.enabled = NO;
    [_configBtn setLayerBorderWidth:0.f borderColor:nil];
    
    [_oldPwd leftViewModeWithConstrainedToWidth:100.f text:@"旧密码 " isLaunchScreen:NO fon:15.f leftFonColor:@"333333" bodyFonColor:@"333333" PlaceholderColor:@"999999"];
    
    [_resetPwd leftViewModeWithConstrainedToWidth:100.f text:@"新密码 " isLaunchScreen:NO fon:15.f leftFonColor:@"333333" bodyFonColor:@"333333" PlaceholderColor:@"999999"];

    
    self.tableView.backgroundColor = [UIColor themeColor];
    
}

- (IBAction)editingChange:(UITextField *)sender {
    if (![NHUtils isBlankString:_oldPwd.text]  && ![NHUtils isBlankString:_resetPwd.text]) {
        _configBtn.enabled = YES;
    }else{
        _configBtn.enabled = NO;
    }
}

// 确定按钮事件
- (IBAction)confirm {
    if ([NHUtils isBlankString:_oldPwd.text] || [NHUtils isBlankString:_resetPwd.text]) {
        [NHUtils alertAction:@selector(enterNotEmpty) alertControllerWithTitle:@"提示" Message:@"输入内容不能为空" Vctl:self Cancel:YES];
    }else{
        if ([[_oldPwd.text md5String] isEqualToString:pwd]) {
            if ([_oldPwd.text isEqualToString:_resetPwd.text]) {
                NSLog(@"密码不能与原始密码相同");
                [NHUtils alertAction:@selector(msgAlert) alertControllerWithTitle:@"提示" Message:@"密码不能与原始密码相同" Vctl:self Cancel:NO];
                
            }else{
                if ([_resetPwd.text checkPassWord]) {
                    [self editPwdRequest];
                }else{
                    NSLog(@"密码不符合要求");
                    [NHUtils alertAction:@selector(pwdSpecification) alertControllerWithTitle:@"错误" Message:@"密码由8-20位数字和字母组成,请按照要求填写" Vctl:self Cancel:NO];
                }
            }
        }else{
            
            NSLog(@"密码错误");
            [NHUtils alertAction:@selector(pwdErrorInfor) alertControllerWithTitle:@"错误" Message:@"旧密码错误,请重新输入" Vctl:self Cancel:NO];
        }
    }

}
//密码不能与原始密码相同
- (void)msgAlert{
    _resetPwd.text = nil;
    _configBtn.enabled = NO;
    [_resetPwd becomeFirstResponder];

}
- (void)enterNotEmpty{
    if ([NHUtils isBlankString:_oldPwd.text] && [NHUtils isBlankString:_resetPwd.text]) {
        [_oldPwd becomeFirstResponder];
        return;
    }else{
        if ([NHUtils isBlankString:_oldPwd.text]) {
            [_oldPwd becomeFirstResponder];
            return;

        }else{
            [_resetPwd becomeFirstResponder];
            return;

        }    }
}
//密码错误
- (void)pwdErrorInfor{
    _oldPwd.text = nil;
    _configBtn.enabled = NO;
    [_oldPwd becomeFirstResponder];
}
//密码不符合要求
- (void)pwdSpecification{
    _resetPwd.text = nil;
    [_resetPwd becomeFirstResponder];

}

//忘记密码
- (IBAction)ForgetPwd:(UIButton *)sender {
    
    Forgot_paway *pay = [[Forgot_paway alloc]initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:pay animated:YES];
}

- (void)editPwdRequest{
    WEAKSELF;
    
    NSDictionary *params = @{
                             @"uid": @([YConfig getOwnID]),
                             @"password":[self.resetPwd.text md5String],
                             @"newpass":[self.resetPwd.text md5String],
                             @"sign":[YConfig getSign]};


    
    [YNetworking postRequestWithUrl:editPwd params:params cache:NO successBlock:^(id returnData, int code, NSString *msg) {
        if (code == 1) {
            NSLog(@"修改成功");
            [SSKeychain deletePasswordForService:@"service" account:pwd];
            [YConfig saveOwnAccount:account andPassword:[weakSelf.resetPwd.text md5String]];
         
            MemberTableViewController*memberViewController;
            for (UIViewController *ctl in weakSelf.navigationController.viewControllers) {
                if ([ctl isKindOfClass:[MemberTableViewController class]]) {
                    memberViewController = (MemberTableViewController*)ctl;
                }}
            [weakSelf.navigationController popToViewController:memberViewController animated:NO];
            
        }
        else if(code == 201){
            
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
            NSLog(@"%@" ,msg);
            
            [weakSelf.navigationController.view showError:msg];
        }
    } failureBlock:^(NSError *error) {
        [weakSelf.navigationController.view showError:error.localizedDescription];

        
    } showHUD:NO];

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_oldPwd.text.length >0 && _resetPwd.text.length >0) {
        [self editPwdRequest];
        [self.view endEditing:YES];
    }else{
        [_resetPwd beginningOfDocument];
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
