//
//  BindingcardListCell.m
//  youxian
//
//  Created by sunbin on 16/10/31.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "BindingcardListCell.h"

@interface BindingcardListCell()
//底图view
@property (weak, nonatomic) IBOutlet UIView *background;



@end

@implementation BindingcardListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.background setLayerCornerRadius:ScaleHeight(15.f/2)];
    self.background.backgroundColor = [UIColor py_colorWithHexString:@"#ffffff"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
