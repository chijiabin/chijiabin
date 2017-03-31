//
//  ResetPwdView.h
//  Ubate
//
//  Created by sunbin on 2016/12/22.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "BaseView.h"
@protocol ResetPwdViewDelegate <NSObject>

- (void)navBtnIdex;


@end

@interface ResetPwdView : BaseView
@property (nonatomic, weak)id <ResetPwdViewDelegate>delegate;

@property (nonatomic,copy) void (^ResetPwdViewHandler)(NSString *newPwd ,NSString *pwd);

+ (instancetype)LoadResetPwdView;


@end
