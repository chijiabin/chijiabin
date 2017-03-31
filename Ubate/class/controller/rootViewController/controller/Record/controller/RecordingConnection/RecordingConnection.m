//
//  RecordingConnection.m
//  Ubate
//
//  Created by sunbin on 2017/2/6.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "RecordingConnection.h"
#import "ConsumptionHeaderFooterView.h"
static NSString *ConsumptionHeaderFooterViewIden = @"ConsumptionHeaderFooterViewIden";

@interface RecordingConnection ()
@property (nonatomic ,strong) NSArray *cellData;
@property (nonatomic ,strong) NSDictionary *sourceData;

@property (nonatomic) JHUD *hudView;
@end

@implementation RecordingConnection
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title = NSLocalizedString(@"relational.Record", @"Relational Record");

}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat padding = 0;
    self.hudView.frame = CGRectMake(padding,
                                    padding,
                                    self.view.frame.size.width - padding*2,
                                    self.view.frame.size.height - padding*2);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.hudView = [[JHUD alloc]initWithFrame:self.view.bounds];
    self.hudView.indicatorBackGroundColor = [UIColor clearColor];
    self.hudView.indicatorForegroundColor = kRGBAColor(60, 139, 246, .5);
    
    WEAKSELF;
    //自动消失
    [weakSelf loadData];//数据加载
    if (_sourceData.count !=0) {
        //1有数据  不用重新加载
        //        [JHUD hideForView:weakSelf.view];//自动消失
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
    //第一次请求  或无网络时显示
    //2无数据  需要加载
    self.hudView.messageLabel.text = @"正在加载数据中";
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCircle];
    //自动消失 2s消失后显示失败
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(disafter * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JHUD hideForView:weakSelf.view];//自动消失
        [weakSelf initView];
        [weakSelf loadData];
    });
}

- (void)initView{
    [self tableViewAttributes];
    
    
}

- (void)tableViewAttributes
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 0;
    
    [self tableviewSeparator];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ConsumptionHeaderFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:ConsumptionHeaderFooterViewIden];
}
- (void)tableviewSeparator{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
//    self.tableView.separatorColor = [UIColor appSeparatorColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)loadData{
    _cellData = @[@"付款方式",@"商家地址" ,@"返现金额" ,@"消费时间",@"流水编号" ,@"支付宝编号" ];
    
    
    NSDictionary *params = @{
                             @"uid":   @([YConfig getOwnID]),
                             @"id":     @([[_recordingConnectionDic objectForKey:@"parent_id"] integerValue]),
                             @"type": @(1),
                             @"sign":[YConfig getSign]
                             };
    
    
    WEAKSELF;
    [self request:params response:^(BOOL state, NSDictionary *results, NSString *responseResults) {
        if (state) {
            weakSelf.sourceData = [NSMutableDictionary dictionaryWithDictionary:results];
            
            [weakSelf.tableView reloadData];
            
        }
        
    }];
    
}


- (void)request:(NSDictionary *)params response:(void (^)(BOOL state,NSDictionary * results,NSString * responseResults))states{
    WEAKSELF;
    [YNetworking postRequestWithUrl:logDetail params:params cache:YES successBlock:^(id returnData, int code, NSString *msg) {
        if (code == 1) {
            states(YES ,[returnData objectForKey:@"data"] ,msg);
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
            states(NO ,nil ,msg);
        }
    } failureBlock:^(NSError *error) {
        if (weakSelf.sourceData.count !=0) {
        }else{
            states(NO ,nil ,error.localizedDescription);
            [weakSelf failure];
        }
    } showHUD:NO];
    
    
}

#pragma 熊猫闭眼  失败  按钮
- (void)failure
{
    self.hudView.indicatorViewSize = CGSizeMake(150, 150);
    self.hudView.messageLabel.text = @"网络故障,尝试检查下网络设置";
    [self.hudView.refreshButton setTitle:@"Refresh ?" forState:UIControlStateNormal];
    self.hudView.customImage = [UIImage imageNamed:@"tishi"];
    
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeFailure];
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        
        [cell.textLabel setFont:FONT_FONTMicrosoftYaHei(13.f)];
        [cell.detailTextLabel setFont:FONT_FONTMicrosoftYaHei(13.f)];
        [cell.textLabel setTextColor:[UIColor py_colorWithHexString:@"4c4c4c"]];
        [cell.detailTextLabel setTextColor:[UIColor py_colorWithHexString:@"808080"]];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    
    cell.textLabel.text = [_cellData objectAtIndex:indexPath.row];
        
    switch (indexPath.row) {
        case 0:{
            if ([[_sourceData objectForKey:@"type"] isEqualToString:@"0"]) {
                cell.detailTextLabel.text = @"支付宝";
            }else if([[_sourceData objectForKey:@"type"] isEqualToString:@"1"]){
                cell.detailTextLabel.text = @"微信";
            }else{
                cell.detailTextLabel.text = @"银行";
            }
        }
            break;
        case 1:{
            NSString *store = IF_NULL_TO_STRING([_sourceData objectForKey:@"store"]);
           // NSString *provice = IF_NULL_TO_STRING([_sourceData objectForKey:@"city"]);
            NSString *city = IF_NULL_TO_STRING([_sourceData objectForKey:@"city"]);
            NSString *area = IF_NULL_TO_STRING([_sourceData objectForKey:@"area"]);
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@",city,area,store];
        }
            break;
        case 2:{
            NSString *returnmoney = IF_NULL_TO_STRING([_sourceData objectForKey:@"return_money"]);
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",[returnmoney floatValue]];
        }
            break;
        case 3:
            cell.detailTextLabel.text = IF_NULL_TO_STRING([_sourceData objectForKey:@"timer"]);
            break;
        case 4:
            cell.detailTextLabel.text =  IF_NULL_TO_STRING([_sourceData objectForKey:@"order"]);
            break;
        case 5:{
            if ([[_sourceData objectForKey:@"type"] isEqualToString:@"0"]) {
                cell.textLabel.text = @"支付宝编号";
            }else if([[_sourceData objectForKey:@"type"] isEqualToString:@"1"]){
                cell.textLabel.text = @"微信编号";
            }else{
                cell.textLabel.text = @"银行编号";
            }
            cell.detailTextLabel.text =  IF_NULL_TO_STRING([_sourceData objectForKey:@"no"]);
        }
            break;
        default:
            break;
    }
    return cell;
    
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    ConsumptionHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ConsumptionHeaderFooterViewIden];
    
    NSString *imageName;
    imageName = @"consume";
    NSString *company = IF_NULL_TO_STRING([_sourceData objectForKey:@"company"]);
    NSString *store = IF_NULL_TO_STRING([_sourceData objectForKey:@"store"]);
    
    
    headView.shopNmae.text =[company stringByAppendingString:[NSString stringWithFormat:@"(%@)" ,store]];
    NSString *money = IF_NULL_TO_STRING([_sourceData objectForKey:@"money"]);

    headView.amount.text = [NSString stringWithFormat:@"%.2f",[money floatValue]];
    
    headView.logo.image = Icon(imageName);
    return headView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [SizeProportion SizeProportionWithHeight:50.f];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return [SizeProportion SizeProportionWithHeight:161.f];;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
