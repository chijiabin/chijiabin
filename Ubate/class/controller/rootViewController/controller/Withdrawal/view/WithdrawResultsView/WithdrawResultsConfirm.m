//
//  WithdrawResultsConfirm.m
//  Ubate
//
//  Created by sunbin on 2016/12/2.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "WithdrawResultsConfirm.h"

@implementation WithdrawResultsConfirm

- (IBAction)confirmOnclick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(withdrawlResultsConfirm:)]) {
        [self.delegate withdrawlResultsConfirm:sender];
    }

}

@end
