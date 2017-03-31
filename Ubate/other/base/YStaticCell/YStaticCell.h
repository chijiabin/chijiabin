//
//  YStaticCell.h
//  Ubate
//
//  Created by sunbin on 2017/2/5.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YStaticCell : UITableViewController

@property (nonatomic ,assign) NSInteger row;//多少行

@property (nonatomic ,assign) BOOL NoShowHead;
@property (nonatomic ,assign) BOOL NoNeedTapGesture;

@end
