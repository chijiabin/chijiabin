//
//  YHomeItemRoundCell.m
//  Ubate
//
//  Created by sunbin on 2016/11/27.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "YHomeItemRoundCell.h"
#import "CircleView.h"
#import "AccountMoneySingle.h"

@interface YHomeItemRoundCell()<LYCircleViewDelegate>
{
    CircleView *circle;
    
    /**
     *  累计返现数据源
     */
    
    NSArray * circleArray;
    /**
     *  定时器
     */
    NSTimer *countTimer;
    
    /**
     *  累加累减 默认为0
     */

    NSInteger index;
    
    /**
     *  积累点击的次数 判断选择哪个圆环
     */
    
    NSInteger times;
    /**
     *  网络获取数据源
     */
    
    NSDictionary * resultsDict;
    /**
     *  共享人数 消费返现
     */
    
    NSString *share_count;NSString *return_money;
    
    
    /**
     *  累计返现总和
     */
    
    CGFloat totalsum;
    
    
    /**
     *  加速到指定值 （消费 共享 取最小值）
     */
    CGFloat makeTospeed;
    
    
    
    
    AccountMoneySingle *accountMoneyManage;
    
    CGFloat shareMoney;  CGFloat returnMoney;
    
    /**
     *  累加次数限制
     */
    NSInteger addCount;
    
    CGFloat speed;
    
}

@end

@implementation YHomeItemRoundCell

- (void)awakeFromNib {
    [super awakeFromNib];
    accountMoneyManage = [AccountMoneySingle sharedAccountMoneySingle];
    [self circleView];
    /**
     *  接收通知=>返现转出完成操作刷新  发通知（获取可用返现）
     */
}


-(void)setDic:(NSDictionary *)dic
{
    circle.isShowCumulative = NO;
    [USER_DEFAULT removeObjectForKey:@"tapCount"];
    
    _dic = dic;
    
    //可用余额 提现现转出需要
    accountMoneyManage.dic = dic;
    __weak __typeof(&*self)weakSelf = self;
    
    [weakSelf sumMoney:_dic];
    
    /**
     *  获取数据resultsDict
     */
    
    if (resultsDict != nil) {
        return_money = [resultsDict objectForKey:@"share_money"];
        share_count = [resultsDict objectForKey:@"count"];
    }
    
    
    
}
- (void)circleView{
    
#pragma make 代码适配
    CGFloat height;
    if (Iphone4) {
        height = 190;

    }else if (Iphone5){
        height = 190;
    }else if (Iphone6){
        height = 265;
    }else{
        height = 284;
    }
    /**
     *  圆环对象实例化
     */
    
    circle = [[CircleView alloc]initWithFrame:CGRectMake(0, -10, SCREEN_WIDTH, height)];
    circle.isShowCumulative = NO;
    [USER_DEFAULT removeObjectForKey:@"tapCount"];
    
    circle.delegate = self;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(circle.bounds.size.width/2-circle.bounds.size.height / 4.5, circle.bounds.size.height/2-circle.bounds.size.height / 4.5, circle.bounds.size.height / 4.5*2, circle.bounds.size.height / 4.5*2)];
    view.backgroundColor = [UIColor clearColor];
    view.alpha = 0.2;
    [circle addSubview:view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick)];
    [view addGestureRecognizer:tap];
    
    [self addSubview:circle];
    
}

