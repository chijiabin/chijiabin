//
//  YScanPay.m
//  Ubate
//
//  Created by sunbin on 2017/2/10.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "YScanPay.h"

#import "SelectedCell.h"
#import "PayConfirmButton.h"

#import "AlipayManage.h"
#import "WechartManage.h"
#import "ConsumptionReturn.h"


static NSString *PayConfirmButton_Iden = @"PayConfirmButton_Iden";

@interface YScanPay ()<TextFilterDelegate ,PayConfirmButtonDelegate>

//选择支付方式tableview
@property (weak, nonatomic) IBOutlet UITableView *payTypeTableview;
@property (assign, nonatomic) NSIndexPath *selectedIndexPath;//单选，当前选中的行


@property (nonatomic ,strong) NSDictionary *dataDic;

@property (nonatomic) JHUD *hudView;
@property (nonatomic,strong)NSString * Trade_id;

@end

@implementation YScanPay
{
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"付款详情";
    [self pop];
}
- (void)pop{
    [NHUtils pushAndPop:@"QRReader" range:NSMakeRange(1, 1) currentCtl:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_enterAmount becomeFirstResponder];
    [self initView];
    [self loadData];
    
    self.payTypeTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxPayCallBackAction:) name:@"WXPayCallBack" object:nil];
}

// 页面布局
- (void)initView{
    
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }

    //.1设置文本属性 设置money输入
    [_enterAmount leftViewModeWithConstrainedToWidth:30.f text:@"￥" isLaunchScreen:NO fon:25.f leftFonColor:@"da5555" bodyFonColor:@"da5555" PlaceholderColor:@"da5555"];
    _enterAmount.text.length <= 6;
    
    filterMoney = [[TextFilter alloc] init];
    [filterMoney SetMoneyFilter:_enterAmount delegate:self];
    
    [_enterAmount setPlaceholderColor:[UIColor py_colorWithHexString:@"999999"]];
        
    
    self.payTypeTableview.scrollEnabled = NO;
    self.payTypeTableview.backgroundColor = [UIColor themeColor];
    [self.payTypeTableview registerNib:[UINib nibWithNibName:@"PayConfirmButton" bundle:nil] forHeaderFooterViewReuseIdentifier:PayConfirmButton_Iden];
    //.2默认选择支付方式
    [self defaultSelected];
    
}


- (void)defaultSelected{
    _selectedIndexPath  = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.payTypeTableview  selectRowAtIndexPath:_selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    if ([self.payTypeTableview.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.payTypeTableview.delegate tableView:self.payTypeTableview didSelectRowAtIndexPath:_selectedIndexPath];
    }
}

// 2加载数据
- (void)loadData{
   NSDictionary *params = [self uid:[NSString stringWithFormat:@"%lld" ,[YConfig getOwnID]] sign:[YConfig getSign] idMake:[NSString stringWithFormat:@"%ld" ,(long)_store_id]];
    WEAKSELF;

    [YNetworking postRequestWithUrl:storeDetail params:params cache:NO successBlock:^(id returnData, int code, NSString *msg) {
        if (code == 1) {
            [JHUD hideForView:weakSelf.view];
            weakSelf.dataDic = [(NSDictionary *)returnData objectForKey:@"data"];
            [self loadData:weakSelf.dataDic];
            
        }else{
        }
    } failureBlock:^(NSError *error) {
    } showHUD:YES];
    }

- (NSDictionary *)uid:(NSString *)mUid sign:(NSString *)mSign idMake:(NSString *)idMake{
    NSDictionary *dic = @{@"uid" : mUid,
                          @"sign": mSign,
                          @"id"  : idMake
                          };
    return dic;
}


