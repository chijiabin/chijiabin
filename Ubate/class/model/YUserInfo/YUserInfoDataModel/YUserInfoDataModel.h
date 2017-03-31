//
//  YUserInfoDataModel.h
//  Ubate-UV
//
//  Created by sunbin on 2017/1/22.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YUserInfo.h"
@interface YUserInfoDataModel : NSObject

@property (nonatomic, assign) double res;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) YUserInfo *data;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;


@end
