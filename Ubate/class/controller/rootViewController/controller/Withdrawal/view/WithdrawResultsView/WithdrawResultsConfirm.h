//
//  WithdrawResultsConfirm.h
//  Ubate
//
//  Created by sunbin on 2016/12/2.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WithdrawResultsConfirmDelegate <NSObject>

- (void)withdrawlResultsConfirm:(UIButton *)btn;

@end

@interface WithdrawResultsConfirm : UITableViewHeaderFooterView
@property (nonatomic, weak) id<WithdrawResultsConfirmDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *incomeTime;

@end
