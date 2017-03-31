//
//  ForgotPwdCell.m
//  Ubate
//
//  Created by sunbin on 2016/12/5.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "ForgotPwdCell.h"
#import "UIButton+countDown.h"

@interface ForgotPwdCell()
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *scode;

@property (weak, nonatomic) IBOutlet UIButton *countDown;
@property (nonatomic ,strong) NSDictionary *params;
@property (nonatomic ,strong) NSString *requestWithUrl;


@end
@implementation ForgotPwdCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self loadView];

}

- (void)finfType:(NSString *)type parms:(NSDictionary *)parms urlWithStr:(NSString *)requestWithUrl makeIden:(NSInteger)make{
    [_account leftViewModeWithConstrainedToWidth:100.f text:type isLaunchScreen:NO];
    _params = parms;
    _requestWithUrl = requestWithUrl;
    if (make == 0) {
        _account.text = [parms objectForKey:@"phone"];

    }else{
        _account.text = [parms objectForKey:@"email"];

    }
    
    

}


- (void)loadView{

    [_scode leftViewModeWithConstrainedToWidth:100.f text:@"验证码" isLaunchScreen:NO];
    
    
    QCNetworkStatus status = [YNetworking currentNetworkStatus];
    
    if (status == QCNetworkStatusUnknown || status == QCNetworkStatusNotReachable) {
        [_countDown setTitle:@"网络故障" forState:UIControlStateNormal];
    }else{
        [_countDown startTime:59 title:@"重新发送" waitTittle:@"秒" respond:^(BOOL isPlayComple) {
            
        }];
    }
    
}

- (IBAction)toResend:(UIButton *)sender {
    WEAKSELF;
    [self requestWithUrl:_requestWithUrl params:_params isCache:NO showHUD:NO myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg) {
        NSLog(@"%@" ,[responseResults objectForKey:@"code"]);
        if ([weakSelf.delegate respondsToSelector:@selector(requestResults:responsestate:)]) {
            [weakSelf.delegate requestResults:msg responsestate:state];
        }
        if (state == Succeed) {
            [weakSelf.countDown startTime:59 title:@"重新发送验证码" waitTittle:@"秒" respond:^(BOOL isPlayComple) {
            }];
        }
        if (state == Error) {}
        if (state == Failure) {}

    }];
    

}



- (IBAction)editingChanaged:(UITextField *)sender {
    if ([self.delegate respondsToSelector:@selector(listEnter:)]) {
        [self.delegate listEnter:sender.text];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
