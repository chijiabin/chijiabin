//
//  ForgotPwdFooterView.h
//  Ubate
//
//  Created by sunbin on 2016/12/5.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ForgotPwdFooterDelegate <NSObject>

- (void)forgotPwdoperation:(UIButton *)btn;

@end
@interface ForgotPwdFooterView : UITableViewHeaderFooterView
@property (nonatomic, weak) id<ForgotPwdFooterDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;

@end
