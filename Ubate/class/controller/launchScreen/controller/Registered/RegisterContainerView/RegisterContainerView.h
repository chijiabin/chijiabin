//
//  RegisterContainerView.h
//  Ubate
//
//  Created by sunbin on 2016/12/20.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "BaseView.h"

typedef enum : NSUInteger {
    RegisterPhone   =  0,
    Registeremail   =  1,
    
} RegisterMethod;

@protocol RegisterContainerViewDelegate <NSObject>

- (void)terms:(NSInteger)termsMake;
- (void)navBtnIdex:(NSInteger)index;

@end

@interface RegisterContainerView : BaseView

@property (nonatomic, weak)id <RegisterContainerViewDelegate>delegate;


@property (weak, nonatomic) IBOutlet UITextField *account;

@property (weak, nonatomic) IBOutlet BanPasteTextField *pwd;
@property (nonatomic,copy) void (^registerHandler)(NSString *account,NSString *pwd);

@property (weak, nonatomic) IBOutlet UIButton *configBtn;

+ (instancetype)RegisterView:(RegisterMethod)method;

@end
