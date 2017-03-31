//
//  NewMessageCell.m
//  Ubate
//
//  Created by sunbin on 2017/2/6.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "NewMessageCell.h"

@implementation NewMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)newMessageData:(NSDictionary *)dic{
    NSInteger newmessage  = [[dic objectForKey:@"newmessage"] integerValue];
    
    NSString *money       = [@"+" stringByAppendingString:[NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"money"]floatValue]]];
    
    NSString *time        = [dic objectForKey:@"time"];
    NSString *isread      = [dic objectForKey:@"isread"];
    NSString *issuccessful= [dic objectForKey:@"issuccessful"];


    // 标识符newmessage 如为1消费 2共享 3转出
    _name.text = @[NSLocalizedString(@"消费返现", @"Consumption cashback") ,
                   NSLocalizedString(@"共享返现", @"Shared cashback") ,
                   NSLocalizedString(@"返现转出", @"Withdrawal details")][newmessage-1];
    _time.text = time;
    WEAKSELF;
    
    if (newmessage == 3) {
        // 1代表成功  0代表失败
        weakSelf.infor.text = [issuccessful isEqualToString:@"0"]?NSLocalizedString(@"失败", @"failure"):NSLocalizedString(@"成功", @"successful");
    }else{
        _infor.text = money;
    }


//    _name.backgroundColor = [isread isEqualToString:@"0"]?[UIColor redColor]:[UIColor clearColor];
    
    
}

@end
