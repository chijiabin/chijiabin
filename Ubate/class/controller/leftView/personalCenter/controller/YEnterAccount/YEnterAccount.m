//
//  YEnterAccount.m
//  Ubate
//
//  Created by sunbin on 2017/2/10.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "YEnterAccount.h"
#import "YVerifyPassword.h"
#import "MemberTableViewController.h"

@interface YEnterAccount ()
//文字
@property (weak, nonatomic) IBOutlet UILabel *alertTitle;
//手机号
@property (weak, nonatomic) IBOutlet UITextField *account;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *scoderNum;
//发送验证码
@property (weak, nonatomic) IBOutlet UIButton *resentScode;
//确认
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (nonatomic,strong) NSString * UID;
@end

@implementation YEnterAccount
{
    YUserInfo *userInfor;
    NSDictionary *resentScodeParams;
    NSString *requestURL;
    NSDictionary *senderScodeParams;
    
    BOOL isEmail;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self pop];
}
- (void)pop{
    NSLog(@"%@" ,self.navigationController.viewControllers);
    [NHUtils pushAndPop:@"YVerifyPassword" range:NSMakeRange(3, 1) currentCtl:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self initView];
    
    [_confirmBtn setLayerBorderWidth:0.0f borderColor:[UIColor borderColor]];
}

- (void)loadData{
    userInfor = [YConfig myProfile];
    
    self.UID = userInfor.uid;
    
    self.row = 1;
}


- (void)initView{
    
    NSString *leftStrMake;
    NSString *titleMake;
    NSString *accountPlace;
    
    switch (_checkPwdType) {
        case BingPhone:{
            leftStrMake = @"手机号: ";       titleMake = @"绑定手机号";
            accountPlace = @"请输入手机号";
            requestURL = editPhone;
            isEmail = NO;
        }
            
            break;
        case BingEmail:{
            leftStrMake = @"邮箱: ";     titleMake = @"绑定邮箱";
            accountPlace = @"请输入邮箱";
            requestURL = editEmail;
            isEmail = YES;
            
        }
            
            break;
        case FixPhoneNum:{
            leftStrMake = @"手机号: ";   titleMake = @"更改手机号";
            accountPlace = @"请输入手机号";
            requestURL = editPhone;
            isEmail = NO;
            
        }
            
            break;
        case FixEmailAdress:{
            leftStrMake = @"邮箱: ";    titleMake = @"更改邮箱";
            accountPlace = @"请输入邮箱";
            requestURL = editEmail;
            isEmail = YES;
            
        }
            
            break;
            
        default:
            break;
    }
    self.title = titleMake;

    NSRange range =  NSMakeRange(3, leftStrMake.length-2);
    NSMutableString *str = [[NSMutableString alloc] initWithString:_alertTitle.text];
    [str insertString:leftStrMake atIndex:3];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor py_colorWithHexString:@"208dcf"]} range:range];
    
    [_alertTitle setAttributedText:attributedString];
    
    [_account leftViewModeWithConstrainedToWidth:100.f text:leftStrMake isLaunchScreen:NO fon:15.f leftFonColor:@"333333" bodyFonColor:@"333333" PlaceholderColor:@"999999"];
    
    
    [_scoderNum leftViewModeWithConstrainedToWidth:100.f text:@"验证码: " isLaunchScreen:NO fon:15.f leftFonColor:@"333333" bodyFonColor:@"333333" PlaceholderColor:@"999999"];
    
    [_account setPlaceholder:accountPlace];
    [_scoderNum setPlaceholder:@"输入验证码"];


    self.tableView.backgroundColor = [UIColor themeColor];
    [NHUtils setBtnColor:_confirmBtn];
    _confirmBtn.enabled = NO;
    [_confirmBtn setLayerBorderWidth:0.f borderColor:nil];//设置按钮圆角

}

//确认
- (IBAction)confirm {
    if (_account.text.length >0 && _scoderNum.text.length >0) {
        [self editNum];
    }else{
        NSLog(@"不为空");
        [NHUtils alertAction:@selector(enterTemp) alertControllerWithTitle:@"提示" Message:@"输入内容不能为空,请重新输入" Vctl:self Cancel:NO];
    }
}
- (void)enterTemp{}


