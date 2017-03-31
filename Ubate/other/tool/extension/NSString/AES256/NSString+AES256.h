//
//  NSString+AES256.h
//  Ubate-UV
//
//  Created by sunbin on 2017/1/22.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AES256)
-(NSString *) aes256_encrypt:(NSString *)key;


-(NSString *) aes256_decrypt:(NSString *)key;

@end
