//
//  NSData+AES256.h
//  Ubate-UV
//
//  Created by sunbin on 2017/1/22.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)
- (NSData *)aes256_encrypt:(NSString *)key;   //加密
- (NSData *)aes256_decrypt:(NSString *)key;   //解密

@end
