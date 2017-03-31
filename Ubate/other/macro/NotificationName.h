//
//  NotificationName.h
//  Ubate
//
//  Created by sunbin on 2017/1/23.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#ifndef NotificationName_h
#define NotificationName_h


/** 当前纬度*/

const static NSString *kNHUserCurrentLatitude = @"kNHUserCurrentLatitude";
/** 当前经度*/

const static NSString *kNHUserCurrentLongitude = @"kNHUserCurrentLongitude";
/** 是否登陆*/

const static NSString *kNHHasLoginFlag = @"kNHHasLoginFlag";
/** 网络请求成功*/

const static NSString *kNHRequestSuccessNotification = @"kNHRequestSuccessNotification";


const static NSString *SET_USERINFO = @"SET_USERINFO";

static NSString *RECORDSELECTINDEX = @"RecordSelectIndexNotification";


static NSString *LOGOUT = @"LOGOUTNotification";

static NSString *USERREFRESHEXIT = @"USERREFRESHEXIT";
//网络重启 
static NSString *RECONNECTNETWORK = @"RECONNECTNETWORK";

//无网络
static NSString *NONET = @"NONET";

static NSString *BIGCARDNUMSUSSECTION = @"BIGCARDNUMSUSSECTION";

static NSString *ENTERMONEY = @"ENTERMONEY";

static NSString *ALIPAYRELUT = @"ALIPAYRELUT";


static NSString *ALIPAYRETOMERCHANT = @"ALIPAYRETOMERCHANT";




static NSString *CHANGEBTNSTATE = @"CHANGEBTNSTATE";

static NSString *PAY_CHANGEBTNSTATE = @"PAY_CHANGEBTNSTATE";
//提现申请成功
static NSString *APPLYSUCCESSOFWITHDRAWALS = @"APPLYSUCCESSOFWITHDRAWALS";
//支付成功
static NSString *PAYSUCCESS = @"PAYSUCCESS";



#endif
