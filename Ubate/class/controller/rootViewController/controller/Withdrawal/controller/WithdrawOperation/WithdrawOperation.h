//
//  WithdrawOperation.h
//  Ubate
//
//  Created by sunbin on 2017/2/7.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    isEnterFile   =  0,
    isOnclick  =  1,
    
} EnterFileFormMethod;

@interface WithdrawOperation : UITableViewController

@property (nonatomic ,strong) NSDictionary *DicType;
@property (nonatomic ,strong) NSString *withdraawID;
@property (nonatomic ,assign) EnterFileFormMethod method;
@end
