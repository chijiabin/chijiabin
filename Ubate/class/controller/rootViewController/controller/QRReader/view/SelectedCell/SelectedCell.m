//
//  SelectedCell.m
//  Ubate
//
//  Created by sunbin on 2016/12/19.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "SelectedCell.h"
#import "Masonry.h"

@implementation SelectedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _selectedButton = [[UIButton alloc] init];
        [self addSubview:_selectedButton];
        WEAKSELF;
        [_selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
    
            make.centerY.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(17.f , 17.f));
            make.right.equalTo(weakSelf.mas_right).with.offset(-20);
            
        }];
        _selectedButton.enabled = NO;
        
        
        _logImg = [[UIImageView alloc] init];
        [self addSubview:_logImg];
        [_logImg mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(17.5f , 17.5f));
            make.left.equalTo(weakSelf.mas_left).with.offset(20);
            
        }];

        
        _payType = [[UILabel alloc] init];
        [self addSubview:_payType];
        [_payType mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(100.f , HEIGHT(weakSelf)));
            make.left.equalTo(weakSelf.logImg.mas_right).with.offset(20);
            
        }];
        _payType.font = FONT_FONTMicrosoftYaHei(14.f);
        _payType.textColor = [UIColor py_colorWithHexString:@"4c4c4c"];

        
        
    }
    return self;
}


@end
