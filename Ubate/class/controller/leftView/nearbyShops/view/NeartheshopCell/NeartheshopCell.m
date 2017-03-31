//
//  NeartheshopCell.m
//  Ubate
//
//  Created by sunbin on 2017/2/8.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "NeartheshopCell.h"
#import "NeartheshopModel.h"
#import "SearchStoreModelData.h"

@interface NeartheshopCell()
@property (weak, nonatomic) IBOutlet UILabel *company_name;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *valueR1;
@property (weak, nonatomic) IBOutlet UILabel *area;
//距离
@property (weak, nonatomic) IBOutlet UILabel *distanceLab;
@property (weak, nonatomic) IBOutlet UILabel *type_name;

@end

@implementation NeartheshopCell
{
}
- (void)awakeFromNib {
    [super awakeFromNib];
    _image.aliCornerRadius = ScaleHeight(5);
}

- (void)setModel:(NeartheshopModel *)model{
    _model = model;
    NSString *company_name = IF_NULL_TO_STRING(model.company_name);
    NSString *store_name = IF_NULL_TO_STRING(model.store_name);
    _company_name.text = [company_name stringByAppendingString:[NSString stringWithFormat:@"(%@)" ,store_name]];
    [self company_nameAttributed:_company_name.text];

    
    
    
    //回赠 百分号处理
    _valueR1.text = [NSString stringWithFormat:@"%@%%" , IF_NULL_TO_STRING(model.valueR1)];
    
    NSString *valueR1 = IF_NULL_TO_STRING(model.valueR1);
    [self valueR1AttributedString:_valueR1.text  range:NSMakeRange(0, valueR1.length)];

    
    _area.text = IF_NULL_TO_STRING(model.area);
    _type_name.text = IF_NULL_TO_STRING(model.type_name) ;
    
    
    NSString *geolat = IF_NULL_TO_STRING(model.geolat);
    NSString *geolnt = IF_NULL_TO_STRING(model.geolng);

    //商店位置
    CLLocation *shopLocation = [[CLLocation alloc] initWithLatitude:[IF_NULL_TO_STRING(geolnt) floatValue] longitude:[IF_NULL_TO_STRING(geolat) floatValue]];
    
    CLLocationDistance distance = [kAppDelegate.location distanceFromLocation:shopLocation] ;
    
    _distanceLab.text =  [NHUtils distanceWithInterge:[[NSString stringWithFormat:@"%.2f" ,distance] floatValue]];
        
//    _distanceLab.text = IF_NULL_TO_STRING(model.distance);
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:[adress stringByAppendingString:IF_NULL_TO_STRING(model.cLogo)]] placeholderImage:Icon(@"jiazai")];

    
}



//属性 富文本设置 公司+商店
- (void)company_nameAttributed:(NSString *)str{
    
    _company_name.text = str;
    NSString *shopName = _company_name.text;
    NSArray *ary = [shopName componentsSeparatedByString:@"("];
    NSString *company = [ary firstObject];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:shopName];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:FONT_FONTMicrosoftYaHei(11)
                             range:NSMakeRange(company.length,shopName.length - company.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor py_colorWithHexString:@"666666"]
                             range:NSMakeRange(company.length,shopName.length - company.length)];
    _company_name.attributedText = attributedString;
    
    
    
}


//回赠富文本处理
- (void)valueR1AttributedString:(NSString *)countent range:(NSRange)range{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:countent];
    
    [AttributedStr setAttributes:@{NSFontAttributeName:FONT_FONTMicrosoftYaHei(25.f)} range:range];
    
    [AttributedStr setAttributes:@{NSFontAttributeName:FONT_FONTMicrosoftYaHei(15.f)} range:NSMakeRange(range.length, 1)];
    _valueR1.attributedText = AttributedStr;
    
    
}





#pragma make -搜索
-(void)setSearchStoreModel:(SearchStoreModelData *)searchStoreModel{
    _searchStoreModel = searchStoreModel;
    
    NSString *company_name = IF_NULL_TO_STRING(searchStoreModel.company_name);
    NSString *store_name = IF_NULL_TO_STRING(searchStoreModel.store_name);
    _company_name.text = [company_name stringByAppendingString:[NSString stringWithFormat:@"(%@)" ,store_name]];
    [self company_nameAttributed:_company_name.text];
    
    //回赠 百分号处理
    _valueR1.text = [NSString stringWithFormat:@"%@%%" , IF_NULL_TO_STRING(searchStoreModel.valueR1)];
    
    NSString *valueR1 = IF_NULL_TO_STRING(searchStoreModel.valueR1);
    [self valueR1AttributedString:_valueR1.text  range:NSMakeRange(0, valueR1.length)];
    
    
    _area.text = IF_NULL_TO_STRING(searchStoreModel.area);
    _type_name.text = IF_NULL_TO_STRING(searchStoreModel.type_name) ;
    

    NSString *geolat = IF_NULL_TO_STRING(searchStoreModel.geolat);
    NSString *geolnt = IF_NULL_TO_STRING(searchStoreModel.geolnt);
    
    //商店位置  初始化CLLocation，传入经纬度
    CLLocation *shopLocation = [[CLLocation alloc] initWithLatitude:[IF_NULL_TO_STRING(geolnt) floatValue] longitude:[IF_NULL_TO_STRING(geolat) floatValue]];
    
    //个人位置到商店的位置 （两地距离）
    CLLocationDistance distance = [kAppDelegate.location distanceFromLocation:shopLocation];
    
    
    _distanceLab.text =  [NHUtils distanceWithInterge:[[NSString stringWithFormat:@"%.2f" ,distance] integerValue]];
    [self.image sd_setImageWithURL:[NSURL URLWithString:[adress stringByAppendingString:IF_NULL_TO_STRING(searchStoreModel.cLogo)]] placeholderImage:Icon(@"jiazai")];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
