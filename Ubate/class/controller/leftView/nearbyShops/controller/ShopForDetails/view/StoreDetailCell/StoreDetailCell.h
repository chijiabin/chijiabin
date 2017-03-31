//
//  StoreDetailCell.h
//  Ubate
//
//  Created by sunbin on 2016/12/9.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StoreDetailData;

@interface StoreDetailCell : UITableViewCell

//图片
@property (weak, nonatomic) IBOutlet UIImageView *log;
//回赠
@property (weak, nonatomic) IBOutlet UILabel *logMake;
//数据
@property (weak, nonatomic) IBOutlet UILabel *detailData;

- (void)setgetInfoCellInfo:(StoreDetailData *)data;

@end
