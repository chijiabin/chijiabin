//
//  ResetPwdView.m
//  Ubate
//
//  Created by sunbin on 2016/12/22.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "ResetPwdView.h"
@interface ResetPwdView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *newpwd;

@property (weak, nonatomic) IBOutlet BanPasteTextField *pwd;

@property (weak, nonatomic) IBOutlet UIButton *configBtn;
@property (weak, nonatomic) IBOutlet UIView *nav;


@end

@implementation ResetPwdView


+ (instancetype)LoadResetPwdView{
    
    ResetPwdView *resetPwdView = [self loadFromNib];
    
    resetPwdView.newpwd.secureTextEntry = YES;
    
    resetPwdView.pwd.secureTextEntry = YES;

    
    
    [resetPwdView.newpwd leftViewModeWithConstrainedToWidth:100.f text:@"新密码:  " isLaunchScreen:YES fon:18.f leftFonColor:@"e5e5e5" bodyFonColor:@"e5e5e5" PlaceholderColor:@"666666"];
    [resetPwdView.pwd leftViewModeWithConstrainedToWidth:100.f text:@"确认密码:  " isLaunchScreen:YES fon:18.f leftFonColor:@"e5e5e5" bodyFonColor:@"e5e5e5" PlaceholderColor:@"666666"];

    
    resetPwdView.configBtn.enabled = NO;
    [resetPwdView.configBtn setBackgroundColor:[UIColor py_colorWithHexString:@"208dcf" alpha:1] forState:UIControlStateNormal];
    [resetPwdView.configBtn setBackgroundColor:[UIColor py_colorWithHexString:@"333333" alpha:0.6] forState:UIControlStateDisabled];
    [resetPwdView.configBtn setTitleColor:[UIColor py_colorWithHexString:@"666666"] forState:UIControlStateDisabled];
    [resetPwdView.configBtn setTitleColor:[UIColor py_colorWithHexString:@"e5e5e5"] forState:UIControlStateNormal];
    [resetPwdView.configBtn setLayerBorderWidth:0 borderColor:nil];

    
    
    
    return resetPwdView;
}
+ (instancetype)loadFromNib{
    
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"ResetPwdView" owner:nil options:nil];
    return [objects lastObject];
}

- (IBAction)confim {
    [self endEditing:YES];
    if (![NHUtils isBlankString:_newpwd.text] && ![NHUtils isBlankString:_newpwd.text]) {
        
        if (![_newpwd.text isEqualToString:_pwd.text]) {
        }else{
            if (![_newpwd.text checkPassWord]) {
            }else{
                
                if (_ResetPwdViewHandler) {
                    _ResetPwdViewHandler(_pwd.text ,_newpwd.text);
                }  }
        }
        
    }else{
    }

    
}
- (IBAction)editingChanage:(UITextField *)sender {
    if (_pwd.text.length >0 && _newpwd.text.length) {
        _configBtn.enabled = YES;
    }else{
        _configBtn.enabled = NO;
    }
}

- (IBAction)backOperationBtn {
    if ([self.delegate respondsToSelector:@selector(navBtnIdex)]) {
        [self.delegate navBtnIdex];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (Iphone5) {
        _nav.hidden = YES;
    }
    return YES;
}- (void)textFieldDidBeginEditing:(UITextField *)textField{

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (Iphone5) {
        _nav.hidden = NO;
    }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

}
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0){}


- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    if (_pwd.text.length >0 && _newpwd.text.length >0) {
        [self confim];
    }else{
        [_pwd becomeFirstResponder];
    }
    return YES;

}


@end
