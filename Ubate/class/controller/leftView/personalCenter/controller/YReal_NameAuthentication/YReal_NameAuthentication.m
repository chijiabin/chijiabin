//
//  YReal_NameAuthentication.m
//  Ubate
//
//  Created by sunbin on 2017/2/5.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "YReal_NameAuthentication.h"
#import "RootViewController.h"
#import "MemberTableViewController.h"
#import "WithdrawOperation.h"
#import "CardTypeList.h"

@interface YReal_NameAuthentication ()
//姓名
@property (weak, nonatomic) IBOutlet UITextField *real_name;
//身份证
@property (weak, nonatomic) IBOutlet UITextField *idcard;
//确认
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;


@property (weak, nonatomic) IBOutlet UILabel *l1;
@property (weak, nonatomic) IBOutlet UILabel *l2;

@end

@implementation YReal_NameAuthentication
{
    YUserInfo *userInfor;
    NSString *pwd;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    self.title = NSLocalizedString(@"实名认证", @"Real name authentication");
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];    [self initView];

}


- (void)loadData{
    self.row = 3;
    userInfor = [YConfig myProfile];
    _confirmBtn.enabled = NO;

    [NHUtils setBtnColor:_confirmBtn];//设置按钮颜色
    [_confirmBtn setLayerBorderWidth:0.f borderColor:nil];//设置按钮圆角

}

//输入框设置
- (IBAction)editingChange:(UITextField *)sender {
    if (![NHUtils isBlankString:_real_name.text]  && ![NHUtils isBlankString:_idcard.text]) {
        _confirmBtn.enabled = YES;
    }else{
        _confirmBtn.enabled = NO;   
    }
}

- (void)initView{

    self.tableView.tableFooterView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectZero];
    [_real_name leftViewModeWithConstrainedToWidth:100.f text:NSLocalizedString(@"姓名:", @"Name :") isLaunchScreen:NO fon:15.f leftFonColor:@"333333" bodyFonColor:@"333333" PlaceholderColor:@"999999"];
    [_idcard leftViewModeWithConstrainedToWidth:100.f text:NSLocalizedString(@"身份证:", @"ID card No :") isLaunchScreen:NO fon:15.f leftFonColor:@"333333" bodyFonColor:@"333333" PlaceholderColor:@"999999"];
    
    [_real_name setPlaceholder:NSLocalizedString(@"请输入您的姓名", @"Please enter your name")];
    _real_name.font = [UIFont systemFontOfSize:13];
    [_idcard setPlaceholder:NSLocalizedString(@"请输入您的身份证号", @"Please enter your ID number")];
    _idcard.font = [UIFont systemFontOfSize:13];
    [_real_name becomeFirstResponder];

    _l1.text = NSLocalizedString(@"为保障您的账户安全，请填写正确的个人资料",@"To ensure the security of your account, please fill in the correct personal data");
    _l2.text = NSLocalizedString(@"注意:以上资料填写后不能修改", @"Note: the above information can not be modified after filling");

    self.tableView.backgroundColor = [UIColor themeColor];

}

//确认
- (IBAction)confirm {
    [self.view endEditing:YES];
    [self alertStyleWithTextField];
}



