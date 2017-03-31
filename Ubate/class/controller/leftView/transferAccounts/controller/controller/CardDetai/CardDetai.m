//
//  CardDetai.m
//  Ubate
//
//  Created by sunbin on 2017/2/7.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "CardDetai.h"
#import "WithdrawOperation.h"
#import "CardDetaiHeaderFooterView.h"
#import "LoadHtml.h"
@interface CardDetai ()

@end

@implementation CardDetai
{
    NSString *pwd;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"帐号详情", @"Account details");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}


- (void)initView{
    [self tableViewAttributes];
    [self rightBarButton];
    
    self.tableView.backgroundColor = [UIColor themeColor];
}


- (void)rightBarButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:NSLocalizedString(@"解绑", @"manage") forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 60, 40)];
    [btn addTarget:self action:@selector(selectDelecate:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)selectDelecate:(UIButton *)sender{    
//    NSString *make = [_dic objectForKey:@"make"];
//    
//    NSArray *MenuAry;
//    if ([make isEqualToString:@"2"]) {
//        MenuAry = @[NSLocalizedString(@"提现转出", @"Cash transfer")];
//        
//    }else{
//        MenuAry = @[NSLocalizedString(@"提现转出", @"Cash transfer"),
//                    NSLocalizedString(@"解绑", @"Unbundling")];
//    }
//    
//    [FTPopOverMenu showForSender:sender withMenu:MenuAry imageNameArray:MenuAry doneBlock:^(NSInteger selectedIndex) {
//        if (selectedIndex == 0) {
//            // 返现转出操作
//            
//            WithdrawOperation *withdraw = [[WithdrawOperation alloc] initWithStyle:UITableViewStyleGrouped];
//            withdraw.DicType = _dic;
//            [USER_DEFAULT setObject:@"CARDDETAITOWITHDRAWMAKEIDENTIFIER" forKey:@"CARDDETAITOWITHDRAWMAKEIDENTIFIER"];
//            [self.navigationController pushViewController:withdraw animated:YES];
//            
//            return ;
//        }
//        
//        if (selectedIndex == 1) {
//            [self alertStyleWithTextField];
//
//            return ;
//            
//        }
//        
//    } dismissBlock:^{
//        
//    }];

    
     [self alertStyleWithTextField];

}


- (void)alertStyleWithTextField{
    WEAKSELF;

//    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"输入登录密码", @"Enter login password") message:NSLocalizedString(@"为保障您本人操作及数据安全，请输入登录密码", @"In order to ensure the security of you I operation and data, please enter the password") preferredStyle:UIAlertControllerStyleAlert];
//    [actionSheetController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder     = NSLocalizedString(@"请输入密码", @"Please enter a password");
//        textField.secureTextEntry = YES;
//        textField.textAlignment   = NSTextAlignmentCenter;
//        
//        [textField addTarget:weakSelf action:@selector(usernameDidChange:)forControlEvents:UIControlEventEditingChanged];
//        
//    }];
//    
//    
//    UIAlertAction *determineAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认", @"Sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [weakSelf.view endEditing:YES];
//        
//        if ([NHUtils isBlankString:pwd]) {
//            [NHUtils alertAction:@selector(msgAlert) alertControllerWithTitle:NSLocalizedString(@"提示", @"Prompt") Message:NSLocalizedString(@"密码不能为空", @"Password is not empty") Vctl:weakSelf Cancel:NO];
//            
//            return ;
//        }else{
//            
//            if ([[[YConfig getOwnAccountAndPassword] lastObject] isEqualToString:[pwd md5String]]) {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定解绑" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary * unbundlingDic = @{@"sign":[YConfig getSign] ,
                                         @"uid" :@([YConfig getOwnID]) ,
                                         @"type":[_dic objectForKey:@"make"]
                                         };
        
         [YNetworking postRequestWithUrl:bindAccount params:unbundlingDic cache:YES successBlock:^(id returnData, int code, NSString *msg) {
             
             if (code == 1) {
                 
                     NSString *make = [weakSelf.dic objectForKey:@"make"];
                     if ([make isEqualToString:@"0"])
                     {
                         weakSelf.userInfor.baofu_status = @"0";
                         weakSelf.userInfor.baofu_account = nil;
                         kAppDelegate.userInfo = weakSelf.userInfor;
                     }
                     if ([make isEqualToString:@"1"]) {
                         weakSelf.userInfor.wechat_status = @"0";
                         weakSelf.userInfor.wechat_account = nil;
                         kAppDelegate.userInfo = weakSelf.userInfor;
                     }
                     [weakSelf.navigationController popViewControllerAnimated:NO];
                 
             }else if(code == 201){
                 
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
                 
             }else{
                 [NHUtils alertAction:@selector(msgAlert) alertControllerWithTitle:NSLocalizedString(@"提示", @"Prompt") Message:@"银行卡暂不支持解绑" Vctl:self Cancel:NO];
             }
             
         } failureBlock:^(NSError *error) {

             
             
         } showHUD:YES];
        
        
        
        
        
        
//        [weakSelf requestWithUrl:bindAccount params:unbundlingDic isCache:NO showHUD:NO myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg) {
//            
//            if (state == Succeed) {
//                NSString *make = [weakSelf.dic objectForKey:@"make"];
//                if ([make isEqualToString:@"0"])
//                {
//                    weakSelf.userInfor.baofu_status = @"0";
//                    weakSelf.userInfor.baofu_account = nil;
//                    kAppDelegate.userInfo = weakSelf.userInfor;
//                }
//                if ([make isEqualToString:@"1"]) {
//                    weakSelf.userInfor.wechat_status = @"0";
//                    weakSelf.userInfor.wechat_account = nil;
//                    kAppDelegate.userInfo = weakSelf.userInfor;
//                }
//                [weakSelf.navigationController popViewControllerAnimated:NO];
//            }else{
//                [NHUtils alertAction:@selector(msgAlert) alertControllerWithTitle:NSLocalizedString(@"提示", @"Prompt") Message:@"银行卡暂不支持解绑" Vctl:self Cancel:NO];
//            }
//        }];

    }];
    
    [alert addAction:actionYES];
    [alert addAction:actionNO];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
