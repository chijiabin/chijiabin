//
//  AppDelegate.h
//  Ubate
//
//  Created by sunbin on 2017/1/23.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate ,JPUSHRegisterDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) YUserInfo *userInfo;

@property (strong, nonatomic) CLLocation *location;
- (void)getlocation:(void (^)(CLLocation *location, CLPlacemark *placeMark, NSString *error))states;

@end

