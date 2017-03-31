//
//  ForgotTableViewCell.m
//  test
//
//  Created by Tps on 2017/3/21.
//  Copyright © 2017年 Tps. All rights reserved.
//

#import "ForgotTableViewCell.h"

@implementation ForgotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.type = VerifyPasswordStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


@end
