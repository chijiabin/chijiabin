//
//  UIResponder+Network.h
//  Ubate
//
//  Created by sunbin on 2017/2/5.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Network)
/**
 * requestWithUrl
 * params
 * myBlock
 * BOOL state 请求状态 成功与否
 *
 *
 *
 *
 *
 *
 *
 *
 */
- (void)requestWithUrl:(NSString *)url
                params:(NSDictionary *)params isCache:(BOOL)cache showHUD:(BOOL)showHUD myBlock:(void (^)(responseState state,NSDictionary * responseResults, NSString* msg))states;
    



- (void)bingCardManage:(void (^)(BingMethodMethod bingCardCount ,NSMutableArray *bingCardNumAry ,NSMutableArray *nobingCardNumAry ))states;


@end
