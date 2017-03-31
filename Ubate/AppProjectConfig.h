//
//  AppProjectConfig.h
//  Ubate-UV
//
//  Created by sunbin on 2017/1/22.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppProjectConfig : NSObject
single_interface(AppProjectConfig);

- (BQLDBTool *)notiApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions app:(AppDelegate *)app;

@end
