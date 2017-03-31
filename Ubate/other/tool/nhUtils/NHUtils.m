//
//  NHUtils.m
//  Ubate
//
//  Created by sunbin on 2017/1/23.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "NHUtils.h"

#import "NHRefreshFooter.h"
#import <AVFoundation/AVFoundation.h>


@implementation NHUtils


/** 开始下拉刷新*/
+ (void)beginPullRefreshForScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_header beginRefreshing];
}

/**判断头部是否在刷新*/
+ (BOOL)headerIsRefreshForScrollView:(UIScrollView *)scrollView {
    
    BOOL flag =  scrollView.mj_header.isRefreshing;
    return flag;
}

/**判断是否尾部在刷新*/
+ (BOOL)footerIsLoadingForScrollView:(UIScrollView *)scrollView {
    return  scrollView.mj_footer.isRefreshing;
}

/**提示没有更多数据的情况*/
+ (void)noticeNoMoreDataForScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_footer endRefreshingWithNoMoreData];
}

/**重置footer*/
+ (void)resetNoMoreDataForScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_footer resetNoMoreData];
}

/**停止下拉刷新*/
+ (void)endRefreshForScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_header endRefreshing];
}

/**停止上拉加载*/
+ (void)endLoadMoreForScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_footer endRefreshing];
}

/** 隐藏footer*/
+ (void)hiddenFooterForScrollView:(UIScrollView *)scrollView {
    // 不确定是哪个类型的footer
    scrollView.mj_footer.hidden = YES;
}

/**隐藏header*/
+ (void)hiddenHeaderForScrollView:(UIScrollView *)scrollView {
    scrollView.mj_header.hidden = YES;
}

/**上拉*/
+ (void)addLoadMoreForScrollView:(UIScrollView *)scrollView
                loadMoreCallBack:(XRRefreshAndLoadMoreHandle)loadMoreCallBackBlock {
    
    if (scrollView == nil || loadMoreCallBackBlock == nil) {
        return ;
    }
    NHRefreshFooter *footer = [NHRefreshFooter footerWithRefreshingBlock:^{
        if (loadMoreCallBackBlock) {
            loadMoreCallBackBlock();
        }
    }];
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"内涵正在为您加载数据" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多了~" forState:MJRefreshStateNoMoreData];
    
    
    
    footer.stateLabel.textColor = kRGBColor(90, 90, 90);
    footer.stateLabel.font =FONT_FONTMicrosoftYaHei(13.f);
    //    footer.automaticallyHidden = YES;
    scrollView.mj_footer = footer;
    footer.backgroundColor = kClearColor;
    
    
}

/**下拉*/
+ (void)addPullRefreshForScrollView:(UIScrollView *)scrollView
                pullRefreshCallBack:(XRRefreshAndLoadMoreHandle)pullRefreshCallBackBlock {
    __weak typeof(UIScrollView *)weakScrollView = scrollView;
    if (scrollView == nil || pullRefreshCallBackBlock == nil) {
        return ;
    }
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (pullRefreshCallBackBlock) {
            pullRefreshCallBackBlock();
        }
        if (weakScrollView.mj_footer.hidden == NO) {
            [weakScrollView.mj_footer resetNoMoreData];
        }
        
    }];
    
    [header setTitle:@"释放更新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在更新" forState:MJRefreshStateRefreshing];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    
    header.stateLabel.font = [UIFont systemFontOfSize:13];
    header.stateLabel.textColor = kCommonBlackColor;
    header.lastUpdatedTimeLabel.hidden = YES;
    
    scrollView.mj_header = header;
}













+ (NSString *)datestrFromDate:(NSDate *)date
               withDateFormat:(NSString *)format {
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:date];
}


// 几天前 几分钟前..
+ (NSString *)updateTimeForTimeInterval:(NSInteger)timeInterval {
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = timeInterval;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    if (time < 60) {
        return @"刚刚";
    }
    NSInteger minutes = time / 60;
    if (minutes < 60) {
        return [NSString stringWithFormat:@"%ld分钟前", (long)minutes];
    }
    // 秒转小时
    NSInteger hours = time / 3600;
    if (hours < 24) {
        return [NSString stringWithFormat:@"%ld小时前",(long)hours];
    }
    // 秒转天数
    NSInteger days = time / 3600 / 24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前",(long)days];
    }
    // 秒转月
    NSInteger months = time / 3600 / 24 / 30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld月前",(long)months];
    }
    // 秒转年
    NSInteger years = time / 3600 / 24 / 30 / 12;
    return [NSString stringWithFormat:@"%ld年前",(long)years];
}



