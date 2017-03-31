//
//  YBonline.h
//  Ubate
//
//  Created by sunbin on 2017/2/10.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "YStaticCell.h"
typedef enum : NSUInteger {
    User     =  0,//用户
    Merchant =  1,//商户
    
} OnlineMethod;

@interface YBonline : YStaticCell
@property (nonatomic ,strong) NSString *uid;
@property (nonatomic ,assign) OnlineMethod onlineMethod;
@property (nonatomic ,assign) BOOL isAddOnLine;

@end
