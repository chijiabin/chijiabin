//
//  AboutUsViewController.m
//  Ubate
//
//  Created by sunbin on 2016/11/27.
//  Copyright © 2016年 Quanli. All rights reserved.
//
#import <StoreKit/StoreKit.h>
#import "AboutUsViewController.h"
#import "AboutUsViewControllerHeader.h"

@interface AboutUsViewController ()<SKStoreProductViewControllerDelegate>
@property (nonatomic ,strong) NSArray *cellTextLabAry;
@end

@implementation AboutUsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"关于我们", @"About us");
    _cellTextLabAry = @[NSLocalizedString(@"去评分", @"To score") ,NSLocalizedString(@"系统通知", @"System informs")];
    
    self.view.backgroundColor = [UIColor py_colorWithHexString:@"f5f5f5"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor appSeparatorColor];
    
    
    [self layoutUI];
}

/**
 * 实例化一个SKStoreProductViewController类 -- 评分    用
 */
- (void)openAppWithIdentifier:(NSString *)appId {
    SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
    storeProductVC.delegate = self;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
    [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
        if (result) {
            [self presentViewController:storeProductVC animated:YES completion:nil];
        }
    }];

}

#pragma mark - SKStoreProductViewControllerDelegate 嵌入应用商店
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)storeProductVC {
    [storeProductVC dismissViewControllerAnimated:YES completion:^{
        
       // [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}



- (void)layoutUI{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AboutUsHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:AboutUsHeaderViewReuseIdentifier];

    
    [self.tableView registerNib:[UINib nibWithNibName:@"AboutUsFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:AboutUsFooterViewReuseIdentifier];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _cellTextLabAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * cellIdentifier = @"cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor themeColor];
    }
    if (indexPath.row != 2) {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.backgroundColor = [UIColor py_colorWithHexString:@"ffffff"];
    [cell.textLabel setFont:FONT_FONTMicrosoftYaHei(14.f)];
    cell.textLabel.text = _cellTextLabAry[indexPath.row];
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    AboutUsHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:AboutUsHeaderViewReuseIdentifier];
    headerView.backview.backgroundColor = [UIColor py_colorWithHexString:@"f5f5f5"];
    return headerView;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    AboutUsFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:AboutUsFooterViewReuseIdentifier];
    footerView.backviewfoot.backgroundColor = [UIColor py_colorWithHexString:@"f5f5f5"];
    footerView.Copylable.textColor = [UIColor py_colorWithHexString:@"#999999"];
    footerView.CLlable.textColor = [UIColor py_colorWithHexString:@"#999999"];
    return footerView;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 170.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.view.frame.size.height - 350;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //去评分
    if (indexPath.row == 0) {
       
        //上线后可以跳入
       [self openAppWithIdentifier:@"1151112198"];
        
       // [self.navigationController pushViewController:[UserFeedBackViewController new] animated:YES];
        //直接跳入app商店
        //   [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1104867082&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
        
    }if (indexPath.row == 1) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"暂无系统通知" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:actionYES];
        [alert addAction:actionNO];
        [self presentViewController:alert animated:YES completion:nil];

    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