// 公共富文本
+ (NSAttributedString *)attStringWithString:(NSString *)string keyWord:(NSString *)keyWord {
    return [self attStringWithString:string keyWord:keyWord font:FONT_FONTMicrosoftYaHei(16) highlightedColor:kCommonHighLightRedColor textColor:kCommonBlackColor];
}

+ (NSAttributedString *)attStringWithString:(NSString *)string
                                    keyWord:(NSString *)keyWord
                                       font:(UIFont *)font
                           highlightedColor:(UIColor *)highlightedcolor
                                  textColor:(UIColor *)textColor {
    return [self attStringWithString:string keyWord:keyWord font:font highlightedColor:highlightedcolor textColor:textColor lineSpace:2.0];
}

+ (NSAttributedString *)attStringWithString:(NSString *)string
                                    keyWord:(NSString *)keyWord
                                       font:(UIFont *)font
                           highlightedColor:(UIColor *)highlightedcolor
                                  textColor:(UIColor *)textColor
                                  lineSpace:(CGFloat)lineSpace {
    if (string.length) {
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
        if (!keyWord || keyWord.length == 0) {
            NSRange allRange = NSMakeRange(0, string.length);
            [attStr addAttribute:NSFontAttributeName value:font range:allRange];
            [attStr addAttribute:NSForegroundColorAttributeName value:textColor range:allRange];
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = lineSpace;
            [attStr addAttribute:NSParagraphStyleAttributeName value:style range:allRange];
            return attStr;
        }
        NSRange range = [string rangeOfString:keyWord options:NSCaseInsensitiveSearch];
        // 找到了关键字
        if (range.location != NSNotFound) {
            NSRange allRange = NSMakeRange(0, string.length);
            [attStr addAttribute:NSFontAttributeName value:font range:allRange];
            [attStr addAttribute:NSForegroundColorAttributeName value:textColor range:allRange];
            [attStr addAttribute:NSForegroundColorAttributeName value:highlightedcolor range:range];
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = lineSpace;
            [attStr addAttribute:NSParagraphStyleAttributeName value:style range:allRange];
        } else {
            NSRange allRange = NSMakeRange(0, string.length);
            [attStr addAttribute:NSFontAttributeName value:font range:allRange];
            [attStr addAttribute:NSForegroundColorAttributeName value:textColor range:allRange];
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = lineSpace;
            [attStr addAttribute:NSParagraphStyleAttributeName value:style range:allRange];
            return attStr;
        }
        return attStr.copy;
    }
    return [[NSAttributedString alloc] init];
}



+ (NSString *)validString:(NSString *)string {
    if ([self isBlankString:string]) {
        return  @"";
    } else {
        return string;
    }
}
/**
 *  判断字符串是否为空
 */
+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    if ([string isKindOfClass:[NSString class]] == NO) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return NO;
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}




+ (NSString *)moneyWithInterge:(CGFloat)moneValue{
    NSString *account;
    if (moneValue == 0) {
        account = [NSString stringWithFormat:@"%.2f" ,moneValue];
    }
    if (moneValue >0 && moneValue <= 0.01) {
        account =@"≤0.01";
    }
    if (1.0 > moneValue && moneValue> 0.01) {
        account = [NSString stringWithFormat:@"%.2f" ,moneValue];
    }
    if (100.0 > moneValue && moneValue >= 1.0) {
        account = [NSString stringWithFormat:@"%.2f" ,moneValue];
    }
    if (1000.0 > moneValue && moneValue >= 100.0) {
        account = [NSString stringWithFormat:@"%.1f" ,moneValue];
    }
    if (10000.0 > moneValue && moneValue >= 1000.0) {
        account = [NSString stringWithFormat:@"%.2fK" ,moneValue/1000];
    }
    if (10000000.0 > moneValue && moneValue>= 10000.0) {
        account = [NSString stringWithFormat:@"%.1f万" ,moneValue/10000];
    }
    return account;
    
}


+ (void) alertAction:(SEL)selector alertControllerWithTitle:(NSString *)Title Message:(NSString *)message Vctl:(UIViewController *)Ctl Cancel:(BOOL)isCancel
{
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:Title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@",@"确定"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [Ctl performSelector:selector withObject:Ctl afterDelay:0.1];
    }];
    [alertCtl addAction:defaultAction];
    
    if (isCancel) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@",@"取消"] style:UIAlertActionStyleCancel handler:nil];
        [alertCtl addAction:cancelAction];
    }else{}
    [Ctl presentViewController:alertCtl animated:YES completion:^{
        
    }];
}



