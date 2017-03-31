//
//  NewMessage.m
//  Ubate
//
//  Created by sunbin on 2017/1/25.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "NewMessage.h"
#import "NewMessageCell.h"
#import "Rollout.h"
#import "ConsumptionReturn.h"


@interface NewMessage ()
@property (weak, nonatomic) IBOutlet UITableView *messageRecord;
@property (nonatomic ,strong) NSArray *ary;

@end

@implementation NewMessage
{
    BQLDBTool *tool;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"新消息", @"The new message");

    [self loadData];
    [self.messageRecord reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NHUtils tableViewProperty:_messageRecord registerNib:@"NewMessageCell" forCellReuseIdentifier:@"NewMessageCellIdentifier"];
    
    self.hudRect = SCREEN_RECT;
    WEAKSELF;
    [weakSelf activityLoad];
    [self.hudView setJHUDReloadButtonClickedBlock:^() {
        [weakSelf activityLoad];
    }];
}

- (void)activityLoad{
    self.hudView.messageLabel.text = NSLocalizedString(@"加载中", @"Being loaded data");
    self.hudView.indicatorForegroundColor = kRGBColor(60, 139, 246);
    self.hudView.indicatorBackGroundColor = [UIColor clearColor];
   
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCircleJoin];

    //JHUD消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(disafter * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JHUD hideForView:self.view];
        [self loadData];
    });
}

- (void)loadData{

    tool = [BQLDBTool instantiateTool];
    _ary = [NHUtils flashbackAry:[tool queryDataWith:NewMessageFile]];
    if (_ary.count != 0) {
        for(NSDictionary *dic in _ary) {
            NSLog(@"%@" ,changeToTextWithDictionary(dic));
        }
        [JHUD hideForView:self.view];
        [self.messageRecord reloadData];
    }else{
        //无数据
        [self failure:NOData indicatorViewSize: CGSizeMake(76, 57) messageLabel:NSLocalizedString(@"暂时没有任何新消息", @"Currently no received any consumption record") customImageName:@"kong-1"];
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _ary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewMessageCellIdentifier" forIndexPath:indexPath];
   NSDictionary *dic = (NSDictionary *)[_ary objectAtIndex:indexPath.row];
    [cell newMessageData:dic];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    NSDictionary *dic = (NSDictionary *)[_ary objectAtIndex:indexPath.row];
    NSString *isread = [dic objectForKey:@"isread"];
    //当未查看消息才修改更新
    if ([isread isEqualToString:@"1"]) {
        NSString *identifier = [dic objectForKey:@"tradingid"];
        [self updateIsread:identifier];
    }
    

    //newmessageMake 1消费返现  2共赏返现  3提现
    NSInteger newmessageMake = [IF_NULL_TO_STRING([dic objectForKey:@"newmessage"]) integerValue];

    NSString *tradingid = [dic objectForKey:@"tradingid"];

    if (newmessageMake != 3) {
        ConsumptionReturn *consumptionReturn = [[ConsumptionReturn alloc] initWithStyle:UITableViewStyleGrouped];
        consumptionReturn.consumptionReturnData = @{@"list_id":tradingid ,@"mark":@"2" ,@"type":[NSString stringWithFormat:@"%ld" ,newmessageMake-1]};
        
      consumptionReturn.title =newmessageMake == 1?NSLocalizedString(@"消费返现",@"Consumption cashback"):NSLocalizedString(@"共享返现",@"Shared cashback");
        [self.navigationController pushViewController:consumptionReturn animated:YES];
    }else{
        
        Rollout *rollout = [[Rollout alloc] initWithStyle:UITableViewStyleGrouped];
        rollout.title = NSLocalizedString(@"返现转出详情", @"Withdrawal details");
        rollout.rolloutData = @{@"list_id":tradingid ,@"mark":@"3"};
        [self.navigationController pushViewController:rollout animated:YES];
    }
    
    
}


- (void)updateIsread:(NSString *)IdentifierValue{
    if ([tool modifyDataWith:NewMessageFile Key:@"isread" Value:@"0" Identifier:@"tradingid" IdentifierValue:IdentifierValue]) {
        NSLog(@"修改成功");
    }else{
        NSLog(@"修改失败");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScaleHeight(60.f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ScaleHeight(8.f);

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return ScaleHeight(0.f);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
