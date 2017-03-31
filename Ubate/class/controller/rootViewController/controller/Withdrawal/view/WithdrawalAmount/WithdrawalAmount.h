//
//  WithdrawalAmount.h
//  Ubate
//
//  Created by sunbin on 2016/12/1.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFilter.h"

@protocol WithdrawalAmountDelegate <NSObject>

- (void)onClickAllDrawalAmountBtn:(UIButton *)btn availableMoney:(NSString *)money showEnterTextfile:(UITextField *)file isSelect:(BOOL)select;


@end


typedef void(^enterMoney)(UITextField *file,NSString *limitMoney);


@interface WithdrawalAmount : UITableViewCell<TextFilterDelegate>
{
    TextFilter *filterMoney;
}
@property (nonatomic ,strong) enterMoney myBlock;
@property (nonatomic ,weak) id<WithdrawalAmountDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextField *txtMoney;

@property (weak, nonatomic) IBOutlet UILabel *availableMoney;


- (void)moneyValue:(NSString *)money;


@end