- (void)loadData:(NSDictionary *)data{

    WEAKSELF;
    NSString *company_nameStr = IF_NULL_TO_STRING([data objectForKey:@"company_name"]);
    NSString *store_nameStr = IF_NULL_TO_STRING([data objectForKey:@"store_name"]);
    
    weakSelf.company_name.text = [company_nameStr stringByAppendingString:[NSString stringWithFormat:@"(%@)" ,store_nameStr]];
    NSInteger ioc = company_nameStr.length;
    NSInteger len = store_nameStr.length + 2;
    [weakSelf companyAttributedString: weakSelf.company_name.text range:NSMakeRange(ioc, len)];
    weakSelf.address.text = IF_NULL_TO_STRING([data objectForKey:@"address"]);

    
    NSString *valueR1 = [NSString stringWithFormat:@"%@%%" ,IF_NULL_TO_STRING([data objectForKey:@"valueR1"])];
    
    weakSelf.valueR1.text =valueR1;
    
    [weakSelf valueR1AttributedString:weakSelf.valueR1.text range:NSMakeRange(0, valueR1.length-1)];

}


//富文本设置
- (void)companyAttributedString:(NSString *)countent range:(NSRange)range{
    WEAKSELF;
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:countent];
    [AttributedStr setAttributes:@{NSFontAttributeName:FONT_FONTMicrosoftYaHei(15.f)} range:range];
    weakSelf.company_name.attributedText = AttributedStr;
}


- (void)valueR1AttributedString:(NSString *)countent range:(NSRange)range{
    WEAKSELF;
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:countent];
    
    [AttributedStr setAttributes:@{NSFontAttributeName:FONT_FONTMicrosoftYaHei(32.f)} range:range];
    
    [AttributedStr setAttributes:@{NSFontAttributeName:FONT_FONTMicrosoftYaHei(15.f)} range:NSMakeRange(range.length, 1)];
    weakSelf.valueR1.attributedText = AttributedStr;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


