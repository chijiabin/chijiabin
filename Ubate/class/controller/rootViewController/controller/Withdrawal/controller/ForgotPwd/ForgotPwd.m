//
//  ForgotPwd.m
//  Ubate
//
//  Created by sunbin on 2017/2/7.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "ForgotPwd.h"
#import "ForgotPwdCell.h"
#import "ForgotPwdFooterView.h"
#import "PasswordReset.h"

static NSString *ForgotPwdCell_Identifier = @"ForgotPwdCell_Identifier";

static NSString *ForgotPwdFooterView_Identifier = @"ForgotPwdFooterView_Identifier";


@interface ForgotPwd ()<ForgotPwdCellDelegate ,ForgotPwdFooterDelegate>
@property (nonatomic ,strong) NSString *enterScoder;

@end

@implementation ForgotPwd
{
    ForgotPwdFooterView *footView;
    
    BOOL isWayBackToCtl;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = [_findType stringByAppendingString:@"找回"];
    QCNetworkStatus status = [YNetworking currentNetworkStatus];
    if (status == QCNetworkStatusUnknown || status == QCNetworkStatusNotReachable) {
        [self.view showError:@"网络出错"];
    }else{
        [self requestWithUrl:_requestWithUrl params:_dic isCache:NO showHUD:NO myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg) {
            if (state == Succeed) {
                isWayBackToCtl = YES;
            }else{
                isWayBackToCtl = NO;

            }
            [self.navigationController.view showLoadFinish:msg];
        }];}
    [self pushAndPop];
}

- (void)pushAndPop{
        NSLog(@"%@" ,self.navigationController.viewControllers);
        [NHUtils pushAndPop:@"WayBack" range:NSMakeRange(2, 1) currentCtl:self];
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];[self initView];
}
- (void)loadData{
}
- (void)initView{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ForgotPwdCell" bundle:nil] forCellReuseIdentifier:ForgotPwdCell_Identifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ForgotPwdFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:ForgotPwdFooterView_Identifier];
    
    [self tapGestureRecognizer];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ForgotPwdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ForgotPwdCell_Identifier" forIndexPath:indexPath];
    cell.delegate = self;
    cell.backgroundColor = [UIColor appCellColor];
    
    [cell finfType:_findType parms:_dic urlWithStr:_requestWithUrl makeIden:_findTypeMake];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ForgotPwdFooterView_Identifier];
    footView.delegate = self;
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ScaleHeight(8);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return ScaleHeight(110.f);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScaleHeight(101.f);
}


#pragma make -ForgotPwdCellDelegate -做提示 发送成功与失败 失败后重新发送按钮失效
- (void)requestResults :(NSString *)results responsestate:(BOOL)state{
    if (state) {
    }
    [self.navigationController.view showLoadFinish:results];
}

- (void)listEnter:(NSString *)str{
    _enterScoder = str;
    if ([NHUtils isBlankString:_enterScoder]) {
        footView.nextStepBtn.enabled = NO;
    }else
    {
        footView.nextStepBtn.enabled = YES;
    }
}

#pragma make -ForgotPwdFooterDelegate -确认按钮
- (void)forgotPwdoperation:(UIButton *)btn{
    if ([NHUtils isBlankString:_enterScoder]) {
        NSLog(@"输入内容不能为空");
    }else{
        NSDictionary *params;
        NSString *account;
        if (_findTypeMake == 0) {
            params = @{
                       @"act"  :@(1),
                       @"phone":[_dic objectForKey:@"phone"],
                       @"scode":_enterScoder,
                       @"sign":SIGN
                       };
            account = [_dic objectForKey:@"phone"];
        }else{
            params = @{
                       @"act"  :@(1),
                       @"email":[_dic objectForKey:@"email"],
                       @"scode":_enterScoder,
                       @"sign":SIGN
                       };
            account = [_dic objectForKey:@"email"];
        }
        
        
        [self requestWithUrl:_requestWithUrl params:params myBlock:^(BOOL state, NSString *responseMsg) {
            if (state) {
                
                PasswordReset *reset = kVCFromSb(@"PasswordResetID", @"Withdraw");
                
                reset.findTypeMake = _findTypeMake;
                reset.findType = account;
                reset.requestWithUrl = _requestWithUrl;
                [self.navigationController pushViewController:reset animated:NO];
            }else{
                [NHUtils alertAction:@selector(responseMsgError) alertControllerWithTitle:@"提示" Message:responseMsg Vctl:self Cancel:NO];
                
            }
        }];

    }

}
- (void)responseMsgError{}

- (void)requestWithUrl:(NSString *)url
                params:(NSDictionary *)params myBlock:(void (^)(BOOL state,NSString * responseMsg))states{
    [YNetworking postRequestWithUrl:url params:params cache:NO successBlock:^(id returnData, int code, NSString *msg) {
        if (code == 1) {
            NSDictionary *dic =(NSDictionary *)returnData;
            NSLog(@"%@" ,dic);
            states(YES,msg);
        }else{
            states(false,msg);
            
        }
        
    } failureBlock:^(NSError *error) {
        states(NO,error.localizedDescription);
        
    } showHUD:NO];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}



- (void)tapGestureRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)
                                   ];
    tap.cancelsTouchesInView = NO;
    tap.numberOfTapsRequired = 1;tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void)endEditing
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
