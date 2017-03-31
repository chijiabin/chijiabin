//
//  WithdrawResults.m
//  Ubate
//
//  Created by sunbin on 2017/2/7.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "WithdrawResults.h"
#import "WithdrawResultsCell.h"
#import "WithdrawResultsConfirm.h"

#import "WithdrawResultsCell.h"
#import "WithdrawResultsConfirm.h"
#import "Rollout.h"

static NSString * WithdrawResultsIden    = @"WithdrawResults_Identifier";

static NSString * WithdrawResultsConfirmIden    = @"WithdrawResultsConfirm_Identifier";


@interface WithdrawResults ()<WithdrawResultsConfirmDelegate>

@end

@implementation WithdrawResults

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"申请提现";
    [self initView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (void)initView{
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]init];
    barBtn.enabled = NO;
    barBtn.title=@"";
    self.navigationItem.leftBarButtonItem = barBtn;
    [self rightBarItem];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WithdrawResultsCell" bundle:nil] forCellReuseIdentifier:WithdrawResultsIden];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WithdrawResultsConfirm" bundle:nil] forHeaderFooterViewReuseIdentifier:WithdrawResultsConfirmIden];
}



- (void)rightBarItem{
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"查看转出记录" style:UIBarButtonItemStylePlain target:self action:@selector(rightNavAction)];
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)rightNavAction{
    Rollout *rollout = [[Rollout alloc] initWithStyle:UITableViewStyleGrouped];
    rollout.title = @"转出详情";
    NSDictionary *params = @{
                             @"uid": @([YConfig getOwnID]),
                             @"list_id" : @([_withdraawID integerValue]),
                             @"mark":@(3),
                             @"sign":SIGN
                             };
    rollout.rolloutData =  params;
    [self.navigationController pushViewController:rollout animated:YES];
    
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WithdrawResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:WithdrawResultsIden forIndexPath:indexPath];
    [cell insertData:[NSString stringWithFormat:@"%@",_moneyValue]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    WithdrawResultsConfirm *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:WithdrawResultsConfirmIden];
    //预计到账时间
    footer.delegate = self;
    footer.incomeTime.text = [NSString stringWithFormat:@"预计%@到账",[NHUtils getDaysTime:3 afterDay:YES]];
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [SizeProportion SizeProportionWithHeight:250.f];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return [SizeProportion SizeProportionWithHeight:170.f];
}



- (void)withdrawlResultsConfirm:(UIButton *)btn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
