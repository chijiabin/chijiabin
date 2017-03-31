//
//  BaseViewController.h
//  Ubate
//
//  Created by sunbin on 2017/1/23.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic ,assign) CGRect hudRect;
@property (nonatomic ,strong) JHUD  *hudView;//占位图
@property (nonatomic ,assign) BOOL isfullScreen;

//显示hud 底部 中部显示
- (void)showText:(NSString *)showContent showPosition:(hudShowTextPostion)position;

// 菊花+文字 蒙版
- (void)dimBackground:(NSString *)labtext doSomeBlock:(void (^) ())completion;




// 失败占位图
- (void)failure:(noDataORnoNet)state indicatorViewSize:(CGSize)size messageLabel:(NSString *)msg customImageName:(NSString *)imageName;




- (void)circleAnimation;

- (void)circleJoinAnimation;
- (void)dotAnimation;
- (void)classMethod;



- (void)presentVc:(UIViewController *)vc completion:(void (^)(void))completion;
- (void)presentVc:(UIViewController *)vc;









@end
