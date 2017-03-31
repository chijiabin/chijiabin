//
//  YBonline.m
//  Ubate
//
//  Created by sunbin on 2017/2/10.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "YBonline.h"

@interface YBonline ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *city;

@property (weak, nonatomic) IBOutlet UILabel  *alertTitle;
@property (weak, nonatomic) IBOutlet UIButton *configBtn;

@property (nonatomic ,strong) NSDictionary *data;

@end

@implementation YBonline
{
    YUserInfo *userInfor;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = @"成为分享者";
    [self pop];
}
- (void)pop{
    [NHUtils pushAndPop:@"QRReader" range:NSMakeRange(1, 1) currentCtl:self];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData]; [self initView];
}

- (void)initView{
    
    self.tableView.backgroundColor = [UIColor themeColor];
    _userImage.aliCornerRadius   = 10;
    _alertTitle.text             = _isAddOnLine?@"确认之后将不能更改":@"确认之后将不能更改";
    [_configBtn setTitle:_isAddOnLine?@"成为TA的分享者":@"成为TA的分享者" forState:UIControlStateNormal];
    [_configBtn setLayerBorderWidth:0.f borderColor:nil];//设置按钮圆角
    
    [self requestData:^(BOOL state, NSDictionary *results, NSError *requestError) {
    }];
    [self respondData];
}

- (void)loadData{
    self.row = 1;
    userInfor = [YConfig myProfile];
    _data = [[NSDictionary alloc] init];
}


//网络请求求 获取用户与商户资料 回调block'
- (void)requestData:(void (^)(BOOL state,NSDictionary * results,NSError * requestError))states{
    
    __block NSDictionary *respondDic;
    NSDictionary *params ;
    NSString *requesrUrl ;
    
    
    switch (_onlineMethod) {
        case User:{
            params = @{
                       @"uid":@([_uid integerValue]),
                       @"sign":[YConfig getSign]
                       };}
            requesrUrl = getInfo;
            break;
            
        case Merchant:{
            params = @{
                       @"uid":@([YConfig getOwnID]),
                       @"id":@([_uid integerValue]),
                       @"sign":[YConfig getSign]
                       };}
            requesrUrl = storeDetail;
            break;
        default:
            break;
    }
    
    [YNetworking postRequestWithUrl:requesrUrl params:params cache:NO successBlock:^(id returnData, int code, NSString *msg) {
        if (code == 1) {
            respondDic = (NSDictionary *)[returnData objectForKey:@"data"];
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
        states(NO,nil,error);
    } showHUD:NO];
}

//加载网路请求返回数据
- (void)respondData{
    WEAKSELF;
    [self requestData:^(BOOL state, NSDictionary *results, NSError *requestError) {
        if (requestError == nil) {
            [weakSelf loadData:results];
        }
    }];
}


- (void)loadData:(NSDictionary *)dic{
    switch (_onlineMethod) {
        case User:{
            _nickname.text = [dic objectForKey:@"nickname"];
            NSString *city = [dic objectForKey:@"city"];
            
            _city.textColor = [UIColor py_colorWithHexString:@"#999999"];
            if ([NHUtils isBlankString:city]) {
                _city.text = @"当前该用户未设置地址";
            }else{
                NSString *province =  [dic objectForKey:@"province"];
                NSString *city     =  [dic objectForKey:@"city"];
                _city.text         =  [province stringByAppendingString:[NSString stringWithFormat:@"-%@",city]];
            }
            
            NSString *image_url = [adress stringByAppendingString:[dic objectForKey:@"user_img"]];
            
            [_userImage mac_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:Icon(@"")];
        }
            break;
        case Merchant:{            
            _nickname.text       = [dic objectForKey:@"company_name"];
            NSString *store_name =[dic objectForKey:@"store_name"];
            NSString *address    =[dic objectForKey:@"address"];
            _city.text           = [address stringByAppendingString:store_name];
            
            [_userImage mac_setImageWithURL:[NSURL URLWithString:[adress stringByAppendingString:[dic objectForKey:@"cLogo"]]] placeholderImage:Icon(@"")];
        }
            break;
        default:
            break;
    }
    
}


#pragma make -添加上线会员按钮
- (IBAction)confirm {
    NSDictionary *params ;
    switch (_onlineMethod) {
        case User:{
            params = @{@"mid": @([_uid integerValue]),
                       @"uid":@([YConfig getOwnID]),
                       @"sign":[YConfig getSign]};
        }
            break;
        case Merchant:{
            params = @{@"sid": @([_uid integerValue]),
                       @"uid":@([YConfig getOwnID]),
                       @"sign":[YConfig getSign]};
        }
            break;
        default:
            break;
    }
    
    
    RootViewController *mainCtl;
    for (UIViewController *ctl  in self.navigationController.viewControllers) {
        
        if ([ctl isKindOfClass:[RootViewController class]]) {
            mainCtl = (RootViewController *)ctl;
        }
    }
    WEAKSELF;
    [YNetworking postRequestWithUrl:scanCode params:params cache:NO successBlock:^(id returnData, int code, NSString *msg) {
        if (code == 1) {
            userInfor.sponsorID = weakSelf.uid;
            kAppDelegate.userInfo = userInfor;
            [weakSelf.navigationController popToViewController:mainCtl animated:YES];
            
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
            [NHUtils alertAction:@selector(msgAlert) alertControllerWithTitle:@"提示" Message:msg Vctl:weakSelf Cancel:NO];
        }
    } failureBlock:^(NSError *error) {
            [NHUtils alertAction:@selector(msgAlert) alertControllerWithTitle:@"提示" Message:error.localizedDescription Vctl:weakSelf Cancel:NO];
        
    } showHUD:YES];
    
}

- (void)msgAlert{}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
