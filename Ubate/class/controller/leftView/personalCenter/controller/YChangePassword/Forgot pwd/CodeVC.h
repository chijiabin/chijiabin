//
//  CodeVC.h
//  Ubate
//
//  Created by 池先生 on 17/3/20.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForgotTableViewCell.h"
@interface CodeVC : UIViewController
@property (nonatomic,strong)NSString *change;
@property (nonatomic, assign) VerifyPasswordStyle type;//!< 类型
@end
