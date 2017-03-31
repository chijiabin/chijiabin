//
//  RootViewController.m
//  Ubate
//
//  Created by sunbin on 2017/1/25.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "RootViewController.h"
#import "GetUserInfo.h"
#import "NewMessage.h"
#import "RoutePlanning.h"


#import "RecentRecordCell.h"
#import "RecentRecordModel.h"

#import "MemberTableViewController.h"
#import "AdditionalServices.h"
#import "NewMessage.h"
#import "CardTypeList.h"
#import "Setting.h"

#import "SwipableViewController.h"
#import "Rollout.h"
#import "ConsumptionReturn.h"

#import "WithdrawOperation.h"
#import "YReal_NameAuthentication.h"
#import "logOut.h"

#import "YHomeItemRoundCell.h"
#import "LoginController.h"

#import "TempView.h"
#import "Mynews.h"
static NSString * RecentRecordIdentifier = @"RecentRecord_Identifier";
static NSString * YXHomeItemRound = @"HomeItemRound_Identifier";

static NSString * TempView_Identifier = @"TempView_Identifier";


@interface RootViewController ()<LeftMenuDelegate ,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *chartCollectionView;

// 最近交易记录
@property (weak, nonatomic) IBOutlet UITableView *recentRecordTableview;
@property (nonatomic, strong) NSMutableArray *recoderListArr;

@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet UIButton *drawBtn;
@property (weak, nonatomic) IBOutlet UILabel *recentRecordLab;
@property (weak, nonatomic) IBOutlet UIButton *moreLab;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation RootViewController

static int pageIndex = 10;
// 导航栏隐藏问题
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [USER_DEFAULT removeObjectForKey:@"MAKEIDENTIFIER"];//清理操作 避免转出账号操作删除造成崩溃
    [USER_DEFAULT removeObjectForKey:@"CARDDETAITOWITHDRAWMAKEIDENTIFIER"];//清理操作 避免转出账号操作删除造成崩溃

    [self.chartCollectionView reloadData];
    [self.recentRecordTableview reloadData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    

}

- (void)loadView
{
    [super loadView];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
//    CGFloat height_Y = Y(_bottomView)+Y(_recentRecordTableview);
//    self.hudRect = CGRectMake(0, height_Y, SCREEN_WIDTH, SCREEN_HEIGHT-Y(_bottomView));

}

- (NSMutableArray *)recoderListArr
{
    if (!_recoderListArr) {
        _recoderListArr = [NSMutableArray array];
    }
    return _recoderListArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    WEAKSELF;
    
    [GetUserInfo userInfor];   // 获取个人中心
    [self notice];             // 通知 退出登录

    [self initView];
    
     [weakSelf UseMoneyData:pageIndex];
    
    self.recentRecordTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex+=10;

        [weakSelf UseMoneyData:pageIndex];
        
        [weakSelf.recentRecordTableview.mj_header endRefreshing];
    }];
    self.recentRecordTableview.mj_header.automaticallyChangeAlpha = YES;
    
}
- (void)notice{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logOutEven) name:LOGOUT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataRefresh) name:APPLYSUCCESSOFWITHDRAWALS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataRefresh) name:PAYSUCCESS object:nil];

}
- (void)logOutEven{
    NSString *account = [[logOut sharedlogOut] logOutOperation];
    [USER_DEFAULT removeObjectForKey:@"tapCount"];
    
    [USER_DEFAULT removeObjectForKey:@"SELECTINDEX"];
    
    [self jumpLog:account];
}
//退出登录
- (void)jumpLog:(NSString *)logAccount{
    LoginController *loginController = [[LoginController alloc] init];
    loginController.account = logAccount;
    
    [kAppDelegate.window addSubview:loginController.view];
    [self.view removeFromSuperview];
    kAppDelegate.window.rootViewController = loginController;
    
    [self presentViewController:loginController animated:NO completion:^{        
       // NSLog(@"self.navigationController.viewControllers=%@" ,self.navigationController.viewControllers);
    }];

}


/**
 *btnOnClickEven 按钮事件
 *
 *sender 根据tag值跳转指定页面
 *      如tag值= 0左侧菜单栏 1扫一扫 2返回转出 3更多选项按钮事件
 *      扫一扫
 *      返回转出
 *      更多选项按钮事件
 *      左侧菜单栏
 */

