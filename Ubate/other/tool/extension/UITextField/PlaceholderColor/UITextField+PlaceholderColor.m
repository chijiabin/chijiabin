//
//  UITextField+PlaceholderColor.m
//  Ubate
//
//  Created by sunbin on 2017/2/6.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "UITextField+PlaceholderColor.h"

/** 占位文字颜色 */
static NSString * const JPPlaceholderColorKey = @"placeholderLabel.textColor";
@implementation UITextField (PlaceholderColor)
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    BOOL change = NO;
    // 保证有占位文字
    if (self.placeholder == nil) {
        self.placeholder = @" ";
        change = YES;
    }
    // 设置占位文字颜色
    [self setValue:placeholderColor forKeyPath:  JPPlaceholderColorKey];
    // 恢复原状
    if (change) {
        self.placeholder = nil;
    }
}
- (UIColor *)placeholderColor
{
    return [self valueForKeyPath: JPPlaceholderColorKey];
}

@end
