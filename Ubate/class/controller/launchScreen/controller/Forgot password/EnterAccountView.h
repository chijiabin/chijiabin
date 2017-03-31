//
//  EnterAccountView.h
//  Ubate
//
//  Created by sunbin on 2016/12/12.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "BaseView.h"

@protocol EnterAccountViewDelegate <NSObject>

- (void)navBtnIdex;


@end

@interface EnterAccountView : BaseView
@property (nonatomic, weak)id <EnterAccountViewDelegate>delegate;

@property (nonatomic,copy) void (^enterAccountHandler)(NSInteger accountType ,NSDictionary *dic ,NSString *requestUrl);


+ (instancetype)LoadEnterAccountView;

@end
