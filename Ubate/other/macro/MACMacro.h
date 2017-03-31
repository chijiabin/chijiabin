//
//  MACMacro.h
//  Ubate
//
//  Created by sunbin on 2017/1/23.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#ifndef MACMacro_h
#define MACMacro_h

// 键盘高度
#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)


// 高度-状态栏 导航栏 底部工具栏
#define STATUS_BAR_HEIGHT 20
#define NAVIGATION_BAR_HEIGHT 44
#define BOTTOMB_BAR_HEIGHT        (49.f)
#define STATUS_AND_NAVIGATION_HEIGHT ((STATUS_BAR_HEIGHT) + (NAVIGATION_BAR_HEIGHT))

// 屏幕（宽高）
#define SCREEN_RECT    ([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH   ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT  ([UIScreen mainScreen].bounds.size.height)
#define CONTENT_HEIGHT (SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT)


// 获取当前屏幕的高度 applicationFrame就是app显示的区域，不包含状态栏
#define kMainScreenHeight ([UIScreen mainScreen].applicationFrame.size.height)
#define kMainScreenWidth  ([UIScreen mainScreen].applicationFrame.size.width)

// View 坐标(x,y)和宽高(width,height)
#define X(v)                                                            (v).frame.origin.x
#define Y(v)                                                            (v).frame.origin.y
#define WIDTH(v)                                                        (v).frame.size.width
#define HEIGHT(v)                                                       (v).frame.size.height
#define MinX(v)                                                         CGRectGetMinX((v).frame)
#define MinY(v)                                                         CGRectGetMinY((v).frame)
#define MidX(v)                                                         CGRectGetMidX((v).frame)
#define MidY(v)                                                         CGRectGetMidY((v).frame)
#define MaxX(v)                                                         CGRectGetMaxX((v).frame)
#define MaxY(v)                                                         CGRectGetMaxY((v).frame)
#define RECT_CHANGE_x(v,x)                CGRectMake(x, Y(v), WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_y(v,y)                CGRectMake(X(v), y, WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_point(v,x,y)          CGRectMake(x, y, WIDTH(v),    HEIGHT(v))
#define RECT_CHANGE_width(v,w)            CGRectMake(X(v), Y(v), w,     HEIGHT(v))

#define RECT_CHANGE_height(v,h)           CGRectMake(X(v), Y(v), WIDTH(v), h)
#define RECT_CHANGE_size(v,w,h)           CGRectMake(X(v), Y(v), w,        h)


//.判断当前的iPhone设备/系统版本
// 判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
// 判断是否为iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
// 判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

#define Iphone4 CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 480))?YES:NO
#define Iphone5 CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 568))?YES:NO
#define Iphone6 CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 667))?YES:NO
#define Iphone6Plus CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 736))?YES:NO


// 本地资源文件
#define LOADPathResource(file ,ext) [[NSBundle mainBundle] pathForResource:file ofType:ext]
// 加载图片资源
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

#define IMAGE(imageName)  [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]
#define Icon(iconName)    [IMAGE(iconName) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
#define PNGPATH(NAME)     [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"png"]
#define JPGPATH(NAME)     [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"jpg"]
#define PATH(NAME, EXT)   [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]
#define PNGkImg(NAME)     [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPGkImg(NAME)     [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define kImg(NAME, EXT)   [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]
#define V_IMAGE(imgName)  [UIImage imageNamed:imgName]



// 获取AppDelegate
#define kAppDelegate ((AppDelegate*)([UIApplication sharedApplication].delegate))
// 获取  kWindow
#define kWindow   [[UIApplication sharedApplication] keyWindow]
// 获取根视图
#define kRootViewController [[[[UIApplication sharedApplication] keyWindow] objectAtIndex:0]rootViewController]


// Storyboard操作
#define kStoryboard(StoryboardName)                 [UIStoryboard storyboardWithName:StoryboardName bundle:nil]
#define kVCFromSb(storyboardId, storyboardName)     [[UIStoryboard storyboardWithName:storyboardName bundle:nil] \
instantiateViewControllerWithIdentifier:storyboardId]



// 处理字段时候为空的情况
#define TEXT_STRING(x) [NSString stringWithFormat:@"%@",x]
#define IF_NULL_TO_STRING(x) ([(x) isEqual:[NSNull null]]||(x)==nil)? @"":TEXT_STRING(x)
// 当无值=未绑定显示
#define IF_Binding(x) ([(x) isEqual:[NSNull null]]||(x)==nil)? @"未绑定":TEXT_STRING(x)

// 保留两位位
#define TEXT_Keep(x) [NSString stringWithFormat:@"%.2f",[x floatValue]]
// 字符串转整形数据
#define NstringToInt(str) [str integerValue]
//字符串 操作
#define URL(url) [NSURL URLWithString:url]
#define string(str1,str2) [NSString stringWithFormat:@"%@%@",str1,str2]
#define s_str(str1) [NSString stringWithFormat:@"%@",str1]
#define s_Num(num1) [NSString stringWithFormat:@"%d",num1]
#define s_Integer(num1) [NSString stringWithFormat:@"%ld" ,num1]
#define s_percent(num1) [NSString stringWithFormat:@"%@%%",num1]
//number转String
#define IntTranslateStr(int_str) [NSString stringWithFormat:@"%d",int_str];
#define FloatTranslateStr(float_str) [NSString stringWithFormat:@"%.2f",float_str];
#define UnsignedInteger_Int(uInt) [[NSNumber numberWithUnsignedInteger:uInt] integerValue]
// 本地化字符串
/** NSLocalizedString宏做的其实就是在当前bundle中查找资源文件名“Localizable.strings”(参数:键＋注释) */
#define LocalString(x, ...)     NSLocalizedString(x, nil)
/** NSLocalizedStringFromTable宏做的其实就是在当前bundle中查找资源文件名“xxx.strings”(参数:键＋文件名＋注释) */
#define AppLocalString(x, ...)  NSLocalizedStringFromTable(x, @"someName", nil)




