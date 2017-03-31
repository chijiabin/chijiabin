//
//  UITextField+LeftViewMode.h
//  Ubate
//
//  Created by sunbin on 2017/2/6.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LeftViewMode)

- (void)leftViewModeWithConstrainedToWidth:(CGFloat)width text:(NSString *)labStr isLaunchScreen:(BOOL)launch;

/**
 *leftViewModeWithConstrainedToWidth 宽度
 *text              显示文本内容
 *isLaunchScreen    是否启动视图
 *fon               字号大小
 *leftFonColor      左侧视图字体颜色
 *bodyFonColor      边框颜色
 *PlaceholderColor  占位颜色
 *
 **/

- (void)leftViewModeWithConstrainedToWidth:(CGFloat)width text:(NSString *)labStr isLaunchScreen:(BOOL)launch fon:(CGFloat)fonSize leftFonColor:(NSString *)leftFonColor bodyFonColor:(NSString *)bodyFonColor PlaceholderColor:(NSString *)PlaceholderColor;

@end
