//
//  YScanPay.h
//  Ubate
//
//  Created by sunbin on 2017/2/10.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "YStaticCell.h"
#import "TextFilter.h"

@interface YScanPay : BaseViewController
{
    TextFilter *filterMoney;
}

@property (nonatomic ,assign) NSInteger store_id;
//输入消费金额
@property (weak, nonatomic) IBOutlet UITextField *enterAmount;
//返现金额
@property (weak, nonatomic) IBOutlet UILabel *cashBackValue;
//公司名字
@property (weak, nonatomic) IBOutlet UILabel *company_name;
//地址
@property (weak, nonatomic) IBOutlet UILabel *address;
//返现率
@property (weak, nonatomic) IBOutlet UILabel *valueR1;



@end
