//
//  TransferAccountsList.m
//  Ubate
//
//  Created by sunbin on 2017/2/7.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "TransferAccountsList.h"
#import "WithdrawOperation.h"
#import "bingAccoutCell.h"
#import "Addcard.h"
static NSString * bingAccoutIden    = @"bingAccout_Identifier";

@interface TransferAccountsList ()
@property (nonatomic, retain) NSIndexPath* checkedIndexPath;

@end

@implementation TransferAccountsList
{
    YUserInfo *userInfor;
    WithdrawOperation *withdrawOperation;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"切换帐号", @"Switch account");
    //获取数据 绑定账号数据
    WEAKSELF;
    [self bingCardManage:^(BingMethodMethod bingCardCount, NSMutableArray *bingCardNumAry, NSMutableArray *nobingCardNumAry) {
        weakSelf.bingCardCount   = bingCardCount;
        weakSelf.selectCardAry   = bingCardNumAry;
        weakSelf.unSelectCardAry = nobingCardNumAry;
        [weakSelf defaultSelect:weakSelf];
        
    }];
    
    [self loadData];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


//默认选中某单元格
- (void)defaultSelect:(TransferAccountsList *)ctl{

    if (ctl.bingCardCount) {
        
       NSString *fromeCardDetaiMake = [USER_DEFAULT objectForKey:@"CARDDETAITOWITHDRAWMAKEIDENTIFIER"];

        if ([NHUtils isBlankString:fromeCardDetaiMake]) {
            NSString *makeidentifier = [USER_DEFAULT objectForKey:@"MAKEIDENTIFIER"];
            if ([NHUtils isBlankString:makeidentifier]) {
                makeidentifier = @"0";
            }
            ctl.selectedIndex = [makeidentifier integerValue];
            ctl.checkedIndexPath = [NSIndexPath indexPathForRow:ctl.selectedIndex inSection:0];
            UITableViewCell *cell = [ctl.tableView cellForRowAtIndexPath:ctl.checkedIndexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            [ctl.selectCardAry enumerateObjectsUsingBlock:^(NSDictionary *objDic, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[objDic objectForKey:@"make"] integerValue] == ctl.cardDetailsselectedIndex) {
                    ctl.checkedIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                    UITableViewCell *cell = [ctl.tableView cellForRowAtIndexPath:ctl.checkedIndexPath];
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            }];
            
        }

    }
    [self.tableView reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];[self initView];
}


- (void)initView{
    [NHUtils tableViewProperty:self.tableView registerNib:@"bingAccoutCell" forCellReuseIdentifier:bingAccoutIden];
}


- (void)loadData{
    userInfor = [YConfig myProfile];
    for (UIViewController * objCtl in self.navigationController.viewControllers) {
        if ([objCtl isKindOfClass:[WithdrawOperation class]]) {
            withdrawOperation =(WithdrawOperation *) objCtl;
            break;
        }
    }
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
            return _selectCardAry.count;
        }else{
            return _unSelectCardAry.count;
        }
    }else{
        return 3; }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (_bingCardCount == 0 ) {
        cell =  [self systemCellForRowAtIndexPath:indexPath tableView:tableView];
    }
    
    if (_bingCardCount == 1 ) {
        cell = [self customCellForRowAtIndexPath:indexPath tableView:tableView];
    }
    if (_bingCardCount == 2 ) {
        NSInteger section = indexPath.section;
        if (section == 0) {
            cell = [self customCellForRowAtIndexPath:indexPath tableView:tableView];
        }
        
        if (section == 1) {
            cell = [self systemCellForRowAtIndexPath:indexPath tableView:tableView];
        }    }
    return cell;
}

