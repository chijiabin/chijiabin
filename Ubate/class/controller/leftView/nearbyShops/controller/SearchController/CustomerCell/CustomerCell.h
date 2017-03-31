//
//  CustomerCell.h
//  PYSearchExample
//
//  Created by sunbin on 2016/12/25.
//  Copyright © 2016年 CoderKo1o. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchStoreModelData.h"

@interface CustomerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *LogImg;

@property (weak, nonatomic) IBOutlet UILabel *shop;

@property (nonatomic ,strong) SearchStoreModelData *storeModelData;


@end
