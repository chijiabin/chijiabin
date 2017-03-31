//
//  SwipableViewController.m
//  Youxian
//
//  Created by sunbin on 16/10/3.
//  Copyright © 2016年 sunbin. All rights reserved.
//

#import "SwipableViewController.h"
#import "SwipableViewControllerHeader.h"

@interface SwipableViewController ()<FJSlidingControllerDataSource,FJSlidingControllerDelegate>

@property (nonatomic, strong)NSArray *titles;

@property (nonatomic, strong)NSMutableArray *controllers;

@property (nonatomic ,strong) NSDictionary  *respondData;
@property (nonatomic ,strong) NSString      *status;
@end

@implementation SwipableViewController
{

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self swipableView];
    [self notificationCenter];

}

- (void)loadData{

}

- (void)notificationCenter{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tzAction:) name:RECORDSELECTINDEX object:nil];
}

- (void)swipableView{

    self.datasouce   = self;
    self.delegate    = self;
    self.titles      = @[NSLocalizedString(@"全部"        , @"All"),
                         NSLocalizedString(@"消费", @"Consumption"),
                         NSLocalizedString(@"返现"     , @"Return"),
                         NSLocalizedString(@"转出" , @"Withdrawal")];
    self.controllers = [[NSMutableArray alloc] init];
    for (int i = 0; i < _titles.count; i++)
    {
        Record *record = [[Record alloc] initWithStyle:UITableViewStylePlain];
        if (i == 0) {
            record.index = i;
        }
        [self.controllers addObject:record];
        [self addChildViewController:record];
    }
    self.title = @"记录";
    [self reloadData];
}


- (void)tzAction:(NSNotification *)sender
{
    NSString *mark = IF_NULL_TO_STRING( [sender.userInfo objectForKey:@"mark"]);
    
    if ([mark isEqualToString:@"1"] || [mark isEqualToString:@"2"]){
        ConsumptionReturn *consumptionAndTotally =  [[ConsumptionReturn alloc] initWithStyle:UITableViewStyleGrouped];
        consumptionAndTotally.consumptionReturnData = sender.userInfo;
        
        if([mark isEqualToString:@"1"]){
            consumptionAndTotally.title = NSLocalizedString(@"消费详情", @"Transaction details");
        }else{
            NSString *type = IF_NULL_TO_STRING([sender.userInfo objectForKey:@"type"]);
            consumptionAndTotally.title = [@[
                                             NSLocalizedString(@"消费返现详情", @"Consumption cashback"),
                                             NSLocalizedString(@"共享返现", @"Shared cashback")] objectAtIndex:[type integerValue]];
        }
        [self.navigationController pushViewController:consumptionAndTotally animated:YES];
        
    }else{
        //返现转出
        Rollout *rollout = [[Rollout alloc] initWithStyle:UITableViewStyleGrouped];
        rollout.title = NSLocalizedString(@"转出详情", @"Withdrawal details");
        rollout.rolloutData =  sender.userInfo;
        [self.navigationController pushViewController:rollout animated:YES];
        
    }
}


#pragma mark dataSouce
- (NSInteger)numberOfPageInFJSlidingController:(FJSlidingController *)fjSlidingController{
    return self.titles.count;
}
- (UIViewController *)fjSlidingController:(FJSlidingController *)fjSlidingController controllerAtIndex:(NSInteger)index{
    return self.controllers[index];
}
- (NSString *)fjSlidingController:(FJSlidingController *)fjSlidingController titleAtIndex:(NSInteger)index{
    return self.titles[index];
}
#pragma mark delegate
- (void)fjSlidingController:(FJSlidingController *)fjSlidingController selectedIndex:(NSInteger)index{
    //self.title = [self.titles objectAtIndex:index];
    Record *record = self.controllers[index];
    record.index = index;
}
- (void)fjSlidingController:(FJSlidingController *)fjSlidingController selectedController:(UIViewController *)controller{
}
- (void)fjSlidingController:(FJSlidingController *)fjSlidingController selectedTitle:(NSString *)title{
}
-(void)dealloc{
    NSLog(@"!dealloc!");
}


- (UIColor *)lineColorInFJSlidingController:(FJSlidingController *)fjSlidingController{
    return [UIColor clearColor];
}


- (CGFloat)titleFontInFJSlidingController:(FJSlidingController *)fjSlidingController{
    return 14;
}

- (void)noNetwork{
    
}

- (void)reconnectNet{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}







@end
