//
//  UIImageView+MAC.m
//  Ubate
//
//  Created by sunbin on 2017/1/28.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "UIImageView+MAC.h"

#import "objc/runtime.h"
#import "UIView+AnimationProperty.h"


static char imageURLKey;

@implementation UIImageView (MAC)

- (void)mac_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self mac_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)mac_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDExternalCompletionBlock)completedBlock {


    [self sd_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if (!(options & SDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            self.image = placeholder;
        });
    }
    if (url) {
        __weak __typeof(self)wself = self;
        // wself.alpha = 0;
        SDWebImageManager *manage = [SDWebImageManager sharedManager];
        
        id <SDWebImageOperation> operation = [manage loadImageWithURL:url options:options progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            if (!wself) return;
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (!wself) return;
            dispatch_main_async_safe(^{
                if (!wself) return;
                if (image && (options & SDWebImageAvoidAutoSetImage) && completedBlock)
                {
                    completedBlock(image, error, cacheType, url);
                    return;
                }
                else if (image) {
                    wself.image = image;
                    [wself setNeedsLayout];
                    
                } else {
                    if ((options & SDWebImageDelayPlaceholder)) {
                        wself.image = placeholder;
                        [wself setNeedsLayout];
                    }
                }
                wself.scale = 0.95f;
                wself.alpha = 0.3f;
                [UIView animateWithDuration:0.6f animations:^{
                    wself.scale = 1.0f;
                    wself.alpha = 1.0f;
                }];
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
            }];

        [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
        
    }else{
        dispatch_main_async_safe(^{
            if (completedBlock) {
                NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
    
    
    

    
    
}

@end
