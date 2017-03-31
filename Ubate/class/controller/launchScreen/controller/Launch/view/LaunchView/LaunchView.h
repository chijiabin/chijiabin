//
//  LaunchView.h
//  Ubate
//
//  Created by sunbin on 2016/12/12.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "BaseView.h"

@protocol LaunchViewDelegate <NSObject>

- (void)navBtnIdex:(NSInteger)index;


@end

@interface LaunchView : BaseView
@property (nonatomic, weak)id <LaunchViewDelegate>delegate;
+ (instancetype)loadLaunchView;
@end
