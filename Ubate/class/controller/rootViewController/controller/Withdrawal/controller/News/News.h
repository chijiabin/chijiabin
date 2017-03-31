//
//  News.h
//  Ubate
//
//  Created by 池先生 on 17/3/2.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentRecordModel.h"
@interface News : UITableViewController
@property (nonatomic ,strong) NSDictionary *consumptionReturnData;
@property (nonatomic ,strong) RecentRecordModel *model;
@end
