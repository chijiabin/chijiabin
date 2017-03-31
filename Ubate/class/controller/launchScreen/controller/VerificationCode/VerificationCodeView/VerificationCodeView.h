//
//  VerificationCodeView.h
//  Ubate
//
//  Created by sunbin on 2016/12/11.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "BaseView.h"

@protocol VerificationCodeViewDelegate <NSObject>

- (void)listToCountDown:(UIButton *)sender;
- (void)navBtnIdex;

@end

@interface VerificationCodeView : BaseView


@property (nonatomic,copy) void (^VerificationCodeHandler)(NSString *scode);

@property (nonatomic, weak)id <VerificationCodeViewDelegate>delegate;

+ (instancetype)LoadVerificationCodeView;

@end
