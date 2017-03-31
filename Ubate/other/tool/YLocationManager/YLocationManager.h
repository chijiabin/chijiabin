//
//  YLocationManager.h
//  Ubate
//
//  Created by sunbin on 2016/12/22.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>
/**
 *  定位block块
 *
 *  @param location  当前位置对象
 *  @param placeMark 反地理编码对象
 *  @param error     错误信息
 */
typedef void(^ResultLocationInfoBlock)(CLLocation *location, CLPlacemark *placeMark, NSString *error);

/**
 *  定位block块(仅获取经纬度坐标)
 *
 *  @param location  当前位置对象
 *  @param error     错误信息
 */
typedef void(^ResultLocationBlock)(CLLocation *location);


@interface YLocationManager : NSObject
//单例对象
single_interface(YLocationManager)
/**
 *  直接通过代码块获取用户位置信息
 *
 *  @param block 定位block代码块
 */
-(void)getCurrentLocation:(ResultLocationInfoBlock)block onViewController:(UIViewController *)viewController;

/**
 *  直接通过代码块获取用户位置信息
 *
 *  @param block 定位block代码块
 */
-(void)getCurrentLocationOnly:(ResultLocationBlock)block onViewController:(UIViewController *)viewController;


@end
