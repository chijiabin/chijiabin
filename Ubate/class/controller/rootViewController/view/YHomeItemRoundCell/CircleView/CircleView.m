//
//  CircleView.m
//  Ubate
//
//  Created by sunbin on 2016/11/30.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "CircleView.h"
#import <Foundation/Foundation.h>

#define CENTER_X self.bounds.size.width / 2
#define CENTER_Y self.bounds.size.height / 2

#define FIRST_LINE_X(x) CENTER_X + x
#define FIRST_LINE_Y(y) CENTER_Y + y

#define SEC_LINE_X(x) x > 0 ? FIRST_LINE_X(x) + secLine : FIRST_LINE_X(x) - secLine

#define SIN(x) sin(x / 180 * M_PI)
#define COS(x) cos(x / 180 * M_PI)
#define PI 3.14159265358979323846

static NSInteger firstLine = 20;
static NSInteger secLine = 50;


@implementation CircleView
{
    UILabel *personCountLab ;
    UILabel *personCountLab1 ;
    /**
     *  颜色数组
     */
    
    NSMutableArray *hexColorArray;
    
    /**
     *  百分比数组  数据源
     */
    
    NSArray *percentArray;
    
    /**
     *  文本注释数据
     */
    
    NSArray *textArray;
    
    /**
     *  路径图层数组 点击事件
     */
    
    NSMutableArray *pathArray;
    
    
    /**
     *  判断是否能画圆 画圆条件
     */
    
    BOOL canDraw;
    
    /**
     *  弧度
     */
    
    NSInteger totalAngle;
    
    /**
     *  圆环半径 =大圆 中间圆半径
     */
    CGFloat radius;
    
    CGFloat  middleCircleRadius;
    
    /**
     *  分享人数shareCount 返现
     */
    
    NSString *shareCount;
    NSString *Cashback;
    
    UIImageView *leftimage;
    
//    UIImageView *lineOne;
//    UIImageView *lineTwo;
}


/**
 *  实例化
 *  背景颜色
 *  默认的颜色数组
 *  获取当前view 的宽高比决定半径大小
 *
 */

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
//        lineOne = [[UIImageView alloc]init];
//        lineOne.frame = CGRectMake(25, 50, 30, 30);
//        lineOne.alpha = 0;
//        lineOne.image = [UIImage imageNamed:@"left.png"];
        [self createColorArray];
        
        if (self.bounds.size.width >= self.bounds.size.height) {
            radius = (self.bounds.size.height - firstLine - 25 -20) / 2.5f;
            middleCircleRadius = radius/2 + 10;
        }else {
            radius = self.bounds.size.width / 4.5;
            middleCircleRadius = radius/2;
        }
        pathArray = [[NSMutableArray alloc]init];
        
    }
    return self;
}

/**
 *  自带颜色
 *  蓝色: 0000FF
 *  绿色: 008000
 *  紫色: 800080
 *  黄色: FFFF00
 *  红色: FF0000
 *  桃色: FFDAB9
 *
 */


- (void)createColorArray{
    hexColorArray = [[NSMutableArray alloc]initWithObjects:@"0000FF",@"008000",@"800080",@"FFFF00",@"FF0000",@"FFDAB9", nil];
}


/**
 *累计返现（消费返现 共享返现） 圆饼百分比 赋值数据源
 */

-(void)setPercentOfTheCircle:(NSArray *)percentOfTheCircle{
    NSArray * labelArray = [self subviews];
    for (UIView * view in labelArray) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    _percentOfTheCircle = percentOfTheCircle;
}


/**
 *  获取 其他控制器传入的值
 */

