//
//  CircleView.h
//  Ubate
//
//  Created by sunbin on 2016/11/30.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LYCircleViewDelegate <NSObject>

@optional
/**
 点击事件代理
 */
- (void)didSelectCircleViewAtIndex:(NSInteger)index;
/**
 显示分享人数
 */

- (NSString *)sharepresonCount;

@end

@interface CircleView : UIView

@property (nonatomic, weak)id <LYCircleViewDelegate>delegate;

/**
 * 累计返现（消费返现 共享返现） 圆饼百分比
 */

@property (nonatomic ,strong) NSArray *percentOfTheCircle;

/**
 颜色与百分比一一对应
 */

@property (nonatomic ,strong) NSArray *hexStringOfCircleColor;
/**
 *显示的文本内容
 */

@property (nonatomic ,strong) NSArray *textStringOfCircle;




/**
 *显示分享人数
 */
@property (nonatomic ,strong) NSString *sharepresonCount;


/**
 *可用返现
 */
@property (nonatomic ,strong) NSString *availableCashback;

/**
 *累计返现
 */
@property (nonatomic ,strong) NSString *collect_money;



/**
 *  是否显示累计返现
 */

@property (nonatomic ,assign) BOOL isShowCumulative;

/**
 *更新数据
 */
- (void)reloadData;

@end
