//
//  YArea.m
//  Ubate
//
//  Created by sunbin on 2016/12/15.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "YArea.h"
#import "MemberTableViewController.h"
@interface YArea ()
@property (nonatomic ,strong) NSMutableArray *cellData;

@end

@implementation YArea

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData]; [self initView];
}

- (void)loadData{
    _cellData = [[NSMutableArray alloc] init];
    for (NSString *area in _AreaAry) {
        if ([area isEqualToString:_userInfor.area]) {
            [_cellData insertObject:area atIndex:0];
        }else{
            [_cellData addObject:area];
        }
    }
}

- (void)initView{
    self.tableView.separatorColor = [UIColor py_colorWithHexString:@"#cccccc"];

    self.tableView.tableFooterView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];

    self.tableView.backgroundColor = [UIColor themeColor];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        [cell.textLabel setTextColor:[UIColor py_colorWithHexString:@"333333"]];
        [cell.textLabel setFont:FONT_FONTMicrosoftYaHei(14.f)];
    }
    
    cell.textLabel.text  = [_cellData objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor appCellColor];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MemberTableViewController*memberViewController;
    
    for (UIViewController *ctl in self.navigationController.viewControllers) {
        if ([ctl isKindOfClass:[MemberTableViewController class]]) {
            memberViewController = (MemberTableViewController*)ctl;
        }}

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *params = @{@"uid":@([YConfig getOwnID]),
                             @"province":self.province ,
                             @"city":self.title,
                             @"area":selectCell.textLabel.text,
                             @"sign":[YConfig getSign]};
    
    WEAKSELF;
    if ([_userInfor.area isEqualToString:selectCell.textLabel.text]) {
        [self.navigationController popToViewController:memberViewController animated:YES];
        
        
    }else{
        [YNetworking postRequestWithUrl:editInfo params:params cache:NO successBlock:^(id returnData, int code, NSString *msg) {
            if (code == 1) {
                _userInfor.province = self.province;
                _userInfor.city = self.title;
                _userInfor.area = selectCell.textLabel.text;
                kAppDelegate.userInfo = _userInfor;
                [weakSelf.navigationController popToViewController:memberViewController animated:YES];
            }else if(code == 201){
                
                [self.view showSuccess:@"登录过期，请重新登录"];
                
                dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
                dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                    [YConfig outlog];
                });
                
            }else if(code == 202){
                
                [self.view showSuccess:@"您的帐号在另一处登录，请重新登录"];
                
                dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
                dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                    [YConfig outlog];
                });
                
            }

            else{
                NSLog(@"错误%@" ,msg);
                [weakSelf.view showError:msg];

            }
        } failureBlock:^(NSError *error) {
            [weakSelf.view showError:error.localizedDescription];

        } showHUD:YES];
    }
}




//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"全部";
//}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [SizeProportion SizeProportionWithHeight:20.f];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SizeProportion SizeProportionWithHeight:45.f];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