- (void)layoutSubviews{
    [super layoutSubviews];
    
    /** 布局
     *  personCountLab 分享人数
     */
    if (_isShowCumulative) {
        
        personCountLab = [[UILabel alloc]init];
        personCountLab.font = FONT_FONTMicrosoftYaHei(12);
        personCountLab.textColor = [UIColor whiteColor];
        personCountLab.textAlignment = NSTextAlignmentCenter;
        personCountLab.frame = CGRectMake(15, 0, 60, 60);
        personCountLab.numberOfLines = 0;
        personCountLab.alpha = 0;

        
        
        [UIView animateWithDuration:0.3 delay:0.05 options:UIViewAnimationOptionCurveEaseOut animations:^{
        personCountLab.alpha = 1;
            
            
        if ([self.delegate respondsToSelector:@selector(sharepresonCount)]) {
                NSString *str = [self.delegate sharepresonCount];
                NSRange range = [str rangeOfString:@"\n"];
                
               // NSLog(@"rang:%@",NSStringFromRange(range));
                NSUInteger loc = range.location;
                
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
                
                [attributedString addAttribute:NSFontAttributeName
                                         value:FONT_FONTMicrosoftYaHei(15)
                                         range:NSMakeRange(0, loc)];
                
                [attributedString addAttribute:NSForegroundColorAttributeName
                                         value:[UIColor whiteColor]
                                         range:NSMakeRange(0,loc)];
                personCountLab.attributedText = attributedString;
            }

        } completion:nil];

       // [self addSubview:leftimage];
        [self addSubview:personCountLab];
       // [self addSubview:lineOne];
    }
        
    /**
     *  能否画
     */
    canDraw = YES;
    /**
     *  数据源赋值
     */
    
    percentArray = [NSArray arrayWithArray:_percentOfTheCircle];
    
    /**
     *  文本注释内容赋值 _textStringOfCircle
     */
    textArray = [NSArray arrayWithArray:_textStringOfCircle];
//    NSArray *colorArray = [NSArray arrayWithArray:_hexStringOfCircleColor];
    
//    if (colorArray.count > 0) {
//        for (int i = 0; i < colorArray.count; i ++) {
//            /**
//             *  颜色数组添加颜色
//             */
//            [hexColorArray insertObject:colorArray[i] atIndex:i];
//            
//        }}
    /**
     *  核对圆环数据
     */
    [self checkCirCleViewDatas];
}


/**
 *  核对圆环数据
 */
- (void)checkCirCleViewDatas{
    //当百分百数组>颜色数组 或者百分百数据源为空
    if (percentArray.count > hexColorArray.count || percentArray.count == 0) {
        canDraw = NO;
        return;
    }
    
    /**
     totalPercent 数组值总和
     检查百分比数组
     NSRoundPlain,   取整
     NSRoundDown,    只舍不入
     NSRoundUp,      只入不舍
     NSRoundBankers  四舍五入
     */
    
    NSDecimalNumber *totalPercent = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    
    /**
     *  遍历数据源值 且值需大于0 累加
     */
    
    for (NSString *percent in percentArray) {
        if ([percent floatValue] < 0) {
            canDraw = NO;
            return;
        }
        NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:percent];
        totalPercent = [totalPercent decimalNumberByAdding:value];
    }
    
    
    if (textArray.count > 0 &&  textArray.count != percentArray.count ) {
        canDraw = NO;
    }
}

/**
 *  画图
 */

