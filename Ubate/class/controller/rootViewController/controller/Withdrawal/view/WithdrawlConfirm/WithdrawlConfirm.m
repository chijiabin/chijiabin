//
//  WithdrawlConfirm.m
//  Ubate
//
//  Created by sunbin on 2016/12/1.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "WithdrawlConfirm.h"

@implementation WithdrawlConfirm

-(void)awakeFromNib{
    [super awakeFromNib];
    
    //设置按钮状态
    _confirmBtn.enabled = NO;
    
    [NHUtils setBtnColor:_confirmBtn];
    [_confirmBtn setLayerBorderWidth:0.f borderColor:nil];//设置按钮圆角
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBtnState:) name:CHANGEBTNSTATE object:nil];

}

- (void)changeBtnState:(NSNotification *)note{
   NSString *money = [note.userInfo objectForKey:@"key"];
    if ([money isBlank]) {
        _confirmBtn.enabled = NO;
    }else{
        _confirmBtn.enabled = YES;

    }


}
//确定键事件
- (IBAction)confirmOnclick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(withdrawlConfirm:)]) {
        [self.delegate withdrawlConfirm:sender];
    }
}
@end
