//
//  UIColor+MACProject.m
//  Ubate
//
//  Created by sunbin on 2017/1/25.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "UIColor+MACProject.h"

@implementation UIColor (MACProject)
//导航条颜色
+ (UIColor *)appNavigationBarColor{
   return [UIColor py_colorWithHexString:@"262626"];
}
/**
 *  主题颜色设置
 */
+ (UIColor *)themeColor{
    return [UIColor py_colorWithHexString:@"f5f5f5"];
}
/**
 *  单元格分界线颜色
 */

+ (UIColor *)appSeparatorColor{
    return [UIColor py_colorWithHexString:@"CCCCCC"];
}
/**
 *  单元格textLabel字体颜色
 */
+ (UIColor *)appTextLabelColor{
    return [UIColor py_colorWithHexString:@"4c4c4c"];
}

/**
 *  单元格detailTextLabel字体颜色
 */
+ (UIColor *)appDetailTextLabelColor{
    return [UIColor py_colorWithHexString:@"5f5f5f"];
}

/**
 *  单元格背景色
 */
+ (UIColor *)appCellColor{
    return [UIColor py_colorWithHexString:@"FAFAFA"];
}
/**
 *  抽屉视图背景色
 */
+ (UIColor *)appLeftViewBackgroundColor{
    return [UIColor py_colorWithHexString:@"5f5f5f"];
}
/**
 *  头部 尾部颜色设置
 */
+ (UIColor *)appTableViewHeaderFooterViewColor{
    return [UIColor py_colorWithHexString:@"5f5f5f"];
}

+ (UIColor *)windowBackgroundColor{
    return [UIColor blackColor];
}


+ (UIColor *)borderColor{
    return [UIColor py_colorWithHexString:@"dfdfdf"];
}

/**
 *  按钮禁止点击状态背景颜色
 */
+ (UIColor *)appBtnStateDisabledBackgroundColor{
    return [UIColor py_colorWithHexString:@"ffffff"];
}
/**
 *  按钮常态下背景颜色
 */
+ (UIColor *)appBtnStateNormalBackgroundColor{
    return [UIColor py_colorWithHexString:@"208dcf"];
}
/**
 *  按钮禁止点击状态文字颜色
 */
+ (UIColor *)appBtnStateDisabledTitleColor{
    return [UIColor py_colorWithHexString:@"cccccc"];
}
/**
 *  按钮常态下文字颜色
 */
+ (UIColor *)appBtnStateNormalTitleColor{
    return [UIColor py_colorWithHexString:@"ffffff"];
}


+ (UIColor *)appPlaceholderColor{
    return [UIColor whiteColor];
}



















+ (UIColor *)NSCirclegradient{
    return [UIColor py_colorWithHexString:@"1074b9"];
}


+ (UIColor *)NMCirclegradientFromCGrect:(CGRect)rect{
    
    CGSize size = rect.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[12] = {1.0,1.0,0.97,1.0,0.24,0.83,0.95,1.0,0.76,0.90,0.98,0.1};
    CGFloat locations[3] = {0.0,0.63,1.0};//从哪个位置开始到结束颜色
    
    CGGradientRef gradient=CGGradientCreateWithColorComponents(colorSpace, components, locations, 3);
    
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width,rect.size.height));
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0, 0.0), CGPointMake(rect.size.width, rect.size.height), kCGGradientDrawsAfterEndLocation);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
    
    
    
}


+ (UIColor *)NBCirclegradientFromCGrect:(CGRect)rect{
    CGSize size = rect.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[8] = {0.03,0.33,0.55,1.0,0.14,0.43,0.6,1.0};
    CGFloat locations[2] = {0.0,1.0};//从哪个位置开始到结束颜色
    
    CGGradientRef gradient=CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width,rect.size.height));
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0, 0.0), CGPointMake(rect.size.width, rect.size.height), kCGGradientDrawsAfterEndLocation);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
    
    
    
}








+ (UIColor *)SSCirclegradient:(CGRect)rect{
    CGSize size = rect.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[8] = {0.11,0.43,0.65,1.0,0.26,0.58,0.75,1.0};
    CGFloat locations[2] = {0.0,1.0};//从哪个位置开始到结束颜色
    
    CGGradientRef gradient=CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width,rect.size.height));
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0, 0.0), CGPointMake(rect.size.width, rect.size.height), kCGGradientDrawsAfterEndLocation);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
    
}

+ (UIColor *)SMCirclegradientFromCGrect:(CGRect)rect{
    CGSize size = rect.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[8] = {0.76,0.91,0.57,1.0,0.91,0.97,0.83,1.0};
    CGFloat locations[2] = {0.0,1.0};//从哪个位置开始到结束颜色
    
    CGGradientRef gradient=CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width,rect.size.height));
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0, 0.0), CGPointMake(rect.size.width, rect.size.height), kCGGradientDrawsAfterEndLocation);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
    
}
+ (UIColor *)SBCirclegradientFromCGrect:(CGRect)rect{
    CGSize size = rect.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[8] = {0.14,0.4,0.58,1.0,0.18,0.44,0.6,1.0};
    CGFloat locations[2] = {0.0,1.0};//从哪个位置开始到结束颜色
    
    CGGradientRef gradient=CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width,rect.size.height));
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0, 0.0), CGPointMake(rect.size.width, rect.size.height), kCGGradientDrawsAfterEndLocation);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
    
}


+ (UIColor *)NWBCirclegradientFromCGrect:(CGRect)rect{
    CGSize size = rect.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[8] = {0.09,0.39,0.61,1.0,0.18,0.50,0.68,1.0};
    CGFloat locations[2] = {0.0,1.0};//从哪个位置开始到结束颜色
    
    CGGradientRef gradient=CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width,rect.size.height));
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0, 0.0), CGPointMake(rect.size.width, rect.size.height), kCGGradientDrawsAfterEndLocation);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
    
    
    
    
}

+ (UIColor *)SGWBCirclegradientFromCGrect:(CGRect)rect{
    CGSize size = rect.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[8] = {1,0.65,0.19,1.0,0.95,0.89,0.77,1.0};
    CGFloat locations[2] = {0.0,1.0};//从哪个位置开始到结束颜色
    
    CGGradientRef gradient=CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width,rect.size.height));
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0, 0.0), CGPointMake(rect.size.width, rect.size.height), kCGGradientDrawsAfterEndLocation);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
    
    
}
+ (UIColor *)SXWBCirclegradientFromCGrect:(CGRect)rect{
    CGSize size = rect.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[8] = {0.47,0.89,1.0,1.0,0.37,0.68,0.38,1.0};
    CGFloat locations[2] = {0.0,1.0};//从哪个位置开始到结束颜色
    
    CGGradientRef gradient=CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width,rect.size.height));
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0, 0.0), CGPointMake(rect.size.width, rect.size.height), kCGGradientDrawsAfterEndLocation);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
    
}

@end
