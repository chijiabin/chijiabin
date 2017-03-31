//
//  WithdrawOperation.m
//  Ubate
//
//  Created by sunbin on 2017/2/7.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "WithdrawOperation.h"
#import "CardDetai.h"

#import "DefaultAccountCell.h"
#import "WithdrawalAmount.h"
#import "WithdrawlConfirm.h"

#import "InPutPassWordView.h"

#import "WayBack.h"
#import "LoadHtml.h"
#import "TransferAccountsList.h"
#import "WithdrawResults.h"
#import "Rollout.h"

static NSString * DefaultAccountIden    = @"DefaultAccount_Identifier";  //默认转出账号
static NSString * WithdrawalAmountIden  = @"WithdrawalAmount_Identifier";//转出金额 用户输入
static NSString * WithdrawlConfirmIden  = @"WithdrawlConfirm_Identifier";//转出确认按钮
static NSString * AccountMoneyIden      = @"AccountMoney_Identifier";    //可用余额



@interface WithdrawOperation ()<WithdrawlConfirmDelegate  ,WithdrawalAmountDelegate ,InPutPassWordViewDelegate>



@property (nonatomic ,assign) BingMethodMethod bingCardCount;  //卡号绑定个数获取

@property (nonatomic ,strong) NSMutableArray *bingCardNumAry;  //绑定的数据
@property (nonatomic ,strong) NSMutableArray *nobingCardNumAry;//未绑定的数据

@end

@implementation WithdrawOperation
{
    YUserInfo *userInfor;

    NSString *account_money ;//账户可用余额
    BOOL _wasKeyboardManagerEnabled;//键盘局部设置

    NSString *lisToenterMoney;//用户输入金额 监听文本输入的金额
    NSString *enterMoneyShow; //全部转出金额
    WithdrawlConfirm *confirmBtn;//确认转出按钮

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"返现转出", @"Withdrawal");

    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self pop];
    
    userInfor = [YConfig myProfile];
    account_money = [[AccountMoneySingle sharedAccountMoneySingle].dic objectForKey:@"account_money"];
    
    
    [self initView];
    [self loadData];
    [self rightBarItem];
    [self.tableView reloadData];

}

- (void)pop{
    //返回主视图
    [NHUtils pushAndPop:@"YReal_NameAuthentication" range:NSMakeRange(1, 1) currentCtl:self];
    
    [NHUtils pushAndPop:@"CardDetai" range:NSMakeRange(1, 2) currentCtl:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor py_colorWithHexString:@"f5f5f5"];

}


- (void)initView{
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1f)];
    [self.tableView registerNib:[UINib nibWithNibName:@"WithdrawalAmount" bundle:nil] forCellReuseIdentifier:WithdrawalAmountIden];
    [self.tableView registerNib:[UINib nibWithNibName:@"DefaultAccountCell" bundle:nil] forCellReuseIdentifier:DefaultAccountIden];
    [self.tableView registerNib:[UINib nibWithNibName:@"WithdrawlConfirm" bundle:nil] forHeaderFooterViewReuseIdentifier:WithdrawlConfirmIden];
}
- (void)loadData{    [self checkBindingCardNumber];}
//获取 数据 绑定卡号数据
- (void)checkBindingCardNumber{
    _bingCardNumAry   = [[NSMutableArray alloc] init];
    _nobingCardNumAry = [[NSMutableArray alloc] init];
    
    WEAKSELF;
    [self bingCardManage:^(BingMethodMethod bingCardCount, NSMutableArray *bingCardNumAry, NSMutableArray *nobingCardNumAry) {
        weakSelf.bingCardCount = bingCardCount;
        weakSelf.bingCardNumAry = bingCardNumAry;
        weakSelf.nobingCardNumAry = nobingCardNumAry;
        
    }];
    
}

- (void)rightBarItem{
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"限额说明", @"Limit description") style:UIBarButtonItemStylePlain target:self action:@selector(rightNavAction)];
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)rightNavAction{
    LoadHtml *loadHtml = [[LoadHtml alloc] initWithNibName:@"LoadHtml" bundle:nil];
    loadHtml.makeType = 2;
    loadHtml.loadType = Local;
    [self.navigationController pushViewController:loadHtml animated:YES];

}

//字符串转数组
- (NSDictionary *)strToDic:(NSString *)accountName icon:(NSString *)accountIcon account:(NSString *)accountNum makeFu:(NSString *)make{
    
    NSDictionary *dic = @{@"name":accountName ,
                          @"icon":accountIcon ,
                          @"account":accountNum ,
                          @"make":make
                          };
    return dic;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}



