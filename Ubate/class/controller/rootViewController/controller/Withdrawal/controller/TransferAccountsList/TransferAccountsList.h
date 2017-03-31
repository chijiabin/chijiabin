//
//  TransferAccountsList.h
//  Ubate
//
//  Created by sunbin on 2017/2/7.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransferAccountsList : UITableViewController
@property (nonatomic ,strong) NSMutableArray *selectCardAry;
@property (nonatomic ,strong) NSMutableArray *unSelectCardAry;

@property (nonatomic ,assign) BingMethodMethod  bingCardCount;

@property (nonatomic ,assign) NSInteger selectedIndex ;
@property (nonatomic ,assign) NSInteger cardDetailsselectedIndex ;

@end
