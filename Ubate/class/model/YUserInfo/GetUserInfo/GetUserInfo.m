//
//  GetUserInfo.m
//  Ubate
//
//  Created by sunbin on 2017/1/25.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "GetUserInfo.h"
#import "DataManager.h"
#import "YUserInfoDataModel.h"

@implementation GetUserInfo
+ (void)userInfor{

    NSDictionary *dic = @{@"uid" :@([YConfig getOwnID]),
                          @"sign":[YConfig getSign],
                          };
    [[DataManager sharedManager] startAsyncRequest:@[getInfo] modelsArray:@[@"YUserInfoDataModel"] parameterAry:@[dic] refreshHeadler:^(int index) {
        if (index == 0) {
            id jsonModel = [[DataManager sharedManager].jsonDic objectForKey:@(0)];
            YUserInfoDataModel *model     = (YUserInfoDataModel *)jsonModel;
            YUserInfo          *userInfor = model.data;
            kAppDelegate.userInfo         = userInfor;
            [NHUtils saveCookies];
        
        }
    } completionHeadler:^(int index) {
    }];
}


@end