- (IBAction)btnOnClickEven:(UIButton *)sender {
    NSInteger index = sender.tag - 100;
    if (index == 0) {
        [self leftNavAction];
    }else{
        // .获取用户model 判断是否实名认证
        YUserInfo *userInfor = [YConfig myProfile];
        
        NSArray *ctlAry = @[
                            kVCFromSb(@"QRReaderID", @"QRReader"),
          
                            [NHUtils isBlankString:userInfor.idcard]?kVCFromSb(@"YReal_NameAuthenticationID", @"YMember"):[[WithdrawOperation alloc] initWithStyle:UITableViewStylePlain],
          
                            [[SwipableViewController alloc]initWithNibName:@"SwipableViewController" bundle:nil]];
        
        
        YReal_NameAuthentication *nameAuthentication ;
        if ([[ctlAry objectAtIndex:index-1] isKindOfClass:[YReal_NameAuthentication class]]) {
            nameAuthentication = (YReal_NameAuthentication*)[ctlAry objectAtIndex:1];
            nameAuthentication.indexMake = @"返现转出操作";
            [self.navigationController pushViewController:nameAuthentication animated:NO];
            return;
        }
        [self.navigationController pushViewController:[ctlAry objectAtIndex:index-1] animated:YES];
    }
}

// 导航左侧按钮点击事件
- (void)leftNavAction{
    [self.menu show];
}

