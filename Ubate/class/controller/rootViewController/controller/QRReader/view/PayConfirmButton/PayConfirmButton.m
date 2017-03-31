//
//  PayConfirmButton.m
//  Ubate
//
//  Created by sunbin on 2016/12/20.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "PayConfirmButton.h"

@implementation PayConfirmButton

-(void)awakeFromNib{
    [super awakeFromNib];
    
    _payBtn.enabled = NO;
    
    [_payBtn setBackgroundColor:[UIColor py_colorWithHexString:@"208dcf" alpha:1] forState:UIControlStateNormal];
    
    [_payBtn setBackgroundColor:[UIColor py_colorWithHexString:@"#ffffff" alpha:1] forState:UIControlStateDisabled];
    [_payBtn setTitleColor:[UIColor py_colorWithHexString:@"cccccc"] forState:UIControlStateDisabled];
    [_payBtn setLayerBorderWidth:0.f borderColor:[UIColor whiteColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBtnState:) name:PAY_CHANGEBTNSTATE object:nil];

}


- (void)changeBtnState:(NSNotification *)noti{
    NSDictionary *dic = noti.userInfo;

   NSString *ListeningStr = [dic objectForKey:@"key"];
    if ([NHUtils isBlankString:ListeningStr]) {
        _payBtn.enabled = NO;

    }else{
        _payBtn.enabled = YES;

    }
    
}
- (IBAction)pay:(id)sender {
    if ([self.delegate respondsToSelector:@selector(payType)]) {
        [self.delegate payType];
    }
}






@end
