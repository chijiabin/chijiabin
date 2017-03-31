//
//  FJSlidingController.h
//  Youxian
//
//  Created by sunbin on 16/10/3.
//  Copyright © 2016年 sunbin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FJSlidingControllerDataSource;
@protocol FJSlidingControllerDelegate;

@interface FJSlidingController : BaseViewController
@property (nonatomic, assign)id<FJSlidingControllerDataSource> datasouce;
@property (nonatomic, assign)id<FJSlidingControllerDelegate> delegate;
-(void)reloadData;
@end



@protocol FJSlidingControllerDataSource <NSObject>
@required
// pageNumber
- (NSInteger)numberOfPageInFJSlidingController:(FJSlidingController *)fjSlidingController;
// index -> UIViewController
- (UIViewController *)fjSlidingController:(FJSlidingController *)fjSlidingController controllerAtIndex:(NSInteger)index;
// index -> Title
- (NSString *)fjSlidingController:(FJSlidingController *)fjSlidingController titleAtIndex:(NSInteger)index;

@optional
// textNomalColor
- (UIColor *)titleNomalColorInFJSlidingController:(FJSlidingController *)fjSlidingController;
// textSelectedColor
- (UIColor *)titleSelectedColorInFJSlidingController:(FJSlidingController *)fjSlidingController;
// lineColor
- (UIColor *)lineColorInFJSlidingController:(FJSlidingController *)fjSlidingController;
// titleFont
- (CGFloat)titleFontInFJSlidingController:(FJSlidingController *)fjSlidingController;
@end




@protocol FJSlidingControllerDelegate <NSObject>
@optional
// selctedIndex
- (void)fjSlidingController:(FJSlidingController *)fjSlidingController selectedIndex:(NSInteger)index;
// selectedController
- (void)fjSlidingController:(FJSlidingController *)fjSlidingController selectedController:(UIViewController *)controller;
// selectedTitle
- (void)fjSlidingController:(FJSlidingController *)fjSlidingController selectedTitle:(NSString *)title;
@end
