//
//  YUserInfo.m
//  Ubate-UV
//
//  Created by sunbin on 2017/1/22.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "YUserInfo.h"

@interface YUserInfo()
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;
@end
@implementation YUserInfo

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.uid           = [self objectOrNilForKey:@"uid" fromDictionary:dict];
        self.user_type     = [self objectOrNilForKey:@"user_type" fromDictionary:dict];
        self.credit_status = [self objectOrNilForKey:@"credit_status" fromDictionary:dict];
        self.bank_name     = [self objectOrNilForKey:@"bank_name" fromDictionary:dict];
        self.phone_status  = [self objectOrNilForKey:@"phone_status" fromDictionary:dict];
        self.is_ban        = [self objectOrNilForKey:@"is_ban" fromDictionary:dict];
        self.address       = [self objectOrNilForKey:@"address" fromDictionary:dict];
        self.account_money = [self objectOrNilForKey:@"account_money" fromDictionary:dict];
        self.nickname      = [self objectOrNilForKey:@"nickname" fromDictionary:dict];
        self.bank_img      = [self objectOrNilForKey:@"bank_img" fromDictionary:dict];
        self.real_name     = [self objectOrNilForKey:@"real_name" fromDictionary:dict];
        self.share_count   = [self objectOrNilForKey:@"share_count" fromDictionary:dict];
        self.user_phone    = [self objectOrNilForKey:@"user_phone" fromDictionary:dict];
        self.safequestion_status = [self objectOrNilForKey:@"safequestion_status" fromDictionary:dict];
        self.baofu_account = [self objectOrNilForKey:@"baofu_account" fromDictionary:dict];
        self.baofu_status  = [self objectOrNilForKey:@"baofu_status" fromDictionary:dict];
        self.area          = [self objectOrNilForKey:@"area" fromDictionary:dict];
        self.sex           = [self objectOrNilForKey:@"sex" fromDictionary:dict];
        self.user_email    = [self objectOrNilForKey:@"user_email" fromDictionary:dict];
        self.idcard        = [self objectOrNilForKey:@"idcard" fromDictionary:dict];
        self.sponsorID     = [self objectOrNilForKey:@"sponsorID" fromDictionary:dict];
        self.bank_code     = [self objectOrNilForKey:@"bank_code" fromDictionary:dict];
        self.city          = [self objectOrNilForKey:@"city" fromDictionary:dict];
        self.bank_account  = [self objectOrNilForKey:@"bank_account" fromDictionary:dict];
        self.account_status = [self objectOrNilForKey:@"account_status" fromDictionary:dict];
        self.province      = [self objectOrNilForKey:@"province" fromDictionary:dict];
        self.wechat_status = [self objectOrNilForKey:@"wechat_status" fromDictionary:dict];
        self.collect_money = [self objectOrNilForKey:@"collect_money" fromDictionary:dict];
        self.email_status  = [self objectOrNilForKey:@"email_status" fromDictionary:dict];
        self.user_img      = [self objectOrNilForKey:@"user_img" fromDictionary:dict];
        self.id_status     = [self objectOrNilForKey:@"id_status" fromDictionary:dict];
        self.is_freeze     = [self objectOrNilForKey:@"is_freeze" fromDictionary:dict];
        self.is_read_email = [self objectOrNilForKey:@"is_read_email" fromDictionary:dict];
        self.bank_status   = [self objectOrNilForKey:@"bank_status" fromDictionary:dict];
        self.wechat_account = [self objectOrNilForKey:@"wechat_account" fromDictionary:dict];
        self.member_id     = [self objectOrNilForKey:@"member_id" fromDictionary:dict];
        self.share_num     = [self objectOrNilForKey:@"share_num" fromDictionary:dict];
        self.freeze_money  = [self objectOrNilForKey:@"freeze_money" fromDictionary:dict];
        self.line_num      = [self objectOrNilForKey:@"line_num" fromDictionary:dict];
        self.storeID       = [self objectOrNilForKey:@"storeID" fromDictionary:dict];
    }
    
    return self;
    
}

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
