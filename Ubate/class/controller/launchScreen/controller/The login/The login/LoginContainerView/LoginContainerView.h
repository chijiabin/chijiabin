//
//  LoginContainerView.h
//  Ubate
//
//  Created by sunbin on 2016/11/30.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoginContainerViewDelegate <NSObject>

- (void)navBtnIdex:(NSInteger)index;

@end

@interface LoginContainerView : BaseView

//手机号
@property (weak, nonatomic) IBOutlet UITextField *account;
//密码
@property (weak, nonatomic) IBOutlet BanPasteTextField *pwd;
//确认
@property (weak, nonatomic) IBOutlet UIButton *configBtn;

@property (nonatomic,copy) void (^loginHandler)(NSString *account,NSString *pwd);

@property (nonatomic, weak)id <LoginContainerViewDelegate>delegate;

+ (instancetype)LoginViewAccount:(NSString *)account;


@end
