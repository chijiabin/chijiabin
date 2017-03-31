//
//  InPutPassWordView.m
//  youxian
//
//  Created by sunbin on 16/11/8.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "InPutPassWordView.h"
#import "WSPaymentPasswordView.h"


@interface InPutPassWordView()<WSPaymentPasswordViewDelegate>
@property (nonatomic, strong) WSPaymentPasswordView *paymentPasswordView; // 付款密码视图
@end
@implementation InPutPassWordView


- (instancetype)initWithInfo
{
    if (self = [super init]) {

    }
    return self;
}

/**
 *  显示付款视图
 */
- (void)show
{
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    self.frame = SCREEN_RECT;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
    /**
     *  加载密码输入框
     */    
    self.paymentPasswordView = [[[NSBundle mainBundle] loadNibNamed:@"WSPaymentPasswordView" owner:nil options:nil] lastObject];
    self.paymentPasswordView.delegate = self;
    
    CGFloat height = 0.0f;
    if (Iphone4) {
        height = 130.f;
    }else if (Iphone5) {
        height = 200.f;
    }else if (Iphone6) {
        height = 300.f;
    }else if(Iphone6Plus){
        height = 290.f;
    }else{
        height = 200.f;
    }

    
    [self.paymentPasswordView.passwordField becomeFirstResponder];
    self.paymentPasswordView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - height);
    [[UIApplication sharedApplication].keyWindow addSubview:self.paymentPasswordView];
    [UIView animateWithDuration:0.25 animations:^{
        self.paymentPasswordView.transform = CGAffineTransformTranslate(self.paymentPasswordView.transform, 0, -(SCREEN_HEIGHT - height));
    }];
}


/**
 *  销毁付款视图
 */
- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.paymentPasswordView.transform = CGAffineTransformTranslate(self.paymentPasswordView.transform, 0, SCREEN_HEIGHT - 250);
    } completion:^(BOOL finished) {
        [self.paymentPasswordView removeFromSuperview];
        [self removeFromSuperview];
    }];
}


#pragma mark - WSPaymentPasswordViewDelegate

- (void)didTappedConfirmButton:(UIButton *)confrimButton paymentPassword:(NSString *)paymentPassword
{
    
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(didTappedConfirmButton:paymentPassword:)]) {
        [self.delegate didTappedConfirmButton:confrimButton paymentPassword:paymentPassword];
    }
}

/**
 *  返回支付详情视图
 */
- (void)didTappedbackButton:(UIButton *)backButton
{
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(didTappedColseBtn:)]) {
        [self.delegate didTappedColseBtn:backButton];
    }
}


/**
 *  忘记密码
 */
- (void)didTappedForgetPasswordButton:(UIButton *)forgetPasswordButton
{
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(didTappedForgetPasswordBtn:)]) {
        [self.delegate didTappedForgetPasswordBtn:forgetPasswordButton];
    }
}



@end
