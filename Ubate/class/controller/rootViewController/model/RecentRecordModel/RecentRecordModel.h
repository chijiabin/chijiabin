//
//  RecentRecordModel.h
//  Ubate
//
//  Created by sunbin on 2017/2/5.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentRecordModel : NSObject
/*
 *交易id
 */

@property (nonatomic, copy) NSString *list_id;
/*
 *
 */

@property (nonatomic, copy) NSString *recordid;
/*
 *用户id
 */

@property (nonatomic, copy) NSString *uid;
/*
 *交易时间 时间戳
 */

@property (nonatomic, copy) NSString *add_time;
/*
 *交易时间
 */

@property (nonatomic, copy) NSString *timer;
/*
 *交易金额
 */

@property (nonatomic, copy) NSString *money;
/*
 *是否删除
 */

@property (nonatomic, copy) NSString *is_hidden;
/*
 *mark标识符
 */

@property (nonatomic, copy) NSString *mark;
/*
 *交易状态
 */

@property (nonatomic, copy) NSString *status;
/*
 *名字
 */

@property (nonatomic, copy) NSString *name;
/*
 *交易类型
 */

@property (nonatomic, copy) NSString *type;
/*
 *交易状态详情
 */

@property (nonatomic, copy) NSString *status_info;



@end