+ (void)pushAndPop:(NSString *)popView range:(NSRange )makeRange currentCtl:(UIViewController *)wSelf{
    Class class = NSClassFromString(popView);
    NSArray *ctlAry = [wSelf.navigationController viewControllers];
    [ctlAry enumerateObjectsUsingBlock:^(UIViewController *Ctl, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([Ctl isKindOfClass:class]) {
            NSMutableArray *array = [wSelf.navigationController.viewControllers mutableCopy];
            [array removeObjectsInRange:makeRange];
            
            [wSelf.navigationController setViewControllers:[array copy] animated:YES];
        }
    }];
}



+ (void)presentViewController:(NSString *)className currentController:(UIViewController *)ctl modalTransitionStyle:(UIModalTransitionStyle)style{
    
    Class class = NSClassFromString(className);
    UIViewController *controller = [[class alloc] init];
    controller.modalTransitionStyle = style;
    [ctl presentViewController:controller animated:YES completion:nil];
    
}




+ (void)clear{
    [[SDImageCache sharedImageCache] clearMemory];

    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
    }];
    [QCNetworkCache clearAllCache];
}



+ (NSString *)getAppIconName{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    //获取app中所有icon名字数组
    NSArray *iconsArr = infoDict[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"];
    //取最后一个icon的名字
    NSString *iconLastName = [iconsArr lastObject];
    return iconLastName;
}


+ (NSString *)getLaunchImageName{
    
    NSString *launchImageName = @"";  //启动图片名称变量
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    //获取与当前设备匹配的启动图片名称
    if (screenHeight == 480){ //4，4S
        launchImageName = @"LaunchImage-700";
    }
    else if (screenHeight == 568){ //5, 5C, 5S, iPod
        launchImageName = @"LaunchImage-700-568h";
    }
    else if (screenHeight == 667){ //6, 6S
        launchImageName = @"LaunchImage-800-667h";
    }
    else if (screenHeight == 736){ // 6Plus, 6SPlus
        launchImageName = @"LaunchImage-800-Landscape-736h";
    }
    
    if (launchImageName.length < 1){
        return nil;
    }else{
        return launchImageName;
    };
    
    
}


+ (NSMutableDictionary *)parameterName:(NSArray *)parameterNameAry parameterData:(NSArray *)parameterDataAry{
    __block NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [parameterNameAry enumerateObjectsUsingBlock:^(NSString *objKey, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = objKey;
        NSString *value = [parameterDataAry objectAtIndex:idx];
        [dic addEntriesFromDictionary:@{key:value}];
    }];
    
    return dic;
}

+ (void)playBeep
{
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"滴-2"ofType:@"mp3"]], &soundID);
    AudioServicesPlaySystemSound(soundID);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


+ (NSDictionary *)stringtojson:(NSString *)str{
    
    NSString *requestTmp = [NSString stringWithString:str];
    NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];  //解析
    
    return resultDic;
    
}

+ (NSString *)distanceWithInterge:(CGFloat)disctance{
    //厘米（cm）、分米（dm）、千米（km）、米（m）
    if (disctance >= 0 && disctance < 1000 ){
        CGFloat dictan = disctance;
        return [NSString stringWithFormat:@"%.fm",dictan];
    }else {
        CGFloat dictan = disctance/1000;
        return [NSString stringWithFormat:@"%.1fkm",dictan];
    }
}



