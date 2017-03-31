//
//  BindingcardListCell.h
//  youxian
//
//  Created by sunbin on 16/10/31.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindingcardListCell : UITableViewCell
//号码
@property (weak, nonatomic) IBOutlet UILabel *account;
//图片
@property (weak, nonatomic) IBOutlet UIImageView *accountLoo;
//付款类型
@property (weak, nonatomic) IBOutlet UILabel *cardType;

@end
