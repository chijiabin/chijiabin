//
//  EnterAccountView.m
//  Ubate
//
//  Created by sunbin on 2016/12/12.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "EnterAccountView.h"
#import "LoginController.h"
@interface EnterAccountView()
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UIButton    *nextStepBtn;



@end

@implementation EnterAccountView

+ (instancetype)LoadEnterAccountView{
    
    EnterAccountView *enterAccount = [self loadFromNib];
    
    [enterAccount.account leftViewModeWithConstrainedToWidth:100.f text:@"账号:  " isLaunchScreen:YES];
    
    enterAccount.account.placeholderColor = [UIColor py_colorWithHexString:@"999999"];
   
    enterAccount.nextStepBtn.enabled = NO;
    [enterAccount.nextStepBtn setLayerBorderWidth:0.f borderColor:nil];
    [enterAccount.nextStepBtn setTitleColor:[UIColor py_colorWithHexString:@"666666"] forState:UIControlStateDisabled];
    [enterAccount.nextStepBtn setTitleColor:[UIColor py_colorWithHexString:@"e5e5e5"] forState:UIControlStateNormal];
    [enterAccount.nextStepBtn setBackgroundColor:[UIColor py_colorWithHexString:@"208dcf" alpha:1] forState:UIControlStateNormal];
    
    [enterAccount.nextStepBtn setBackgroundColor:[UIColor py_colorWithHexString:@"333333" alpha:0.6] forState:UIControlStateDisabled];
    
    
    
    
    return enterAccount;
}
+ (instancetype)loadFromNib{
    
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"EnterAccountView" owner:nil options:nil];
    return [objects lastObject];
}

- (IBAction)editingChange:(UITextField *)sender {
    if (sender.text.length == 0) {
        _nextStepBtn.enabled = NO;

    }else{
        _nextStepBtn.enabled = YES;
    }
}

- (IBAction)nextStep {

    [self endEditing:YES];
    if (!self.account.hasText) {
        return;

    }else{
        NSInteger     accounttype;
        NSDictionary *dic;
        NSString     *requestUrl;
        if ([_account.text isMobileNumberClassification]) {
            accounttype = 0;
            dic = @{@"phone":_account.text ,@"send":@(1),@"sign":[YConfig getSign]};
            requestUrl = phoneResetPwd;
        }else if ([_account.text isEmailAddress]){
            accounttype = 1;
            dic = @{@"email":_account.text ,@"send":@(1),@"sign":[YConfig getSign]};
            requestUrl = emailResetPwd;

        }else{
            return;
        }
        if (_enterAccountHandler) {
            _enterAccountHandler(accounttype ,dic ,requestUrl);
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    if (![NHUtils isBlankString:_account.text] ) {
        [self nextStep];
        return YES;
        
    }else{
        return NO;
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
}

- (void)textFieldDidEndEditing:(UITextField *)textField{}
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
}

- (IBAction)navOperation:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(navBtnIdex)]) {
        [self.delegate navBtnIdex];
    }
}



@end
