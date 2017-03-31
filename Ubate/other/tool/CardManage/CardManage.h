//
//  CardManage.h
//  Ubate
//
//  Created by sunbin on 2016/12/14.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardManage : NSObject
single_interface(CardManage);

- (void)checkAccountState:(NSString *)baofu_status wechat:(NSString *)wechat_status bank:(NSString *)bank_status myBlock:(void (^)(BingMethodMethod bingCardCount ,NSMutableArray *bingCardNumAry ,NSMutableArray *nobingCardNumAry ))states;




@end
