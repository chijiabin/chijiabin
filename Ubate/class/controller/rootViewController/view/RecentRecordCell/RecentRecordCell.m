//
//  RecentRecordCell.m
//  Ubate
//
//  Created by sunbin on 2017/2/5.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "RecentRecordCell.h"
#import "RecentRecordModel.h"


@interface RecentRecordCell()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *timer;
@property (weak, nonatomic) IBOutlet UILabel *money;

@end


@implementation RecentRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(RecentRecordModel *)model{
    _model = model;

    
    self.name.text  = IF_NULL_TO_STRING(model.name);
    self.timer.text = IF_NULL_TO_STRING(model.timer);

    NSString *make = model.mark;
    NSString *money = [NHUtils moneyWithInterge: [IF_NULL_TO_STRING(model.money) floatValue]];

    NSArray *moneyAry = @[money ,[@"+" stringByAppendingString:money] ,[@"-" stringByAppendingString:money]];

    self.money.text = [moneyAry objectAtIndex:[make integerValue]-1];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
