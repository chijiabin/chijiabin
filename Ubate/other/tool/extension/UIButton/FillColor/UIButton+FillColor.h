//
//  UIButton+FillColor.h
//  Ubate
//
//  Created by sunbin on 2017/2/6.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (FillColor)
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state ;
+ (UIImage *)imageWithColor:(UIColor *)color ;

@end
