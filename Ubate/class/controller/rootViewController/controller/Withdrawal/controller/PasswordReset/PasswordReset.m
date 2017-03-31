//
//  PasswordReset.m
//  Ubate
//
//  Created by sunbin on 2016/12/5.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "PasswordReset.h"

@interface PasswordReset ()
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *newpwd;
@property (weak, nonatomic) IBOutlet UIButton *configBtn;

@end

@implementation PasswordReset
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"密码重置";
    [self pushAndPop];
}

- (void)pushAndPop{
    [NHUtils pushAndPop:@"ForgotPwd" range:NSMakeRange(2, 1) currentCtl:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];[self loadData];
}

- (void)loadData{
    self.row = 2;
}


- (void)initView{
    [NHUtils setBtnColor:_configBtn];
    [_configBtn setLayerBorderWidth:0.f borderColor:nil];//设置按钮圆角
    _configBtn.enabled = NO;
    [_pwd leftViewModeWithConstrainedToWidth:100.f    text:@"新密码:" isLaunchScreen:NO];
    [_newpwd leftViewModeWithConstrainedToWidth:100.f text:@"确认密码:" isLaunchScreen:NO];
    _pwd.placeholderColor = [UIColor appPlaceholderColor];
    _newpwd.placeholderColor = [UIColor appPlaceholderColor];

}


- (NSDictionary *)requestWithParams{
    NSDictionary *params;
    if (_findTypeMake == 0) {
        params = @{
                   @"phone" :_findType ,
                   @"newpwd":[_newpwd.text md5String] ,
                   @"pwd"   :[_pwd.text md5String] ,
                   @"sign"  :SIGN
                   };
    }else{
        params = @{
                   @"email" :_findType ,
                   @"newpwd":[_newpwd.text md5String] ,
                   @"pwd"   :[_pwd.text md5String] ,
                   @"sign"  :SIGN
                   };
    }
    return params;
}



- (void)requestWithParams:(NSDictionary*)dic response:(void (^)(BOOL state,NSString * responseMsg))states{
    [YNetworking postRequestWithUrl:_requestWithUrl params:dic cache:NO successBlock:^(id returnData, int code, NSString *msg) {
        if (code == 1) {
            states(YES ,msg);
        }else{
            states(NO ,msg);
        }
        
    } failureBlock:^(NSError *error) {
        states(NO ,error.localizedDescription);
    } showHUD:YES];
}





- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self confirm];
    return YES;
}

- (IBAction)confirm {
    if ([_pwd.text isEqualToString:_newpwd.text]) {
        if ([_pwd.text checkPassWord]) {
            [self confirmRequest];
        }else{
            [NHUtils alertAction:@selector(alertconfirm) alertControllerWithTitle:@"密码不符合要求" Message:@"密码由8-20位数字和字母组成,请按照要求填写" Vctl:self Cancel:NO];
        }
    }else{
        [NHUtils alertAction:@selector(alertconfirm) alertControllerWithTitle:@"密码不相同" Message:@"确认密码与新密码不相同,请从新输入" Vctl:self Cancel:NO];
    }
}
- (void)alertconfirm{
    _pwd.text = nil;
    _newpwd.text = nil;
    [_pwd becomeFirstResponder];
}

// 密码修改成功 后重新登录
- (void)confirmRequest{
    NSDictionary *params = [self requestWithParams];
    [self requestWithParams:params response:^(BOOL state, NSString *responseMsg) {
        if (state) {
            [self logOut];
        }else{
        }
        [self.navigationController.view showLoadFinish:responseMsg];
    }];

}

// editingChanged输入监听
- (IBAction)editingChanged:(UITextField *)sender {
    if (_pwd.text.length !=0 && _newpwd.text.length !=0) {
        _configBtn.enabled = YES;
    }else{
        _configBtn.enabled = NO;
    }
}

- (void)logOut{
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUT object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
