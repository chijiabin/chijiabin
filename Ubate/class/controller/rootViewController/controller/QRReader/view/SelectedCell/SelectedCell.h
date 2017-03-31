//
//  SelectedCell.h
//  Ubate
//
//  Created by sunbin on 2016/12/19.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedCell : UITableViewCell


@property (nonatomic, strong) UIButton *selectedButton;

@property (assign, nonatomic) NSIndexPath *selectedIndexPath;



@property (nonatomic, strong) UIImageView *logImg;
@property (nonatomic, strong) UILabel *payType;

@end
