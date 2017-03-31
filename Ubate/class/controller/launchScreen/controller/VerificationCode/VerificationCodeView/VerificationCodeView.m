//
//  VerificationCodeView.m
//  Ubate
//
//  Created by sunbin on 2016/12/11.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "VerificationCodeView.h"

@interface VerificationCodeView()
//发送验证码
@property (weak, nonatomic) IBOutlet UIButton *countDown;
@property (weak, nonatomic) IBOutlet UITextField *scode;
@property (weak, nonatomic) IBOutlet UIButton *configtn;


@end

@implementation VerificationCodeView

+ (instancetype)LoadVerificationCodeView{

    VerificationCodeView *verificationCodeView = [self loadFromNib];
    
    [verificationCodeView.configtn setLayerBorderWidth:0.f borderColor:nil];

    verificationCodeView.configtn.enabled = NO;
    [verificationCodeView.configtn setBackgroundColor:[UIColor py_colorWithHexString:@"208dcf" alpha:1] forState:UIControlStateNormal];
    
    [verificationCodeView.configtn setBackgroundColor:[UIColor py_colorWithHexString:@"333333" alpha:0.6] forState:UIControlStateDisabled];
    
    
    [verificationCodeView.configtn setLayerBorderWidth:0.f borderColor:nil];
    [verificationCodeView.configtn setTitleColor:[UIColor py_colorWithHexString:@"666666"] forState:UIControlStateDisabled];
    [verificationCodeView.configtn setTitleColor:[UIColor py_colorWithHexString:@"e5e5e5"] forState:UIControlStateNormal];
    
    
    [verificationCodeView.countDown setLayerCornerRadius:7.f borderWidth:1.f borderColor:[UIColor py_colorWithHexString:@""]];
    
    
    [verificationCodeView.scode leftViewModeWithConstrainedToWidth:100.f text:@"验证码:  " isLaunchScreen:YES fon:18.f leftFonColor:@"e5e5e5" bodyFonColor:@"e5e5e5" PlaceholderColor:@"666666"];

    
    [verificationCodeView.scode setPlaceholderColor:[UIColor py_colorWithHexString:@"999999"]];
    
    [verificationCodeView.countDown startTime:59 title:@"重新发送" waitTittle:@"秒" respond:^(BOOL isPlayComple) {
        if (isPlayComple) {
            [verificationCodeView.countDown setLayerCornerRadius:7.f borderWidth:0.f borderColor:nil];
            [verificationCodeView.countDown setBackgroundColor:[UIColor py_colorWithHexString:@"208dcf"] forState:UIControlStateNormal];
        }else{
            [verificationCodeView.countDown setLayerCornerRadius:7.f borderWidth:1.f borderColor:[UIColor py_colorWithHexString:@"999999"]];
            [verificationCodeView.countDown setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
        }

    }];
    
    
    return verificationCodeView;
}
+ (instancetype)loadFromNib{
    
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"VerificationCodeView" owner:nil options:nil];
    return [objects lastObject];
}


//确认
- (IBAction)nextStep {

    [self endEditing:YES];
    if (![NHUtils isBlankString:_scode.text]) {
        if (self.VerificationCodeHandler) {
            self.VerificationCodeHandler(_scode.text);
        }
    }else{
        
    }
}


//发送验证码
- (IBAction)countdownEven:(UIButton *)sender {
    [self endEditing:YES];

    if ([self.delegate respondsToSelector:@selector(listToCountDown:)]) {
        [self.delegate listToCountDown:sender];
    }
}


- (IBAction)editingChanged:(UITextField *)sender {
    
    if (![sender.text isBlankString]) {
        _configtn.enabled = YES;
    }else{
        _configtn.enabled = NO;

    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (![NHUtils isBlankString:_scode.text] ) {
        [self nextStep];
        return YES;
        
    }else{
        return NO;
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{}

- (void)textFieldDidEndEditing:(UITextField *)textField{}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
}


- (IBAction)backOpeartion:(id)sender {
    if ([self.delegate respondsToSelector:@selector(navBtnIdex)]) {
        [self.delegate navBtnIdex];
    }

}


@end
