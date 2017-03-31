//
//  WithdrawlConfirm.h
//  Ubate
//
//  Created by sunbin on 2016/12/1.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WithdrawlConfirmDelegate <NSObject>

- (void)withdrawlConfirm:(UIButton *)btn;

@end

@interface WithdrawlConfirm : UITableViewHeaderFooterView

@property (nonatomic, weak) id<WithdrawlConfirmDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;



@end
