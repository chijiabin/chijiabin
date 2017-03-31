//
//  Addcard.m
//  Ubate
//
//  Created by sunbin on 2016/12/3.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "Addcard.h"
#import "TransferAccountsList.h"
#import "YUrlencode.h"
#import "CardTypeList.h"

@interface Addcard ()<UITextFieldDelegate>
//姓名
@property (weak, nonatomic) IBOutlet UITextField *realname;
//帐号
@property (weak, nonatomic) IBOutlet UITextField *account;
//确定
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (nonatomic ,strong) YUserInfo *userInfor;

@end

@implementation Addcard
{
    NSString *titleForHeaderInSection;//头部显示表示文字
    NSString *placeStr;               //当前视图标题
    NSString *bank_code;              //银行名表示
    NSString *pwd;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData]; [self initView];
}

- (void)initView{
    self.row = 2;
    _userInfor = [YConfig myProfile];//获取个人中心

    // 账号 姓名 左侧标题
    [_realname leftViewModeWithConstrainedToWidth:100.f text:NSLocalizedString(@"姓名", @"Name ") isLaunchScreen:NO];
    [_account leftViewModeWithConstrainedToWidth:100.f text:[placeStr stringByAppendingString:@"  "] isLaunchScreen:NO];

    // 影藏省略部分
    self.realname.text = [NHUtils cipherShowText:RelaName cipherData:_userInfor.real_name];

    [NHUtils setBtnColor:_confirmBtn];
    _confirmBtn.enabled = NO;
    [_confirmBtn setTitle:NSLocalizedString(@"确定", @"Sure") forState:UIControlStateNormal];
    [_confirmBtn setLayerCornerRadius:20.0f borderWidth:0.5f borderColor:[UIColor borderColor]];
}

- (void)loadData{
    
    titleForHeaderInSection  = NSLocalizedString(@"请绑定与实名认证信息一致的", @"Please bind with the real name authentication information");
    if ([_make isEqualToString:@"0"]) {
        placeStr = NSLocalizedString(@"支付宝帐号", @"Alipay");
        titleForHeaderInSection = [titleForHeaderInSection stringByAppendingString:placeStr];
        
    }else if ([_make isEqualToString:@"1"]){
        placeStr = NSLocalizedString(@"微信帐号", @"WeChat account");
        titleForHeaderInSection = [titleForHeaderInSection stringByAppendingString:placeStr];
    }else{
        placeStr = NSLocalizedString(@"银行卡号", @"Bank card");
        titleForHeaderInSection = NSLocalizedString(@"请绑定持卡人本人的银行卡", @"Please bind the cardholder's bank card");
    }
    self.title = [NSLocalizedString(@"添加", @"Add to") stringByAppendingString:placeStr];
    _account.keyboardType = UIKeyboardTypeASCIICapable;
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return titleForHeaderInSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ScaleHeight(30.f);
}


//确定
- (IBAction)addCardConfirmBtn {
    [self.view endEditing:YES];
    
    WEAKSELF;
    
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"输入登录密码", @"Enter login password") message:NSLocalizedString(@"为保障您本人操作及数据安全，请输入登录密码", @"In order to ensure the security of you I operation and data, please enter the password") preferredStyle:UIAlertControllerStyleAlert];
    [actionSheetController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder     = NSLocalizedString(@"请输入密码", @"Please enter a password");
        textField.secureTextEntry = YES;
        textField.textAlignment   = NSTextAlignmentCenter;
        
        [textField addTarget:weakSelf action:@selector(usernameDidChange:)forControlEvents:UIControlEventEditingChanged];
        
    }];
    
    
    UIAlertAction *determineAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认", @"Sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.view endEditing:YES];
        
        if ([NHUtils isBlankString:pwd]) {
            [NHUtils alertAction:@selector(msgAlert) alertControllerWithTitle:NSLocalizedString(@"提示", @"Prompt") Message:NSLocalizedString(@"密码不能为空", @"Password is not empty") Vctl:weakSelf Cancel:NO];
            
            return ;
        }else{
            
            if ([[[YConfig getOwnAccountAndPassword] lastObject] isEqualToString:[pwd md5String]]) {
                
                if (![_make isEqualToString:@"2"]) {
#pragma make 0支付宝（手机与邮箱）  1微信（长度>=6 不允许中文）
                    NSDictionary *params = @{
                                             @"uid":  @([YConfig getOwnID]),
                                             @"account":_account.text,
                                             @"type":@([_make integerValue]),
                                             @"sign":[YConfig getSign]
                                             };
                    //支付宝
                    if ([_make integerValue] == 0) {
                        if ([_account.text isEmailAddress] || [_account.text isMobileNumberClassification]) {
                            [self Networking:[_make integerValue] requesAPI:bindAccount requesParams:params];
                        }else{
                            NSLog(@"判断是否手机或邮箱");
                            [NHUtils alertAction:@selector(msgAlert) alertControllerWithTitle:NSLocalizedString(@"Prompt", @"Prompt") Message:NSLocalizedString(@"Alipay mobile phone number or email account to be bound", @"Alipay mobile phone number or email account to be bound") Vctl:self Cancel:NO];
                        }
                    }
                    //微信
                    if ([_make integerValue] == 1) {
                        if (18>= _account.text.length  && _account.text.length >=6) {
                            [self Networking:[_make integerValue] requesAPI:bindAccount requesParams:params];
                        }else{
                            [NHUtils alertAction:@selector(msgAlert) alertControllerWithTitle:NSLocalizedString(@"Prompt", @"Prompt") Message:NSLocalizedString(@"WeChat account error", @"WeChat account error") Vctl:self Cancel:NO];
                        }}
                }else{
                    
                    
                    
                     //1判断是非他人绑定
                     //2判断是非与实名认证姓名一致
                     //姓名 匹配
                     //3插入
                    
                    NSDictionary *matchingparams = @{
                                                     @"bankcard":_account.text,
                                                     @"realname":[YUrlencode decodeString:_userInfor.real_name],
                                                     @"key":verifybankcardqueryKey};
               
                    [weakSelf checkCar:matchingparams];
     
                }


                
            }else{
                [NHUtils alertAction:@selector(msgAlert) alertControllerWithTitle:NSLocalizedString(@"Prompt", @"Prompt") Message:NSLocalizedString(@"密码错误,请重新输入", @"rong password, please enter again") Vctl:weakSelf Cancel:NO];
            }
        }
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", @"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [actionSheetController addAction:determineAction];
    [actionSheetController addAction:cancelAction];
    
    [self presentViewController:actionSheetController animated:YES completion:nil];
    
    
}