- (void)editNum{
    
    MemberTableViewController*memberViewController;
    for (UIViewController * cont in self.navigationController.viewControllers) {
        if ([cont isKindOfClass:[MemberTableViewController class]]) {
            memberViewController =(MemberTableViewController *) cont;
            break;
        }}
    WEAKSELF;
    senderScodeParams = [self requestData:NO];

    
    [YNetworking postRequestWithUrl:requestURL params:senderScodeParams cache:YES successBlock:^(id returnData, int code, NSString *msg) {
        
        if (code == 1) {
            switch (_checkPwdType) {
                    
                    
                case BingPhone:{
                    userInfor.user_phone = _account.text;
                    kAppDelegate.userInfo = userInfor;
                    
                    [weakSelf.navigationController popToViewController:memberViewController animated:NO];
                }
                    
                    break;
                    
                case BingEmail:{
                    
                    userInfor.user_email = _account.text;
                    kAppDelegate.userInfo = userInfor;
                    
                    [weakSelf.navigationController popToViewController:memberViewController animated:NO];
                    
                }
                    break;
                    //修改手机号
                case FixPhoneNum:{
                    
                    userInfor.user_phone = _account.text;
                    kAppDelegate.userInfo = userInfor;
                    
                    if ([weakSelf isPhoneLog]) {
                        [self accountFix];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUT object:nil];
                        
                    }else{
                        [weakSelf.navigationController popToViewController:memberViewController animated:NO];
                        
                    }
                    
                }
                    
                    break;
                    
                    //修改邮箱号
                case FixEmailAdress:{
                    
                    //更新数据
                    userInfor.user_email = _account.text;
                    kAppDelegate.userInfo = userInfor;
                    
                    if ([weakSelf isPhoneLog]) {
                        
                        
                        [self accountFix];
                        [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUT object:nil];
                        
                    }else{
                        [weakSelf.navigationController popToViewController:memberViewController animated:NO];
                    }
                }
                    
                    break;
                    
                default:
                    break;
            }
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
            
            [self.navigationController.view showError:msg];
        }
        
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:YES];
    
    
//    [self requestWithUrl:requestURL params:senderScodeParams isCache:NO showHUD:YES myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg) {
//    
//        if (state == Succeed) {
//            
//            switch (_checkPwdType) {
//                    
//                    
//                case BingPhone:{
//                    userInfor.user_phone = _account.text;
//                    kAppDelegate.userInfo = userInfor;
//                    
//                    [weakSelf.navigationController popToViewController:memberViewController animated:NO];
//                }
//                    
//                    break;
//                    
//                case BingEmail:{
//                    
//                    userInfor.user_email = _account.text;
//                    kAppDelegate.userInfo = userInfor;
//                    
//                    [weakSelf.navigationController popToViewController:memberViewController animated:NO];
//                    
//                }
//                    break;
//                //修改手机号    
//                case FixPhoneNum:{
//                    
//                    userInfor.user_phone = _account.text;
//                    kAppDelegate.userInfo = userInfor;
//                    
//                    if ([weakSelf isPhoneLog]) {
//                        [self accountFix];
//                        
//                        [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUT object:nil];
//                        
//                    }else{
//                        [weakSelf.navigationController popToViewController:memberViewController animated:NO];
//                        
//                    }
//                    
//                }
//                    
//                    break;
//
//                //修改邮箱号
//                case FixEmailAdress:{
//                    
//                    //更新数据
//                    userInfor.user_email = _account.text;
//                    kAppDelegate.userInfo = userInfor;
//                    
//                    if ([weakSelf isPhoneLog]) {
//                        
//                        
//                        [self accountFix];
//                        [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUT object:nil];
//                        
//                    }else{
//                        [weakSelf.navigationController popToViewController:memberViewController animated:NO];
//                    }
//                }
//                    
//                    break;
//                    
//                default:
//                    break;
//            }
//  
//        }else{
//            
//            [self.navigationController.view showError:msg];
//        }
//        
//    }];

}


- (void)accountFix{
    NSString *pwd = [[YConfig getOwnAccountAndPassword] lastObject];
    [YConfig saveOwnAccount:_account.text andPassword:pwd];
}

//发送验证码
- (IBAction)toResend:(UIButton *)sender {
    
    NSLog(@"%@" ,resentScodeParams);
    if (_account.text.length > 0) {
        if (isEmail) {
            if ([_account.text isEmailAddress]) {
                
                [self loadRequest];
            }else{
                [NHUtils alertAction:@selector(resendError) alertControllerWithTitle:@"输入邮箱格式有误 ,请重新输入" Message:@"" Vctl:self Cancel:NO];
            }
        }else{
            if ([_account.text isMobileNumberClassification])
            {
                [self loadRequest];
                
            }else{
                [NHUtils alertAction:@selector(resendError) alertControllerWithTitle:@"输入手机号码格式有误 ,请重新输入" Message:@"" Vctl:self Cancel:NO];
            }
        }
    }else{
        [NHUtils alertAction:@selector(resendError) alertControllerWithTitle:@"绑定或修改的账号不能为空 ,请重新输入" Message:@"" Vctl:self Cancel:NO];

    }
}
- (void)resendError{
    _account.text = nil;
    [_account becomeFirstResponder];
}

