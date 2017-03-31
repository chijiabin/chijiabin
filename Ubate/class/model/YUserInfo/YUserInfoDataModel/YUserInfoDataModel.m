//
//  YUserInfoDataModel.m
//  Ubate-UV
//
//  Created by sunbin on 2017/1/22.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "YUserInfoDataModel.h"

@interface YUserInfoDataModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation YUserInfoDataModel

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.res = [[self objectOrNilForKey:@"res" fromDictionary:dict] doubleValue];
        self.msg = [self objectOrNilForKey:@"msg" fromDictionary:dict];
        self.data = [YUserInfo modelObjectWithDictionary:[dict objectForKey:@"data"]];        
    }
    
    return self;
    
}

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}
@end
