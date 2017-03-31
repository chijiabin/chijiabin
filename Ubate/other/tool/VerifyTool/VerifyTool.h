//
//  VerifyTool.h
//  Ubate
//
//  Created by sunbin on 2016/12/15.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerifyTool : NSObject

typedef NS_ENUM(NSInteger, VerifyFlag){
    
    VerifyFlagEmpty = 0,               //可以为空
    VerifyFlagUnEmpty,                 //不能为空
};

typedef NS_ENUM(NSInteger, VerifyType){
    
    VerifyTypeChinese = 0,               //只能为汉字
    VerifyTypeNum,                       //只能为数字
    VerifyTypeLetter,                    //只能为字母
    VerifyTypeNumAndLetter,              //只能为数字和字母
    VerifyTypeIncludeSpace,              //是否包含空格
    VerifyTypePhone,                     //手机号验证
    VerifyTypePassword,                  //密码验证 正确格式为：以字母开头，长度在6~18之间，只能包含字符、数字
    VerifyTpeEmail,                      //邮箱验证
    VerifyTypeCardID,                    //身份证号验证
    VerifyTypeBankCard,                  //银行卡号验证
    VerifyTypeCarNo,                     //车牌号验证
    
};

typedef NS_ENUM(NSInteger, VerifyTip){
    
    VerifyTipShow = 0,              //需要提示框
    VerifyTipHide,                  //不显示提示框
};
+(BOOL)check:(NSDictionary *)dict;

@end