- (void)alertStyleWithTextField{
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"输入密码", @"Input password") message:NSLocalizedString(@"为保障您的数据安全,请输入登录密码", @"To protect your data security, please enter the login password") preferredStyle:UIAlertControllerStyleAlert];
    [actionSheetController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedString(@"请输入密码", @"Please enter a password");
        textField.secureTextEntry = YES;
        [textField addTarget:self action:@selector(editingChanage:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    

    UIAlertAction *determineAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", @"Sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"%@" ,pwd);
        if ([NHUtils isBlankString:pwd]) {
            [NHUtils alertAction:@selector(enterPwdTemp) alertControllerWithTitle: NSLocalizedString(@"提示", @"Prompt") Message:NSLocalizedString(@"Password is not empty", @"Password is not empty") Vctl:self Cancel:NO];
            
        }else{
            if ([[[YConfig getOwnAccountAndPassword] lastObject] isEqualToString:[pwd md5String]])
            {
                [self checkData];
            }else{
                [NHUtils alertAction:@selector(formatoperation) alertControllerWithTitle:NSLocalizedString(@"提示", @"Prompt") Message:NSLocalizedString(@"密码错误", @"Password error") Vctl:self Cancel:NO];

            }
            
        }
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", @"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionSheetController addAction:determineAction];
    [actionSheetController addAction:cancelAction];
    
    [self presentViewController:actionSheetController animated:YES completion:nil];


    
}

- (void)editingChanage:(UITextField *)sender{
    pwd = sender.text;
}
- (void)enterPwdTemp{}
- (void)passwordinput{}
- (void)formatoperation{}

/**
 * 注释
 *调用三个接口  bindIdcard绑定调用两次（1.判断是否已经使用该用户  2.插入后台数据库）idcardquery（姓名账号匹配）
 *步骤1.正则判断用户名账号密码正确性
 2.调用bindIdcard判断是否经使用该用户
 3.若没有绑定 就匹配账号姓名一致性
 4.若res 为1匹配 再次调用bindIdcard
 verify为验证内容 传入参数的key值需固定 type为验证类型 text为验证内容 length为长度限制 flagEmpty为是否可以为空
 
 */

