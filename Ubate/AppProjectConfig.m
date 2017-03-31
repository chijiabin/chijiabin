//
//  AppProjectConfig.m
//  Ubate-UV
//
//  Created by sunbin on 2017/1/22.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "AppProjectConfig.h"
#import <WXApi.h>
#import "NewMessageModel.h"
@interface AppProjectConfig()


@end

@implementation AppProjectConfig
{
    //数据库（新消息插入本地数据库）
    BQLDBTool *tool;
    NSDictionary *newMessageDic;
}
single_implementation (AppProjectConfig);


- (BQLDBTool *)notiApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions app:(AppDelegate *)app{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];


    [self jpushDidFinishLaunchingWithOptions:launchOptions app:app];
    [self configureBoardManager];
    [self weChat];
    [self globalConfiguration];
    return [self createTheDatabase];
}


//1激光推送 注册方式
- (void)jpushDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions app:(AppDelegate *)app{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:app];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHServiceAPPKEY
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
           // NSLog(@"registrationID获取成功：%@",registrationID);
        }
        else{
           // NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}


//创建数据库
- (BQLDBTool *)createTheDatabase{
    tool = [BQLDBTool instantiateTool];
    // 打开或者创建数据库(数据库要根据模型决定创建哪些字段)
    newMessageDic = @{@"tradingid"   :@"",
                      @"money"       :@"",
                      @"time"        :@"",
                      @"newmessage"  :@"",
                      @"isRead"      :@"",
                      @"issuccessful":@""
                      };
    NewMessageModel *model = [NewMessageModel modelWithDictionary:newMessageDic];
    [tool openDBWith:NewMessageFile Model:model];
    return tool;
}

// 键盘风格
-(void)configureBoardManager{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.keyboardDistanceFromTextField=44;
    manager.enableAutoToolbar = NO;
    
}
// 支付宝
- (void)weChat{
    BOOL isok = [WXApi registerApp:WXAppId withDescription:@"Ubate"];
    if (isok) {
     //   NSLog(@"注册微信成功");
    }else{
     //   NSLog(@"注册微信失败");
    }

}

// 全局设置
- (void)globalConfiguration{

    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
    shadow.shadowOffset = CGSizeMake(0, 0);
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor py_colorWithHexString:@"fafafa"],
                                                           NSShadowAttributeName: shadow,
                                                           NSFontAttributeName: FONT_BarTitleAttributes
                                                           }];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor appNavigationBarColor]];
    


}
@end
