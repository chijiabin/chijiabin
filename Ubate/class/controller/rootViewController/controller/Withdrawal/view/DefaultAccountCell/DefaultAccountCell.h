//
//  DefaultAccountCell.h
//  Ubate
//
//  Created by sunbin on 2016/12/1.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefaultAccountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bankLog;

@property (weak, nonatomic) IBOutlet UILabel *bcardType;

@property (weak, nonatomic) IBOutlet UILabel *bankAccount;


@property (nonatomic ,assign) NSString *make;

@end
