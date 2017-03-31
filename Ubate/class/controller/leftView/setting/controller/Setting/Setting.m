//
//  Setting.m
//  Ubate
//
//  Created by sunbin on 2017/2/5.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "Setting.h"
#import "ExitApp.h"
#import "AboutUsViewController.h"
#import "Messageswitch.h"
#import "LoadHtml.h"
#import "logOut.h"
@interface Setting ()<LCActionSheetDelegate>

@end

@implementation Setting

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

     self.title = NSLocalizedString(@"设置", @"Setting");
    
        
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *cellDefs = @[
                          @[NSLocalizedString(@"新消息提示", @"A new message"),
                            NSLocalizedString(@"关于我们"  , @"About us"),
                            NSLocalizedString(@"服务条款"  , @"Terms of service"),
                            NSLocalizedString(@"隐私政策", @"Privacy policy"),
                            NSLocalizedString(@"清除缓存"  , @"Clear the cache")],
                          @[NSLocalizedString(@"退出" , @"Log out")],
                          ];
    self.dataArray = [[NSMutableArray alloc] initWithArray:cellDefs];
    self.sepLineColor = [UIColor appSeparatorColor];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.separatorColor  = [UIColor appSeparatorColor];
    
    [self nh_reloadData];

}

- (NSInteger)nh_numberOfSections {
    return self.dataArray.count;
}


- (NSInteger)nh_numberOfRowsInSection:(NSInteger)section{
    NSArray *itemAry = [self.dataArray objectAtIndex:section];
    return  itemAry.count;
}

- (NHBaseTableViewCell *)nh_cellAtIndexPath:(NSIndexPath *)indexPath{
    // 1. 创建cell
    NHBaseTableViewCell *cell = [NHBaseTableViewCell cellWithTableView:self.tableView];
    // 2. 设置单元格数据
    NSArray *itemAry = [self.dataArray objectAtIndex:indexPath.section];
    cell.textLabel.text = [itemAry objectAtIndex:indexPath.item];

    if (indexPath.section == 0){
        if (indexPath.row != 0  && indexPath.row != 4)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            if (indexPath.row == 4) {
                //暂时不显示
            //NSString *size = [[CacheSize sharedCacheSize] cacheSize];
            // cell.detailTextLabel.text = size;
            }
        }
    }
    
    // 3. 返回cell
    return cell;

}

- (void)nh_didSelectCellAtIndexPath:(NSIndexPath *)indexPath cell:(NHBaseTableViewCell *)cell{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger section = indexPath.section;
    if (section == 0) {
        NSInteger row = indexPath.row;
        if (row !=4) {
            if (row >1) {
                LoadHtml *loadHtml = [[LoadHtml alloc] initWithNibName:@"LoadHtml" bundle:nil];
                
                loadHtml.loadType = Online;
                loadHtml.makeType =  row -2;
                
                //服务条款 2   隐私 3   makeType 0  1
                
                [self.navigationController pushViewController:loadHtml animated:YES];

                
            }else{
                NSArray *ctlAry = @[[[Messageswitch alloc] initWithStyle:UITableViewStyleGrouped],
                                    [[AboutUsViewController alloc] initWithStyle:UITableViewStyleGrouped],
                                    ];
                [self.navigationController pushViewController:ctlAry[row] animated:YES];
            }
            return;
        }else{
            [self clear];
            return;
        }
        
    }

    if (section == 1) {
        [self Logout];
        return;

    }

    
}


- (UIEdgeInsets)nh_sepEdgeInsetsAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (CGFloat)nh_cellheightAtIndexPath:(NSIndexPath *)indexPath {
    return ScaleHeight(50.f);
}


- (CGFloat)nh_sectionHeaderHeightAtSection:(NSInteger)section{
    return ScaleHeight(10.f);
}

- (CGFloat)nh_sectionFooterHeightAtSection:(NSInteger)section{
    if (section == 0) {
        return ScaleHeight(30.f);
    }else{
        return ScaleHeight(0.1f);
    }
}

// 清理缓存
- (void)clear{
    WEAKSELF;
    [NHUtils clear];
    [self.navigationController.view showLoading:@"正在清理缓存"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.navigationController.view hideHUD];
        [weakSelf.navigationController.view showSuccess:@"清理成功"];
        [weakSelf.tableView reloadData];
        NSLog(@"%@" ,[[CacheSize sharedCacheSize] cacheSize]);
    });
    
}


-(void)Logout{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定退出帐号" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionYES = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
         [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUT object:nil];
        //清除数据库  注销极光推送
        [[logOut sharedlogOut] logOutOperation];
    }];
    
    [alert addAction:actionYES];
    [alert addAction:actionNO];
    
    [self presentViewController:alert animated:YES completion:nil];

}

//
//// 退出
//- (void)logout{
//    NSArray *logoutType = @[NSLocalizedString(@"exit", @"Exit") ,NSLocalizedString(@"close", @"Close")];
//
//    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to write off?", @"Are you sure you want to write off?")
//                                                   buttonTitles:logoutType
//                                                 redButtonIndex:-1
//                                                       delegate:self];
//    [sheet show];
//    
//}
//
//#pragma mark - LCActionSheet 代理方法
//
//- (void)actionSheet:(LCActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 0) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUT object:nil];
//        return;
//    }
//    if (buttonIndex == 1) {
//        [[ExitApp sharedExitApp] exit];
//        return;
//
//    }
//    NSLog(@"> Clicked Index: %ld", (long)buttonIndex);
//}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
