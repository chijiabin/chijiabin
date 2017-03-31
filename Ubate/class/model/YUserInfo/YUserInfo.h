//
//  YUserInfo.h
//  Ubate-UV
//
//  Created by sunbin on 2017/1/22.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YUserInfo : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *user_type;
@property (nonatomic, copy) NSString *credit_status;
@property (nonatomic, copy) NSString *bank_name;
@property (nonatomic, copy) NSString *phone_status;
@property (nonatomic, copy) NSString *is_ban;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *account_money;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *bank_img;
@property (nonatomic, copy) NSString *real_name;
@property (nonatomic, copy) NSString *share_count;
@property (nonatomic, copy) NSString *user_phone;
@property (nonatomic, copy) NSString *safequestion_status;
@property (nonatomic, copy) NSString *baofu_account;
@property (nonatomic, copy) NSString *baofu_status;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *user_email;
@property (nonatomic, copy) NSString *idcard;
@property (nonatomic, copy) NSString *sponsorID;
@property (nonatomic, copy) NSString *bank_code;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *bank_account;
@property (nonatomic, copy) NSString *account_status;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *wechat_status;
@property (nonatomic, copy) NSString *collect_money;
@property (nonatomic, copy) NSString *email_status;
@property (nonatomic, copy) NSString *user_img;
@property (nonatomic, copy) NSString *id_status;
@property (nonatomic, copy) NSString *is_freeze;
@property (nonatomic, copy) NSString *is_read_email;
@property (nonatomic, copy) NSString *bank_status;
@property (nonatomic, copy) NSString *wechat_account;
@property (nonatomic, copy) NSString *member_id;
@property (nonatomic, copy) NSString *share_num;
@property (nonatomic, copy) NSString *freeze_money;
@property (nonatomic, copy) NSString *line_num;
@property (nonatomic, copy) NSString *storeID;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
