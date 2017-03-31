//
//  UIView+HUD.m
//  Ubate
//
//  Created by sunbin on 2017/2/5.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "UIView+HUD.h"

@implementation UIView (HUD)
//居中 矩形 自动消失
-(void)showMessage:(NSString *)message
{
    [self showSuccess:message];
}


- (void)showCheckBtnState:(void (^)(MBProgressHUD *mbProgresshud))states{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    // Change the background view style and color.
    hud.backgroundColor = kRGBAColor(0, 0, 0, 0.2);//视图背景色
    hud.contentColor = [UIColor appCellColor];      //转圈背景色

    hud.tintColor = [UIColor clearColor];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        states(hud);
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1];
            
        });
    });
    
}

//旋转菊花+提示文字 遮罩 不消失
-(void)showLoading:(NSString *)message {
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundColor = [UIColor clearColor];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
}



-(void)hideHUD
{
    [MBProgressHUD hideHUDForView:self animated:YES];
}
//自动消失 居中举行
-(void)showError:(NSString *)error
{
    [self hideHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.label.font =[UIFont boldSystemFontOfSize:14];
    
    hud.label.text = error;
    hud.animationType=MBProgressHUDAnimationFade;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBProgressHUD.bundle/error"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

-(void)showSuccess:(NSString *)success
{
    [self hideHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.label.font=[UIFont boldSystemFontOfSize:14];
    hud.animationType=MBProgressHUDAnimationFade;
    hud.label.text = success;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBProgressHUD.bundle/success"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0f];
}
-(void)showLoadFinish:(NSString *)alertTitle{
    [self hideHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.label.font=[UIFont boldSystemFontOfSize:14];
    hud.animationType=MBProgressHUDAnimationFade;
    hud.label.text = alertTitle;
    hud.mode = MBProgressHUDModeText;
    hud.yOffset=appHeight/2.0-80;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0f];
}







@end