//            }else{
//                [NHUtils alertAction:@selector(msgAlert) alertControllerWithTitle:NSLocalizedString(@"Prompt", @"Prompt") Message:NSLocalizedString(@"rong password, please enter again", @"rong password, please enter again") Vctl:weakSelf Cancel:NO];
//                
//            }
//        }
//        
//    }];
//    
//
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", @"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//    }];
//    [actionSheetController addAction:determineAction];
//    [actionSheetController addAction:cancelAction];
//    
//    [self presentViewController:actionSheetController animated:YES completion:nil];
//

}

- (void)msgAlert{

}

- (void)usernameDidChange:(UITextField *)sender{
    pwd = sender.text;
}

- (void)tableViewAttributes
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 0;

    [self.tableView registerNib:[UINib nibWithNibName:@"CardDetaiHeaderFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"CardDetaiHeaderFooterViewIdentifier"];
}
- (void)tableviewSeparator{
    self.tableView.separatorColor = [UIColor appSeparatorColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
    }
    if (indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.userInteractionEnabled = NO;
    }
    
    cell.textLabel.text = @[
                            NSLocalizedString(@"单笔限额", @"Single limit") ,
                            NSLocalizedString(@"到账时间", @"Payment date") ,
                            NSLocalizedString(@"提现需知", @"Need to know")][indexPath.row];
    if (indexPath.row !=2) {
        cell.detailTextLabel.text = @[@"￥10-1000" ,NSLocalizedString(@"1-3 工作日", @"1-3 working days")][indexPath.row];
    }
    cell.backgroundColor = [UIColor appCellColor];
    return cell;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CardDetaiHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CardDetaiHeaderFooterViewIdentifier"];
    NSString *make = [_dic objectForKey:@"make"];
    if (![make isEqualToString:@"2"]) {
        
        NSString *account = [_dic objectForKey:@"account"];
        NSString *accountMake;
        if ([account isEmailAddress]) {
            accountMake = [NHUtils cipherShowText:Email cipherData:account];
        }else if ([account isMobileNumberClassification]){
            accountMake = [NHUtils cipherShowText:Iphone cipherData:account];
        }else{
            accountMake = [NHUtils cipherShowText:PureDigital cipherData:account];
        }
        header.bankNum.text = accountMake;
        
        NSString *icon = [[_dic objectForKey:@"icon"] stringByAppendingString:@"Icon"];
        [header.bankLogo mac_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:Icon(icon)];
        
    }else{
        header.bankNum.text =
        [NHUtils cipherShowText:Bank_Card cipherData:[_dic objectForKey:@"account"]];
        
        NSString *bank_img = [adress stringByAppendingString:_userInfor.bank_img];
        [header.bankLogo mac_setImageWithURL:[NSURL URLWithString:bank_img] placeholderImage:Icon(@"")];
    
    }

    
    
    return header;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LoadHtml *loadHtml = [[LoadHtml alloc] initWithNibName:@"LoadHtml" bundle:nil];
    NSString *make = [_dic objectForKey:@"make"];

    loadHtml.makeType = ![make isEqualToString:@"2"]?0:1;
    loadHtml.loadType = Local;
    
    [self.navigationController pushViewController:loadHtml animated:NO];

}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return NSLocalizedString(@"限额与说明", @"Limits and instructions");
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScaleHeight(150.f);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
