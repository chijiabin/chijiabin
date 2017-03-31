//
//  PayConfirmButton.h
//  Ubate
//
//  Created by sunbin on 2016/12/20.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayConfirmButtonDelegate <NSObject>

- (void)payType;
@end

@interface PayConfirmButton : UITableViewHeaderFooterView
@property (nonatomic ,weak) id<PayConfirmButtonDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *payBtn;


@end
