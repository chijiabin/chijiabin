//
//  CardTypeList.m
//  Ubate
//
//  Created by sunbin on 2017/2/5.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "CardTypeList.h"
#import "BindingcardListCell.h"
#import "CardDetai.h"
#import "Addcard.h"
#import "LoadHtml.h"

static NSString * BindingcardListIden    = @"BindingcardList_Identifier";

@interface CardTypeList ()
@property (nonatomic ,assign) BingMethodMethod bingCardCount;

@property (nonatomic ,strong) NSMutableArray *bingCardNumAry;
@property (nonatomic ,strong) NSMutableArray *nobingCardNumAry;

@end

@implementation CardTypeList
{
    YUserInfo *userInfor;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.title = NSLocalizedString(@"转出帐号", @"Binding transfer accounts");
    //返回主视图
    [NHUtils pushAndPop:@"YReal_NameAuthentication" range:NSMakeRange(1, 1) currentCtl:self];

    [self loadData];
    WEAKSELF;
    [self bingCardManage:^(BingMethodMethod bingCardCount, NSMutableArray *bingCardNumAry, NSMutableArray *nobingCardNumAry) {
        weakSelf.bingCardCount    = bingCardCount;
        weakSelf.bingCardNumAry   = bingCardNumAry;
        weakSelf.nobingCardNumAry = nobingCardNumAry;
    }];
    [self.tableView reloadData];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];

}

- (void)loadData{
    
    userInfor = [YConfig myProfile];

}

- (void)initView{
    [self.tableView registerNib:[UINib nibWithNibName:@"BindingcardListCell" bundle:nil] forCellReuseIdentifier:BindingcardListIden];
    
    self.tableView.backgroundColor = [UIColor themeColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_bingCardCount == 2) {
        return 2;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_bingCardCount == 2) {
        if (section == 0) {
            return _bingCardNumAry.count;
        }else{
            return _nobingCardNumAry.count;
        }
    }else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    //未绑定任何
    if (_bingCardCount == 0 ) {
        cell =  [self systemCellForRowAtIndexPath:indexPath tableView:tableView];
        cell.backgroundColor = [UIColor appCellColor];
    }
    //都绑定
    if (_bingCardCount == 1 ) {
        cell = [self customCellForRowAtIndexPath:indexPath tableView:tableView];
        
    }
    //部分绑定
    if (_bingCardCount == 2 ) {
        NSInteger section = indexPath.section;
        if (section == 0) {
            cell = [self customCellForRowAtIndexPath:indexPath tableView:tableView];
            
        }
        
        if (section == 1) {
            cell = [self systemCellForRowAtIndexPath:indexPath tableView:tableView];
            cell.backgroundColor = [UIColor appCellColor];
        }
    }
    return cell;
}


- (UITableViewCell *)systemCellForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
    NSDictionary *dic = [_nobingCardNumAry objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"name"];
    cell.imageView.image =  Icon([dic objectForKey:@"icon"]);
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}


