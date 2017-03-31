
        
                              
#import "RecordCell.h"                
                                      
@implementation RecordCell            
                                      
- (void)awakeFromNib {                    
}                                     
                                          
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {  
    [super setSelected:selected animated:animated];           
}                                                              


- (void)recordData:(NSDictionary *)data{
    
    NSString *type = IF_NULL_TO_STRING([data objectForKey:@"type"]);
    NSString *mark = IF_NULL_TO_STRING([data objectForKey:@"mark"]);
    NSInteger markImage = [mark integerValue];

    NSArray *moneyAry = @[
                          [NHUtils moneyWithInterge:[IF_NULL_TO_STRING([data objectForKey:@"money"]) floatValue]],
                          [NSString stringWithFormat:@"+%@",[NHUtils moneyWithInterge:[IF_NULL_TO_STRING([data objectForKey:@"money"]) floatValue]]],
                          [NSString stringWithFormat:@"-%@",[NHUtils moneyWithInterge:[IF_NULL_TO_STRING([data objectForKey:@"money"]) floatValue]]]
                          ];
    _money.text = [moneyAry objectAtIndex:[mark integerValue]-1];
    _timer.text = IF_NULL_TO_STRING([data objectForKey:@"timer"]);

    [self nameLabelattributes:IF_NULL_TO_STRING([data objectForKey:@"name"])];
    NSString *imageName;
    if (markImage != 2) {
        imageName = [@[@"consume" ,@"", @"withdraw"] objectAtIndex:markImage-1];
    }else{
        imageName = [@[@"consume" ,@"share"] objectAtIndex:[type integerValue]];
    }
    _recoderImageMake.image = Icon(imageName);

}

- (void)nameLabelattributes:(NSString *)str{
    NSArray *ary = [str componentsSeparatedByString:@"/"];
    
    if (ary.count == 2) {
        NSString *company = [ary firstObject];
        NSString *store = [ary lastObject];
        
        _name.text = [company stringByAppendingString:[NSString stringWithFormat:@"(%@)",store]];
    }else{
        _name.text = str;
    }
}

@end                                                            
