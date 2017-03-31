//
//  NHUtils.h
//  Ubate
//
//  Created by sunbin on 2017/1/23.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^XRRefreshAndLoadMoreHandle)(void);


@interface NHUtils : NSObject

/** 开始下拉刷新 */
+ (void)beginPullRefreshForScrollView:(UIScrollView *)scrollView;

/** 判断头部是否在刷新 */
+ (BOOL)headerIsRefreshForScrollView:(UIScrollView *)scrollView;

/** 判断是否尾部在刷新 */
+ (BOOL)footerIsLoadingForScrollView:(UIScrollView *)scrollView;

/** 提示没有更多数据的情况 */
+ (void)noticeNoMoreDataForScrollView:(UIScrollView *)scrollView;

/**   重置footer */
+ (void)resetNoMoreDataForScrollView:(UIScrollView *)scrollView;

/**  停止下拉刷新 */
+ (void)endRefreshForScrollView:(UIScrollView *)scrollView;

/**  停止上拉加载 */
+ (void)endLoadMoreForScrollView:(UIScrollView *)scrollView;

/**  隐藏footer */
+ (void)hiddenFooterForScrollView:(UIScrollView *)scrollView;

/** 隐藏header */
+ (void)hiddenHeaderForScrollView:(UIScrollView *)scrollView;

/** 下拉刷新 */
+ (void)addLoadMoreForScrollView:(UIScrollView *)scrollView
                loadMoreCallBack:(XRRefreshAndLoadMoreHandle)loadMoreCallBackBlock;

/** 上拉加载 */
+ (void)addPullRefreshForScrollView:(UIScrollView *)scrollView
                pullRefreshCallBack:(XRRefreshAndLoadMoreHandle)pullRefreshCallBackBlock;





+ (NSString *)datestrFromDate:(NSDate *)date
               withDateFormat:(NSString *)format;

/**
 *  转化时间
 *  几天前，几分钟前
 */
+ (NSString *)updateTimeForTimeInterval:(NSInteger)timeInterval;


/**
 *  公共富文本
 */
+ (NSAttributedString *)attStringWithString:(NSString *)string keyWord:(NSString *)keyWord;

+ (NSAttributedString *)attStringWithString:(NSString *)string
                                    keyWord:(NSString *)keyWord
                                       font:(UIFont *)font
                           highlightedColor:(UIColor *)highlightedcolor
                                  textColor:(UIColor *)textColor;

+ (NSAttributedString *)attStringWithString:(NSString *)string
                                    keyWord:(NSString *)keyWord
                                       font:(UIFont *)font
                           highlightedColor:(UIColor *)highlightedcolor
                                  textColor:(UIColor *)textColor
                                  lineSpace:(CGFloat)lineSpace;

//判断字符串是否为空
+ (NSString *)validString:(NSString *)string;
+ (BOOL)isBlankString:(NSString *)string;

//color生成image
+ (UIImage *)imageWithColor:(UIColor *)color;
//钱=数据处理（个十百千万）
+ (NSString *)moneyWithInterge:(CGFloat)moneValue;

//系统弹框
+ (void) alertAction:(SEL)selector alertControllerWithTitle:(NSString *)Title Message:(NSString *)message Vctl:(UIViewController *)Ctl Cancel:(BOOL)isCancel;

//控制器返回指定控制器
+ (void)pushAndPop:(NSString *)popView range:(NSRange )makeRange currentCtl:(UIViewController *)wSelf;


//presentViewController
+ (void)presentViewController:(NSString *)className currentController:(UIViewController *)ctl modalTransitionStyle:(UIModalTransitionStyle)style;



+ (void)clear;


//获取app的icon 启动图
+ (NSString *)getAppIconName;
+ (NSString *)getLaunchImageName;



+ (NSMutableDictionary *)parameterName:(NSArray *)parameterNameAry parameterData:(NSArray *)parameterDataAry;

//暂停系统声音
+ (void)playBeep;


//字符串转json
+ (NSDictionary *)stringtojson:(NSString *)str;


//获取两地点距离
+ (NSString *)distanceWithInterge:(CGFloat)disctance;



//省略
+ (NSString *)cipherShowText:(cipherShow)type cipherData:(NSString *)data;



/**
 *  得到退款截止时间
 */
+ (NSString *)theRefundDeadline:(NSDate *)startData toDay:(NSInteger)dis;


/**
 *  字符串与时间转换
 */

+ (NSDate *)dateFromString:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;


+ (NSString *)strTotimestamp:(NSString *)str;
+ (NSString *)getDaysTime:(NSInteger)dis afterDay:(BOOL)afterDay;

+ (NSMutableArray *)flashbackAry:(NSMutableArray *)ary;


// 用于在自定义头部 尾部颜色设置
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size alpha:(float)alpha;

//二维码
+ (UIImage *)generateQrCode:(NSString *)qrCodeContent qrCodeAdress:(NSString *)qrCodeAdress qrCodeColorwithRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue qrCodeSize:(CGFloat)qrCodeSize;


+ (void)saveCookies;
- (void)loadCookies;



//设置tableView属性
+ (void)tableViewProperty:(UITableView *)tableView registerNib:(NSString *)nibWithNibName forCellReuseIdentifier:(NSString *)Identifier;

+ (void)setBtnColor:(UIButton *)btn;

//  获取一个随机整数，范围在[from,to），包括from，包括to
+ (int)getRandomNumber:(int)from to:(int)to;


@end
