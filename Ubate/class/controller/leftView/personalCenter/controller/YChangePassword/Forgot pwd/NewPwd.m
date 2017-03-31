//
//  NewPwd.m
//  Ubate
//
//  Created by 池先生 on 17/3/21.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "NewPwd.h"
#import "YChangePassword.h"
@interface NewPwd ()

//新密码
@property (weak, nonatomic) IBOutlet UITextField *newpwd;
//确认密码
@property (weak, nonatomic) IBOutlet UITextField *confirmpwd;
//确认
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@end

@implementation NewPwd

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.confirmBtn.enabled = NO;
    self.confirmBtn.alpha = 0.4;


}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = NSLocalizedString(@"输入密码", @"Got_paway");
    
    [self.confirmBtn setLayerCornerRadius:5.0f borderWidth:0.5f borderColor:[UIColor borderColor]];
    
        [self.newpwd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.confirmpwd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

//监听
- (void) textFieldDidChange:(id) sender {
    
    if (self.newpwd.text.length > 0 && self.confirmpwd.text.length > 0) {
        self.confirmBtn.enabled = YES;
        self.confirmBtn.alpha = 1;
    }else{
        self.confirmBtn.enabled = NO;
        self.confirmBtn.alpha = 0.4;
    }
}

//监听输入框
- (IBAction)pwdnum:(UITextField *)sender {}


//确认
- (IBAction)Yesbtn:(UIButton *)sender {
    
    if ([self.newpwd.text checkPassWord] && [self.confirmpwd.text checkPassWord]) {
        
        if ([self.newpwd.text isEqualToString:self.confirmpwd.text]) {
            NSDictionary *params = @{
                                     @"uid": @([YConfig getOwnID]),
                                     @"password":[self.newpwd.text md5String],
                                     @"newpass":[self.confirmpwd.text md5String],
                                     @"sign":[YConfig getSign]};
            
             [YNetworking postRequestWithUrl:MyNews params:params cache:YES successBlock:^(id returnData, int code, NSString *msg) {
                 
                 if (code == 1) {
                     
                     for (UIViewController *ctl in self.navigationController.viewControllers) {
                         if ([ctl isKindOfClass:[YChangePassword class]])
                         {
                             [self.navigationController popToViewController:ctl animated:NO];
                         }}
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
                     
                     [self.view showLoadFinish:msg];
                 }
             } failureBlock:^(NSError *error) {
                 
             } showHUD:YES];
            
            
//            [self requestWithUrl:editPwd params:params isCache:YES showHUD:YES myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg) {
//                
//                if (state == Succeed) {
//                    
//                    for (UIViewController *ctl in self.navigationController.viewControllers) {
//                        if ([ctl isKindOfClass:[YChangePassword class]])
//                        {
//                            [self.navigationController popToViewController:ctl animated:NO];
//                        }}
//                }else{
//                    
//                    [self.view showLoadFinish:msg];
//                }
//            }];
        }else{
            [self.view showSuccess:@"两次输入的密码不一致"];
        }
        
    }else{
        NSLog(@"密码不符合要求");
        [NHUtils alertAction:@selector(pwdSpecification) alertControllerWithTitle:@"错误" Message:@"密码由8-20位数字和字母组成,请按照要求填写" Vctl:self Cancel:NO];
    }
}

//密码不符合要求
- (void)pwdSpecification{
    
    //清空输入框
    self.newpwd.text = nil;
    self.confirmpwd.text = nil;
    [self.newpwd becomeFirstResponder];
    
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
