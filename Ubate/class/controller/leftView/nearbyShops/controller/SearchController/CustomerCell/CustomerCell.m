//
//  CustomerCell.m
//  PYSearchExample
//
//  Created by sunbin on 2016/12/25.
//  Copyright © 2016年 CoderKo1o. All rights reserved.
//

#import "CustomerCell.h"

@implementation CustomerCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


-(void)setStoreModelData:(SearchStoreModelData *)storeModelData{
    _storeModelData = storeModelData;
    
    _shop.text = [storeModelData.company_name stringByAppendingString:[NSString stringWithFormat:@"(%@)" ,storeModelData.store_name] ];

    NSUInteger loc = storeModelData.company_name.length;
    NSUInteger len = storeModelData.store_name.length;
    NSRange range = NSMakeRange(loc, len+2);

    [self AttributedStringRange:range content:_shop.text];

    [_LogImg mac_setImageWithURL:[NSURL URLWithString:[adress stringByAppendingString:storeModelData.cLogo]] placeholderImage:Icon(@"")];
    
    
}

- (void)AttributedStringRange:(NSRange)range content:(NSString *)content{

    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:content];
    [attribute addAttribute:NSFontAttributeName value:FONT_FONTMicrosoftYaHei(11.f) range:range];
    
    [_shop setAttributedText:attribute];


}


@end