- (void)checkData{
    
    NSDictionary *verifyparam =  @{
                                   @"verify":@{
                                           @"name":@{
                                                   @"type":@(VerifyTypeChinese),
                                                   @"text":self.real_name.text,
                                                   @"length" : @"1",
                                                   @"flagEmpty" : @(VerifyFlagUnEmpty)
                                                   },
                                           @"password":@{
                                                   @"type":@(VerifyTypeCardID),
                                                   @"text":self.idcard.text,
                                                   @"length" : @"1",
                                                   @"flagEmpty" : @(VerifyFlagUnEmpty)
                                                   }
                                           },
                                   @"unVerify":@(VerifyTipHide)
                                   };
    
    BOOL flag =  [VerifyTool check:verifyparam];
    if (flag) {
        if ( [[[YConfig getOwnAccountAndPassword] lastObject] isEqualToString:[pwd md5String]]) {
            NSDictionary *checkparamDic = @{
                                            @"uid":@([YConfig getOwnID]) ,
                                            @"realname":self.real_name.text ,
                                            @"idcard":self.idcard.text ,
                                            @"pwd":[pwd  md5String],
                                            @"check":@(1),
                                            @"sign":[YConfig getSign]
                                            };
        [YNetworking postRequestWithUrl:bindIdcard params:checkparamDic cache:NO successBlock:^(id returnData, int code, NSString *msg) {
                if (code == 1) {
                    [self idcardquerRequest];
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
                    [NHUtils alertAction:@selector(passwordinput) alertControllerWithTitle:NSLocalizedString(@"error", @"error") Message:msg Vctl:self Cancel:NO];
                }
            } failureBlock:^(NSError *error) {
                [NHUtils alertAction:@selector(passwordinput) alertControllerWithTitle:NSLocalizedString(@"error", @"error") Message:error.localizedDescription Vctl:self Cancel:NO];
            } showHUD:NO];
        }else{
            [NHUtils alertAction:@selector(passwordinput) alertControllerWithTitle:NSLocalizedString(@"error", @"error") Message:NSLocalizedString(@"Wrong password, please enter again", @"Wrong password, please enter again") Vctl:self Cancel:NO];
        }
    }else{
        [NHUtils alertAction:@selector(formatoperation) alertControllerWithTitle:NSLocalizedString(@"错误", @"error") Message:NSLocalizedString(@"请按照正确格式输入", @"Please type in the correct format") Vctl:self Cancel:NO];
    }

}
- (void)idcardquerRequest{
    NSDictionary *idcardqueryparams = @{
                                        @"idcard":_idcard.text,
                                        @"realname":[YUrlencode decodeString:_real_name.text],
                                        @"key":idcardquerykey
                                        };
    [YNetworking postRequestWithUrl:idcardquery params:idcardqueryparams cache:NO successBlock:^(id returnData, int code, NSString *msg) {
        
        NSDictionary *result = [(NSDictionary *)returnData objectForKey:@"result"];
        NSLog(@"%@" ,result);
        
        if ([result isEqual:[NSNull null]]) {
            
            [self.view showSuccess:@"信息不匹配"];
            
        }else{
        
            if ([TEXT_STRING([result objectForKey:@"res"]) isEqualToString:@"1"]) {
                //验证成功后 保存数据
                
                NSDictionary *checkparamDic = @{
                                                @"uid":@([YConfig getOwnID]) ,
                                                @"realname":self.real_name.text ,
                                                @"idcard":self.idcard.text ,
                                                @"pwd":[pwd  md5String],
                                                @"check":@"",
                                                @"sign":[YConfig getSign]
                                                };
                [self saveDataOfRealName:checkparamDic];
            }else{
                
                [self.view showSuccess:@"实名认证不匹配"];
                NSLog(@"%@" ,returnData);
            }
        
        }
        

    } failureBlock:^(NSError *error) {
    } showHUD:NO];

}
- (void)saveDataOfRealName:(NSDictionary *)paramDic{
    WEAKSELF;
    
    [YNetworking postRequestWithUrl:bindIdcard params:paramDic cache:NO successBlock:^(id returnData, int code, NSString *msg) {
        
        if (code == 1) {
            NSLog(@"成功");
            userInfor.real_name = weakSelf.real_name.text;
            userInfor.idcard = weakSelf.idcard.text;
            kAppDelegate.userInfo = userInfor;
            
            //个人中心 上-视图
            MemberTableViewController*memberViewController;
            
            for (UIViewController *ctl in weakSelf.navigationController.viewControllers) {
                if ([ctl isKindOfClass:[MemberTableViewController class]]) {
                    memberViewController = (MemberTableViewController*)ctl;
                }}
            if (memberViewController) {
                memberViewController.title = @"实名认证";
                [weakSelf.navigationController popToViewController:memberViewController animated:NO];
                return ;
            }
            
#pragma make 个人中心 上-视图 判断_indexMake是否为空 不为空返现转出  为空绑定账号列表
            //1个人中心
            RootViewController *root;
            for (UIViewController *ctl in weakSelf.navigationController.viewControllers) {
                if ([ctl isKindOfClass:[RootViewController class]]) {
                    root = (RootViewController*)ctl;
                }}
            //2主页
            if (root) {
                if ([NHUtils isBlankString:_indexMake]) {
                    //2.1绑定账号
                    CardTypeList *cardTypeList = [[CardTypeList alloc] initWithStyle:UITableViewStyleGrouped];
                    cardTypeList.title = @"绑定账号";
                    [self .navigationController pushViewController:cardTypeList animated:NO];
                    
                }else{
                    //2.2返现转出操作
                    WithdrawOperation *withdrawOperation = [[WithdrawOperation alloc] initWithStyle:UITableViewStyleGrouped];
                    withdrawOperation.title = @"返现转出";
                    [self .navigationController pushViewController:withdrawOperation animated:NO];
                    
                }
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
            
            NSLog(@"失败%@" ,msg);
        }
    } failureBlock:^(NSError *error) {
        
    } showHUD:YES];
    
}


#pragma make -UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (_real_name.text.length >0 && _idcard.text.length >0 ) {
        [self confirm];
    }else{
        [_idcard becomeFirstResponder];
    }
    return YES;

}




- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }else
    {
        return 0;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
