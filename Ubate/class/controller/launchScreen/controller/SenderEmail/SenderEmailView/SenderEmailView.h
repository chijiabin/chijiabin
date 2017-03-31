//
//  SenderEmailView.h
//  Ubate
//
//  Created by sunbin on 2016/12/13.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "BaseView.h"
@protocol SenderEmailViewDelegate <NSObject>

- (void)navBtnIdex:(NSInteger)idex;

@end

@interface SenderEmailView : BaseView
@property (nonatomic, weak)id <SenderEmailViewDelegate>delegate;

+ (instancetype)loadSendEmailAdress:(NSString *)Eadress;
@end
