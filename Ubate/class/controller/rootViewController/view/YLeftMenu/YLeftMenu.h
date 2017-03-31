//
//  YLeftMenu.h
//  Ubate
//
//  Created by sunbin on 2016/12/1.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LeftMenuDelegate <NSObject>
/**
 *   代理
 *   借助主视图的导航栏实现view上跳转
 */
-(void)LeftMenuViewClick:(NSInteger)tag;

@end

@interface YLeftMenu : UIView
@property (nonatomic ,weak)id <LeftMenuDelegate> customDelegate;

@end
