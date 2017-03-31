//
//  ConsumptionReturn.h
//  Ubate
//
//  Created by sunbin on 2017/2/6.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentRecordModel.h"

@interface ConsumptionReturn : UITableViewController
@property (nonatomic ,strong) NSDictionary *consumptionReturnData;
@property (nonatomic ,strong) RecentRecordModel *model;

@end
