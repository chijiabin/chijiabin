//
//  WithdrawResultsCell.h
//  Ubate
//
//  Created by sunbin on 2016/12/1.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawResultsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *withdrawAmount;

- (void)insertData:(NSString *)str;

@end
