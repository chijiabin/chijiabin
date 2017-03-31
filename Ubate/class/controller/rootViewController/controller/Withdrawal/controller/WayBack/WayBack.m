//
//  WayBack.m
//  Ubate
//
//  Created by sunbin on 2017/2/7.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "WayBack.h"
#import "ForgotPwd.h"

@interface WayBack ()
@property (nonatomic ,strong) NSMutableArray *logAccountAry;
@end

@implementation WayBack
{
    BOOL _wasKeyboardManagerEnabled;
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
    self.title = @"忘记密码";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];

}
- (void)loadData{
    _logAccountAry = [[NSMutableArray alloc] init];
    
    NSString * email_status = _userInfor.email_status;
    NSString * phone_status = _userInfor.phone_status;
    
    
    if ([email_status isEqualToString:@"1"] && [phone_status isEqualToString:@"1"]) {
        [_logAccountAry addObject:[self strToDic:_userInfor.user_phone makeIden:@"0"]];
        [_logAccountAry addObject:[self strToDic:_userInfor.user_email makeIden:@"1"]];
    }else{
        if ([phone_status isEqualToString:@"1"]) {
            [_logAccountAry addObject:[self strToDic:_userInfor.user_phone makeIden:@"0"]];
        }
        if ([email_status isEqualToString:@"1"]) {
            [_logAccountAry addObject:[self strToDic:_userInfor.user_email makeIden:@"1"]];
        }
    }
}
- (NSDictionary *)strToDic:(NSString *)logAccount makeIden:(NSString *)make
{
    return @{ @"logAccount":logAccount ,
              @"make":make};
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _logAccountAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellid";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *dic = [_logAccountAry objectAtIndex:indexPath.row];
    
    NSString *account = [dic objectForKey:@"logAccount"];
    NSString *make = [dic objectForKey:@"make"];
    
    if ([make isEqualToString:@"0"]) {
        NSString *str =  [account substringFromIndex:7];
        cell.textLabel.text = [NSString stringWithFormat:@"通过绑定手机尾号%@找回" ,str];
        
    }
    
    if ([make isEqualToString:@"1"]) {
        NSArray  *ary = [account componentsSeparatedByString:@"."];
        NSString *str = [ary firstObject];
        NSRange   range = [str rangeOfString:@"@"];
        NSString *email = [str substringFromIndex:range.location+1];
        
        cell.textLabel.text = [NSString stringWithFormat:@"通过绑定%@邮箱找回" ,email];
        
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"通过以下方式找回密码";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [_logAccountAry objectAtIndex:indexPath.row];
    [self requestWithParams:dic];

}


- (void)requestWithParams:(NSDictionary*)dic{
    NSString *logAccount = [dic objectForKey:@"logAccount"];
    NSString *make       = [dic objectForKey:@"make"];
    
    NSDictionary *params;
    NSString     *requestWithUrl;
    NSString     *findType;
    
    if ([make isEqualToString:@"0"]) {
        params = @{@"phone":logAccount, @"send":@(1),@"sign":[YConfig getSign] };
        requestWithUrl = phoneResetPwd;
        findType = @"手机号";
    }
    if ([make isEqualToString:@"1"]) {
        params = @{@"email":logAccount, @"send":@(1),@"sign":[YConfig getSign]};
        requestWithUrl = emailResetPwd;
        findType = @"邮箱号";
        
    }
    ForgotPwd *pwd = [[ForgotPwd alloc] initWithStyle:UITableViewStyleGrouped];
    pwd.dic = params;
    pwd.findType = findType;
    pwd.findTypeMake = [make integerValue];
    pwd.requestWithUrl = requestWithUrl;
    [self.navigationController pushViewController:pwd animated:NO];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
