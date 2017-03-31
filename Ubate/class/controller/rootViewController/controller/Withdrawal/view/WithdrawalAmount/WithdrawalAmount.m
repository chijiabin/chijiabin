//
//  WithdrawalAmount.m
//  Ubate
//
//  Created by sunbin on 2016/12/1.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "WithdrawalAmount.h"
#import "AccountMoneySingle.h"

@interface WithdrawalAmount()

@property (nonatomic ,strong) NSString *allmoney;
@property (weak, nonatomic) IBOutlet UILabel *transferAmountLab;

@property (weak, nonatomic) IBOutlet UIButton *allPutLab;
@end

@implementation WithdrawalAmount
@synthesize txtMoney;

//设置 文本输入框属性 只能输入数字 左边视图
- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    _transferAmountLab.text = NSLocalizedString(@"转出金额", @"Transfer amount");
    [_allPutLab setTitle:NSLocalizedString(@"全部转出", @"All put") forState:UIControlStateNormal];
    [_allPutLab setTintColor:[UIColor py_colorWithHexString:@"1074b7"]];
    
    
    
    filterMoney = [[TextFilter alloc] init];
    [txtMoney leftViewModeWithConstrainedToWidth:30.f text:@"￥" isLaunchScreen:NO fon:30.f leftFonColor:@"333333" bodyFonColor:@"999999" PlaceholderColor:@"333333"];

    [filterMoney SetMoneyFilter:txtMoney delegate:self];

    
    NSDictionary *dic = [AccountMoneySingle sharedAccountMoneySingle].dic;
    _allmoney = IF_NULL_TO_STRING([dic objectForKey:@"account_money"]);
    

}

//代理 -是否Return键
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//监听文本输入框变化
- (IBAction)editingChange:(UITextField *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGEBTNSTATE object:nil userInfo:@{@"key":sender.text}];
    
 
    CGFloat money =  [sender.text floatValue];    
    if (money > [_allmoney floatValue]) {
        txtMoney.textColor = [UIColor redColor];

    }else{
        txtMoney.textColor = [UIColor py_colorWithHexString:@"333333"];
    }
    _myBlock(txtMoney,_allmoney);

    
}



//文本-富文本 显示可提现金额和
- (void)moneyValue:(NSString *)money{
    _availableMoney.text = money;
    NSArray *ary = [money componentsSeparatedByString:@"￥"];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:money];

    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor py_colorWithHexString:@"999999"]
                             range:NSMakeRange([ary[0] length], [ary[1] length]+1)];
    
    _availableMoney.attributedText = attributedString;
}


//全部转出事件
- (IBAction)allDrawalAmount:(UIButton *)sender {    
    
    if ([self.delegate respondsToSelector:@selector(onClickAllDrawalAmountBtn:availableMoney:showEnterTextfile:isSelect:)]) {
        [self.delegate onClickAllDrawalAmountBtn:sender availableMoney:_allmoney showEnterTextfile:txtMoney isSelect:NO];
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