- (void)drawRect:(CGRect)rect{
    
    if (!canDraw) {
        return;
    }
    /**
     *  创建画布 获取上下文信息
     *  已加载的扇形弧度总和
     *  当前扇形所占弧度   每个扇形的百分比
     *
     */
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat endPercent = 0.0;
    
    CGFloat curPercent = 0.0;
    
    CGFloat perPercent = 0.0;
    
    /**
     *  遍历percentArray 百分数据源  扇形的百分比 = 当前值/数组和
     */
    
    for (int i = 0; i < percentArray.count; i ++) {
        
        CGFloat sum = [[percentArray valueForKeyPath:@"@sum.floatValue"] floatValue];
        perPercent = [percentArray[i] floatValue] / sum;
        
        
        NSDateFormatter * dataFormatter = [[NSDateFormatter alloc]init];
        [dataFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSS"];
        
        if (_isShowCumulative) {
            
          //  lineOne.alpha = 1;

           // NSLog(@"开始画线时间 = %@",[dataFormatter stringFromDate:[NSDate date]]);
            
            
            if (i == 0) {
                
                [self drawCircleOnTheContext:context WithRadius:radius  StartAngle:0 EndAngle:2 * M_PI];
                [self endDrawingOnTheContext:context withType:kCGPathFill];
                
                perPercent = 92.f / 100;
                curPercent = perPercent * 2 * M_PI;
                endPercent = perPercent * 2 * M_PI + endPercent;
                double angle = [self countLocationOftheExplainLine:endPercent curDegrees:curPercent];
                
                CGFloat sum = [ [percentArray valueForKeyPath:@"@sum.floatValue"] floatValue];
                
                if (sum ==0 ) {
                    
                    
                }else{
                
                    perPercent = [percentArray[i] floatValue] / sum;
                    
                    [self beginDrawingOnTheContext:context withHexColorString:@"#F5F5F5" alpha:1];
                    
                    [self drawLineOnTheContext:context angle:angle withHexColorString:@"f5f5f5" andTextString:textArray[i] percent:[NSString stringWithFormat:@"%.2f" ,perPercent*100]];
                    
                    [self endDrawingOnTheContext:context withType:kCGPathFill];
                }
                
            }
            
            if (i == 1) {
                
                if (sum ==0 ) {
                    
                }else{
                    
                    NSArray *array = @[[UIColor SGWBCirclegradientFromCGrect:self.frame],[UIColor NWBCirclegradientFromCGrect:self.frame] ];
                    [self beginDrawingOnTheContext:context Color:array[1]];
                    
                    [self drawCircleOnTheContext:context WithRadius:radius  StartAngle:0 EndAngle:2 * M_PI];
                    [self endDrawingOnTheContext:context withType:kCGPathFill];
                    
                    perPercent = 3.f / 100;
                    curPercent = perPercent * 2 * M_PI;
                    endPercent = perPercent * 2 * M_PI + endPercent;
                    
                    double angle = [self countLocationOftheExplainLine:endPercent curDegrees:curPercent];
                    [self beginDrawingOnTheContext:context withHexColorString:@"f5f5f5" alpha:0];
                    
                    CGFloat sum = [ [percentArray valueForKeyPath:@"@sum.floatValue"] floatValue];
                    perPercent = [percentArray[i] floatValue] / sum;
                    
                    [self drawLineOnTheContext:context angle:angle withHexColorString:@"f5f5f5" andTextString:textArray[i] percent:[NSString stringWithFormat:@"%.2f" ,perPercent*100]];
                    
                    [self endDrawingOnTheContext:context withType:kCGPathFill];


                }
            }
            
         //    NSLog(@"结束画线时间 = %@",[dataFormatter stringFromDate:[NSDate date]]);
            
        }else{
         //   lineOne.alpha = 0;

            NSArray *array = @[[UIColor SGWBCirclegradientFromCGrect:self.frame],[UIColor NWBCirclegradientFromCGrect:self.frame] ];
            [self beginDrawingOnTheContext:context Color:array[1]];
            
            [self drawCircleOnTheContext:context WithRadius:radius  StartAngle:0 EndAngle:2 * M_PI];
            [self endDrawingOnTheContext:context withType:kCGPathFill];
            
            
      //      NSLog(@"线条消失时间 = %@",[dataFormatter stringFromDate:[NSDate date]]);
            
        }
        
    }
    
    UIColor *withHexColorString1;
    UIColor *withHexColorString2;
    UIColor *withHexColorString3;//圆心
    
    //大圆出现这里就表示 数据源都为空
    CGFloat floatValue = [[percentArray valueForKeyPath:@"@sum.floatValue"] floatValue];
    
    if (floatValue == 0) {
        if (_isShowCumulative) {
            NSArray *array = @[[UIColor SGWBCirclegradientFromCGrect:self.frame],[UIColor NWBCirclegradientFromCGrect:self.frame] ];
            [self beginDrawingOnTheContext:context Color:array[1]];
            
            
        }else{
            NSArray *array = @[[UIColor SGWBCirclegradientFromCGrect:self.frame],[UIColor NWBCirclegradientFromCGrect:self.frame] ];
            [self beginDrawingOnTheContext:context Color:array[1]];
        }
        
        
        [self drawCircleOnTheContext:context WithRadius:radius  StartAngle:0 EndAngle:2 * M_PI];
        [self endDrawingOnTheContext:context withType:kCGPathFill];
    }
    
    if (_isShowCumulative) {
        withHexColorString1 = [UIColor NBCirclegradientFromCGrect:self.frame];
        withHexColorString2 = [UIColor NMCirclegradientFromCGrect:self.frame];
        withHexColorString3 = [UIColor NSCirclegradient];//圆心
        
    }else{
        
        withHexColorString1 = [UIColor NBCirclegradientFromCGrect:self.frame];
        withHexColorString2 = [UIColor NMCirclegradientFromCGrect:self.frame];
        withHexColorString3 = [UIColor NSCirclegradient];//圆心
        
    }
    
    CGFloat radiusWidth = (radius - middleCircleRadius)/3;
    /** 连续画三个圆
     *  外-里 外2
     */
    
    [self beginDrawingOnTheContext:context Color:withHexColorString1];
    
    [self drawCircleOnTheContext:context WithRadius:radius - radiusWidth StartAngle:0 EndAngle:2 * M_PI];
    [self endDrawingOnTheContext:context withType:kCGPathFill];
    /**
     *  外3
     */
    
    [self beginDrawingOnTheContext:context Color:withHexColorString2];
    
    [self drawCircleOnTheContext:context WithRadius:radius - 2*radiusWidth StartAngle:0 EndAngle:2 * M_PI];
    [self endDrawingOnTheContext:context withType:kCGPathFill];
    /**
     *  外4  中间空白
     */
    
    [self beginDrawingOnTheContext:context Color:withHexColorString3];
    [self drawCircleOnTheContext:context WithRadius:middleCircleRadius  StartAngle:0 EndAngle:2 * M_PI];
    [self endDrawingOnTheContext:context withType:kCGPathFill];
    /**
     *  只有圆画上去才能调用此方法
     */
    [self addCenterLabel:YES];
}

/**
 *  与坐标交点
 */

- (double)countLocationOftheExplainLine:(CGFloat)totalDegrees curDegrees:(CGFloat)curDegrees{
    CGFloat percent = (totalDegrees - curDegrees / 2) / M_PI_2;
    /**
     *  和横纵轴形成的夹角
     */
    totalAngle = percent * 90;
    /**
     *  判断所在范围
     */
    
    if ((totalAngle >= 90 && totalAngle < 180) || (totalAngle >= 270 && totalAngle < 360)) {
        return 90 - totalAngle % 90;
    }
    return totalAngle % 90 ;
}

/**
 *  CGContextMoveToPoint中心点
 *  填充颜色 CGContextSetFillColorWithColor
 *  画笔艳色 CGContextSetStrokeColorWithColor
 *
 */
- (void)beginDrawingOnTheContext:(CGContextRef)context Color:(UIColor *)color{
    CGContextMoveToPoint(context, CENTER_X, CENTER_Y);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetStrokeColorWithColor(context,color.CGColor);
    
}

- (void)beginDrawingOnTheContext:(CGContextRef)context withHexColorString:(NSString *)color alpha:(CGFloat)alpha{
    CGContextMoveToPoint(context, CENTER_X, CENTER_Y);
    CGContextSetFillColorWithColor(context, [self colorWithHexString:color alpha:alpha].CGColor);
    CGContextSetStrokeColorWithColor(context, [self colorWithHexString:color alpha:alpha].CGColor);
}

//画线 获取点的坐标划线 注释内容
- (void)drawLineOnTheContext:(CGContextRef)context angle:(double)angle withHexColorString:(NSString *)color andTextString:(NSString *)text percent:(NSString *)percent{
    
    CGFloat pointX = COS(angle);
    CGFloat pointY = SIN(angle);
    if (totalAngle >= 90 && totalAngle < 180) {
        pointX = -pointX;
    }
    if (totalAngle >= 180 && totalAngle < 270) {
        pointX = -pointX;
        pointY = -pointY;
    }
    if (totalAngle >= 270 && totalAngle < 360) {
        pointY = -pointY;
    }
    CGFloat lineX = FIRST_LINE_X(pointX * (radius + firstLine));
    CGFloat lineY = FIRST_LINE_Y(pointY * (radius + firstLine));
    //第一条线 圆里
    CGContextAddLineToPoint(context, lineX, lineY);
    
    //第二条线
    CGContextAddLineToPoint(context, SEC_LINE_X(pointX * (radius + firstLine)), lineY);
    
    [self createExplainLabelPointX:lineX pointY:lineY withTextColorString:color andTextString:text percent:(NSString *)percent];
    
    //画边上的小圆
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(SEC_LINE_X(pointX * (radius + firstLine))+2, lineY) radius:2 startAngle:0 endAngle:PI * 2 clockwise:YES];
    [[UIColor whiteColor] set];
    arcPath.lineWidth = 0.8;
    
    [arcPath stroke];
    
    
    [self createExplainLabelPointX:lineX pointY:lineY withTextColorString:color andTextString:text percent:(NSString *)percent];
    
}


