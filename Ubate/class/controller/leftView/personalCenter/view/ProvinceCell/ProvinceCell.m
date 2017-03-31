//
//  ProvinceCell.m
//  Ubate
//
//  Created by sunbin on 2016/12/22.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "ProvinceCell.h"
#import "UIButton+Submitting.h"

@interface ProvinceCell()



@end

@implementation ProvinceCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    

}

- (void)locationResult:(NSString *)loc{
    [_areInfor beginSubmitting:@"正在定位"];
    [self.areInfor setTitle:loc forState:UIControlStateNormal];
    [_areInfor endSubmitting];



}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
