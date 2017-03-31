//
//  InPutPassWordView.h
//  youxian
//
//  Created by sunbin on 16/11/8.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InPutPassWordView;

@protocol InPutPassWordViewDelegate <NSObject>

- (void)didTappedConfirmButton:(UIButton *)paymentButton paymentPassword:(NSString *)paymentPassword;



- (void)didTappedColseBtn:(UIButton *)colseButton;
- (void)didTappedForgetPasswordBtn:(UIButton *)forgetPasswordButton;

@end



@interface InPutPassWordView : UIView
@property (nonatomic, weak) id<InPutPassWordViewDelegate> delegate;

- (instancetype)initWithInfo;

/**
 *  显示付款视图
 */
- (void)show;

/**
 *  销毁付款视图
 */
- (void)dismiss;

@end
