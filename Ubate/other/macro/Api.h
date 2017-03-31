//
//  Api.h
//  Ubate
//
//  Created by sunbin on 2017/1/24.
//  Copyright © 2017年 Quanli. All rights reserved.

#ifndef Api_h
#define Api_h

#define scanAdress @"https://www.baidu.com"


/**
 *  开发手册：任何接口自带sign标签s
 */
#define SIGN @"10e1404c147c5f4b2a8a60b272d0fa93"
/**
 *  主机地址adress
 *  加载图片需拼接主机地址
 */
#define adress @"https://accounts.ubate.cn"


#define getInfo @"https://accounts.ubate.cn/home/api/getInfo"



/*******************************记录******************************/
/**
 *1.交易,返现,转出,退款记录
 *  uid  type  start  count
 *  type：不传时显示全部，1交易记录，2返现记录，3转出记录，4退款记录
 */
#define userMoneyLog @"https://accounts.ubate.cn/home/api/userMoneyLog"

/*******************************记录详情******************************/
/**
 *1.获取记录详情
 *  uid  id type
 *  type：不传时显示全部，1交易记录，2返现记录，3转出记录，4退款记录
 */
#define logDetail @"https://accounts.ubate.cn/home/api/logDetail"


/*******************************实名认证******************************/

/**
 *1.实名认证===插入数据库
 *  uid  realname idcard pwd  MD5加密后密码
 */
#define bindIdcard @"https://accounts.ubate.cn/home/api/bindIdcard"




/*******************************身份证实名认证******************************/

/**
 *1.身份证实名认证
 *  AppKey：258d7541ceffce25cc92c30d952b2aa6 应用APPKEY(应用详细页查询)
 *  idcard  身份证号码
 *  realname  姓名(需utf8编码的urlencode)
 *  idcardquery?key=您申请的
 KEY&idcard=420104198905015713&realname=%E7%8E%8B%E9%9D%9E%E5%90%9F
 */

#define idcardquery @"http://op.juhe.cn/idcard/query"
#define idcardquerykey @"258d7541ceffce25cc92c30d952b2aa6"


/*******************************绑定******************************/

/**
 *1.绑定支付宝，微信
 *  uid   account  type 0支付宝，1微信
 */
#define bindAccount @"https://accounts.ubate.cn/home/api/bindAccount"

/*******************************绑定银行******************************/
/**
 *1.绑定银行
 *  uid  bank（银行名称） bank_num（账户号码） type类型  info信息
 */
#define bindbank @"https://accounts.ubate.cn/home/api/bindbank"



/*******************************银行卡******************************/
/**
 *银行卡二元素检测
 *
 *Key：d47c61cf23b5752af95fc55f9086260d
 *bankcard  银行卡卡号
 *realname  姓名(需utf8编码的urlencode)
 */
#define verifybankcardquery @"http://v.juhe.cn/verifybankcard/query"
#define verifybankcardqueryKey @"d47c61cf23b5752af95fc55f9086260d"
/*******************************提现******************************/
/**
 *1.用户提现，提现状态处理中…
 *  uid  amount（格式为100.00必须精确到后两位，提现金额不能少于10.00元） type（提现方式1微信2银联 其它或为空时默认支付宝）
 */
#define appWithdraw @"https://accounts.ubate.cn/home/api/appWithdraw"

/*******************************忘记密码******************************/

/**
 *1.忘记密码(手机)(点下一步或发送短信)
 *  phone send(send=1发送短信)
 *
 *2.忘记密码(手机)确认）
 *  act  act=1  phone  scode验证码
 *
 *3.忘记密码(手机)（输入密码）
 *  phone  newpwd  pwd MD5加密后密码
 */
#define phoneResetPwd @"https://accounts.ubate.cn/home/api/phoneResetPwd"


/**
 *1.忘记密码(邮箱) (点下一步或发送邮件)
 *  email send  send=1发送短信
 *2.忘记密码(邮箱)(确认)
 *  act act=1  email  scode
 *
 *3.忘记密码(邮箱) (输入密码)
 *  email  pwd   newpwd  二次MD5加密后密码
 *
 */

#define emailResetPwd @"https://accounts.ubate.cn/home/api/emailResetPwd"


/*******************************上传头像******************************/

/**
 *1.上传头像
 *  uid
 */

#define headPic @"https://accounts.ubate.cn/home/api/headPic"

/*******************************编辑信息******************************/

/**
 *1.更改用户名
 *  uid  nickname
 *
 *2.修改性别
 *  uid  sex
 *
 *3.设置城市
 *  uid  province  city area
 */