//画圆
- (void)drawCircleOnTheContext:(CGContextRef)context WithRadius:(CGFloat)radiu StartAngle:(CGFloat)startAngle EndAngle:(CGFloat)endAngle{
    //x,y为圆点坐标，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    CGContextAddArc(context, CENTER_X, CENTER_Y, radiu, startAngle, endAngle, 0);
}

//完成绘画    渲染图形
- (void)endDrawingOnTheContext:(CGContextRef)context withType:(CGPathDrawingMode)type{
    CGContextDrawPath(context, type);
}

#pragma make 注释label 文字

- (void)createExplainLabelPointX:(CGFloat)pointX pointY:(CGFloat)pointY withTextColorString:(NSString *)colorStr andTextString:(NSString *)text percent:(NSString *)percent{
    
    if (pointX < CENTER_X) {
        pointX -= 150;
    }
    
    //上方  百分百数据
    UILabel *percentLabel = [[UILabel alloc]initWithFrame:CGRectMake(pointX, pointY - 20, 150, 20)];
    percentLabel.text = [NSString stringWithFormat:@"%@%%",percent ];
    percentLabel.numberOfLines = 0;
    percentLabel.textAlignment = 0;
    if (pointX < CENTER_X) {
        percentLabel.textAlignment = 2;
    }
    percentLabel.textColor = [self colorWithHexString:colorStr alpha:1];
    percentLabel.font = [UIFont systemFontOfSize:15];
    percentLabel.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
    percentLabel.alpha = 1;
    } completion:^(BOOL finished) {

    }];
    
    
    
    
    
    //下方  （共享返现  消费返现）
    UILabel *zhushiLabe = [[UILabel alloc]initWithFrame:CGRectMake(pointX, pointY - 20+20, 150, 20)];
    zhushiLabe.text = [NSString stringWithFormat:@"%@",text ];
    zhushiLabe.numberOfLines = 0;
    zhushiLabe.textAlignment = 0;
    if (pointX < CENTER_X) {
        zhushiLabe.textAlignment = 2;
    }
    zhushiLabe.textColor = [self colorWithHexString:colorStr alpha:1];
    zhushiLabe.font = [UIFont systemFontOfSize:12];
    zhushiLabe.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
    zhushiLabe.alpha = 1;
        
    } completion:^(BOOL finished) {
    }];

    [self addSubview:percentLabel];
    [self addSubview:zhushiLabe];
    
}

