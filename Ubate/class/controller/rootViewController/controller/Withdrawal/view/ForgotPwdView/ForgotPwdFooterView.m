//
//  ForgotPwdFooterView.m
//  Ubate
//
//  Created by sunbin on 2016/12/5.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "ForgotPwdFooterView.h"

@implementation ForgotPwdFooterView
- (void)awakeFromNib{
    [super awakeFromNib];
    [NHUtils setBtnColor:_nextStepBtn];
    _nextStepBtn.enabled = NO;
    [_nextStepBtn setLayerBorderWidth:0.f borderColor:nil];

}
- (IBAction)forgotPwdBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(forgotPwdoperation:)]) {
        [self.delegate forgotPwdoperation:sender];
    }
}

@end
