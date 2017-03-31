//
//  Rollout.m
//  Ubate
//
//  Created by sunbin on 2017/2/6.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "Rollout.h"
#import "RolloutHeaderFooterView.h"

static NSString * RolloutReuseIden= @"RolloutReuseIdentifier";

@interface Rollout ()
@property (nonatomic, strong) NSMutableArray *cellData;
@property (nonatomic ,strong) NSDictionary   *sourceData;
@property (nonatomic) JHUD *hudView;

@end

@implementation Rollout
{
    YUserInfo *userInfor;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    NSLog(@"%@" ,self.navigationController.viewControllers);
    [NHUtils pushAndPop:@"WithdrawResults" range:NSMakeRange(1, 2) currentCtl:self];
}

// 横竖屏适配的话，在此更新hudView的frame。
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat padding = 0;
    self.hudView.frame = CGRectMake(padding,
                                    padding,
                                    self.view.frame.size.width - padding*2,
                                    self.view.frame.size.height - padding*2);
}

- (NSMutableArray *)cellData{
    if (!_cellData) {
        _cellData = [[NSMutableArray alloc] init];
        return _cellData;
    }
    return _cellData;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    userInfor = [YConfig myProfile];
    self.hudView = [[JHUD alloc]initWithFrame:self.view.bounds];
    self.hudView.indicatorBackGroundColor = [UIColor clearColor];
    self.hudView.indicatorForegroundColor = kRGBAColor(60, 139, 246, .5);
    
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    WEAKSELF;
    //1先加载些数据 判断是否缓存
    [weakSelf loadData];//数据加载
    NSLog(@"sourceData=%@" ,_sourceData);
    
    if (_sourceData.count !=0) {
        //无需加载
        [weakSelf initView];
        
    }else{
        [weakSelf reload];
    }
    //点击刷新
    [self.hudView setJHUDReloadButtonClickedBlock:^() {
        NSLog(@"refreshButton");
        [weakSelf reload];
    }];

}
- (void)reload{
    WEAKSELF;
    //需加载
    //第一次请求  或无网络时显示
    //2无数据  需要加载
    self.hudView.messageLabel.text = NSLocalizedString(@"正在加载数据", @"Loading data");
    
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCircle];
    //自动消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(disafter * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JHUD hideForView:weakSelf.view];//自动消失
        [weakSelf initView];
        [weakSelf loadData];
    });
}
#pragma 熊猫闭眼  失败  按钮
- (void)failure
{
    self.hudView.indicatorViewSize = CGSizeMake(150, 150);
    self.hudView.messageLabel.text = NSLocalizedString(@"load.failed", @"Failed to get data, please try again later");
    [self.hudView.refreshButton setTitle:NSLocalizedString(@"refresh", @"Refresh?") forState:UIControlStateNormal];
    self.hudView.customImage = [UIImage imageNamed:@"tishi"];
    
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeFailure];
    
}

- (void)initView{
    

    self.tableView.backgroundColor = [UIColor py_colorWithHexString:@"f5f5f5"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RolloutHeaderFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:RolloutReuseIden];
}
- (void)loadData{
    
    NSString *list_id;     NSString *mark;
    
    if (_model) {
        list_id = _model.list_id;
        mark    = _model.mark;
    }else{
        list_id = [_rolloutData objectForKey:@"list_id"];
        mark    = [_rolloutData objectForKey:@"mark"];
        
    }
    NSDictionary *params = @{
                             @"uid":@([YConfig getOwnID]),
                             @"id": @([list_id integerValue]),
                             @"type":@([mark integerValue]),
                             @"sign":[YConfig getSign]
                             };
    
    WEAKSELF;
    [self requestData:params myBlock:^(BOOL state, NSDictionary *results, NSError *requestError) {
        if (state) {
            weakSelf.sourceData = [NSMutableDictionary dictionaryWithDictionary:results];
            [weakSelf.tableView reloadData];
        }else{
            NSLog(@"数据获取失败");
        }
    }];
}


- (void)requestData:(NSDictionary *)dic myBlock:(void (^)(BOOL state,NSDictionary * results,NSError * requestError))states{
    
    __block NSDictionary *respondDic;
    WEAKSELF;
    [YNetworking postRequestWithUrl:logDetail params:dic cache:YES successBlock:^(id returnData, int code, NSString *msg) {
        respondDic = (NSDictionary *)[returnData objectForKey:@"data"];
        if (code == 1) {
            states(YES,respondDic,nil);
            
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
            states(NO,nil,nil);
        }
    } failureBlock:^(NSError *error) {
        if (weakSelf.sourceData.count !=0) {
        }else{
            states(NO,nil,error);
            [self failure];
        }
        
    } showHUD:NO];
    
}