- (void)loadRequest{
    WEAKSELF;
    resentScodeParams = [self requestData: YES];
    
    [YNetworking postRequestWithUrl:requestURL params:resentScodeParams cache:YES successBlock:^(id returnData, int code, NSString *msg) {
        
        if (code == 1) {
            
            [weakSelf.resentScode startTime:59 title:@"重新发送验证码" waitTittle:@"秒" respond:^(BOOL isPlayComple) {
                if (isPlayComple) {
                    [self.view showSuccess:msg];
                    
                }else{
                    
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

    } failureBlock:^(NSError *error) {
        
    } showHUD:YES];
    
    
//    [self requestWithUrl:requestURL params:resentScodeParams isCache:NO showHUD:YES myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg) {
//        [weakSelf.navigationController.view showLoadFinish:msg];
//        if (state == Succeed) {
//            [weakSelf.resentScode startTime:59 title:@"重新发送验证码" waitTittle:@"秒" respond:^(BOOL isPlayComple) {
//                if (isPlayComple) {
//                }else{
//
//                }
//            }];
//  
//        }else{
//        }
//    }];
    
}


- (NSDictionary *)requestData:(BOOL)isResend{
    NSDictionary *resentScodeDic;
    NSDictionary *senderScodeDic;
    
    
    switch (_checkPwdType) {
        case BingPhone:
            resentScodeDic = [NHUtils parameterName:@[@"sign" ,@"send" ,@"nphone" ,@"uid"] parameterData:@[[YConfig getSign] ,@(1) ,_account.text ,[NSString stringWithFormat:@"%@",self.UID]]];
            
            senderScodeDic = [NHUtils parameterName:@[@"sign" ,@"scode" ,@"nphone" ,@"uid"] parameterData:@[[YConfig getSign] ,_scoderNum.text ,_account.text ,[NSString stringWithFormat:@"%@",self.UID]]];
            break;
         
        //绑定邮箱
        case BingEmail:{
            //验证码
            resentScodeDic = [NHUtils parameterName:@[@"sign" ,@"send" ,@"nemail" ,@"uid"] parameterData:@[[YConfig getSign] ,@(1) ,_account.text ,[NSString stringWithFormat:@"%@",self.UID]]];
            //绑定邮箱
            senderScodeDic = [NHUtils parameterName:@[@"sign" ,@"scode" ,@"nemail" ,@"uid"] parameterData:@[[YConfig getSign] ,_scoderNum.text ,_account.text ,[NSString stringWithFormat:@"%@",self.UID]]];
            
        }
            
            break;
            
        case FixPhoneNum:{
            resentScodeDic = [NHUtils parameterName:@[@"sign" ,@"send" ,@"nphone" ,@"uid"] parameterData:@[[YConfig getSign] ,@(1) ,_account.text ,[NSString stringWithFormat:@"%@",self.UID]]];
            
            senderScodeDic = [NHUtils parameterName:@[@"sign" ,@"scode" ,@"nphone" ,@"uid"] parameterData:@[[YConfig getSign] ,_scoderNum.text ,_account.text ,[NSString stringWithFormat:@"%@",self.UID]]];
            
        }
            
            break;
            
        //修改邮箱
        case FixEmailAdress:{
            resentScodeDic = [NHUtils parameterName:@[@"sign" ,@"send" ,@"nemail" ,@"uid"] parameterData:@[[YConfig getSign] ,@(1) ,_account.text ,[NSString stringWithFormat:@"%@",self.UID]]];
            
            senderScodeDic = [NHUtils parameterName:@[@"sign" ,@"scode" ,@"nemail" ,@"uid"] parameterData:@[[YConfig getSign] ,_scoderNum.text ,_account.text ,[NSString stringWithFormat:@"%@",self.UID]]];
            
        }
            break;
        default:
            break;
    }
    if (isResend) {
        return resentScodeDic;
    }else{
        return senderScodeDic;
    }
    
}

- (BOOL)isPhoneLog{
    NSString *account = [[YConfig getOwnAccountAndPassword] firstObject];
    BOOL isPhoneLog;
    if (![account isEmailAddress]) {
        isPhoneLog = YES;
    }else{
        isPhoneLog = NO;
    }
    return isPhoneLog;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}





@end