#define editInfo @"https://accounts.ubate.cn/home/api/editInfo"

/*******************************修改密码******************************/
/**
 *1.修改密码
 *  uid  登陆用户UID password  newpass  二次MD5加密后密码
 *
 */
#define editPwd @"https://accounts.ubate.cn/home/api/editPwd"





/*******************************注册id******************************/

//注销极光ID
#define unRegistrationID @"https://accounts.ubate.cn/home/api/unRegistrationID"


#define LOGIN_JPUSH @ "https://accounts.ubate.cn/home/api/setRegistrationID"

//获取极光登陆注册ID
#define GET_JPUSH   @ "https://accounts.ubate.cn/home/api/getRegistrationID"


#define PrivacyPolicy @"https://ubate.cn/PrivacyPolicy.html"
#define UserTC @"https://ubate.cn/UserTC.html"


#define nearbyStore @"https://accounts.ubate.cn/home/api/nearbyStore"

/*******************************hotSearch******************************/
#define hotSearch @"https://accounts.ubate.cn/home/api/hotSearch"


/*******************************搜索******************************/
/**
 *1.搜索
 *  uid
 *  search  搜索字符（不能为空）
 *  lat     纬度
 *  lng     经度
 *  start   开始
 *  count   数量
 */
#define searchStore @"https://accounts.ubate.cn/home/api/searchStore"

/*******************************商店详情******************************/
/**
 *1.商店详情
 *  uid
 *  id  商店ID
 */
#define storeDetail @"https://accounts.ubate.cn/home/api/storeDetail"


/**
 *1.扫码成为下线
 *  mid被扫码
 *  uid
 */
#define scanCode @"https://accounts.ubate.cn/home/api/scanCode"



/*******************************圆环数据******************************/
/**
 *1.可用返现,累计返现,共享人数
 *  uid
 */
#define homeData @"https://accounts.ubate.cn/home/api/homeData"

/*******************************登录******************************/

/**
 *1.登录
 *  user_name(用户名（邮箱或手机）)  pwd(MD5加密后密码)
 */
#define userLogin @"https://accounts.ubate.cn/home/api/userLogin"




/**
 *1.手机注册（点下一步和重新发送短信）
 *  phone send(send=1发送短信)
 *
 *2.手机注册（验证验证码）
 *  phone  scode(手机验证码)  txtpwd(MD5加密后密码)
 */
#define phoneReg @"https://accounts.ubate.cn/home/api/phoneReg"




/*******************************注册******************************/

/**
 *1.邮箱注册 (点下一步）
 *  email  txtpwd(MD5加密后密码)  send (send=1发送邮件)
 *
 *2.邮箱注册（重新发送 密码找回）
 *  email  uid(点下一步后系统返回的mid)
 *
 *
 */

#define emailReg @"https://accounts.ubate.cn/home/api/emailReg"


/*******************************修改或绑定手机******************************/
/**
 *1.修改或绑定手机(点下一步和重新发送)
 *  uid  send
 *
 *2.修改或绑定手机(输入验证码点确定)
 *  scode  uid  nphone
 *
 */
#define editPhone @"https://accounts.ubate.cn/home/api/editPhone"



/*******************************修改或绑定邮箱******************************/
/**
 *1.修改或绑定邮箱(点下一步和重新发送)
 *  uid  send  nemail
 *
 *2.修改或绑定邮箱(输入验证码点确定)
 *  scode  uid  nemail inicode（系统code）
 */
#define editEmail @"https://accounts.ubate.cn/home/api/editEmail"

/*******************************文章******************************/

/**
 *1.文章（1使用说明 2服务条款）
 *  id   1使用说明 2服务条款 3隐私政策 4消费回赠 5回赠奖赏
 */
#define getArticle @"https://accounts.ubate.cn/home/api/getArticle?sign=4E05DED7978F9370EE937F52918862DCD234FCA8F52057B8F3A960925CA021C124403D78F1C0095CCE19A787D2457996867295EDBA54AF825A12F1C152BE8E5A&&id="


//10e1404c147c5f4b2a8a60b272d0fa93


//生成订单-支付宝
#define baofuCreateTrade @"https://accounts.ubate.cn/home/api/baofuCreateTrade"

//生成订单-微信
#define wechatCreateTrade @"https://accounts.ubate.cn/home/api/wechatCreateTrade"

/**
 * 1.uid
 * 2.email
   3.content   内容
 */
//我有意见
#define MyNews @"https://accounts.ubate.cn/home/api/addsuggestion"




#endif
