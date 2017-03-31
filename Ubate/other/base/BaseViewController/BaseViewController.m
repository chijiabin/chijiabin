//
//  BaseViewController.m
//  Ubate
//
//  Created by sunbin on 2017/1/23.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)loadView
{
    [super loadView];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// 横竖屏适配的话，在此更新hudView的frame。
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (_isfullScreen) {
        CGFloat padding = 0;
        self.hudView.frame = CGRectMake(padding,
                                        padding,
                                        self.view.frame.size.width - padding*2,
                                        self.view.frame.size.height - padding*2);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor themeColor];
    [self initView];
}

- (void)initView{
}


- (void)setHudRect:(CGRect)hudRect{
    _hudRect = hudRect;
    
    _hudView = [[JHUD alloc]initWithFrame:_hudRect];
    _hudView.backgroundColor = [UIColor themeColor];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}




- (void)showText:(NSString *)showContent showPosition:(hudShowTextPostion)position{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = showContent;
    hud.offset = CGPointMake(0.f, position == centre?0:MBProgressMaxOffset);
    [hud hideAnimated:YES afterDelay:3.f];
}

- (void)dimBackground:(NSString *)labtext doSomeBlock:(void (^) ())completion{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text = labtext;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        completion();
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });

}




#pragma 占位图（无数据  无网络）  失败  按钮
- (void)failure:(noDataORnoNet)state indicatorViewSize:(CGSize)size messageLabel:(NSString *)msg customImageName:(NSString *)imageName
{
    self.hudView.indicatorViewSize = size;
    self.hudView.messageLabel.text = msg;
    self.hudView.messageLabel.textColor = [UIColor py_colorWithHexString:@"#808080"];
    self.hudView.customImage = [UIImage imageNamed:imageName];
    
    [self.hudView.refreshButton setTitle:[NSString stringWithFormat:@"%@" ,@"Refresh ?"] forState:UIControlStateNormal];
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCustomAnimations];
    
    
}



#pragma 马克 点圆
- (void)circleAnimation
{
    self.hudView.messageLabel.text = @"Hello ,this is a circle animation";
    self.hudView.indicatorBackGroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.1];
    self.hudView.indicatorForegroundColor = [UIColor lightGrayColor];
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCircle];
}
#pragma make 动画圆
- (void)circleJoinAnimation
{
    self.hudView.messageLabel.text = @"";
    self.hudView.indicatorForegroundColor = kRGBAColor(60, 139, 246, .5);
    self.hudView.indicatorBackGroundColor = [UIColor clearColor];
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCircleJoin];
    
}

#pragma make 点 摆钟
- (void)dotAnimation
{
    self.hudView.messageLabel.text = @"Hello ,this is a dot animation";
    self.hudView.indicatorBackGroundColor = [UIColor whiteColor];
    self.hudView.indicatorForegroundColor = [UIColor orangeColor];
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeDot];
}
//自动消失 圆点旋转
- (void)classMethod
{
    
    [JHUD showAtView:self.view message:@"I'm a class method."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JHUD hideForView:self.view];
    });
    
}



- (void)presentVc:(UIViewController *)vc completion:(void (^)(void))completion {
    if ([vc isKindOfClass:[UIViewController class]] == NO) return ;
    [self presentViewController:vc animated:YES completion:completion];
}
- (void)presentVc:(UIViewController *)vc {
    if ([vc isKindOfClass:[UIViewController class]] == NO) return ;
    [self presentVc:vc completion:nil];
}


@end
