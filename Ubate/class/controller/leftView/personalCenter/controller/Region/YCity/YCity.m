//
//  YCity.m
//  Ubate
//
//  Created by sunbin on 2016/12/15.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "YCity.h"
#import "YArea.h"

#import "MemberTableViewController.h"

@interface YCity ()
@property (nonatomic ,strong) NSMutableArray *cellData;
@property (nonatomic ,strong) YUserInfo *userInfor;

@end

@implementation YCity

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData]; [self initView];

}

- (void)loadData{
    _userInfor = [YConfig myProfile];
    

    _cellData = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in _citiesAry) {
        NSString *nextStep;
        NSArray *areasDic = [dic objectForKey:@"areas"];
        if ([ [NSString stringWithFormat:@"%@" ,@(areasDic.count)] isEqualToString:@"0"]) {
            nextStep = _userInfor.area;
        }else{
            nextStep = _userInfor.city;
        }
        
        if ([[dic objectForKey:@"city"] isEqualToString:nextStep]) {
            //若与当前位置相同放置最顶部
            [_cellData insertObject:dic atIndex:0];
        }else{
            [_cellData addObject:dic];
        }}

}

- (void)initView{
    self.tableView.separatorColor = [UIColor py_colorWithHexString:@"#cccccc"];

    self.tableView.tableFooterView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    
    self.tableView.backgroundColor = [UIColor themeColor];

}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSDictionary *dic = [_cellData objectAtIndex:indexPath.row];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        
        [cell.textLabel setTextColor:[UIColor py_colorWithHexString:@"333333"]];
        [cell.textLabel setFont:FONT_FONTMicrosoftYaHei(14.f)];
        NSArray *areasDic = [dic objectForKey:@"areas"];
        //判断是否直辖市
        if ([ [NSString stringWithFormat:@"%@" ,@(areasDic.count)] isEqualToString:@"0"]) {
            cell.accessoryType = UITableViewCellAccessoryNone;//是直辖市
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
    }
    cell.textLabel.text = [dic objectForKey:@"city"];
    cell.backgroundColor = [UIColor appCellColor];
    return cell;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary    *dic = [_cellData objectAtIndex:indexPath.row];
    NSMutableArray  *areasDic = [dic objectForKey:@"areas"];
    
    NSDictionary *params = @{@"uid":@([YConfig getOwnID]),
                             @"province":self.title ,
                             @"city":self.title,
                             @"area":selectCell.textLabel.text,
                             @"sign":[YConfig getSign]};
    
    if (areasDic.count == 0) {
#pragma make 直辖市
        MemberTableViewController*memberViewController;
        for (UIViewController * cont in self.navigationController.viewControllers) {
            if ([cont isKindOfClass:[MemberTableViewController class]]) {
                memberViewController =(MemberTableViewController *) cont;
                break;
            }
        }
        
        if ([_userInfor.area isEqualToString:[params objectForKey:@"area"]]) {
            [self.navigationController popToViewController:memberViewController animated:true];
        }else{
            
            WEAKSELF;
            [YNetworking postRequestWithUrl:editInfo params:params cache:YES successBlock:^(id returnData, int code, NSString *msg) {
                if (code == 1) {
                    
                    weakSelf.userInfor.province = self.title;
                    weakSelf.userInfor.city = self.title;
                    weakSelf.userInfor.area = selectCell.textLabel.text;
                    kAppDelegate.userInfo = _userInfor;
                    
                    [self.navigationController popToViewController:memberViewController animated:true];
                    return ;
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
        
        
    }else{
        
        YArea *are = [[YArea alloc] initWithStyle:UITableViewStylePlain];
        are.AreaAry = areasDic;
        are.userInfor = _userInfor;
        are.province = self.title;
        are.title =[dic objectForKey:@"city"];
        [self.navigationController pushViewController:are animated:YES];
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