//监听文本输入
- (IBAction)editingChanage:(UITextField *)sender {
    CGFloat discountValue = [sender.text integerValue];
    
    CGFloat cashBack = discountValue *[ _valueR1.text floatValue] /100.f;
    
    NSString * fuhao = @"￥";
    
    _cashBackValue.text = [fuhao stringByAppendingString:[NSString stringWithFormat:@"%.2f" ,cashBack]];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PAY_CHANGEBTNSTATE object:nil userInfo:@{@"key":sender.text}];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellid";
    SelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[SelectedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.font = FONT_FONTMicrosoftYaHei(12.f);
        [cell.textLabel setTextColor:[UIColor py_colorWithHexString:@"525252"]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   // cell.backgroundColor = [UIColor appCellColor];
    cell.selectedIndexPath = indexPath;
    [cell.selectedButton setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    
    if (_selectedIndexPath == indexPath)
    {
        [cell.selectedButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    NSString *imageName = @[@"zhifubao pay" ,@"wetchat pay"][indexPath.row];
    cell.logImg.image = Icon(imageName);
    cell.payType.text = @[@"支付宝" ,@"微信"][indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectedCell *celled = [tableView cellForRowAtIndexPath:_selectedIndexPath];
    [celled.selectedButton setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    celled.selectedIndexPath = indexPath;
    _selectedIndexPath = indexPath;
    
    SelectedCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.selectedButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor =  [UIColor appCellColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 120, [SizeProportion SizeProportionWithHeight:54.f])];
    label.text = @"支付方式";
    label.font = FONT_FONTMicrosoftYaHei(15.f);
    label.textColor = [UIColor py_colorWithHexString:@"#333333"];
    [view addSubview:label];
    
    UILabel *lin = [[UILabel alloc] initWithFrame:CGRectMake(0, ScaleHeight(54.f)-1, SCREEN_WIDTH, 1)];
    lin.backgroundColor = [UIColor py_colorWithHexString:@"cccccc"];
    [view addSubview:lin];
    
    return view;
    
}



#pragma make -支付确认按钮

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    PayConfirmButton *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:PayConfirmButton_Iden];
    footerView.delegate = self;
    
    footerView.backgroundView = [[UIImageView alloc] initWithImage:[NHUtils imageWithColor:[UIColor themeColor] size:CGSizeMake(WIDTH(footerView), HEIGHT(footerView)) alpha:1]];
    
    return footerView;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleHeight(54.f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScaleHeight(54.f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return ScaleHeight(91.f);
}

#pragma make -支付 0代表支付宝  1代表微信
- (void)payType{
    
    NSInteger selectPayTpe = _selectedIndexPath.row;
    WEAKSELF;

    
    if (_enterAmount.text.length <= 6) {
        
    if (selectPayTpe == 0) {
        //1.支付宝支付
        [[AlipayManage sharedAlipayManage] doAlipayPay:_company_name.text money:_enterAmount.text store_id:[NSString stringWithFormat:@"%ld",(long)_store_id] ctl:self myBlock:^(NSDictionary *requestResultDic ,NSString *trade_id) {
            if ([NHUtils isBlankString:trade_id]) {
                NSLog(@"订单失败");
                [weakSelf.view showError:@"订单获取失败"];
            }else{
                NSString *resultStatus = TEXT_STRING([requestResultDic objectForKey:@"resultStatus"]);
                
                if ([resultStatus isEqualToString:@"9000"]) {
                    [weakSelf handlePayTrade_id:trade_id];
                }else{
                    NSLog(@"支付失败");
                    [weakSelf.view showError:@"支付失败"];
                }
            }
        }];
        return;
    }
    if (selectPayTpe == 1) {
         if (_enterAmount.text.length > 3) {
            
            [weakSelf.view showError:@"微信单笔支付不能超过1000"];
        }else{
            [[WechartManage sharedWechartManage] jumpToWechart:_company_name.text money:_enterAmount.text store_id:[NSString stringWithFormat:@"%ld",(long)_store_id] ctl:self myBlock:^(BOOL isError  , NSString *trade_id) {

                weakSelf.Trade_id = trade_id;
                if (!isError) {
//                    [weakSelf handlePayTrade_id:trade_id];
                }
                
            }];
        }        
    }
    }else{    
        [weakSelf.view showError:@"支付金额过大"];
    }

}

#warning  添加的微信支付回调的通知的方法
// 处理微信支付的回调
- (void)wxPayCallBackAction:(NSNotification *)notifi
{
    NSDictionary *resultDic = notifi.userInfo;
    NSLog(@"%@" ,_Trade_id);
    
    if ([resultDic[@"error_code"] isEqualToString:@"0"]) {
        
        [[[UIAlertView alloc] initWithTitle:@"支付结果" message:@"支付成功" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil] show];
        
        //跳转
        ConsumptionReturn *consumption = [[ConsumptionReturn alloc] initWithStyle:UITableViewStyleGrouped];
        consumption.title = @"交易详情";
        
        NSDictionary *responseData = @{@"list_id":_Trade_id ,@"mark":@"1"};
        
        consumption.consumptionReturnData = responseData;
        
        WEAKSELF;
        [weakSelf.navigationController pushViewController:consumption animated:NO];
        
    }else if ([resultDic[@"error_code"] isEqualToString:@"-2"]){
        // 取消支付
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[[UIAlertView alloc] initWithTitle:@"支付结果" message:@"您已取消支付" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil] show];
            
        });
    }else{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"支付结果" message:@"支付失败，请稍后再试！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil] show];
        });
        
    }
    
}


- (void)handlePayTrade_id:(NSString *)trade_id{
    [[NSNotificationCenter defaultCenter] postNotificationName:PAYSUCCESS object:nil];
    //跳转
    ConsumptionReturn *consumption = [[ConsumptionReturn alloc] initWithStyle:UITableViewStyleGrouped];
    consumption.title = @"交易详情";
    NSDictionary *responseData = @{@"list_id":trade_id ,@"mark":@"1"};
    
    consumption.consumptionReturnData = responseData;
    
    WEAKSELF;
    [weakSelf.navigationController pushViewController:consumption animated:NO];
    
}

-(void)onResp:(BaseReq *)resp{

    if ([resp isKindOfClass:[PayReq class]]) {
        
        
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
