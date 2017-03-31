//
//  ConsumptionHeaderFooterView.h
//  Ubate
//
//  Created by sunbin on 2016/12/6.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsumptionHeaderFooterView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *shopNmae;

@property (weak, nonatomic) IBOutlet UILabel *amount;

@property (weak, nonatomic) IBOutlet UILabel *status;

@end
