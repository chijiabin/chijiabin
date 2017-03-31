//
//  UIColor+MACProject.h
//  Ubate
//
//  Created by sunbin on 2017/1/25.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MACProject)
/**
 *  导航条颜色
 */
+ (UIColor *)appNavigationBarColor;
/**
 *  主题颜色设置
 */
+ (UIColor *)themeColor;
/**
 *  单元格分界线颜色
 */

+ (UIColor *)appSeparatorColor;
/**
 *  单元格textLabel字体颜色
 */
+ (UIColor *)appTextLabelColor;

/**
 *  单元格detailTextLabel字体颜色
 */
+ (UIColor *)appDetailTextLabelColor;

/**
 *  单元格背景色
 */
+ (UIColor *)appCellColor;
/**
 *  抽屉视图背景色
 */
+ (UIColor *)appLeftViewBackgroundColor;
/**
 *  头部 尾部颜色设置
 */
+ (UIColor *)appTableViewHeaderFooterViewColor;
/**
 *  window背景色
 */
+ (UIColor *)windowBackgroundColor;

+ (UIColor *)borderColor;

/**
 *  按钮禁止点击状态背景颜色
 */
+ (UIColor *)appBtnStateDisabledBackgroundColor;
/**
 *  按钮常态下背景颜色
 */
+ (UIColor *)appBtnStateNormalBackgroundColor;
/**
 *  按钮禁止点击状态文字颜色
 */
+ (UIColor *)appBtnStateDisabledTitleColor;
/**
 *  按钮常态下文字颜色
 */
+ (UIColor *)appBtnStateNormalTitleColor;


/**
 *  文本输入框占位符颜色placeholderColor
 */
+ (UIColor *)appPlaceholderColor;







+ (UIColor *)NSCirclegradient;
+ (UIColor *)NMCirclegradientFromCGrect:(CGRect)rect;
+ (UIColor *)NBCirclegradientFromCGrect:(CGRect)rect;


+ (UIColor *)SSCirclegradient:(CGRect)rect;
+ (UIColor *)SMCirclegradientFromCGrect:(CGRect)rect;
+ (UIColor *)SBCirclegradientFromCGrect:(CGRect)rect;


+ (UIColor *)NWBCirclegradientFromCGrect:(CGRect)rect;

+ (UIColor *)SGWBCirclegradientFromCGrect:(CGRect)rect;



+ (UIColor *)SXWBCirclegradientFromCGrect:(CGRect)rect;




@end