- (void)initView{

    //扫描 返现转出 按钮边框设置
    [_scanBtn setLayerCornerRadius:5.0f borderWidth:0.5f borderColor:[UIColor borderColor]];
    [_drawBtn setLayerCornerRadius:5.0f borderWidth:0.5f borderColor:[UIColor borderColor]];

    [_scanBtn setBackgroundColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_drawBtn setBackgroundColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    [_scanBtn setTitleColor:[UIColor py_colorWithHexString:@"6a6a6a"] forState:UIControlStateHighlighted];
    [_drawBtn setTitleColor:[UIColor py_colorWithHexString:@"6a6a6a"] forState:UIControlStateHighlighted];
    
    
    [_scanBtn setTitle:NSLocalizedString(@"扫一扫", @"Scan") forState:UIControlStateNormal];
//    [_drawBtn setTitle:NSLocalizedString(@"withdrawal", @"Withdrawal") forState:UIControlStateNormal];
    [_moreLab setTitle:NSLocalizedString(@"更多", @"More") forState:UIControlStateNormal];
    
    _recentRecordLab.text = NSLocalizedString(@"最近交易记录", @"The recent record");
    [self menuView];
    [self setupTableView];
    
    [self UseMoneyData:pageIndex];
    
    [self theChart];
    [self jPush];

    
}

- (void)theChart{
    
    _chartCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _chartCollectionView.backgroundColor = [UIColor clearColor];
    _chartCollectionView.pagingEnabled = YES;
    
    [_chartCollectionView registerNib:[UINib nibWithNibName:@"YHomeItemRoundCell" bundle:nil] forCellWithReuseIdentifier:YXHomeItemRound];
    
}

- (void)setupTableView{

    
    [NHUtils tableViewProperty:_recentRecordTableview registerNib:@"RecentRecordCell" forCellReuseIdentifier:RecentRecordIdentifier];
    
    [self.recentRecordTableview registerNib:[UINib nibWithNibName:@"TempView" bundle:nil] forHeaderFooterViewReuseIdentifier:TempView_Identifier];
    
}

//  最近记录
-(void)UseMoneyData:(NSInteger )pagecount{

    WEAKSELF;
    
    NSDictionary *params = @{
                             @"uid":  @([YConfig getOwnID]),
                             @"start":@(0),
                             @"count":@(pagecount),
                             @"sign":[YConfig getSign]
                             };
    
    [YNetworking postRequestWithUrl:userMoneyLog params:params cache:YES successBlock:^(id returnData, int code, NSString *msg) {
        
        if (code == 1) {
            NSArray * respondData = [returnData objectForKey:@"data"];
            
            weakSelf.recoderListArr = [RecentRecordModel mj_objectArrayWithKeyValuesArray:respondData];
            
            [weakSelf.recentRecordTableview reloadData];
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
            // 判断 是否无数据
            if (_recoderListArr.count == 0) {
                
            }
            
        }
        
    } failureBlock:^(NSError *error) {
        
        
    } showHUD:NO];
    
    
    
    
//    [weakSelf requestWithUrl:userMoneyLog params:params isCache:YES showHUD:NO myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg) {
//        
//        if (state == Succeed) {
//            NSArray * respondData = [responseResults objectForKey:@"data"];
//            
//            weakSelf.recoderListArr = [RecentRecordModel mj_objectArrayWithKeyValuesArray:respondData];
//            
//            [weakSelf.recentRecordTableview reloadData];
//        }else{
//            // 判断 是否无数据
//            if (_recoderListArr.count == 0) {
//
//            }
//            
//        }
//    }];
}





#pragma make -YMenuView 左侧滑动视图
- (void)menuView
{
    _left = [[YLeftMenu alloc]initWithFrame:CGRectMake(0, 0, leftWidth, SCREEN_HEIGHT)];
    _left.backgroundColor = [UIColor appLeftViewBackgroundColor];
    _left.customDelegate = self;
    
    YMenuView *menu = [YMenuView MenuViewWithDependencyView:self.view MenuView:_left isShowCoverView:YES];
    self.menu = menu;
}

#pragma make -LeftMenuDelegate
-(void)LeftMenuViewClick:(NSInteger)tag{
    [self.menu  hidenWithAnimation];
    
    // .获取用户model 判断是否实名认证
    YUserInfo *userInfor = [YConfig myProfile];
    NSArray *ctlAry = @[[[MemberTableViewController alloc]initWithStyle:UITableViewStylePlain],
                    
//                        kVCFromSb(@"NearShopTabBarControllerID", @"Near"),
                        [[NewMessage alloc] initWithNibName:@"NewMessage" bundle:nil],
                        [[AdditionalServices alloc] init],
                        kVCFromSb(@"UserQrCodeID", @"UserQrCode"),
                        [NHUtils isBlankString:userInfor.idcard]?kVCFromSb(@"YReal_NameAuthenticationID", @"YMember"):[[CardTypeList alloc] initWithStyle:UITableViewStyleGrouped],[[Mynews alloc]init],
                        [[Setting alloc] init]];
    
    
    [self.navigationController pushViewController:(UIViewController *)[ctlAry objectAtIndex:tag] animated:NO];
}



#pragma make -UITableViewDataSource 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recoderListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecentRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:RecentRecordIdentifier forIndexPath:indexPath];
    cell.model = self.recoderListArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleHeight(50.f);
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_recoderListArr.count == 0) {
        return SCREEN_HEIGHT-Y(_bottomView);
    }else{

        return 0.1f;
        
    }}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RecentRecordModel *model = [_recoderListArr objectAtIndex:indexPath.row];
    NSString *mark = IF_NULL_TO_STRING(model.mark);
    NSString *type = IF_NULL_TO_STRING(model.type);

    if ([mark isEqualToString:@"1"] || [mark isEqualToString:@"2"]){
        
        ConsumptionReturn *consumptionReturn = [[ConsumptionReturn alloc] initWithStyle:UITableViewStylePlain];
        
        consumptionReturn.model = model;
        
        if([mark isEqualToString:@"1"]){
            consumptionReturn.title = NSLocalizedString(@"消费详情", @"Transaction details");
        }else{
            
        consumptionReturn.title = [type isEqualToString:@"0"]?NSLocalizedString(@"消费返现详情",@"Consumption cashback"):NSLocalizedString(@"共享返现",@"Shared cashback");
            
        }
        [self.navigationController pushViewController:consumptionReturn animated:YES];
    }
    
    if([mark isEqualToString:@"3"]){
        Rollout *rollout = [[Rollout alloc] initWithStyle:UITableViewStylePlain];
        rollout.model = model;
        rollout.title = NSLocalizedString(@"转出详情", @"Withdrawal details");
        [self.navigationController pushViewController:rollout animated:YES];
    }    
}


//网络请求 圆环数据请求
- (void)RoundCellrequestData:(void (^)(BOOL state,NSDictionary * results,NSString * requestError))states{
    
    __block NSDictionary *respondDic;
    
    NSDictionary *params = @{
                             @"uid":@([YConfig getOwnID]),
                             @"sign":[YConfig getSign]
                             };
    [YNetworking postRequestWithUrl:homeData params:params cache:YES successBlock:^(id returnData, int code, NSString *msg) {
        if (code == 1) {
            respondDic = (NSDictionary *)[returnData objectForKey:@"data"];
            states(YES,respondDic,msg);
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
            states(NO,nil,msg);
        }
    } failureBlock:^(NSError *error) {
        states(NO,nil,error.localizedDescription);
    } showHUD:NO];
}


