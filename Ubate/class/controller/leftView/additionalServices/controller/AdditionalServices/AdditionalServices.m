//
//  AdditionalServices.m
//  Ubate
//
//  Created by sunbin on 2017/2/5.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "AdditionalServices.h"

@interface AdditionalServices ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *sv;
@property(nonatomic,strong)UIPageControl *pc;
@end

@implementation AdditionalServices
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // self.title = NSLocalizedString(@"会员尊享计划", @"Additional services");
    
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

}

- (void)viewWillDisappear:(BOOL)animated{
    
    //如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configScrllView];
    [self configPageControl];

//     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"请放置一张高度=44的透明图片"] forBarMetrics:UIBarMetricsDefault];
}


//设置下面的4个原点
-(void)configPageControl {
    self.pc = [[UIPageControl alloc]init];
    self.pc.frame = CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, 40);
    self.pc.numberOfPages = 6;
    self.pc.currentPage = 0;
    self.pc.pageIndicatorTintColor = [UIColor py_colorWithHexString:@"d9d9d9"];
    self.pc.currentPageIndicatorTintColor = [UIColor blackColor];
    self.pc.alpha = 0.6;
    self.pc.userInteractionEnabled = NO;
    
    [self.view addSubview:self.pc];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int currentPageNum = round(scrollView.contentOffset.x / scrollView.frame.size.width);
    self.pc.currentPage = currentPageNum;
}


-(void)configScrllView {
    
    self.sv = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.sv.delegate = self;
    self.sv.contentSize = CGSizeMake(6 * self.view.frame.size.width, self.view.frame.size.height-64);
    
    for (int i = 0; i < 6; i++) {
        NSString *imageName = [NSString stringWithFormat:@"0%d", i + 1];
        UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        iv.frame = CGRectMake(i * self.view.frame.size.width,-64, self.view.frame.size.width, self.view.frame.size.height);
        [self.sv addSubview:iv];
    }
    self.sv.pagingEnabled = YES;
    self.sv.bounces = NO;
    self.sv.showsHorizontalScrollIndicator = NO;

    [self.view addSubview:self.sv];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
