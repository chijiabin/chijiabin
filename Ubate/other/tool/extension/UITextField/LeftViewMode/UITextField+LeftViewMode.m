//
//  UITextField+LeftViewMode.m
//  Ubate
//
//  Created by sunbin on 2017/2/6.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "UITextField+LeftViewMode.h"

@implementation UITextField (LeftViewMode)
- (void)leftViewModeWithConstrainedToWidth:(CGFloat)width text:(NSString *)labStr isLaunchScreen:(BOOL)launch{
    
    NSString *FonTNAME ;UIColor *color;
    if (launch) {
        launch = @"FZHei-B01S";
        [self setTextColor:[UIColor py_colorWithHexString:@"e5e5e5"]];
        color = [UIColor whiteColor];
    }else{
        launch = @"Microsoft YaHei";
        [self setTextColor:[UIColor blackColor]];
        color = [UIColor blackColor];
    }
    
    CGFloat labForwidth = [labStr stringWidthtWithFont:FONT(FonTNAME, 15.f) width:self.frame.size.height];
    
    
    UILabel *accountIDLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labForwidth+5, self.frame.size.height)];
    accountIDLab.text = labStr;
    accountIDLab.font =FONT(FonTNAME, 15.f);
    [accountIDLab setTextColor:color];
    self.leftView = accountIDLab;
    self.leftViewMode = UITextFieldViewModeAlways;
}


- (void)leftViewModeWithConstrainedToWidth:(CGFloat)width text:(NSString *)labStr isLaunchScreen:(BOOL)launch fon:(CGFloat)fonSize leftFonColor:(NSString *)leftFonColor bodyFonColor:(NSString *)bodyFonColor PlaceholderColor:(NSString *)PlaceholderColor{
    [self setTextColor:[UIColor py_colorWithHexString:bodyFonColor]];
    NSString *FonTNAME ;
    if (launch) {
        FonTNAME = @"FZHei-B01S";
    }else{
        FonTNAME = @"Microsoft YaHei";
    }
    [self setPlaceholderColor:[UIColor py_colorWithHexString:PlaceholderColor]];
    
    CGFloat labForwidth = [labStr stringWidthtWithFont:FONT(FonTNAME, fonSize) width:self.frame.size.height];
    
    
    UILabel *accountIDLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labForwidth+5, self.frame.size.height)];
    accountIDLab.text = labStr;
    accountIDLab.font =FONT(FonTNAME, fonSize);
    [accountIDLab setTextColor:[UIColor py_colorWithHexString:leftFonColor]];
    self.leftView = accountIDLab;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    
}
@end
