//
//  UIColor+PYExtension.h
//  Ubate
//
//  Created by sunbin on 2017/1/25.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (PYExtension)
/** 根据16进制字符串返回对应颜色 */
+ (instancetype)py_colorWithHexString:(NSString *)hexString;

/** 根据16进制字符串返回对应颜色 带透明参数 */
+ (instancetype)py_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end
