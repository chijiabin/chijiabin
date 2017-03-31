//
//  NSString+Size.h
//  Ubate
//
//  Created by sunbin on 2017/1/24.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

/**
 *  获取字符串的高度与固定宽度。
 *
 *  @param attribute 字符串的属性, 例如. attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18.f]}
 *  @param width     固定宽度.
 *
 *  @return 字符串高度
 */
- (CGSize)sizeWithAttribute:(NSDictionary <NSString *, id> *)attribute width:(CGFloat)width;

/**
 *  @brief 计算文字的高度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
/**
 *  @brief 计算文字的宽度
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGFloat)widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

/**
 *  @brief 计算文字的大小
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
/**
 *  @brief 计算文字的大小
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGSize)sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

/**
 *  @brief  反转字符串
 *
 *  @param strSrc 被反转字符串
 *
 *  @return 反转后字符串
 */
+ (NSString *)reverseString:(NSString *)strSrc;

- (CGFloat)stringWidthtWithFont:(UIFont *)font width:(CGFloat)height;


@end