-(void)sumMoney:(NSDictionary*)results{
    
    resultsDict = results;
    
    CGFloat share_moneyMake;
    CGFloat return_moneyMake;
    
    index = 0;
    addCount = 20;
    /**
     * 可用 累计返现
     */
    circle.availableCashback = [results objectForKey:@"account_money"];
    circle.collect_money = [results objectForKey:@"collect_money"];
    
    /**
     * 圆环进度值以如下值作参照
     */
    share_moneyMake  = [IF_NULL_TO_STRING([results objectForKey:@"share_money"]) floatValue];
    return_moneyMake = [IF_NULL_TO_STRING([results objectForKey:@"return_money"]) floatValue];
    
    if (share_moneyMake == return_moneyMake) {
        if (share_moneyMake == 0) {
#pragma make 表示都为0==========================圆环不转
            
#pragma make 1.当都为0时操作
            shareMoney  = 0.000000;
            returnMoney = 0.000000;
            makeTospeed = 0.000000;
            speed       = 0.000000;
            
            totalsum = 2*shareMoney;
        }else{
            /**
             *  判断是小于1 还是大于1
             */

            if (share_moneyMake >= 1) {
#pragma make 2.当都为大于1时操作
                
                //获取值判断前面多少位整数
                NSString *str = [NSString stringWithFormat:@"%.7f" ,share_moneyMake];
                //获取整数位有多少位
                NSInteger lastInt = [[[str componentsSeparatedByString:@"."] firstObject] integerValue];
                NSString *leng =  [NSString stringWithFormat:@"%ld" ,(long)lastInt];
                
           //     NSLog(@"lastInt---%@" ,leng);
           //     NSLog(@"lastInt===%lu" ,(unsigned long)leng.length);
                
            //    NSLog(@"lastInt-=-=-=%f" ,share_moneyMake/pow(10, leng.length-1));
                
                shareMoney =  share_moneyMake/pow(10.0, leng.length-1);
                returnMoney = share_moneyMake/pow(10.0, leng.length-1);
                makeTospeed = share_moneyMake/pow(10.0, leng.length-1);
                speed = makeTospeed/addCount;//  浮点 = 浮点/整形
                
                
                totalsum = 2*shareMoney;
                
                
            //    NSLog(@"%@" ,@[@"0" ,[NSString stringWithFormat:@"%.6f",2*shareMoney]]);
            }else{
#pragma make 3当都为小于1时操作
                //转字符 获取个位数  这里当个位数值过
                NSString *str = [NSString stringWithFormat:@"%.7f" ,share_moneyMake];
                //注意当数据为0.001234 因此在转float 使数据不为0开头
                
                NSInteger lastInt = [[[str componentsSeparatedByString:@"."] lastObject] integerValue];
                
                NSString *leng =  [NSString stringWithFormat:@"%ld" ,(long)lastInt];
                
              //  NSLog(@"---%@" ,leng);
               // NSLog(@"===%lu" ,(unsigned long)leng.length);
                
             //   NSLog(@"%f" ,lastInt/pow(10, leng.length-1));
                
                shareMoney = lastInt/pow(10, leng.length-1);
                returnMoney = lastInt/pow(10, leng.length-1);
                makeTospeed = lastInt/pow(10, leng.length-1);
                speed = makeTospeed/addCount;//  浮点 = 浮点/整形
                
                totalsum = 2*shareMoney;

            }
        }
    }else{
        
        //不相等
        if (share_moneyMake > return_moneyMake) {
            //查看最大值是否小于1
#pragma make 4.当查看最大值是否小于时操作
            
            if (share_moneyMake >= 1) {
                
                //share_moneyMake 大于1
                //1.return_moneyMake小于1  2.return_moneyMake大于1
                if (return_moneyMake >= 1) {
                    //都大于1
#pragma make 4.1都大于1
                    
                    /**
                     *  获取最小值return
                     *  判断最小值整数多少位
                     *  两数值分别除多少位n*10的几次方 得到新值操作
                     *
                     *
                     */
                    
                    //转字符 获取个位数  这里当个位数值过
                    NSString *str = [NSString stringWithFormat:@"%.7f" ,return_moneyMake];
                    //整位数
                    NSInteger lastInt = [[[str componentsSeparatedByString:@"."] firstObject] integerValue];
                    //整位数个数
                    NSString *leng =  [NSString stringWithFormat:@"%ld" ,(long)lastInt];
                    
              //      NSLog(@"---%@" ,leng);
              //      NSLog(@"===%lu" ,(unsigned long)leng.length);
                    
              //      NSLog(@"整数位数多少个%f" ,lastInt/pow(10, leng.length-1));

                    
                    //获取新数据
                    shareMoney  =  share_moneyMake/pow(10.0, leng.length-1);
                    returnMoney = return_moneyMake/pow(10.0, leng.length-1);
                    makeTospeed = return_moneyMake/pow(10.0, leng.length-1);
                    speed = makeTospeed/addCount;
                    totalsum = returnMoney + shareMoney;
               //     NSLog(@"%@" ,@[@"0" ,[NSString stringWithFormat:@"%.6f",totalsum]]);

                }else{
                    //return_moneyMake <= 1 share_moneyMake >= 1
                    //注意这里 return_moneyMake是否为0
                    if (return_moneyMake == 0.0) {
#pragma make 4.2判断最小值是否为0
                        //获取新数据
                        shareMoney  =  share_moneyMake;
                        returnMoney =  return_moneyMake;
                        makeTospeed =  shareMoney;
                        
                        speed = makeTospeed/addCount;
                        totalsum = returnMoney + shareMoney;
                      //  NSLog(@"%@" ,@[@"0" ,[NSString stringWithFormat:@"%.6f",totalsum]]);
                        
                        
                    }else{
                        
                        
#pragma make 4.3return_moneyMake < 1 不为0  share_moneyMake >= 1
                        /** return_moneyMake < 1 不为0  share_moneyMake >= 1
                         *  获取最小值return
                         *  判断最小值整数多少位
                         *  两数值分别除多少位n*10的几次方 得到新值操作
                         *
                         *
                         */
                        //12   0.12 =0.120000 120000 7
                        //最小值转字符串
                        NSString *str = [NSString stringWithFormat:@"%.7f" ,return_moneyMake];
                        //最小值转数组 注意0.012  0.12
                        NSArray *Ary= [str componentsSeparatedByString:@"."];
                        //获取小数点后面字符串
                        NSString *lastStr =  [Ary lastObject];
                        //累乘
                        NSInteger N10 =  pow(10, lastStr.length -1);
                        //不管0.012  0.12 只管乘
                        //转变都为整数
                        CGFloat newReturn_moneyMake = return_moneyMake*N10;
                        
                        CGFloat newShare_moneyMake = share_moneyMake*N10;
                        
//                        NSLog(@"newReturn_moneyMake==%f" ,newReturn_moneyMake);
//                        NSLog(@"newShare_moneyMake==%f" ,newShare_moneyMake);
                        //在转数组 取
                        NSString *newReturnStr = [NSString stringWithFormat:@"%.7f" ,newReturn_moneyMake];
                        
                        
                        NSString *zhnegshuleng = [[newReturnStr componentsSeparatedByString:@"."] firstObject];
                        
                        shareMoney = newShare_moneyMake/pow(10, zhnegshuleng.length -1);
                        returnMoney = newReturn_moneyMake/pow(10, zhnegshuleng.length -1);
//                        NSLog(@"shareMoney==%f" ,shareMoney);
//                        NSLog(@"returnMoney==%f" ,returnMoney);
                        
                        makeTospeed = returnMoney;
                        speed = makeTospeed/addCount;
                        
                        totalsum = returnMoney + shareMoney;
                //        NSLog(@"%@" ,@[@"0" ,[NSString stringWithFormat:@"%.6f",totalsum]]);
                        
                    }
                    
                }
                
            }else{
                
                if (return_moneyMake == 0) {
                    //获取新数据
                    shareMoney  =  share_moneyMake;
                    returnMoney =  return_moneyMake;
                    makeTospeed =  shareMoney;
                    
                    speed = makeTospeed/addCount;
                    
                    
                    totalsum = returnMoney + shareMoney;
                    
                    
            //        NSLog(@"%@" ,@[@"0" ,[NSString stringWithFormat:@"%.6f",totalsum]]);
                    
                    
                }else{
#pragma make 5.share_moneyMake小于1 return_moneyMake也小于1
                    NSString *str = [NSString stringWithFormat:@"%.7f" ,return_moneyMake];
                    NSString *lastStr = [[str componentsSeparatedByString:@"."] lastObject];
                    
                    NSUInteger changdu = lastStr.length;
                    NSInteger NTen =  pow(10, changdu - 1);
                    
                    //获取新数据
                    shareMoney =  share_moneyMake*NTen;
                    returnMoney = return_moneyMake*NTen;
                    
                    makeTospeed = returnMoney;
                    speed = makeTospeed/addCount;
                    
                    totalsum = returnMoney + shareMoney;
                    
                    
                  //  NSLog(@"%@" ,@[@"0" ,[NSString stringWithFormat:@"%.6f",totalsum]]);
                }
            }
            
        }else{
            // share_moneyMake < return_moneyMake
            if (return_moneyMake >= 1) {
                if (share_moneyMake >= 1) {
                    //都大于0
                    //转字符 获取个位数  这里当个位数值过
                    NSString *str = [NSString stringWithFormat:@"%.7f" ,share_moneyMake];
                    
                    NSInteger lastInt = [[[str componentsSeparatedByString:@"."] firstObject] integerValue];
                    
                    NSString *leng =  [NSString stringWithFormat:@"%ld" ,(long)lastInt];
                    
//                    NSLog(@"---%@" ,leng);
//                    NSLog(@"===%lu" ,(unsigned long)leng.length);
//                    
//                    NSLog(@"整数位数多少个%f" ,lastInt/pow(10, leng.length-1));
                    
                    
                    //获取新数据
                    shareMoney  =  share_moneyMake/pow(10.0, leng.length-1);
                    returnMoney = return_moneyMake/pow(10.0, leng.length-1);
                    makeTospeed = share_moneyMake/pow(10.0, leng.length-1);
                    speed = makeTospeed/addCount;
                    
                    totalsum = returnMoney + shareMoney;
                    
                    
                //    NSLog(@"%@" ,@[@"0" ,[NSString stringWithFormat:@"%.6f",totalsum]]);
                    
                }else{
                    //return_moneyMake >= 1 share_moneyMake <= 1
                    
                    if (share_moneyMake == 0) {
                        //等于0
                        //获取新数据
                        shareMoney  =  share_moneyMake;
                        returnMoney =  return_moneyMake;
                        makeTospeed =  returnMoney;
                        
                        speed = makeTospeed/addCount;
                        
                        totalsum = returnMoney + shareMoney;
                        
                        
                   //     NSLog(@"%@" ,@[@"0" ,[NSString stringWithFormat:@"%.6f",totalsum]]);
                        
                    }else{
                        //小于0
                        //12   0.12 =0.120000 120000 7
                        //最小值转字符串
                        NSString *str = [NSString stringWithFormat:@"%.7f" ,share_moneyMake];
                        //最小值转数组 注意0.012  0.12
                        NSArray *Ary= [str componentsSeparatedByString:@"."];
                        //获取小数点后面字符串
                        NSString *lastStr =  [Ary lastObject];
                        //累乘
                        NSInteger N10 =  pow(10, lastStr.length -1);
                        
                        
                        //不管0.012  0.12 只管乘
                        //转变都为整数
                        CGFloat newReturn_moneyMake = return_moneyMake*N10;
                        
                        CGFloat newShare_moneyMake = share_moneyMake*N10;
                        
//                        NSLog(@"newReturn_moneyMake==%f" ,newReturn_moneyMake);
//                        NSLog(@"newShare_moneyMake==%f" ,newShare_moneyMake);
                        
                        
                        
                        //在转数组 取
                        NSString *newReturnStr = [NSString stringWithFormat:@"%.7f" ,newShare_moneyMake];
                        
                        
                        NSString *zhnegshuleng = [[newReturnStr componentsSeparatedByString:@"."] firstObject];
                        
                        shareMoney = newShare_moneyMake/pow(10, zhnegshuleng.length -1);
                        returnMoney = newReturn_moneyMake/pow(10, zhnegshuleng.length -1);
                        NSLog(@"shareMoney==%f" ,shareMoney);
                        NSLog(@"returnMoney==%f" ,returnMoney);
                        
                        makeTospeed = shareMoney;
                        
                        speed = makeTospeed/addCount;
                        
                        
                        totalsum = returnMoney + shareMoney;
                        
                        
                 //       NSLog(@"%@" ,@[@"0" ,[NSString stringWithFormat:@"%.6f",totalsum]]);

                    }
                }
                
            }else{
                
                if (share_moneyMake == 0) {
                    //等于0
                    //获取新数据
                    shareMoney  =  share_moneyMake;
                    returnMoney =  return_moneyMake;
                    makeTospeed =  returnMoney;
                    
                    speed = makeTospeed/addCount;
                    
                    
                    totalsum = returnMoney + shareMoney;
                    
                    
                //    NSLog(@"%@" ,@[@"0" ,[NSString stringWithFormat:@"%.6f",totalsum]]);

                    
                }else{
                    
                    //都小于1
                    //转字符 获取个位数  这里当个位数值过
                    NSString *str = [NSString stringWithFormat:@"%.7f" ,share_moneyMake];
                    NSString *lastStr = [[str componentsSeparatedByString:@"."] lastObject];
                    
                    NSUInteger changdu = lastStr.length;
                    
                    NSInteger NTen =  pow(10, changdu - 1);
                    
                    //获取新数据
                    shareMoney =  share_moneyMake*NTen;
                    returnMoney = return_moneyMake*NTen;
                    
                    makeTospeed = share_moneyMake;
                    speed = makeTospeed/addCount;
                    
                    totalsum = returnMoney + shareMoney;
                    
                    
                  //  NSLog(@"%@" ,@[@"0" ,[NSString stringWithFormat:@"%.6f",totalsum]]);
                }
            }
        }
    }
    
    if (makeTospeed == shareMoney) {
        circle.textStringOfCircle = @[@"共享返现", @"消费返现"];
    }else{
        circle.textStringOfCircle = @[@"消费返现", @"共享返现"];
    }
    circle.hexStringOfCircleColor = @[[UIColor clearColor],[UIColor clearColor]];
    
    
    circle.percentOfTheCircle = @[@"0" ,[NSString stringWithFormat:@"%.6f",[IF_NULL_TO_STRING([results objectForKey:@"collect_money"]) floatValue]]];
    
    NSLog(@"shareMoney=%f   returnMoney=%f makeTospeed=%f totalsum=%f" ,shareMoney ,returnMoney ,makeTospeed,totalsum);
    
    [circle reloadData];
}