- (void)Networking:(NSInteger)requesType requesAPI:(NSString *)api requesParams:(NSDictionary *)params{
    [YNetworking postRequestWithUrl:api params:params cache:NO successBlock:^(id returnData, int code, NSString *msg) {
        
        if (code == 1) {
            switch (requesType) {
                case 0:{
                    //绑定支付宝
                    _userInfor.baofu_account = _account.text;
                    _userInfor.baofu_status  = @"1";
                }
                    break;
                case 1:{
                    //绑定微信
                    _userInfor.wechat_account = _account.text;
                    _userInfor.wechat_status  = @"1";
                }
                    break;
                case 2:{
                    //绑定银行
                    NSDictionary *data =  [returnData objectForKey:@"data"];
                    _userInfor.bank_name    = [data objectForKey:@"bank_name"];
                    _userInfor.bank_account = [data objectForKey:@"bank_num"];
                    _userInfor.bank_code    = [data objectForKey:@"bank_code"];
                    _userInfor.bank_img     = [data objectForKey:@"bank_img"];
                    _userInfor.bank_status  = @"1";
                }
                    break;
                default:
                    break;
            }
            kAppDelegate.userInfo = _userInfor;
            [self pushToTransferAccountsList];//跳转具体控制器
        }
        else if(code == 201){
            
            [self.view showSuccess:@"登录过期，请重新登录"];
            
            dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
            dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                [YConfig outlog];
            });
            
        }
        else if(code == 202){
            
            [self.view showSuccess:@"您的帐号在另一处登录，请重新登录"];
            
            dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
            dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                [YConfig outlog];
            });
            
        }
        else{
            NSLog(@"%@" ,msg);
            [NHUtils alertAction:@selector(msgAlert) alertControllerWithTitle:@"提示" Message:msg Vctl:self Cancel:NO];

        }
    } failureBlock:^(NSError *error) {
        NSLog(@"%@" ,error.localizedDescription);
    } showHUD:YES];
}



- (void)usernameDidChange:(UITextField *)sender{
    pwd = sender.text;
}


- (void)msgAlert{
    [_account becomeFirstResponder];
    _account.text = nil;
}

- (void)pushToTransferAccountsList{
    TransferAccountsList *accountsList;
    
    for (UIViewController *ctl in self.navigationController.viewControllers) {
        if ([ctl isKindOfClass:[TransferAccountsList class]]) {
            accountsList = (TransferAccountsList *)ctl;
            [self.navigationController popToViewController:accountsList animated:true];
        }
    }
    
    CardTypeList *cardTypeList;
    NSArray *ary = self.navigationController.viewControllers;
    if ([[ary objectAtIndex:ary.count-2] isKindOfClass:[CardTypeList class]]) {
        cardTypeList = (CardTypeList *)[ary objectAtIndex:ary.count-2];
        [self.navigationController popToViewController:cardTypeList animated:true];
    }
}

//
- (void)insertedDataBase{
    //绑定银行卡
    NSDictionary *params = @{
                             @"uid":  @([YConfig getOwnID]),
                             @"bank_num":_account.text,
                             @"sign":[YConfig getSign]
                             };
    [self Networking:[_make integerValue] requesAPI:bindbank requesParams:params];

}

- (void)checkCar:(NSDictionary *)carInfor{

    [YNetworking postRequestWithUrl:verifybankcardquery params:carInfor cache:NO successBlock:^(id returnData, int code, NSString *msg) {
        
        NSString *error_code = IF_NULL_TO_STRING([(NSDictionary *)returnData objectForKey:@"error_code"]);
        
        NSString *reason = IF_NULL_TO_STRING([(NSDictionary *)returnData objectForKey:@"reason"]);
        //0 计费
        if ([error_code isEqualToString:@"0"]) {
            NSDictionary *result = [(NSDictionary *)returnData objectForKey:@"result"];
            NSString *res = IF_NULL_TO_STRING([result objectForKey:@"res"]);
            if ([res isEqualToString:@"1"]) {
                NSLog(@"匹配");
                [self insertedDataBase];
            }else{
                NSLog(@"%@" ,reason);
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"该银行卡与实名验证不符合" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    _account.text = nil;
                }];
                
                [alert addAction:actionYES];
                [alert addAction:actionNO];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
        }else{
            NSLog(@"%@" ,reason);
        }
 
    } failureBlock:^(NSError *error) {
      
        
    } showHUD:NO];
}


- (IBAction)editingChanged:(UITextField *)sender {
    if (sender.text.length > 0) {
        _confirmBtn.enabled = YES;
    }else{
        _confirmBtn.enabled = NO;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length > 0) {
        [self addCardConfirmBtn];
        return YES;
    }else{
        return NO;
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}



@end
