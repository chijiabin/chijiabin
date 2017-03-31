//
//  TelPhone.m
//  Ubate
//
//  Created by sunbin on 2016/12/11.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "TelPhone.h"

@implementation TelPhone
single_implementation(TelPhone);


- (UIWebView *)telPhoneNum:(NSString *)num{
    
    UIWebView *webView = [[UIWebView alloc]init];
    NSString *phoneNum = [@"tel://" stringByAppendingString:num];
    NSURL *url = [NSURL URLWithString:phoneNum];
    [webView loadRequest:[NSURLRequest requestWithURL:url ]];
    

    return webView;
}

@end
