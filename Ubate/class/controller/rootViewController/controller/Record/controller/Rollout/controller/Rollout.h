//
//  Rollout.h
//  Ubate
//
//  Created by sunbin on 2017/2/6.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentRecordModel.h"

@interface Rollout : UITableViewController
@property (nonatomic ,strong) NSDictionary *rolloutData;

@property (nonatomic ,strong) RecentRecordModel *model;
@property (nonatomic ,strong) NSString *withdraawID;
@end
