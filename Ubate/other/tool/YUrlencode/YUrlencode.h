//
//  YUrlencode.h
//  Ubate
//
//  Created by sunbin on 2016/11/30.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YUrlencode : NSObject
+(NSString*)encodeString:(NSString*)unencodedString;
+(NSString *)decodeString:(NSString*)encodedString;



@end
