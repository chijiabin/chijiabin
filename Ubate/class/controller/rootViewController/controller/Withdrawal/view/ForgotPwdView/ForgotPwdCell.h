//
//  ForgotPwdCell.h
//  Ubate
//
//  Created by sunbin on 2016/12/5.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ForgotPwdCellDelegate <NSObject>

- (void)requestResults :(NSString *)results responsestate:(BOOL)state;

- (void)listEnter:(NSString *)str;


@end

@interface ForgotPwdCell : UITableViewCell

@property (nonatomic, weak) id<ForgotPwdCellDelegate> delegate;

- (void)finfType:(NSString *)type parms:(NSDictionary *)parms urlWithStr:(NSString *)requestWithUrl makeIden:(NSInteger)make;
@end