- (void)onClick {
    
    times = [USER_DEFAULT integerForKey:@"tapCount"];
    times++;
    [USER_DEFAULT setInteger:times forKey:@"tapCount"];
    
    [USER_DEFAULT synchronize];
    
    times = [USER_DEFAULT integerForKey:@"tapCount"];
    
    /**
     *  实例化定时器
     */
    [countTimer invalidate];
    countTimer = nil;
    
    countTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:countTimer forMode:NSRunLoopCommonModes];
    
}

-(void)timerAction{
    if (times%2 == 0) {
        //累减
        
        index--;
        circle.isShowCumulative = NO;
        
        [UIView animateWithDuration:0.05 animations:^{
            if (speed * (index+1) == 0) {
                [countTimer invalidate];
                countTimer = nil;
                
                if (totalsum == 0) {
                    circle.percentOfTheCircle = @[[NSString stringWithFormat:@"%d",(int)index] ,[NSString stringWithFormat:@"%.6f",0.00f]];
                    
                    //NSLog(@"有数据不会走进来");
                }
                
            }else{
                
                circle.percentOfTheCircle = @[[NSString stringWithFormat:@"%.6f",speed * index] ,[NSString stringWithFormat:@"%.6f",totalsum - speed * index]];
                
            }
            
        }];
        
        
    }else{
        //累加
        index++;
        [UIView animateWithDuration:0.05 animations:^{
            
            //目标值=index最终值为10   speed = makeTospeed/addCount
            
            NSString *m1 = [NSString stringWithFormat:@"%.6f" ,speed * (index-1)];
            NSString *m2 = [NSString stringWithFormat:@"%.6f" ,makeTospeed];
            if ([m1 isEqualToString:m2]) {
                [countTimer invalidate];
                countTimer = nil;
                circle.isShowCumulative = YES;
                
                
            }else{
                
//                NSLog(@"===%@" ,[NSString stringWithFormat:@"%.6f",speed * index]);
//                NSLog(@"----%@" ,[NSString stringWithFormat:@"%.6f",totalsum - speed * index]);
                
                circle.percentOfTheCircle = @[[NSString stringWithFormat:@"%.6f",speed * index] ,[NSString stringWithFormat:@"%.6f",totalsum - speed * index]];
            }
        }];
    }
    [circle reloadData];
    
}
/**
 *  显示人数
 */

- (NSString *)sharepresonCount{
    return [NSString stringWithFormat:@"%@\n共享人数" ,share_count];
}





@end
