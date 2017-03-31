//
//  NSString+MAC.h
//  Ubate
//
//  Created by sunbin on 2017/1/24.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MAC)


/**
 *  判断字符串是否为空
 */
-(BOOL)isBlank;

/**
 *  邮箱的有效性
 */
- (BOOL)isEmailAddress;
/**
 *  手机号有效性
 */
- (BOOL)isMobileNumberClassification;
/**
 *  MD5加密
 */
-(NSString *)md5String;
/**
 *  银行卡的有效性
 */
- (BOOL)bankCardluhmCheck;
/**
 *  网址有效性
 */
- (BOOL)isValidUrl;

-(NSString *)isEmpty:(NSString *)alertStr;
- (BOOL)isEmpty;
- (BOOL) isBlankString;


-(BOOL)checkPassWord;

@end
