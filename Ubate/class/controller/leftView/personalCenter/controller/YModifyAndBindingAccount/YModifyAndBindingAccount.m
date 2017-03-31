//
//  YModifyAndBindingAccount.m
//  Ubate
//
//  Created by sunbin on 2017/2/10.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "YModifyAndBindingAccount.h"
#import "YEnterAccount.h"
#import "YVerifyPassword.h"

@interface YModifyAndBindingAccount ()
@property (weak, nonatomic) IBOutlet UIImageView *accountType;
@property (weak, nonatomic) IBOutlet UILabel     *numInfor;
@property (weak, nonatomic) IBOutlet UILabel     *alertInfor;
@property (weak, nonatomic) IBOutlet UIButton    *configBtn;


@end

@implementation YModifyAndBindingAccount
{
    YUserInfo       *userInfor;
    YVerifyPassword *verifyPassword;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_configBtn setLayerBorderWidth:0.0f borderColor:[UIColor borderColor]];
    
    [self loadData];
}



- (void)loadData{
    self.row = 1;
    userInfor = [YConfig myProfile];
    if ([self.title isEqualToString:@"更改或绑定邮箱"]) {
        _accountType.image = Icon(@"email");
        
        
        if ([userInfor.user_email isBlankString]) {
            /**
             *你还没绑定邮箱
             */
            _numInfor.text  = @"你还没绑定邮箱";
            _numInfor.textColor = [UIColor py_colorWithHexString:@"#666666"];
            _alertInfor.text = @"绑定邮箱后，可直接账号登录，获取分享喜悦乐趣";
            _alertInfor.textColor = [UIColor py_colorWithHexString:@"#666666"];
            self.title = @"绑定邮箱";
            [_configBtn setTitle:@"绑定邮箱" forState:UIControlStateNormal];
            [_configBtn setLayerBorderWidth:0.1f borderColor:[UIColor borderColor]];
        }else{
            
            /**
             * 更换邮箱
             */
            _numInfor.text = [NSString stringWithFormat:@"%@" ,TEXT_STRING(userInfor.user_email)];
            _numInfor.textColor = [UIColor py_colorWithHexString:@"#666666"];
            _alertInfor.text = @"更换邮箱,旧邮箱失效,可用新邮箱号码登录";
            _alertInfor.textColor = [UIColor py_colorWithHexString:@"#666666"];
            self.title = @"更换邮箱";
            [_configBtn setTitle:@"更换邮箱" forState:UIControlStateNormal];
        }
    }else{
        _accountType.image = Icon(@"phone");
        
        if ([userInfor.user_phone isBlankString]) {
            /**
             * 你还没绑定手机号码
             */
            _numInfor.text  = @"你还没绑定手机号码";
            _alertInfor.text = @"绑定手机后，可直接账号登录,分享获取喜悦乐趣";
            self.title = @"绑定手机";
            _numInfor.textColor = [UIColor py_colorWithHexString:@"#666666"];
            _alertInfor.textColor = [UIColor py_colorWithHexString:@"#666666"];
            [_configBtn setTitle:@"绑定手机号" forState:UIControlStateNormal];
        }else{
            /**
             * 更换手机号
             */
            _numInfor.text = [NSString stringWithFormat:@"(+86)%@" ,TEXT_STRING(userInfor.user_phone)];
            _alertInfor.text = @"更换手机号,旧手机号失效,可用新手机号码登录";
            self.title = @"更换手机";
            _numInfor.textColor = [UIColor py_colorWithHexString:@"#666666"];
            _alertInfor.textColor = [UIColor py_colorWithHexString:@"#666666"];
            [_configBtn setTitle:@"更换手机号" forState:UIControlStateNormal];
            [_configBtn setLayerBorderWidth:0.1f borderColor:[UIColor borderColor]];
        }
    }

}



- (void)initView{
    self.NoShowHead = YES;
    self.tableView.backgroundColor = [UIColor themeColor];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [SizeProportion SizeProportionWithHeight:10.f];
}


- (IBAction)confirm:(UIButton *)sender {
    verifyPassword = kVCFromSb(@"YVerifyPasswordID", @"YMember");

    NSString *currentBtnTitle = sender.currentTitle;
    CheckPwType checkPwdType;
    if ([currentBtnTitle isEqualToString:@"绑定邮箱"]) {
        checkPwdType = BingEmail;
    }else if ([currentBtnTitle isEqualToString:@"更换邮箱"]){
        checkPwdType = FixEmailAdress;

    }else if ([currentBtnTitle isEqualToString:@"绑定手机号"]){
        checkPwdType = BingPhone;

    }else if ([currentBtnTitle isEqualToString:@"更换手机号"]){
        checkPwdType = FixPhoneNum;

    } else{
    }
    verifyPassword.checkPwdType = checkPwdType;
    [self.navigationController pushViewController:verifyPassword animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];



}

@end
