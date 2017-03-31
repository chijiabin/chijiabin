//
//  ForgotPwd.h
//  Ubate
//
//  Created by sunbin on 2017/2/7.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPwd : UITableViewController
@property (nonatomic ,strong) NSDictionary *dic ;
@property (nonatomic ,strong) NSString     *findType ;
@property (nonatomic ,assign) NSInteger     findTypeMake ;

@property (nonatomic ,strong) NSString     *requestWithUrl;

@end
