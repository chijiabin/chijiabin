//
//  YNickName.m
//  Ubate
//
//  Created by sunbin on 2017/2/8.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "YNickName.h"

@interface YNickName ()
@property (weak, nonatomic) IBOutlet UITextField *nickName;

@property (nonatomic ,strong) YUserInfo *userInfor;
@end

@implementation YNickName
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.title = @"更改用户名";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    filterLen = [[TextFilter alloc] init];
    [filterLen SetFilter:_nickName
                delegate:self
                maxCHLen:12
                allowNum:YES
                 allowCH:YES
             allowLetter:YES
             allowLETTER:YES
             allowSymbol:YES
             allowOthers:nil];
    
    [self loadData]; [self initView];

}

- (void)loadData{
    self.row = 1;
    _userInfor = [YConfig myProfile];
    _nickName.text = self.userInfor.nickname ;
    
    [_nickName leftViewModeWithConstrainedToWidth:100.f text:@"昵称: " isLaunchScreen:NO fon:15.f leftFonColor:@"333333" bodyFonColor:@"333333" PlaceholderColor:@"999999"];
    
}
- (void)initView{
    self.view.backgroundColor = [UIColor themeColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (IBAction)editingChanged:(UITextField *)sender {
    
    if ([sender.text isBlankString])
    {
        if (sender == self.nickName) {
            if (sender.text.length > 10) {
                sender.text = [sender.text substringToIndex:10];
            }
        }
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
}
- (void)confirm{
    [self.view endEditing:YES];
    
    NSDictionary *params = @{ @"uid": @([YConfig getOwnID]),
                              @"nickname":_nickName.text,
                              @"sign":[YConfig getSign]
                              };
    WEAKSELF;
    
     [YNetworking postRequestWithUrl:editInfo params:params cache:YES successBlock:^(id returnData, int code, NSString *msg) {
         if (code == 1) {
             
             weakSelf.userInfor.nickname = weakSelf.nickName.text;
             kAppDelegate.userInfo = weakSelf.userInfor;
             
             [weakSelf.navigationController popViewControllerAnimated:YES];

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
             [weakSelf.navigationController.view showLoadFinish:msg];
             
         }
         
         
     } failureBlock:^(NSError *error) {
         
     } showHUD:YES];
    
    
//    [self requestWithUrl:editInfo params:params isCache:NO showHUD:YES myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg) {
//        if (state == Succeed) {
//            
//            weakSelf.userInfor.nickname = weakSelf.nickName.text;
//            kAppDelegate.userInfo = weakSelf.userInfor;
//            
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//        }else{
//            [weakSelf.navigationController.view showLoadFinish:msg];
//
//        }
//    }];
    

    
    
}
#pragma make -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (_nickName.text.length >0 ) {
        [self confirm];
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.nickName) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 10) {
            return NO;
        }
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
