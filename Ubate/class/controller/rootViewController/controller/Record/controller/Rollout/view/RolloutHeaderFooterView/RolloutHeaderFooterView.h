//
//  RolloutHeaderFooterView.h
//  Ubate
//
//  Created by sunbin on 2016/12/6.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "NHBaseTableHeaderFooterView.h"

@interface RolloutHeaderFooterView : UITableViewHeaderFooterView

//共享返现
@property (weak, nonatomic) IBOutlet UILabel *name;
//logo
@property (weak, nonatomic) IBOutlet UIImageView *logo;
//钱
@property (weak, nonatomic) IBOutlet UILabel *money;
//交易状态
@property (weak, nonatomic) IBOutlet UILabel *account;


@end
