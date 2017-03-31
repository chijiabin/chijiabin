//
//  ExitApp.m
//  Ubate
//
//  Created by sunbin on 2017/2/5.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "ExitApp.h"

@implementation ExitApp
single_implementation(ExitApp);
- (void)exit{
    
    UIWindow *window = kWindow;
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
    } completion:^(BOOL finished) {
        exit(0);
    }];
}


@end
