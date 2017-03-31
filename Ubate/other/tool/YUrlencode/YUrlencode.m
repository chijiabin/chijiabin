//
//  YUrlencode.m
//  Ubate
//
//  Created by sunbin on 2016/11/30.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "YUrlencode.h"

@implementation YUrlencode
+(NSString*)encodeString:(NSString*)unencodedString{
    /**
     *  CharactersToLeaveUnescaped = @"[].";
     *
     *  CharactersToBeEscaped = @":/?&=;+!@#$()~',*"
     */

    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}
/**
 *  URLDEcode
 *
 *  NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
 */


+(NSString *)decodeString:(NSString*)encodedString

{    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

@end
