//
//  YMenuView.h
//  Ubate
//
//  Created by sunbin on 2016/12/1.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMenuView : UIView
+(instancetype)MenuViewWithDependencyView:(UIView *)dependencyView MenuView:(UIView *)leftmenuView isShowCoverView:(BOOL)isCover;

-(instancetype)initWithDependencyView:(UIView *)dependencyView MenuView:(UIView *)leftmenuView isShowCoverView:(BOOL)isCover;


-(void)show;

-(void)hidenWithoutAnimation;
-(void)hidenWithAnimation;

@end
