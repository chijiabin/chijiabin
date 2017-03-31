//
//  NearShopTabBarController.m
//  Ubate
//
//  Created by sunbin on 2017/2/8.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "NearShopTabBarController.h"
#import "HotSearchModel.h"
#import "ShopForDetails.h"
#import "PYSearchViewController.h"
#import "SearchStoreModelData.h"

@interface NearShopTabBarController ()<PYSearchViewControllerDelegate,UITabBarControllerDelegate>
@property (nonatomic ,strong) NSMutableArray *HotAry;
@property (strong, nonatomic) ShopForDetails *shopDetail;
@property (nonatomic, strong) NSDictionary *data;
@end

@implementation NearShopTabBarController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.delegate = self;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.title = @"附近商家";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchoperations)];

}

#pragma make 右侧搜索栏
- (void)searchoperations{
    //热门搜索
    _HotAry = [NSMutableArray array];
    
    NSDictionary *params = @{@"uid":@([YConfig getOwnID]) ,@"sign":SIGN };
    WEAKSELF;

    [self requestWithUrl:hotSearch params:params isCache:YES showHUD:NO myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg) {
        weakSelf.HotAry = [HotSearchModel mj_objectArrayWithKeyValuesArray:[responseResults objectForKey:@"data"]];
        [weakSelf searchViewController];
    }];
}


- (void)searchViewController{
    WEAKSELF;
    _shopDetail = [[ShopForDetails alloc] initWithStyle:UITableViewStyleGrouped];
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:_HotAry searchBarPlaceholder:@"请输入商家或商店名称" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText ,NSString *store_id) {
        weakSelf.shopDetail.store_id = store_id;
        [searchViewController.navigationController pushViewController:weakSelf.shopDetail animated:YES];
        
    }];

    searchViewController.hotSearchStyle = PYHotSearchStyleARCBorderTag;
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
    
    searchViewController.delegate = weakSelf;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    
    [weakSelf presentViewController:nav  animated:NO completion:nil];
    
}
#pragma mark - PYSearchViewControllerDelegate 搜索时数据显示
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    [self searchViewController:searchViewController searchText:searchText];
}
#pragma make 搜索内容请求在这里

- (void)searchViewController:(PYSearchViewController *)searchViewController searchText:(NSString *)searchText{
    searchViewController.searchSuggestions = nil;
    if (searchText.length) {
        
        [kAppDelegate getlocation:^(CLLocation *location, CLPlacemark *placeMark, NSString *error) {
            CLLocationDegrees lat = location.coordinate.latitude;
            CLLocationDegrees lon = location.coordinate.longitude;
            
            NSDictionary *dic =  @{
                                   @"uid"   : @([YConfig getOwnID]),
                                   @"search": [NSString stringWithFormat:@"%@",searchText],
                                   @"lat"  :[NSString stringWithFormat:@"%f",lat],
                                   @"lng"  :[NSString stringWithFormat:@"%f",lon],
                                   @"start"  : @"0",
                                   @"count"  : @"10",
                                   @"sign":[YConfig getSign]
                                   
                                   };
            [self requestWithUrl:searchStore params:dic isCache:NO showHUD:NO myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg)
             {
                 if (state == Succeed) {
                     
                     
                     NSArray *dataAry = [responseResults objectForKey:@"data"];
                     searchViewController.searchSuggestions = [SearchStoreModelData mj_objectArrayWithKeyValuesArray:dataAry];
                 }
                 
                 
                 if (state == Error) {
                 }
                 if (state == Failure) {
                 }
             }];
        }];
    }else{
    }
}

- (void)searchViewController:(PYSearchViewController *)searchViewController didSearchWithsearchBar:(UISearchBar *)searchBar searchText:(NSString *)searchText storeID:(NSString *)store_id{
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{

    //刷新
    
    
}


@end
