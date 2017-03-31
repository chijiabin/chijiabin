//
//  Fonts.h
//  Ubate
//
//  Created by sunbin on 2017/1/23.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#ifndef Fonts_h
#define Fonts_h

/**
 *  项目 四种字体
 *
 *  "Adobe Heiti Std",  ==ADOBEHEITISTD-REGULAR.OTF 顶部底部
 *  "FZHei-B01S”,       ==方正黑体(登录页面)
 *  "NEW ACADEMY"       ==数字 UBATE――NEW.....
 *  "Microsoft YaHei"   ==其余黑体 微软雅黑mst..
 */

/**
 *  设置字体与字号
 *
 *  @param NAME     字体
 *  @param FONTSIZE 字号
 *
 *  @return 返回font
 */
#define FONT(NAME, FONTSIZE) [UIFont fontWithName:(NAME) size:(FONTSIZE)]


/**
 *  导航栏 字体
 *  1主页导航栏 文字与折扣数组NEW ACADEMY  2其他导航栏Adobe Heiti Std
 */
#define FONT_MAIN_BArTitleAttributes      FONT(@"NEW ACADEMY" ,38)
#define FONT_BarTitleAttributes           FONT(@"Adobe Heiti Std" ,19)


#define FONT_FONTMicrosoftYaHei(FONTSIZE) FONT(@"Microsoft YaHei" ,FONTSIZE)
#define FONT_FONTNEWACDEMY(FONTSIZE)      FONT(@"NEW ACADEMY" ,FONTSIZE)
#define FONT_FONTADOBEGEITI(FONTSIZE)     FONT(@"Adobe Heiti Std" ,FONTSIZE)




#endif /* Fonts_h */
