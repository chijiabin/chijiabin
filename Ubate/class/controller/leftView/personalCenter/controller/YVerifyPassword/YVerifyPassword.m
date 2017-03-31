//
//  YVerifyPassword.m
//  Ubate
//
//  Created by sunbin on 2017/2/13.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "YVerifyPassword.h"
#import "YEnterAccount.h"

@interface YVerifyPassword ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *enterPwd;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation YVerifyPassword
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"输入密码";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.row = 1;
    [self initView];
    
}

- (IBAction)confirm {
    if (_enterPwd.text.length >0) {
        NSString *md5Pwd =  [[YConfig getOwnAccountAndPassword] lastObject];
        if ([md5Pwd isEqualToString:[_enterPwd.text md5String]]) {
            YEnterAccount *enterAccount;
            enterAccount = kVCFromSb(@"YEnterAccountID", @"YMember");
            enterAccount.checkPwdType = _checkPwdType;
            [self.navigationController pushViewController:enterAccount animated:NO];
        }else{
            [NHUtils alertAction:@selector(pwdError) alertControllerWithTitle:@"提示" Message:@"密码错误" Vctl:self Cancel:NO];
        }
        
    }else{
        [NHUtils alertAction:@selector(pwdError) alertControllerWithTitle:@"提示" Message:@"输入内容不能为空" Vctl:self Cancel:NO];
    }
    
    
}
- (void)initView{
    [_enterPwd leftViewModeWithConstrainedToWidth:100.f text:@"密码:" isLaunchScreen:NO];
    [NHUtils setBtnColor:_confirmBtn];
    _confirmBtn.enabled = NO;
    [_confirmBtn setLayerBorderWidth:0.f borderColor:nil];//设置按钮圆角

}
- (void)pwdError{
    _enterPwd.text = nil;
    [_enterPwd becomeFirstResponder];
    _confirmBtn.enabled = NO;
    
}
- (IBAction)editingChanage:(UITextField *)sender {
        if (sender.text.length > 0) {
            _confirmBtn.enabled = YES;
        }else{
            _confirmBtn.enabled = NO;
        }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text !=0) {
        [self confirm];
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
