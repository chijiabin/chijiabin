//
//  UIView+PYExtension.m
//  Ubate
//
//  Created by sunbin on 2017/1/25.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "UIView+PYExtension.h"

@implementation UIView (PYExtension)

- (void)setPy_centerX:(CGFloat)py_centerX
{
    CGPoint center = self.center;
    center.x = py_centerX;
    self.center = center;
}

- (CGFloat)py_centerX
{
    return self.center.x;
}

-(void)setPy_centerY:(CGFloat)py_centerY
{
    CGPoint center = self.center;
    center.y = py_centerY;
    self.center = center;
}

- (CGFloat)py_centerY
{
    return self.center.y;
}


@end