+ (NSString *)cipherShowText:(cipherShow)type cipherData:(NSString *)data{
    
    NSString *num;
    if (type == ID_Card) {
        num = [data stringByReplacingCharactersInRange:NSMakeRange(6, 10) withString:@"●●●●●●●●●"];
    }
    if (type == Bank_Card) {
        num = [data stringByReplacingCharactersInRange:NSMakeRange(0, data.length-2) withString:@"*****************"];
    }
    if (type == Certification_ID) {
        num = [data stringByReplacingCharactersInRange:NSMakeRange(6, 10) withString:@"*********"];
    }
    
    
    if (type == Iphone) {
        num = [data stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    
    if (type == RelaName) {
        
        num = [data stringByReplacingCharactersInRange:NSMakeRange(1, data.length-1) withString:[self cipherPlaceNum:data.length-1]];
    }
    
    
    if (type == Email) {
        //前3后@ 中间省略
        NSUInteger length = data.length;
        NSString *emailAdress = [[data componentsSeparatedByString:@"@"] lastObject];
        NSUInteger emailAdressLength = emailAdress.length+1;
        
        NSInteger cipherPlaceLeng = length-emailAdressLength-3;
        
        
        num = [data stringByReplacingCharactersInRange:NSMakeRange(3, cipherPlaceLeng) withString:[self cipherPlaceNum:cipherPlaceLeng]];
    }
    
    if (type == PureDigital) {
        NSUInteger length = data.length;
        if (length>8) {
            NSInteger cipherPlaceLeng = length-6;
            num = [data stringByReplacingCharactersInRange:NSMakeRange(3, cipherPlaceLeng) withString:[self cipherPlaceNum:cipherPlaceLeng]];
            
        }else{
            NSInteger cipherPlaceLeng = length-4;
            num = [data stringByReplacingCharactersInRange:NSMakeRange(2, cipherPlaceLeng) withString:[self cipherPlaceNum:cipherPlaceLeng]];
            
        }
        
    }
    
    
    return num;
}

//多少个*号
+ (NSString *)cipherPlaceNum:(NSUInteger)num{
    
    NSString *strPlace = @"";
    for (NSInteger index = 0; index < num; index++) {
        NSString *str1 =  [strPlace stringByAppendingString:@"*"];
        strPlace =  str1;
    }
    return strPlace;
    
}



+ (NSString *)theRefundDeadline:(NSDate *)startData toDay:(NSInteger)dis{
    NSLog(@"startData====%@" ,startData);
    NSDate* theDate;
    NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
    
    //之后的天数
    theDate = [startData initWithTimeInterval: +oneDay*dis sinceDate:startData];
    
    //之前的天数
    //    theDate = [nowDate initWithTimeIntervalSinceNow: -oneDay*dis ];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString * currentDateStr = [dateFormatter stringFromDate:theDate];
    NSLog(@"===%@",currentDateStr);
    
    return currentDateStr;
    
    
}

//NSDate转NSString
+ (NSString *)stringFromDate:(NSDate *)date
{
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    //输出currentDateString
    NSLog(@"%@",currentDateString);
    return currentDateString;
}

//NSString转NSDate
+ (NSDate *)dateFromString:(NSString *)string
{
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:string];
    return date;
}


+ (NSString *)strTotimestamp:(NSString *)str{
    NSDate* date = [self dateFromString:str];
    NSTimeInterval a=[date timeIntervalSince1970]; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    return timeString;
}

//逆向遍历
+(NSMutableArray *)flashbackAry:(NSMutableArray *)array{
    NSEnumerator *enumerator = [array reverseObjectEnumerator];
    array = (NSMutableArray*)[enumerator allObjects];
    
    return array;
}

#pragma make -颜色转图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size alpha:(float)alpha
{
    @autoreleasepool {
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetAlpha(context, alpha);
        CGContextSetFillColorWithColor(context,color.CGColor);
        CGContextFillRect(context, rect);
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
        
    }
}

#pragma make -获取当前几天后时间
+ (NSString *)getDaysTime:(NSInteger)dis afterDay:(BOOL)afterDay{
    NSDate*nowDate = [NSDate date];
    NSDate* theDate;
    
    if(dis!=0)
    {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = afterDay?[nowDate initWithTimeIntervalSinceNow: +oneDay*dis ]:[nowDate initWithTimeIntervalSinceNow: -oneDay*dis ];
    }
    else
    {
        theDate = nowDate;
    }
    
    return [self stringFromDate:theDate];
    
}















+ (UIImage *)generateQrCode:(NSString *)qrCodeContent qrCodeAdress:(NSString *)qrCodeAdress qrCodeColorwithRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue qrCodeSize:(CGFloat)qrCodeSize{


        UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:[qrCodeAdress stringByAppendingString:[NSString stringWithFormat:@" %@" ,qrCodeContent]]] withSize:qrCodeSize];
    
    UIImage *customQrcode = [self imageBlackToTransparent:qrcode withRed:red andGreen:green andBlue:blue];
    return customQrcode;
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
#pragma mark - QRCodeGenerator
+ (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}

#pragma mark - imageToTransparent

+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}


#pragma mark - imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}




+ (void)saveCookies
{
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey: @"sessionCookies"];
    [defaults synchronize];
    
}

- (void)loadCookies
{
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookies){
        [cookieStorage setCookie: cookie];
    }
}




+ (void)tableViewProperty:(UITableView *)tableView registerNib:(NSString *)nibWithNibName forCellReuseIdentifier:(NSString *)Identifier{
    tableView.tableFooterView = [[UIView alloc] init];
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    
    tableView.separatorColor = [UIColor appSeparatorColor];
    tableView.backgroundColor = [UIColor themeColor];

    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator   = NO;


    [tableView registerNib:[UINib nibWithNibName:nibWithNibName bundle:nil] forCellReuseIdentifier:Identifier];
    

}



+ (void)setBtnColor:(UIButton *)btn{
    [btn setBackgroundColor:[UIColor appBtnStateNormalBackgroundColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor appBtnStateDisabledBackgroundColor] forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor appBtnStateNormalTitleColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor appBtnStateDisabledTitleColor] forState:UIControlStateDisabled];
    


}




+ (int)getRandomNumber:(int)from to:(int)to
{
        return (int)(from + (arc4random() % (to - from + 1)));
}







@end
