//
//  SizeProportion.m
//  Ubate
//
//  Created by sunbin on 2016/12/1.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "SizeProportion.h"

@implementation SizeProportion
+ (CGFloat) SizeProportionWithHeight:(CGFloat) iphone6Height
{
    CGFloat proportion = iphone6Height/667;
    if (!Iphone4) {
        return SCREEN_HEIGHT *proportion;
    }else
    {
        return SCREEN_HEIGHT *proportion -3*proportion ;
    }
    
}


@end
