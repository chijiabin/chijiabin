//
//  YReal_NameInformation.m
//  Ubate
//
//  Created by sunbin on 2017/2/8.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "YReal_NameInformation.h"

@interface YReal_NameInformation ()
@property (weak, nonatomic) IBOutlet UITextField *real_name;
@property (weak, nonatomic) IBOutlet UITextField *idcard;

@end

@implementation YReal_NameInformation
{
    YUserInfo *userInfor;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self initVew];
}
- (void)loadData{
    self.row = 1;
}

- (void)initVew{
    
    [_real_name leftViewModeWithConstrainedToWidth:100.f text:@"姓名: " isLaunchScreen:NO fon:15.f leftFonColor:@"333333" bodyFonColor:@"333333" PlaceholderColor:@"999999"];
    [_idcard leftViewModeWithConstrainedToWidth:100.f text:@"身份证: " isLaunchScreen:NO fon:15.f leftFonColor:@"333333" bodyFonColor:@"333333" PlaceholderColor:@"999999"];
    
    
    userInfor = [YConfig myProfile];
    _real_name.text = [NHUtils cipherShowText:RelaName cipherData:userInfor.real_name];
        
    _idcard.text = [NHUtils cipherShowText:Certification_ID cipherData:userInfor.idcard];
    _real_name.enabled = NO;
    _idcard.enabled = NO;
    
    self.tableView.backgroundColor = [UIColor themeColor];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
