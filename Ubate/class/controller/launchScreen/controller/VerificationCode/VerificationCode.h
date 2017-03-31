//
//  VerificationCode.h
//  Ubate
//
//  Created by sunbin on 2016/12/11.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "BaseViewController.h"

@interface VerificationCode : BaseViewController

@property (nonatomic ,strong) NSDictionary *params ;
@property (nonatomic ,strong) NSString *pwd;

@property (nonatomic ,assign) BOOL isFindPwd;
@property (nonatomic ,strong) NSString *requestUrl;
@property (nonatomic ,assign) NSInteger finfPwdType;

@end
