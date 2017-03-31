//
//  ForgotPasswordModel.h
//  test
//
//  Created by Tps on 2017/3/21.
//  Copyright © 2017年 Tps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ForgotTableViewCell.h"
@interface ForgotPasswordModel : NSObject

@property (nonatomic, assign) VerifyPasswordStyle type;//!< 类型

@property (nonatomic, copy) NSString *number;//!<

@end
