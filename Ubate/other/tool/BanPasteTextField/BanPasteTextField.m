//
//  BanPasteTextField.m
//  Ubate
//
//  Created by sunbin on 2016/11/30.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "BanPasteTextField.h"

@implementation BanPasteTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    UIMenuController*menuController = [UIMenuController sharedMenuController];
    if(menuController) {
        [UIMenuController sharedMenuController].menuVisible=NO;
    }
    return NO;
    
}

@end
