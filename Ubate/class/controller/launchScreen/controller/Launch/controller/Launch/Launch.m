//
//  Launch.m
//  Ubate
//
//  Created by sunbin on 2017/2/12.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "Launch.h"
#import "LaunchView.h"
#import "LoginController.h"
#import "RegisteredPhone.h"

@interface Launch ()<LaunchViewDelegate>

@end

@implementation Launch
{
    LaunchView *container ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
- (void)initView{
    container = [LaunchView loadLaunchView];
    container.frame = SCREEN_RECT;
    container.delegate = self;
    [self.view addSubview:container];
}

- (void)navBtnIdex:(NSInteger)index{
    
    [NHUtils presentViewController:@[@"RegisteredPhone" ,@"LoginController"][index-1] currentController:self modalTransitionStyle:UIModalTransitionStyleCrossDissolve];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
