//
//  ForgotTableViewCell.h
//  test
//
//  Created by Tps on 2017/3/21.
//  Copyright © 2017年 Tps. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VerifyPasswordStyle) {
    VerifyPasswordStyleNone = 0,
    VerifyPasswordStylePhone,
    VerifyPasswordStyleEmail,
};

@interface ForgotTableViewCell : UITableViewCell

@property (nonatomic, assign) VerifyPasswordStyle type;//!< 手机或则邮箱  类型

@end