- (UITableViewCell *)systemCellForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
    NSDictionary *dic = [_unSelectCardAry objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"name"];
    cell.imageView.image =  Icon([dic objectForKey:@"icon"]);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (UITableViewCell *)customCellForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    
    bingAccoutCell *cell = [tableView dequeueReusableCellWithIdentifier:bingAccoutIden forIndexPath:indexPath];
    
    if([self.checkedIndexPath isEqual:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (_selectCardAry.count >(long)indexPath.row) {
        NSLog(@"indexPath.row===%ld" ,(long)indexPath.row);
        NSDictionary *dic = [_selectCardAry objectAtIndex:indexPath.row];
        NSLog(@"%@" ,dic);
        cell.accountName.text = [dic objectForKey:@"name"];
        NSString *account =  [dic objectForKey:@"account"];
        
        NSString *make = [dic objectForKey:@"make"];
        if ([make isEqualToString:@"2"]) {
            cell.accountNum.text = [NSString stringWithFormat:@"尾号%@储蓄卡",[account substringFromIndex:account.length-4]];
            
            
            NSString *bankImage = userInfor.bank_code;
            [cell.accounLog mac_setImageWithURL:[NSURL URLWithString:bankImage] placeholderImage:Icon(bankImage)];
        }else{
            cell.accounLog.image = Icon([dic objectForKey:@"icon"]);
            
            NSString *accountMake;
            if ([account isEmailAddress]) {
                accountMake = [NHUtils cipherShowText:Email cipherData:account];
            }else if ([account isMobileNumberClassification]){
                accountMake = [NHUtils cipherShowText:Iphone cipherData:account];
            }else{
                accountMake = [NHUtils cipherShowText:PureDigital cipherData:account];
            }
            cell.accountNum.text  = accountMake;
            
        }
        

    }
    cell.accountNum.textColor = [UIColor py_colorWithHexString:@"#808080"];
    cell.accountName.textColor = [UIColor py_colorWithHexString:@"#4c4c4c"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [USER_DEFAULT removeObjectForKey:@"CARDDETAITOWITHDRAWMAKEIDENTIFIER"];

    //部分 绑定账号
    if (_bingCardCount == 2) {
        if (indexPath.section == 0) {
            [self selectMakeIden:indexPath tableView:tableView];//切换账号
            
        }else{
            [self bingCard:indexPath];//添加绑定 账号
        }
        //全部绑定
    }else if (_bingCardCount == 1){
        [self selectMakeIden:indexPath tableView:tableView]; //切换账号
        
    }else{
        //1.没有任何账号绑定
        [self bingCard:indexPath];
    }
    
}
- (void)noRealNameAuthentication{
    [self gotoRealNameAuthentication];
    
}
- (void)gotoRealNameAuthentication{
    [self.navigationController pushViewController:kVCFromSb(@"YReal_NameAuthenticationID", @"YMember") animated:NO];
}

- (void)selectMakeIden:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    
#pragma BCARDTYPEMAKE-这里表示make标识符 0支付宝  1微信   2银行  MAKEIDENTIFIER数组元素的下标
    NSString *bCardType = [[_selectCardAry objectAtIndex:indexPath.row] objectForKey:@"make"];
    [USER_DEFAULT setObject:bCardType forKey:@"BCARDTYPEMAKE"];
    
    
    NSString *make = [NSString stringWithFormat:@"%ld" ,(long)indexPath.row];
    
    bingAccoutCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.checkedIndexPath = indexPath;
    
    [USER_DEFAULT setObject:make forKey:@"MAKEIDENTIFIER"];
    [withdrawOperation.tableView reloadData];
    [self.navigationController popToViewController:withdrawOperation animated:NO];
    
}
- (void)bingCard:(NSIndexPath*)indexPath{
    Addcard *addcard = kVCFromSb(@"AddcardID", @"Withdraw");
    
    NSDictionary *dic = [_unSelectCardAry objectAtIndex:indexPath.row];
    addcard.make = [dic objectForKey:@"make"];
    [self.navigationController pushViewController:addcard animated:NO];
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (_bingCardCount == 2) {
        if (section == 0) {
            return nil;
        }else{return @"";}
        
    }else if (_bingCardCount == 0){
        return @"";
    }else{
        return nil;
    }
    
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_bingCardCount == 2) {
        if (indexPath.section == 0) {
            return [SizeProportion SizeProportionWithHeight:65.f];
        }else{
            return [SizeProportion SizeProportionWithHeight:45.f];
        }
    }else{
        return [SizeProportion SizeProportionWithHeight:55.f];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_bingCardCount == 2) {
        if (section == 0) {
            return [SizeProportion SizeProportionWithHeight:8.f];
        }else{
            return [SizeProportion SizeProportionWithHeight:10.f];
        }
    }else{
        return [SizeProportion SizeProportionWithHeight:8.f];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}





@end
