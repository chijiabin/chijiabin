//
//  News.m
//  Ubate
//
//  Created by 池先生 on 17/3/2.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "News.h"
#import "ConsumptionHeaderFooterView.h"
#import "ReturnHeaderFooterView.h"
#import "RecordingConnection.h"

#import "YScanPay.h"

static NSString *ConsumptionHeaderFooterViewIDen = @"ConsumptionHeaderFooterViewIDen";

static NSString *ReturnHeaderFooterViewIDen      = @"ReturnHeaderFooterViewIDen";

@interface News ()
@property (nonatomic ,strong) NSDictionary *sourceData;

@property (nonatomic) JHUD *hudView;

@end

@implementation News

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat padding = 0;
    self.hudView.frame = CGRectMake(padding,
                                    padding,
                                    self.view.frame.size.width - padding*2,
                                    self.view.frame.size.height - padding*2);
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self pop];
}
- (void)pop{
    NSLog(@"%@" ,self.navigationController.viewControllers);
    [NHUtils pushAndPop:@"YScanPay" range:NSMakeRange(1, 1) currentCtl:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hudView = [[JHUD alloc]initWithFrame:self.view.bounds];
    self.hudView.indicatorBackGroundColor = [UIColor clearColor];
    self.hudView.indicatorForegroundColor = kRGBAColor(60, 139, 246, .5);
    
    self.tableView.scrollEnabled =NO;
    
    
    WEAKSELF;
    [weakSelf loadData];//数据加载
    
    if (_sourceData.count !=0) {
        // 1有数据  不用重新加载
        //  [JHUD hideForView:weakSelf.view];//自动消失
        [weakSelf initView];
    }else{
        [weakSelf reload];
    }
    // 点击刷新
    [self.hudView setJHUDReloadButtonClickedBlock:^() {
        NSLog(@"refreshButton");
        [weakSelf reload];
        
    }];
    
    
}


- (void)reload{
    WEAKSELF;
    //第一次请求  或无网络时显示
    //2无数据  需要加载
    self.hudView.messageLabel.text = NSLocalizedString(@"正在加载数据", @"Loading data");
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCircle];
    //自动消失 2s消失后显示失败
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(disafter * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JHUD hideForView:weakSelf.view];//自动消失
        [weakSelf initView];
        [weakSelf loadData];
    });
    
}

- (void)loadData{
    
    WEAKSELF;
    [self DatarequestData:^(BOOL state ,BOOL isNotNet, NSDictionary *results, NSError *requestError) {
        if (state) {
            weakSelf.sourceData =results;
            [weakSelf.tableView reloadData];
        }else{
        }
    }];
    
}
- (void)DatarequestData:(void (^)(BOOL state,BOOL isNotNet, NSDictionary * results,NSError * requestError))states{
    
    __block NSDictionary *respondDic;
    NSDictionary *params ;
   
        params = @{
                   @"uid":   @([YConfig getOwnID]),
                   @"id":    @([[_consumptionReturnData objectForKey:@"list_id"] integerValue]),
                   @"type":  @([[_consumptionReturnData objectForKey:@"mark"] integerValue]),
                   @"sign":[YConfig getSign]
                   };
        
    
    WEAKSELF;
    
    [YNetworking postRequestWithUrl:logDetail params:params cache:YES successBlock:^(id returnData, int code, NSString *msg) {
        if (code == 1)
        {
            respondDic = (NSDictionary *)[returnData objectForKey:@"data"];
            states(YES,NO, respondDic,nil);
            
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
            states(NO,NO, respondDic,nil);
            
        }
        
    } failureBlock:^(NSError *error) {
        
        if (weakSelf.sourceData.count !=0) {
        }else{
            states(NO, YES,nil,error);
            [self failure];
        }
        
    } showHUD:NO];
}
#pragma 熊猫闭眼  失败  按钮
- (void)failure
{
    self.hudView.indicatorViewSize = CGSizeMake(150, 150);
    self.hudView.messageLabel.text =     NSLocalizedString(@"网络故障，尝试检查下网络设置", @"Network failure, try to check the network settings");
    [self.hudView.refreshButton setTitle:NSLocalizedString(@"refresh", @"Refresh?") forState:UIControlStateNormal];
    self.hudView.customImage = [UIImage imageNamed:@"tishi"];
    
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeFailure];
    
}

- (void)initView{
    [self tableViewAttributes];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ConsumptionHeaderFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:ConsumptionHeaderFooterViewIDen];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ReturnHeaderFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:ReturnHeaderFooterViewIDen];
    
}

- (void)tableViewAttributes{
    
    self.tableView.backgroundColor = [UIColor py_colorWithHexString:@"f5f5f5"];
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 0;
    
    [self tableviewSeparator];
}