#pragma mark -UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YHomeItemRoundCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:YXHomeItemRound forIndexPath:indexPath];
    
    [self RoundCellrequestData:^(BOOL state, NSDictionary *results, NSString *requestError) {
        if (state) {
            cell.dic = results;
        }
    }];
    
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, collectionView.frame.size.height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}




- (void)jPush{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
    
    NSString *registrationID = [JPUSHService registrationID];
    
   // NSLog(@"registrationID =%@" ,registrationID);
    if ([JPUSHService registrationID]) {
   //     NSLog(@"get RegistrationID=%@" ,[JPUSHService registrationID]);
        [self jpushRegistrationID:registrationID];
    }


}

- (void)jpushRegistrationID:(NSString *)registrationID{
    NSDictionary *params = @{
                             @"uid":  @([YConfig getOwnID]),
                             @"registrationID":registrationID,
                             @"sign":[YConfig getSign]
                             };
    
    [YNetworking postRequestWithUrl:LOGIN_JPUSH params:params cache:NO successBlock:^(id returnData, int code, NSString *msg) {
        
        if (code == 1) {
            NSLog(@"%@" ,msg);
        }
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];

}




- (void)networkDidSetup:(NSNotification *)notification {
  //  NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
  //  NSLog(@"未连接");
}

- (void)networkDidRegister:(NSNotification *)notification {
  //  NSLog(@"%@", [notification userInfo]);
    [[notification userInfo] valueForKey:@"RegistrationID"];
    
  //  NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
   // NSLog(@"已登录");
}



- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    
   // NSLog(@"%@" ,notification.userInfo);
    
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary    *extra = [userInfo valueForKey:@"extras"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *currentContent = [NSString
                                stringWithFormat:
                                @"收到自定义消息:%@\ntitle:%@\ncontent:%@\nextra:%@\n",
                                [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                               dateStyle:NSDateFormatterNoStyle
                                                               timeStyle:NSDateFormatterMediumStyle],
                                title, content, [self logDic:extra]];
   // NSLog(@"%@", currentContent);
    
    [_messageContents insertObject:currentContent atIndex:0];
    
    NSString *allContent = [NSString
                            stringWithFormat:@"%@收到消息:\n%@\nextra:%@",
                            [NSDateFormatter
                             localizedStringFromDate:[NSDate date]
                             dateStyle:NSDateFormatterNoStyle
                             timeStyle:NSDateFormatterMediumStyle],
                            [_messageContents componentsJoinedByString:@""],
                            [self logDic:extra]];
    
   // NSLog(@"allContent   alert=%@" ,allContent);
    _messageCount++;
    [self reloadMessageCountLabel];
    
}

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    
    [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return str;
}

- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
  //  NSLog(@"%@", error);
}


- (void)addNotificationCount {
    _notificationCount++;
    [self reloadNotificationCountLabel];
}
- (void)addMessageCount {
    _messageCount++;
    [self reloadMessageCountLabel];
}
- (void)reloadMessageContentView {
}
- (void)reloadMessageCountLabel {
    
   // NSLog(@"%@" ,[NSString stringWithFormat:@"%d", _messageCount]);
    
}
- (void)reloadNotificationCountLabel {
    
   // NSLog(@"%@" ,[NSString stringWithFormat:@"%d", _notificationCount]);
    [self dataRefresh];
    
}
- (void)dataRefresh{
    [self UseMoneyData:pageIndex];
    [self.recentRecordTableview reloadData];
}
- (void)dealloc {
    [self unObserveAllNotifications];
}
- (void)unObserveAllNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidSetupNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidCloseNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidRegisterNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidLoginNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidReceiveMessageNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFServiceErrorNotification
                           object:nil];
}





- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    if (isShowHomePage) {
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    TempView *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TempView_Identifier];
    head.backgroundView = [[UIImageView alloc] initWithImage:[NHUtils imageWithColor:[UIColor whiteColor] size:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH) alpha:1]];
    
    if (_recoderListArr.count != 0) {
        head.LableNO.text = nil;
        head.Imageview.image = [UIImage imageNamed:@""];
    }
    
    return head;

}


@end
