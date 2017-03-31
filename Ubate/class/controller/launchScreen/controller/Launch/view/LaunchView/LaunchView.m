//
//  LaunchView.m
//  Ubate
//
//  Created by sunbin on 2016/12/12.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "LaunchView.h"


@interface LaunchView()
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UIButton *logBtn;


@end

@implementation LaunchView

+ (instancetype)loadLaunchView{
    CGFloat radius = 0.0;
    if (Iphone4) {
        radius = 18.f;
    }
    if (Iphone5) {
        radius = 18.f;
    }

    if (Iphone6) {
        radius = 20.f;
    }

    if (Iphone6Plus) {
        radius = 20.f;
 
    }

    LaunchView *launchView = [self loadFromNib];
    [launchView.registerBtn setLayerCornerRadius:radius borderWidth:0 borderColor:[UIColor py_colorWithHexString:@""]];

    [launchView.logBtn setLayerCornerRadius:radius borderWidth:1 borderColor:[UIColor py_colorWithHexString:@"FAFAFA"]];

    return launchView;

}
+ (instancetype)loadFromNib{
    
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"LaunchView" owner:nil options:nil];
    return [objects lastObject];
}




- (IBAction)launchOperation:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if ([self.delegate respondsToSelector:@selector(navBtnIdex:)]) {
        [self.delegate navBtnIdex:tag];
    }
    
}



@end