- (void)tableviewSeparator{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    //self.tableView.separatorColor = [UIColor clearColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *make;
    
    NSString *type;

    make = [_consumptionReturnData objectForKey:@"mark"];
    type = [_consumptionReturnData objectForKey:@"type"];
    
    //支付宝 微信
    if ([make isEqualToString:@"1"]) {
        return 6;
    }//返现转出
    else if ([make isEqualToString:@"3"]){
    
        return 6;
    }//共享返现
    else{
    
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    NSString *make;
    NSString *type;
    make = [_consumptionReturnData objectForKey:@"mark"];
    type = [_consumptionReturnData objectForKey:@"type"];
    
    //共享返现
    if ([make isEqualToString:@"3"]) {
        
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
            
            //转出成功
            if (status == 1)
            {
                cell.textLabel.text = @[@"提现方式",@"转出时间" ,@"到账时间" ,@"流水编号",accountType ,@"转出状态" ][indexPath.row];
                
                switch (indexPath.row) {
                    case 0:{
                        if ([[_sourceData objectForKey:@"type"] isEqualToString:@"0"]) {
                            content = @"支付宝";
                        }else if([[_sourceData objectForKey:@"type"] isEqualToString:@"1"]){
                            content = @"微信";
                        }else{
                            content = @"银行卡";
                            
                        }
                    }
                        break;
                    case 1:content = [_sourceData objectForKey:@"timer"];
                        break;
                    case 2:content = [_sourceData objectForKey:@"expect_timer"];
                        break;
                    case 3:content = [_sourceData objectForKey:@"order"];
                        break;
                    case 4:{content = [_sourceData objectForKey:@"no"];
                        break;
                    case 5:content = @"转出成功";
                        break;
                    default:
                        break;
                    }}
            }
            
            //处理中
            if (status == 0) {
                
                
                cell.textLabel.text = @[@"提现方式",@"转出时间" ,@"预计到账时间" ,@"流水编号" ,accountType,@"转出状态" ][indexPath.row];
                switch (indexPath.row) {
                    case 0:{
                        if ([[_sourceData objectForKey:@"type"] isEqualToString:@"0"]) {
                            content = @"支付宝";
                        }else if([[_sourceData objectForKey:@"type"] isEqualToString:@"1"]){
                            content = @"微信";
                        }else{
                            content = @"银行卡";
                            
                        }
                    }
                        break;
                    case 1:content = [_sourceData objectForKey:@"timer"];
                        break;
                    case 2:content = [_sourceData objectForKey:@"expect_timer"];
                        break;
                    case 3:content = [_sourceData objectForKey:@"order"];
                        break;
                    case 4:content = [_sourceData objectForKey:@"in_mid"];
                        break;
                    case 5:content = @"正在转出";
                        break;
                    default:
                    break;}
            }
            
            //失败
            if (status == 2) {
                cell.textLabel.text = @[@"提现方式",@"转出时间" ,@"预计到账时间",@"流水编号" ,accountType,@"转出状态" ,@"失败原因"][indexPath.row];
                if (indexPath.row == 5) {
                    cell.detailTextLabel.textColor = [UIColor redColor];
                }
                switch (indexPath.row) {
                    case 0:{
                        if ([[_sourceData objectForKey:@"type"] isEqualToString:@"0"]) {
                            content = @"支付宝";
                        }else if([[_sourceData objectForKey:@"type"] isEqualToString:@"1"]){
                            content = @"微信";
                        }else{
                            content = @"银行卡";
                        }
                    }
                        break;
                    case 1:
                        content = [_sourceData objectForKey:@"timer"];
                        break;
                    case 2:
                        content = [_sourceData objectForKey:@"expect_timer"];
                        break;
                    case 3:
                        content = [_sourceData objectForKey:@"order"];
                        break;
                    case 4:
                        content = [_sourceData objectForKey:@"in_mid"];
                        break;
                    case 5:
                        content = @"转出失败";
                        cell.detailTextLabel.textColor = [UIColor py_colorWithHexString:@"#CC0033"];
                        break;
                    case 6:content = [_sourceData objectForKey:@"no"];
                        break;
                        
                    default:
                        break;
                }
            }
            
            cell.accessoryType  = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailTextLabel.text = content;
        }
    
    }
        //     *  消费记录 付款方式 商家地址 回赠金额 消费时间 流水编号 支付宝编号 退款
        
    if ([make isEqualToString:@"1"]) {
            NSString *city    =  [_sourceData objectForKey:@"city"];
            NSString *area    =  [_sourceData objectForKey:@"area"];
            NSString *store   =  [_sourceData objectForKey:@"store"];
            NSString *provice =  [_sourceData objectForKey:@"provice"];
            NSString *adres   =  [NSString stringWithFormat:@"%@%@%@%@" ,provice,city,area,store];
            
            NSArray *textLabelAry = @[NSLocalizedString(@"付款方式", @"Payment method") ,
                                      NSLocalizedString(@"商家地址", @"Merchant address") ,
                                      NSLocalizedString(@"返现金额", @"Rebate amount") ,
                                      NSLocalizedString(@"消费时间", @"Trading time") ,
                                      NSLocalizedString(@"流水编号", @"Flow number") ,[[_sourceData objectForKey:@"type"] isEqualToString:@"0"]?NSLocalizedString(@"支付宝编码", @"Alipay transaction number"):NSLocalizedString(@"微信编码", @"WeChat transaction number")];
            
            
            NSArray *detailTextLabelAry = @[[[_sourceData objectForKey:@"type"] isEqualToString:@"0"]?@"支付宝":@"微信",
                                            adres,
                                            [NSString stringWithFormat:@"%.2f",[[_sourceData objectForKey:@"return_money"] floatValue]],
                                            [_sourceData objectForKey:@"timer"],
                                            [_sourceData objectForKey:@"order"],
                                            [_sourceData objectForKey:@"no"]];
            
            cell.textLabel.text = [textLabelAry objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [detailTextLabelAry objectAtIndex:indexPath.row];
            
            
            
        }
//    else{
//        
//                NSArray *textLabelAry = @[NSLocalizedString(@"返现时间", @"Return time") ,NSLocalizedString(@"流水编号", @"Flow number")];
//                NSArray *detailTextLabelAry = @[[_sourceData objectForKey:@"timer"],[_sourceData objectForKey:@"order"]];
//                cell.textLabel.text = [textLabelAry objectAtIndex:indexPath.row];
//                cell.detailTextLabel.text = [detailTextLabelAry objectAtIndex:indexPath.row];
//        
//        }
        [cell.textLabel setFont:FONT_FONTMicrosoftYaHei(13.f)];
        [cell.detailTextLabel setFont:FONT_FONTMicrosoftYaHei(13.f)];
        [cell.textLabel setTextColor:[UIColor py_colorWithHexString:@"525252"]];
        [cell.detailTextLabel setTextColor:[UIColor py_colorWithHexString:@"808080"]];
    
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //make 区分 1消费记录 2返现记录
    //type 区分 返现记录下（共享 消费奖赏）
    
    //根据跳转方式 具体分析实现数据来源 RecentRecordModel *model  RecentRecordModel *model
    NSString *make;NSString *type;
    
    if ([NHUtils isBlankString:_model.mark]) {
        make = [_consumptionReturnData objectForKey:@"mark"];
        type = [_consumptionReturnData objectForKey:@"type"];
        
    }else{
        make = _model.mark;
        type = _model.type;
    }
    
    //测试公司
    if ([make isEqualToString:@"1"]) {
        //消费返现
        
        ConsumptionHeaderFooterView *consumptionHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ConsumptionHeaderFooterViewIDen];
        
        NSString *imageName;
        imageName = @"consume";
        NSString *company = IF_NULL_TO_STRING([_sourceData objectForKey:@"company"]);
        NSString *store = IF_NULL_TO_STRING([_sourceData objectForKey:@"store"]);
        //状态
        
        NSString *status_info = IF_NULL_TO_STRING([_sourceData objectForKey:@"status_info"]);
        consumptionHeadView.status.text = status_info;
        
        consumptionHeadView.shopNmae.text =[company stringByAppendingString:[NSString stringWithFormat:@"(%@)" ,store]];
        
        CGFloat money =  [[_sourceData objectForKey:@"money"] floatValue];
        consumptionHeadView.amount.text = [NSString stringWithFormat:@"%.2f",money];
        
        consumptionHeadView.logo.image = Icon(imageName);
        
        return consumptionHeadView;
        
        
    }
    //消费返现
    else{
        
        ReturnHeaderFooterView *returnHeaderheadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ReturnHeaderFooterViewIDen];
        
        NSString * money = IF_NULL_TO_STRING([_sourceData objectForKey:@"money"]);
        NSString *symbol = [@"+" stringByAppendingString:money];
        returnHeaderheadView.money.text = [NSString stringWithFormat:@"%+.2f" ,symbol.floatValue];
        
        returnHeaderheadView.returnType.text = ![type isEqualToString:@"0"]?NSLocalizedString(@"共享返现", @"Shared cashback"):NSLocalizedString(@"消费返现", @"Consumption cashback");
        //        returnHeaderheadView.logo.image = Icon(![type isEqualToString:@"0"]?@"share":@"return");
        
        if ([type isEqualToString:@"0"]) {
            NSString *imageName;
            imageName = @"consume";
            returnHeaderheadView.logo.image = Icon(imageName);
        }else{
            
            NSString *imageName;
            imageName = @"share";
            returnHeaderheadView.logo.image = Icon(imageName);
        }
        
        return returnHeaderheadView;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScaleHeight(50.f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScaleHeight(161.f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}


@end