// 本地持久化宏
#define USER_DEFAULT                 [NSUserDefaults standardUserDefaults]
#define SEEKPLISTTHING(KEY)          [[NSUserDefaults standardUserDefaults]objectForKey:KEY]
#define DEPOSITLISTTHING(VALUE,KEY)  [[NSUserDefaults standardUserDefaults] setObject:VALUE forKey:KEY]


// 获取temp
#define kPathTemp NSTemporaryDirectory()
// 获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
// 获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#define kFileManager [NSFileManager defaultManager]
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]



// 个人信息
#define IS_LOGIN (((NSString *)SEEKPLISTTHING(USER_ID)).length > 0)
#define QL_USER_ID IF_NULL_TO_STRING(((NSString *)SEEKPLISTTHING(USER_ID)))
#define QL_USER_PHONE IF_NULL_TO_STRING(((NSString *)SEEKPLISTTHING(USER_PHONE)))
#define QL_USER_EASEMOB_NAME IF_NULL_TO_STRING(((NSString *)SEEKPLISTTHING(USER_EASEMOB_NAME)))


// 弧度与角度互换
#pragma mark - degrees/radian functions由角度转换弧度 由弧度转换角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)


// 线程
#define kDelay  1.5
#define delayRun dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelay * NSEC_PER_SEC)), dispatch_get_main_queue()
#define kDelay01  0.7
#define delayRun05 dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelay01 * NSEC_PER_SEC)), dispatch_get_main_queue()
//GCD 的宏定义
//GCD - 一次性执行
#define kDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);
//GCD - 在Main线程上运行
#define kDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);
//GCD - 开启异步线程
#define kDISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);


/** 时间间隔 */
#define kHUDDuration            (1.f)

/** 一天的秒数 */
#define SecondsOfDay            (24.f * 60.f * 60.f)

/** 秒数 */
#define Seconds(Days)           (24.f * 60.f * 60.f * (Days))

/** 一天的毫秒数 */
#define MillisecondsOfDay       (24.f * 60.f * 60.f * 1000.f)

/** 毫秒数 */
#define Milliseconds(Days)      (24.f * 60.f * 60.f * 1000.f * (Days))




#define kScreenScale            UIScreenScale()



// 当前语言
#define CURRENTLANGUAGE         ([[NSLocale preferredLanguages] objectAtIndex:0])

#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;



//-------------------系统----------------
//当前系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//版本判断语句,是否是version以后的
#define IOS(version) (([[[UIDevice currentDevice] systemVersion] intValue] >= version)?1:0)

//获取当前语言
#define CurrentLanguage [[NSLocale preferredLanguages]objectAtIndex:0]

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)





// 获取屏幕宽度、高度
#define appWidth [UIScreen mainScreen].bounds.size.width
#define appHeight [UIScreen mainScreen].bounds.size.height


// 获取状态栏和导航栏高度
#define appStatusBarHeight  [UIApplication sharedApplication].statusBarFrame.size.height
#define appNavigationBarHeight  self.navigationController.navigationBar.frame.size.height



// 处理
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)










#pragma mark - 颜色
#define kWhiteColor            [UIColor whiteColor]
#define kBlackColor            [UIColor blackColor]
#define kDarkGrayColor         [UIColor darkGrayColor]
#define kLightGrayColor        [UIColor lightGrayColor]
#define kGrayColor             [UIColor grayColor]
#define kRedColor              [UIColor redColor]
#define kGreenColor            [UIColor greenColor]
#define kBlueColor             [UIColor blueColor]
#define kCyanColor             [UIColor cyanColor]
#define kYellowColor           [UIColor yellowColor]
#define kMagentaColor          [UIColor magentaColor]
#define kOrangeColor           [UIColor orangeColor]
#define kPurpleColor           [UIColor purpleColor]
#define kBrownColor            [UIColor brownColor]
#define kClearColor            [UIColor clearColor]
#define kCommonGrayTextColor   [UIColor colorWithRed:0.63f green:0.63f blue:0.63f alpha:1.00f]
#define kCommonRedColor        [UIColor colorWithRed:0.91f green:0.33f blue:0.33f alpha:1.00f]
#define kBgColor               kRGBColor(243,245,247)
#define kLineBgColor           [UIColor colorWithRed:0.86f green:0.88f blue:0.89f alpha:1.00f]
#define kTextColor             [UIColor colorWithRed:0.32f green:0.36f blue:0.40f alpha:1.00f]
#define kRGBAColor(r,g,b,a)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define kRGBColor(r,g,b)       kRGBAColor(r,g,b,1.0f)
#define kCommonBlackColor      [UIColor colorWithRed:0.17f green:0.23f blue:0.28f alpha:1.00f]
#define kSeperatorColor        kRGBColor(234,237,240)
#define kDetailTextColor       [UIColor colorWithRed:0.56f green:0.60f blue:0.62f alpha:1.00f]
#define kCommonTintColor       [UIColor colorWithRed:0.42f green:0.33f blue:0.27f alpha:1.00f]
#define kCommonBgColor         [UIColor colorWithRed:0.86f green:0.85f blue:0.80f alpha:1.00f]
#define kCommonHighLightRedColor [UIColor colorWithRed:1.00f green:0.49f blue:0.65f alpha:1.00f]

#define kLeftMargin 15
#define kScope 20000000000 //区域范围内




#endif /* MACMacro_h */