//status = 0;处理 1成功 2失败

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger status = [[_sourceData objectForKey:@"status"] integerValue];
    if (status == 2) {
        //处理  失败
        return 6;
    }else if(status == 0){
        //转出处理
        return 6;
    }else{
        
    //转出成功
        return 7;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellid = @"cellid";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
    }
    
    [cell.textLabel setFont:FONT_FONTMicrosoftYaHei(13.f)];
    [cell.detailTextLabel setFont:FONT_FONTMicrosoftYaHei(13.f)];
    [cell.textLabel setTextColor:[UIColor py_colorWithHexString:@"525252"]];
    [cell.detailTextLabel setTextColor:[UIColor py_colorWithHexString:@"808080"]];

    if (_sourceData !=0)
    {
        NSInteger status = [[_sourceData objectForKey:@"status"] integerValue];
        NSString *content;
     
        NSString *accountType;
        if ([[_sourceData objectForKey:@"type"] isEqualToString:@"0"]) {
            accountType = @"支付宝编号";
        }else if([[_sourceData objectForKey:@"type"] isEqualToString:@"1"]){
            accountType = @"微信编号";
        }else{
            accountType = @"银行编号";
        }
        
        NSString * in_mid = [_sourceData objectForKey:@"in_mid"];
        //转出成功
        if (status == 1)
        {
            cell.textLabel.text = @[@"转出至",@"实际到账",@"申请时间" ,@"到账时间" ,@"流水编号",accountType ,@"转出状态" ][indexPath.row];
            
            switch (indexPath.row) {
                case 0:{
                    
                    if ([[_sourceData objectForKey:@"type"] isEqualToString:@"0"]) {
                        content = [@"支付宝  " stringByAppendingString:[NSString stringWithFormat:@"%@",in_mid]];
                    }else if([[_sourceData objectForKey:@"type"] isEqualToString:@"1"]){
                        content = [@"微信  " stringByAppendingString:[NSString stringWithFormat:@"%@",in_mid]];
                    }else{
                        content = [@"银行卡  " stringByAppendingString:[NSString stringWithFormat:@"%@",in_mid]];

                    }
                }
                    break;
                case 1:content = [_sourceData objectForKey:@"real_money"];
                    break;
                case 2:content = [_sourceData objectForKey:@"timer"];
                    break;
                case 3:{
                    NSString *timer = [_sourceData objectForKey:@"deal_time"];
                    
                    NSTimeInterval time=[timer doubleValue];
                    
                    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    
                    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];

                    content = currentDateStr;
                    
                }
                    break;
                case 4:content = [_sourceData objectForKey:@"order"];
                    break;
                case 5:{content = [_sourceData objectForKey:@"no"];
                    break;
                case 6:content = @"转出成功";
                    break;
               
                default:
                    break;
                }}
        }
        
        //处理中
        if (status == 0) {
            

            cell.textLabel.text = @[@"转出至",@"实际到账",@"申请时间" ,@"预计到账时间" ,@"流水编号" ,@"转出状态" ][indexPath.row];
            switch (indexPath.row) {
                case 0:{
                    
                    if ([[_sourceData objectForKey:@"type"] isEqualToString:@"0"]) {
                        content = [@"支付宝  " stringByAppendingString:[NSString stringWithFormat:@"%@",in_mid]];
                    }else if([[_sourceData objectForKey:@"type"] isEqualToString:@"1"]){
                        content = [@"微信  " stringByAppendingString:[NSString stringWithFormat:@"%@",in_mid]];
                    }else{
                        content = [@"银行卡  " stringByAppendingString:[NSString stringWithFormat:@"%@",in_mid]];
                        
                    }

                }
                    break;
                case 1:content = [_sourceData objectForKey:@"real_money"];
                    break;
                case 2:content = [_sourceData objectForKey:@"timer"];
                    break;
                case 3:content = [_sourceData objectForKey:@"expect_timer"];
                    break;
                case 4:content = [_sourceData objectForKey:@"order"];
                    break;

                case 5:content = @"正在转出";
                    break;
               
                default:
                break;}
        }
        
        //失败
        if (status == 2) {
            cell.textLabel.text = @[@"转出至",@"申请时间" ,@"处理时间",@"流水编号",@"转出状态" ,@"失败原因"][indexPath.row];
            
            switch (indexPath.row) {
                case 0:{
                    if ([[_sourceData objectForKey:@"type"] isEqualToString:@"0"]) {
                        content = [@"支付宝  " stringByAppendingString:[NSString stringWithFormat:@"%@",in_mid]];
                    }else if([[_sourceData objectForKey:@"type"] isEqualToString:@"1"]){
                        content = [@"微信  " stringByAppendingString:[NSString stringWithFormat:@"%@",in_mid]];
                    }else{
                        content = [@"银行卡  " stringByAppendingString:[NSString stringWithFormat:@"%@",in_mid]];
                        
                    }
                }
                    break;

                case 1:
                    content = [_sourceData objectForKey:@"timer"];
                    break;
                case 2:
                {
                    NSString *timer = [_sourceData objectForKey:@"deal_time"];
                    
                    NSTimeInterval time=[timer doubleValue];
                    
                    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    
                    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
                    
                    content = currentDateStr;
                    
                }
                    break;
                case 3:
                    content = [_sourceData objectForKey:@"order"];
                    break;
                case 4:
                    content = @"转出失败";
                    cell.detailTextLabel.textColor = [UIColor py_colorWithHexString:@"#CC0033"];
                    break;
                case 5:content = [_sourceData objectForKey:@"deal_info"];
                    break;
                    
                default:
                    break;
            }
        }
        
        cell.accessoryType  = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.text = content;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (UIEdgeInsets)nh_sepEdgeInsetsAtIndexPath:(NSIndexPath *)indexPath { return UIEdgeInsetsMake(0, 15, 0, 0); }

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RolloutHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:RolloutReuseIden];
    NSString *logo = @"withdraw";
    headView.logo.image = Icon(logo);
    
    NSString *money = IF_NULL_TO_STRING([_sourceData objectForKey:@"money"]);
    NSString *symbol = [@"-" stringByAppendingString:money];
    
    headView.money.text = [NSString stringWithFormat:@"%@",symbol];
    
//    NSString *status = IF_NULL_TO_STRING([_sourceData objectForKey:@"status"]);
//    if ([status isEqualToString:@"0"]) {
//        headView.account.text = @"正在转出";
//    }else if ([status isEqualToString:@"1"]){
//        headView.account.text = @"交易成功";
//    }else{
//        headView.account.text = @"交易失败";
//    }
//
//    headView.account.textColor = [UIColor py_colorWithHexString:@"808080"];
    
    return headView;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
