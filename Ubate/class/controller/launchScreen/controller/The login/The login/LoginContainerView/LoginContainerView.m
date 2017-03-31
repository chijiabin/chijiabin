//
//  LoginContainerView.m
//  Ubate
//
//  Created by sunbin on 2016/11/30.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "LoginContainerView.h"

@interface LoginContainerView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView  *nav;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;



@end


@implementation LoginContainerView

+ (instancetype)LoginViewAccount:(NSString *)account{
    
    LoginContainerView *loginContainerView = [self loadFromNib];
    
    
     loginContainerView.configBtn.enabled = NO;
    [loginContainerView.configBtn setBackgroundColor:[UIColor py_colorWithHexString:@"208dcf" alpha:1] forState:UIControlStateNormal];
    [loginContainerView.configBtn setBackgroundColor:[UIColor py_colorWithHexString:@"333333" alpha:0.6] forState:UIControlStateDisabled];
    [loginContainerView.configBtn setTitleColor:[UIColor py_colorWithHexString:@"666666"] forState:UIControlStateDisabled];
    [loginContainerView.configBtn setTitleColor:[UIColor py_colorWithHexString:@"e5e5e5"] forState:UIControlStateNormal];
    [loginContainerView.configBtn setLayerBorderWidth:0 borderColor:nil];


    
    if (![NHUtils isBlankString:account]) {
        loginContainerView.account.text = account;
        [loginContainerView.pwd becomeFirstResponder];
    }
    
    [loginContainerView.account leftViewModeWithConstrainedToWidth:100.f text:@"账号  " isLaunchScreen:YES fon:18.f leftFonColor:@"e5e5e5" bodyFonColor:@"e5e5e5" PlaceholderColor:@"666666"];

    [loginContainerView.pwd leftViewModeWithConstrainedToWidth:100.f text:@"密码  " isLaunchScreen:YES fon:18.f leftFonColor:@"e5e5e5" bodyFonColor:@"e5e5e5" PlaceholderColor:@"666666"];

    
  


    loginContainerView.lab1.text = @"欢迎";
    loginContainerView.lab2.text = @"回来~";
    [loginContainerView.pwd     setPlaceholderColor:[UIColor py_colorWithHexString:@"999999"]];
    [loginContainerView.account setPlaceholderColor:[UIColor py_colorWithHexString:@"999999"]];

    
    return loginContainerView;
}


+ (instancetype)loadFromNib{
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"LoginContainerView" owner:nil options:nil];
    return [objects lastObject];
}



//输入框监听
- (IBAction)editingChanged:(UITextField *)sender {
    
    NSLog(@"%@" ,_account.text);
    NSLog(@"%@" ,_pwd.text);
    if (![NHUtils isBlankString:_account.text] && ![NHUtils isBlankString:_pwd.text]) {
        _configBtn.enabled = YES;
        
        [self.configBtn setBackgroundColor:kRGBAColor(34, 141, 207, 1) forState:UIControlStateNormal];
        [self.configBtn  setBackgroundColor:[UIColor py_colorWithHexString:@"208dcf"]];
        self.configBtn.alpha = 1;

    }else{
        _configBtn.enabled = NO;
        [self.configBtn  setBackgroundColor:[UIColor py_colorWithHexString:@"cccccc"]];
        self.configBtn.alpha = 0.64;
    }
    
}

//确认
- (IBAction)login {
    [self endEditing:YES];

    if (!self.account.hasText || !self.pwd.hasText) {
        NSLog(@"账号或密码不能为空");
        if (!self.account.hasText) {
        }
        if (!self.pwd.hasText) {
        }
        return;
    }
    if (self.loginHandler) {
        self.loginHandler(self.account.text,self.pwd.text);
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (![NHUtils isBlankString:_pwd.text] && ![NHUtils isBlankString:_account.text]) {
        [self login];
        return YES;
    }else{
        return NO;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (Iphone4) {
        _nav.hidden = YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (Iphone4) {
        _nav.hidden = NO;
    }
}



- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
}



- (IBAction)navOperation:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if ([self.delegate respondsToSelector:@selector(navBtnIdex:)]) {
        [self.delegate navBtnIdex:tag];
    }
    
    
}


@end
