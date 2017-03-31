//
//  WithdrawResultsCell.m
//  Ubate
//
//  Created by sunbin on 2016/12/1.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "WithdrawResultsCell.h"

@implementation WithdrawResultsCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)insertData:(NSString *)str{

    NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:_withdrawAmount.text];
    [mutableStr insertString:str atIndex:3];
    _withdrawAmount.text = mutableStr;
    
    }


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