//绑定后
- (UITableViewCell *)customCellForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    
    BindingcardListCell *cell = [tableView dequeueReusableCellWithIdentifier:BindingcardListIden forIndexPath:indexPath];
    
    NSDictionary *dic = [_bingCardNumAry objectAtIndex:indexPath.row];
    
    NSString *make = [dic objectForKey:@"make"];

    //绑定全部
    
    //1银行卡
    if ([make isEqualToString:@"2"]) {
        cell.account.text = [NHUtils cipherShowText:Bank_Card cipherData:[dic objectForKey:@"account"]];
        
        
        NSString *bankImage = userInfor.bank_code;
        cell.accountLoo.image = IMAGE(bankImage);
        
        cell.cardType.text = userInfor.bank_name;
        cell.account.textColor = [UIColor py_colorWithHexString:@"#808080"];
    }else if ([make isEqualToString:@"1"])
    {
        //2支付宝 微信
        NSString *account =  [dic objectForKey:@"account"];
        if ([account isMobileNumberClassification]) {
            cell.account.text = [NHUtils cipherShowText:Iphone cipherData:[dic objectForKey:@"account"]];
        }else if ([account isEmailAddress]){
            cell.account.text = [NHUtils cipherShowText:Email cipherData:[dic objectForKey:@"account"]];
        }else{
            cell.account.text = [NHUtils cipherShowText:PureDigital cipherData:[dic objectForKey:@"account"]];
        }
        cell.accountLoo.image = Icon([[dic objectForKey:@"icon"] stringByAppendingString:@" pay"]);
        cell.account.textColor = [UIColor py_colorWithHexString:@"#808080"];
        cell.cardType.text = NSLocalizedString(@"WeChat", @"WeChat");
    }else{
        //2支付宝 微信
        NSString *account =  [dic objectForKey:@"account"];
        if ([account isMobileNumberClassification]) {
            cell.account.text = [NHUtils cipherShowText:Iphone cipherData:[dic objectForKey:@"account"]];
        }else if ([account isEmailAddress]){
            cell.account.text = [NHUtils cipherShowText:Email cipherData:[dic objectForKey:@"account"]];            
        }else{
            cell.account.text = [NHUtils cipherShowText:PureDigital cipherData:[dic objectForKey:@"account"]];
        }
        cell.accountLoo.image = Icon([[dic objectForKey:@"icon"] stringByAppendingString:@" pay"]);
        cell.account.textColor = [UIColor py_colorWithHexString:@"#808080"];
        NSLog(@"%@" ,dic);
        cell.cardType.text = NSLocalizedString(@"alipay", @"Alipay");
    }
    
    return cell;
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSString *headerTitle;
//    
//    if (_bingCardCount == 0) {
//        headerTitle = NSLocalizedString(@"You can add the following account", @"You can add the following account");
//    }
//    if (_bingCardCount == 1) {
//        headerTitle = nil;
//    }
//    if (_bingCardCount == 2) {
//        if (section == 0) {
//            headerTitle = nil;
//        }
//        if (section == 1) {
//            headerTitle = NSLocalizedString(@"You can add the following account", @"You can add the following account");
//        }
//    }
//    return headerTitle;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //部分绑定
    if (_bingCardCount == 2) {
        if (section == 0) {
            return ScaleHeight(2.f);
        }else{
            return ScaleHeight(2.f);
        }
    }else{
        if (_bingCardCount == 0) {
            return ScaleHeight(10.f);
        }else{
            return ScaleHeight(2.f);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_bingCardCount == 2) {
        if (indexPath.section == 0) {
            return ScaleHeight(80.f);
        }else{
            return ScaleHeight(50.f);
        }
    }else{
        if (_bingCardCount == 1) {
            return ScaleHeight(80.f);
        }else{
            return ScaleHeight(50.f);
            
        }
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (_bingCardCount == 1) {
    //都绑定
        [self checkDetails:indexPath];
    }else{
        if (_bingCardCount == 2) {
            NSInteger section = indexPath.section;
            if (section == 0) {
               //绑定
                [self checkDetails:indexPath];
            }else{
            //未绑定
                [self addcarType:indexPath.row];
            }
        }else{
            [self addcarType:indexPath.row];
        }
    }
}

// 查看卡号
- (void)checkDetails:(NSIndexPath *)indexPath{
    CardDetai *cardDetai = [[CardDetai alloc] initWithStyle:UITableViewStyleGrouped];
    NSDictionary *dic = [_bingCardNumAry objectAtIndex:indexPath.row];
    cardDetai.dic = dic;
    cardDetai.userInfor = userInfor;
    [self.navigationController pushViewController:cardDetai animated:YES];
}
// 添加卡号
- (void)addcarType:(NSInteger)type{
    Addcard *addcard = kVCFromSb(@"AddcardID", @"Withdraw");
    NSDictionary *dic = [_nobingCardNumAry objectAtIndex:type];
    addcard.make = [dic objectForKey:@"make"];
    [self.navigationController pushViewController:addcard animated:NO];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
