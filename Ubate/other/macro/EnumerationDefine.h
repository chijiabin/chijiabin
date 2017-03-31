//
//  EnumerationDefine.h
//  Ubate
//
//  Created by sunbin on 2017/1/23.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#ifndef EnumerationDefine_h
#define EnumerationDefine_h

typedef enum : NSUInteger {
    BingMethodNo   =  0,                    //没有绑定任何账号
    BingMethodAll  =  1,                    //都绑定
    BingMethodPart =  2,                    //部分绑定
    
} BingMethodMethod;

typedef enum : NSUInteger {
    BingPhone      =  0,                    //绑定手机号
    BingEmail      =  1,                    //绑定邮箱号
    FixPhoneNum    =  2,                    //修改手机号
    FixEmailAdress =  3,                    //修改邮箱号
} CheckPwType;

typedef NS_ENUM(NSInteger, cipherShow)  {   //添加省略方式
    ID_Card,
    Bank_Card,
    Iphone,
    RelaName,
    Email,
    PureDigital,
    Certification_ID
};


typedef NS_ENUM(NSInteger, hudShowTextPostion)  {   //位置
    centre,
    bottom
};


typedef NS_ENUM(NSInteger, responseState)  {       //请求返回状态

    Succeed,                                       //请求成功 成功状态
    Error  ,                                       //请求成功 错误状态
    Failure,                                       //请求失败 一般网络故障原因
};


typedef NS_ENUM(NSInteger, noDataORnoNet)  {      //占位显示无网络 无数据
    
    NOData,                                       //无数据
    NONet  ,                                      //无网络
};


typedef NS_ENUM(NSInteger, loadWebType)  {      //web内容数据源
    Local,                                       //本地
    Online  ,                                    //在线
};






#endif /* EnumerationDefine_h */
