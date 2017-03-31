//
//  CacheSize.m
//  Ubate
//
//  Created by sunbin on 2017/2/5.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "CacheSize.h"

@implementation CacheSize
single_implementation(CacheSize);
-(NSString *)cacheSize{
    
    NSUInteger imageSize = [[SDImageCache sharedImageCache] getSize];
    
    NSInteger total = UnsignedInteger_Int(imageSize)+[QCNetworkCache totalDiskCacheSize]+[QCNetworkCache totalMemoryCacheSize];
    
    if (total < 1024) {
        return [NSString stringWithFormat:@"%ldB",(long)total];
    }else if (total < 1024 * 1024){
        CGFloat aFloat = total/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (total < 1024 * 1024 * 1024){
        CGFloat aFloat = total/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = total/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
    
}

@end
