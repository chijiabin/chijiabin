//
//  NeartheshopCell.h
//  Ubate
//
//  Created by sunbin on 2017/2/8.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NeartheshopModel;
@class SearchStoreModelData;
@interface NeartheshopCell : UITableViewCell
@property (nonatomic ,strong) NeartheshopModel *model;
@property (nonatomic ,strong) SearchStoreModelData *searchStoreModel;



@end
