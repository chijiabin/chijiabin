//
//  NewMessageTool.m
//  Ubate
//
//  Created by sunbin on 2017/1/25.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "NewMessageTool.h"
#import "NewMessageModel.h"
@implementation NewMessageTool

+ (void)newMessageTool:(BQLDBTool *)tool insertData:(NSString *)record_id money:(NSString *)money type:(NSString *)type add_time:(NSString *)add_time isRead:(NSString *)isRead issuccessful:(NSString *)issuccessful{
    // 保证唯一标示的学生id不能为空(其实姓名这种理应也不应为空,只是唯一标识是绝对不能为空的)
    if(!checkObjectNotNull(record_id)) {
        NSLog(@"id不能为空");
        return;
    }
   
    
    NSDictionary *dic =  @{@"tradingid"   :record_id,
                           @"money"       :checkObjectNotNull(money)?money:@"",
                           @"time"        :checkObjectNotNull(add_time)?add_time:@"",
                           @"newmessage"  :checkObjectNotNull(type)?type:@"",
                           @"isread"      :checkObjectNotNull(isRead)?isRead:@"",
                           @"issuccessful":checkObjectNotNull(issuccessful)?issuccessful:@""
                           };

    NewMessageModel *model = [NewMessageModel modelWithDictionary:dic];
    if([tool insertDataWith:NewMessageFile Model:model]) {
        NSLog(@"插入成功");
    }
    else {
        NSLog(@"插入失败");
    }
}
@end
