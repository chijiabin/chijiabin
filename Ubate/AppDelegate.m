//
//  AppDelegate.m
//  Ubate
//
//  Created by sunbin on 2017/1/23.
//  Copyright © 2017年 Quanli. All rights reserved.
//
#import "AppDelegate.h"
#import <WXApi.h>
#import "WXApiManager.h"
#import "UserQrCode.h"
#import "AppProjectConfig.h"
#import "NewMessageTool.h"
#import "NavigationController.h"
#import "YLocationManager.h"
#import "Launch.h"
#import "ConsumptionReturn.h"
#import <Bugly/Bugly.h>
#import "NearMV.h"
#import "Rollout.h"
#import "News.h"
#import "LoginController.h"
@interface AppDelegate ()<JPUSHRegisterDelegate>
@end
@implementation AppDelegate
{
    BQLDBTool *tool;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Bugly startWithAppId:@"7516e87aee"];
    
    tool = [[AppProjectConfig sharedAppProjectConfig] notiApplication:application didFinishLaunchingWithOptions:launchOptions app:self];
    WEAKSELF;
    [self getlocation:^(CLLocation *location, CLPlacemark *placeMark, NSString *error) {
        weakSelf.location = location;
    //    NSLog(@"======%f  %f" ,location.coordinate.latitude ,location.coordinate.longitude);
    }];
    
    _userInfo = [YConfig myProfile];

     _window.rootViewController = [self getRootViewController];
    [_window makeKeyAndVisible];
    return YES;
}




- (UIWindow *)window
{
    if (!_window) {
        _window                 = [[UIWindow alloc] initWithFrame:SCREEN_RECT];
        _window.backgroundColor = [UIColor whiteColor];
        [_window makeKeyAndVisible];
    }
    return _window;
}

-(RootViewController *)rootViewController{
    if (!_rootViewController) {
        _rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    }
    return _rootViewController;
    
}

-(void)setUserInfo:(YUserInfo *)userInfo
{
    [YConfig saveProfile:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SET_USERINFO" object:nil];
}

- (UIViewController *)getRootViewController{
    if ([YConfig getOwnID] != 0) {
        NavigationController *navigationController ;
        if (_rootViewController) {
            navigationController = [[NavigationController alloc] initWithRootViewController:_rootViewController];
        }else{
            navigationController = [[NavigationController alloc] initWithRootViewController:[self rootViewController]];
        }
        return  navigationController;
    }else{
        Launch *launch = [[Launch alloc] init];
        return launch;
    }
}



-  (void)getlocation:(void (^)(CLLocation *location, CLPlacemark *placeMark, NSString *error))states{
    [[YLocationManager sharedYLocationManager] getCurrentLocation:^(CLLocation *location, CLPlacemark *placeMark, NSString *error) {
        states(location ,placeMark , error);
        if (error) {
       //     NSLog(@"定位出错,错误信息:%@",error);
        }else{
         //   NSLog(@"定位成功:经度:%f 纬度:%lf 当前地址:%@  \n location详细信息:%@ \n ",location.coordinate.latitude, location.coordinate.longitude, placeMark.name, location);
                        
        }
    } onViewController:self.window.rootViewController];
}


- (void)applicationWillResignActive:(UIApplication *)application {
   // NSLog(@"applicationWillResignActive");

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
   // NSLog(@"applicationDidBecomeActive");
}


- (void)applicationWillTerminate:(UIApplication *)application {
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  //  NSLog(@"deviceToken==%@" , [NSString stringWithFormat:@"%@", deviceToken]);
  //  NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
   // NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
//在ios8系统 还需添加这个方法 通过新的API注册推送服务
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];

}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
 //   NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
    application.applicationIconBadgeNumber = 0;
    [_rootViewController addNotificationCount];
    [self goToMssageViewControllerWith:userInfo];

}

#pragma make 收到消息内容 数据插入
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    //abstract 处理收到的 APNs 消息
    [JPUSHService handleRemoteNotification:userInfo];

 //   NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    //微信
    [self insertedIntoDatabase:userInfo];
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
        [_rootViewController addNotificationCount];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}


// 插入数据库
- (void)insertedIntoDatabase:(NSDictionary *)userInfo{
    NSDictionary *data = [userInfo objectForKey:@"data"];
    
    NSString *add_time = IF_NULL_TO_STRING([data objectForKey:@"add_time"]);
    NSString *money = IF_NULL_TO_STRING([data objectForKey:@"money"]);
    NSString *record_id = IF_NULL_TO_STRING([data objectForKey:@"record_id"]);
    
    NSString *type = IF_NULL_TO_STRING([data objectForKey:@"type"]);
    NSString *status;//0代表失败 1代表成功
    if ([type isEqualToString:[NSString stringWithFormat:@"%@" ,@"3"]])
    {
        status = IF_NULL_TO_STRING([data objectForKey:@"status"]);
    }else{
        status = [NSString stringWithFormat:@"%@" ,@"1"];
    }
    
    [NewMessageTool newMessageTool:tool insertData:record_id money:money type:type add_time:add_time isRead:@"1" issuccessful:status];

}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    //@abstract 前台展示本地推送
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate


// 前台接收消息 接收到消息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
  //  [self insertedIntoDatabase:userInfo];(微信不走这个插入)

    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
     //   NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
     //   NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}
//前台后台消息点击进入
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    
    [self goToMssageViewControllerWith:userInfo];

    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
      //  NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        [_rootViewController addNotificationCount];

    }
    else {
        // 判断为本地通知
      //  NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif




// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

#pragma mkae -信息入口
- (void)goToMssageViewControllerWith:(NSDictionary*)msgDic{
    
    NSDictionary *data = [msgDic objectForKey:@"data"];
    NSString *record_id = IF_NULL_TO_STRING([data objectForKey:@"record_id"]);
    NSString *type = IF_NULL_TO_STRING([data objectForKey:@"type"]);

    if (![NHUtils isBlankString:type]) {
        //共享记录
        ConsumptionReturn *share= [[ConsumptionReturn alloc] initWithStyle:UITableViewStyleGrouped];
        NSDictionary *dic = @{@"list_id":record_id ,@"mark":type ,@"type":type};
        share.consumptionReturnData = dic;
        
        if ([type isEqualToString:@"1"]) {
            share.title = @"消费返现";
        }
        if ([type isEqualToString:@"2"]) {
            share.title = @"共赏返现";
        }
        if ([type isEqualToString:@"3"]) {
            
            share.title = @"转出详情";
        }

        [_rootViewController.navigationController pushViewController:share animated:NO];
        return;
    }
}

@end