// 注意 从账号 详情跳转问题解决
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //1.没有绑定 任何卡号
        if (_bingCardNumAry.count == 0) {
            static NSString *cellID = @"cellid";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image = Icon(@"ADD");
            cell.textLabel.text = @"目前没有绑定任何转出账号";
            return cell;
        }else{
            //2.绑定
            DefaultAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:DefaultAccountIden forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSDictionary *dic ;
            //2.1数组元素下标值
            NSString * makeidentifier = [USER_DEFAULT objectForKey:@"MAKEIDENTIFIER"];
            
            NSString * fromCardDetaiMake = [USER_DEFAULT objectForKey:@"CARDDETAITOWITHDRAWMAKEIDENTIFIER"];
#pragma make 如点击提现限额说明bug  获取数据源
            //2.2判断是从哪里跳转到当前页面
            if (![NHUtils isBlankString:fromCardDetaiMake]) {
                dic = _DicType;
            }else{
                if ([NHUtils isBlankString:makeidentifier])
                {
                    dic = (NSDictionary *)[_bingCardNumAry firstObject];
                }else{
                    dic = (NSDictionary *)[_bingCardNumAry objectAtIndex:[makeidentifier integerValue]];
                }
            }
            cell.bcardType.text = [dic objectForKey:@"name"];
            
            NSString *make = [dic objectForKey:@"make"];
            if ([make isEqualToString:@"2"]) {
                cell.bankLog.image = IMAGE(userInfor.bank_code);
                
                NSString *account = [dic objectForKey:@"account"];
                cell.bankAccount.text = [NSString stringWithFormat:@"尾号%@储蓄卡",[account substringFromIndex:account.length-4]];
                cell.bankAccount.textColor = [UIColor py_colorWithHexString:@"#808080"];
                
                NSString *BandType = @"2";
                [USER_DEFAULT setObject:BandType forKey:@"BCARDTYPEMAKE"];
                
            }else{
                //支付宝
                if ([make isEqualToString:@"0"]) {
                    NSString *ZhifubaoType = @"0";
                    [USER_DEFAULT setObject:ZhifubaoType forKey:@"BCARDTYPEMAKE"];
                }
                if ([make isEqualToString:@"1"]) {
                    NSString *ZhifubaoType = @"1";
                    [USER_DEFAULT setObject:ZhifubaoType forKey:@"BCARDTYPEMAKE"];

                }
                
                //支付宝 微信
                NSString *icon = [dic objectForKey:@"icon"] ;
                cell.bankLog.image = IMAGE(icon);
                
                NSString *account = [dic objectForKey:@"account"];
                NSString *accountMake;
                if ([account isEmailAddress]) {
                    accountMake = [NHUtils cipherShowText:Email cipherData:account];
                }else if ([account isMobileNumberClassification]){
                    accountMake = [NHUtils cipherShowText:Iphone cipherData:account];
                }else{
                    accountMake = [NHUtils cipherShowText:PureDigital cipherData:account];
                }
                cell.bankAccount.text  = accountMake;
                cell.bankAccount.textColor = [UIColor py_colorWithHexString:@"#808080"];
            }
            return cell;
        }
        
    }else{
        
#pragma make -WithdrawalAmount
        WithdrawalAmount *cell = [tableView dequeueReusableCellWithIdentifier:WithdrawalAmountIden forIndexPath:indexPath];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        NSString *moneyStr = [NSString stringWithFormat:@"%@￥%@",NSLocalizedString(@"当前可用回赠", @"Current available amount"),[NHUtils moneyWithInterge:[account_money floatValue]]];
        
        [cell moneyValue:moneyStr];
        
        cell.myBlock =  ^(UITextField *file ,NSString *limitMoney){
            _method = isEnterFile;
            lisToenterMoney = file.text;
            file.font = [UIFont boldSystemFontOfSize:32];
            
            if (confirmBtn) {
                if ([lisToenterMoney floatValue] >=0.f && [lisToenterMoney floatValue] < 10) {
                    [confirmBtn.confirmBtn setTitle:NSLocalizedString(@"确认", @"confirm") forState:UIControlStateNormal];
                    
                }else{
//                    [confirmBtn.confirmBtn setTitle:[NSString stringWithFormat:@"转出金额:￥%@",file.text] forState:UIControlStateNormal];
                }
            }        };
        cell.delegate = self;
        
        return cell;
    }}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0)
    {
        return nil;
    }else{
        confirmBtn = [tableView dequeueReusableHeaderFooterViewWithIdentifier:WithdrawlConfirmIden];
        confirmBtn.delegate = self;
        
        return confirmBtn;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        TransferAccountsList *accountsList = [[TransferAccountsList alloc] initWithStyle:UITableViewStylePlain];
        NSString * fromCardDetaiMake = [USER_DEFAULT objectForKey:@"CARDDETAITOWITHDRAWMAKEIDENTIFIER"];

        if (![NHUtils isBlankString:fromCardDetaiMake]) {
            NSString *make = [_DicType objectForKey:@"make"];
            accountsList.cardDetailsselectedIndex = [make integerValue];
        }

        [self.navigationController pushViewController:accountsList animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return ScaleHeight(60.f);
        
    }else{
        return ScaleHeight(112.f);
        
    }}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1f;
    }else{
        return ScaleHeight(110.f);
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ScaleHeight(10.f);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma make -WithdrawlConfirmDelegate
- (void)withdrawlConfirm:(UIButton *)btn{
    [self.view endEditing:YES];


    //1判断输入是否为空
    BOOL istemp = false;
    istemp = _method == isEnterFile?[NHUtils isBlankString:lisToenterMoney]: [NHUtils isBlankString:enterMoneyShow];
    
    //2获取用户输入金额
    CGFloat drawMoney = [_method == isEnterFile?lisToenterMoney:enterMoneyShow floatValue];
    
    if (istemp) {
        NSLog(@"不能为空");
        [NHUtils alertAction:@selector(msgAlert) alertControllerWithTitle:@"提示" Message:@"输入金额不能为空,请重新输入" Vctl:self Cancel:NO];
    }else{
        //3判断用户输入金额（限额说明）
        NSLog(@"输入金额%f  可用余额 %@" ,drawMoney,account_money);
        if (drawMoney >= 10) {
            if (drawMoney > [account_money floatValue]) {
                [NHUtils alertAction:@selector(msgAlert) alertControllerWithTitle:@"提示" Message:@"输入金额不能大于您的可用余额,请重新输入" Vctl:self Cancel:NO];
                
                
            }else{
#pragma make 输入密码 判断密码是否正确
                InPutPassWordView *input = [[InPutPassWordView alloc] initWithInfo];
                input.delegate = self;
                [input show];
            }
        }else{
            [NHUtils alertAction:@selector(enterAmountError) alertControllerWithTitle:@"提示" Message:@"转出金额不能低于10元,请重新输入" Vctl:self Cancel:NO];
        }}
}

- (void)enterAmountError{}

- (void)msgAlert{

}
- (void)didTappedConfirmButton:(UIButton *)paymentButton paymentPassword:(NSString *)paymentPassword{
    NSLog(@"paymentPassword==%@" ,paymentPassword);
    //    MAKEIDENTIFIER 数组元素下标志
    //    BCARDTYPEMAKE  卡号类型  0表示支付宝   1微信   2银行卡
    NSString *cardTypeMake = [USER_DEFAULT objectForKey:@"BCARDTYPEMAKE"];
    
    CGFloat drawMoney = [_method == isEnterFile?lisToenterMoney:enterMoneyShow floatValue];
    
    NSString *money = [NSString stringWithFormat:@"%.2f" ,drawMoney];
    NSDictionary *params ;

    //    *  uid  amount（格式为100.00必须精确到后两位，提现金额不能少于10.00元） type（提现方式1微信2银联 其它或为空时默认支付宝）
    
    //第一次进入表示为空 可以根据数组下标确定绑定卡号类型
    if ([NHUtils isBlankString:cardTypeMake]) {
        
        
        NSDictionary * dic = (NSDictionary *)[_bingCardNumAry firstObject];
        
        NSInteger make = [[dic objectForKey:@"make"] integerValue];
        if (make == 0) {
            params = @{
                       @"uid"   :@([YConfig getOwnID]),
                       @"sign":[YConfig getSign],
                       @"amount":money
                       };
        }else{
            params = @{
                       @"uid"   :@([YConfig getOwnID]),
                       @"sign":[YConfig getSign],
                       @"amount":money,
                       @"type"  :[dic objectForKey:@"make"]
                       };
            
        }
    }else{
#pragma make 非第一次进入 
        // (支付宝)
        if ([cardTypeMake isEqualToString:@"0"]) {
            params = @{
                       @"uid"   :@([YConfig getOwnID]),
                       @"sign":[YConfig getSign],
                       @"amount":money
                       };
            
        }else{ //微信 银行
            params = @{
                       @"uid"   :@([YConfig getOwnID]),
                       @"sign":[YConfig getSign],
                       @"amount":money,
                       @"type"  :cardTypeMake
                       };
        }}
    NSLog(@"%@" ,params);
    NSString *pwd = [[YConfig getOwnAccountAndPassword] lastObject];
    if ([[paymentPassword md5String] isEqualToString:pwd]) {        
        WEAKSELF;
        NSLog(@"%@" ,params);
        
         [YNetworking postRequestWithUrl:appWithdraw params:params cache:YES successBlock:^(id returnData, int code, NSString *msg) {
             
             if (code == 1) {
                 //确定转出调入详情页面
                 WithdrawResults *resultsObj = [[WithdrawResults alloc] initWithStyle:UITableViewStyleGrouped];
                 resultsObj.withdraawID = [returnData objectForKey:@"data"];
                 resultsObj.moneyValue = _method == isEnterFile?lisToenterMoney:enterMoneyShow;
                 
                 Rollout *rollout = [[Rollout alloc] initWithStyle:UITableViewStyleGrouped];
                 rollout.title = @"转出详情";
                 NSDictionary *params = @{
                                          @"uid": @([YConfig getOwnID]),
                                          @"list_id" : @([resultsObj.withdraawID integerValue]),
                                          @"mark":@(3),
                                          @"sign":[YConfig getSign]
                                          };
                 rollout.rolloutData =  params;
                 
                 //发通知 实现刷新
                 [[NSNotificationCenter defaultCenter] postNotificationName:APPLYSUCCESSOFWITHDRAWALS object:nil];
                 [weakSelf.navigationController pushViewController:rollout animated:YES];

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
                 
                 [NHUtils alertAction:@selector(msgAlert) alertControllerWithTitle:@"提示" Message:msg Vctl:self Cancel:NO];
                 
             }
             
         } failureBlock:^(NSError *error) {
             
             
             
         } showHUD:YES];
        
//        [self requestWithUrl:appWithdraw params:params myBlock:^(BOOL state, NSDictionary *results, NSString *requestError) {
//            if (state) {
//                
//                //确定转出调入详情页面
//                WithdrawResults *resultsObj = [[WithdrawResults alloc] initWithStyle:UITableViewStyleGrouped];
//                resultsObj.withdraawID = [results objectForKey:@"data"];
//                resultsObj.moneyValue = _method == isEnterFile?lisToenterMoney:enterMoneyShow;
//                
//                Rollout *rollout = [[Rollout alloc] initWithStyle:UITableViewStyleGrouped];
//                rollout.title = @"转出详情";
//                NSDictionary *params = @{
//                                         @"uid": @([YConfig getOwnID]),
//                                         @"list_id" : @([resultsObj.withdraawID integerValue]),
//                                         @"mark":@(3),
//                                         @"sign":[YConfig getSign]
//                                         };
//                rollout.rolloutData =  params;
//                
//                //发通知 实现刷新
//                [[NSNotificationCenter defaultCenter] postNotificationName:APPLYSUCCESSOFWITHDRAWALS object:nil];
//                [weakSelf.navigationController pushViewController:rollout animated:YES];
//            }else{
//                                
//                NSLog(@"123提现失败%@" ,requestError);
//                [NHUtils alertAction:@selector(msgAlert) alertControllerWithTitle:@"提示" Message:requestError Vctl:self Cancel:NO];
//
//            }
//        }];
    }else{
        [NHUtils alertAction:@selector(msgAlert) alertControllerWithTitle:@"错误" Message:@"密码错误" Vctl:self Cancel:NO];
    }
}


#pragma make -数据请求
- (void)requestWithUrl:(NSString *)url
                params:(NSDictionary *)params myBlock:(void (^)(BOOL state,NSDictionary * results,NSString * requestError))states{
    
    [YNetworking postRequestWithUrl:url params:params cache:NO successBlock:^(id returnData, int code, NSString *msg) {
        if (code == 1) {
            states(YES,returnData,nil);
        }else{
            states(false,nil,msg);
        }
    } failureBlock:^(NSError *error) {
        states(NO,nil,[error localizedDescription]);
        
    } showHUD:NO];
}


- (void)didTappedColseButton:(UIButton *)colseButton{
    
}

- (void)didTappedForgetPasswordBtn:(UIButton *)forgetPasswordButton{
    
    [self.view endEditing:YES];
    WayBack * wayBack = [[WayBack alloc] initWithStyle:UITableViewStyleGrouped];
    wayBack.userInfor = userInfor;
    [self.navigationController pushViewController:wayBack animated:NO];
}

#pragma make -WithdrawalAmountDelegate 全部转出按钮事件触发
- (void)onClickAllDrawalAmountBtn:(UIButton *)btn availableMoney:(NSString *)money showEnterTextfile:(UITextField *)file isSelect:(BOOL)select{
    [self.view endEditing:YES];
    [self.view showCheckBtnState:^(MBProgressHUD *mbProgresshud) {
    }];
    if ([money floatValue] <= 1000) {
        enterMoneyShow = money;
    }else{
        enterMoneyShow = @"1000";
    }
    
//    [confirmBtn.confirmBtn setTitle:[NSString stringWithFormat:@"转出金额:￥%@",enterMoneyShow] forState:UIControlStateNormal];

    _method = isOnclick;
    file.text = [NSString stringWithFormat:@"%.2f" ,[enterMoneyShow floatValue]];
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGEBTNSTATE object:nil userInfo:@{@"key":file.text}];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