//颜色转换
- (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha{
    
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}



- (void)addCenterLabel:(BOOL)isOnClick{
    
#pragma make 判断是否点击 传入的是数值不需处理
    NSString *money;
    NSString *cashbackType;
    
    
    if (_isShowCumulative) {
        cashbackType = @"累计返现";
        money = [NHUtils moneyWithInterge:[_collect_money floatValue]];
        
        
    }else{
        cashbackType = @"可用返现";
        money = [NHUtils moneyWithInterge:[_availableCashback floatValue]];
    }
    
    
    CGSize viewSize = self.bounds.size;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    
    
    //可用返现
    CGFloat fontSize;
    if (Iphone4) {
        fontSize = 8.f;
    }else if (Iphone5){
        fontSize = 9.f;
    }else{
        fontSize = 12.f;
    }
    
    //数据
    CGFloat fontSize1;
    if (Iphone4) {
        fontSize1 = 11.f;
    }else if (Iphone5){
        fontSize1 = 13.f;
    }else{
        fontSize1 = 21.f;
    }
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:fontSize],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,[UIColor clearColor],NSBackgroundColorAttributeName,paragraph,NSParagraphStyleAttributeName,nil];
    
    NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:fontSize1],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,[UIColor clearColor],NSBackgroundColorAttributeName,paragraph,NSParagraphStyleAttributeName,nil];
    
    
    CGFloat MY;
    CGFloat MY1;
    CGFloat MY2;
    
    if (Iphone4) {
        MY = (viewSize.height-12)/2.5+10;
        MY1 = MY+12;
        MY2 = MY1+12+5+2;
        
    }else if (Iphone5){
        MY = (viewSize.height-12)/2.5+10;
        MY1 = MY+12;
        MY2 = MY1+12+5+2;
        
    }else if (Iphone6){
        MY = (viewSize.height-12)/2.5+10;
        MY1 = MY+12+6;
        MY2 = MY1+12+5+2;
    }else if (Iphone6Plus){
        MY = (viewSize.height-12)/2.5+12;
        MY1 = MY+12+6;
        MY2 = MY1+12+5+4;
        
    }
    
    
    [money drawInRect:CGRectMake(0, MY-5, viewSize.width, 12+15) withAttributes:attributes1];
    
    [cashbackType drawInRect:CGRectMake(0, MY1, viewSize.width, 12+5) withAttributes:attributes];
    
    //图片
    UIImage *image = Icon(@"zhuanhuan");
    [image drawInRect:CGRectMake((viewSize.width - 17)/2, MY2, 20, 10)];
    
}


- (void)reloadData{
    [self layoutSubviews];
    [self setNeedsDisplay];
}


@end
