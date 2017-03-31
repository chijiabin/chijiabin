//
//  SegmentTapView.h
//  Youxian
//
//  Created by sunbin on 16/10/3.
//  Copyright © 2016年 sunbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SegmentTapViewDelegate <NSObject>
@optional
/**
 选择index回调
  */
-(void)selectedIndex:(NSInteger)index;
@end

@interface SegmentTapView : UIView

/**
 选择回调
 */
@property (nonatomic, assign)id<SegmentTapViewDelegate> delegate;
/**
 数据源
 */
@property (nonatomic, strong)NSArray *dataArray;
/**
 字体非选中时颜色
 */
@property (nonatomic, strong)UIColor *textNomalColor;
/**
 字体选中时颜色
 */
@property (nonatomic, strong)UIColor *textSelectedColor;
/**
 横线颜色
 */
@property (nonatomic, strong)UIColor *lineColor;
/**
 字体大小
 */
@property (nonatomic, assign)CGFloat titleFont;
/**
 手动选择
 
 @param index inde（从1开始）
 */
-(void)selectIndex:(NSInteger)index;

@end
