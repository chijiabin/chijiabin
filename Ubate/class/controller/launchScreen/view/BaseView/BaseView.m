//
//  BaseView.m
//  Ubate
//
//  Created by sunbin on 2016/11/30.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView


-(void)awakeFromNib{
    [super awakeFromNib];
    [self Background];

    self.backgroundColor = [UIColor blackColor];
    
}

- (void)Background{
    
    UIImage *image = LOADIMAGE(@"Back", @"png");
    self.layer.contents = (id) image.CGImage;
    
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
}


@end
