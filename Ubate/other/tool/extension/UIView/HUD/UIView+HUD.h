//
//  UIView+HUD.h
//  Ubate
//
//  Created by sunbin on 2017/2/5.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HUD)
/**
 *  普通展示提示信息 (1.5秒后消失) 中间
 */
-(void)showMessage:(NSString *)message;
/**
 *  展示程序的错误或者警告信息 (1.5秒后消失)  中间
 */
-(void)showError:(NSString *)error;
/**
 *  展示成功信息 (1.5秒后消失)  中间
 */
-(void)showSuccess:(NSString *)success;


- (void)showCheckBtnState:(void (^)(MBProgressHUD *mbProgresshud))states;


/**
 *  默认加载进度动画 不消失 带菊花加载及文字
 */
-(void)showLoading:(NSString*)message;
/**
 *   提示您已加载全部数据 底部显示
 */
-(void)showLoadFinish:(NSString *)alertTitle;

/**
 *  隐藏HUD
 */
-(void)hideHUD;


@end
