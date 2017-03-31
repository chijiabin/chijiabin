//
//  Province.m
//  Ubate
//
//  Created by sunbin on 2016/12/15.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "Province.h"
#import "YCity.h"

#import "ProvinceCell.h"

static NSString *ProvinceHeaderIden = @"ProvinceHeaderIden_Identifier";
static NSString *cellID = @"Cell_Identifier";

@interface Province ()
@property (nonatomic ,strong) NSMutableArray *provinceAry;
@end

@implementation Province
{
    YUserInfo *userInfor;
    YCity *city;

    NSArray *addressAry;
    
    NSString *loc;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   NSString *area    = IF_NULL_TO_STRING(userInfor.area);
   NSString *content = [_dic objectForKey:@"content"];
   NSString *res     = [_dic objectForKey:@"res"];
    
    
    if ([res isEqualToString:@"1"]) {
        loc = content;
      NSString *LocationArea = [[content componentsSeparatedByString:@"-"] lastObject];
        
        if ([LocationArea isEqualToString:area]) {
            NSIndexPath *_checkedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_checkedIndexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    }else{
        NSLog(@"定位出错");
        loc = @"定位出错";

    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@" ,_dic);
    userInfor = [YConfig myProfile];

    
    [self loadData], [self initView];
}

- (void)loadData{
    _provinceAry =  [[NSMutableArray alloc] init];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
    addressAry = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *dic in addressAry) {
        NSString *state = [dic objectForKey:@"state"];
        if ([state isEqualToString:@"国外"] ) { }else{
            if ([state isEqualToString:userInfor.province])
            {
                [_provinceAry insertObject:dic atIndex:0];
            }else{
                [_provinceAry addObject:dic];
            }
        }}
}

- (void)initView{

    [self tableViewAttributes];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ProvinceCell" bundle:nil] forCellReuseIdentifier:ProvinceHeaderIden];
    
    self.view.backgroundColor = [UIColor themeColor];
}

- (void)tableViewAttributes
{
    
    [self tableViewSetSeparatorInset];
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
}

- (void)tableViewSetSeparatorInset{
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.separatorColor = [UIColor py_colorWithHexString:@"#cccccc"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    
    if (section == 1) {
        return _provinceAry.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        ProvinceCell *cell = [tableView dequeueReusableCellWithIdentifier:ProvinceHeaderIden forIndexPath:indexPath];
        
        [cell locationResult:loc];
        return cell;
    }
    
    if (section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.textLabel setFont:FONT_FONTMicrosoftYaHei(14)];
            [cell.textLabel setTextColor:[UIColor py_colorWithHexString:@"333333"]];
        }
        cell.textLabel.text = [[_provinceAry objectAtIndex:indexPath.row] objectForKey:@"state"];
        if ([userInfor.city isEmpty]) {
            
        }else{
            if (indexPath.row == 0) {
                if ( [[userInfor.province isEmpty:@""] isEqualToString:[userInfor.city isEmpty:@""]])
                {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@", [userInfor.province isEmpty:@""],[userInfor.area isEmpty:@""]];
                }else{
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@-%@", [userInfor.province isEmpty:@""],[userInfor.city isEmpty:@""],[userInfor.area isEmpty:@""]];
                }
            }else
            {
                cell.detailTextLabel.text  = @"";
            }
        }
        
        cell.backgroundColor = [UIColor appCellColor];
        return cell;
    }

    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    
    if (section == 0) {

        
        ProvinceCell *cell = (ProvinceCell*)[tableView cellForRowAtIndexPath:indexPath];
        NSArray *ary = [cell.areInfor.titleLabel.text componentsSeparatedByString:@"-"];
        if ([userInfor.area isEqualToString:[ary lastObject]]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            if (ary.count == 2) {
                //直辖市
                
                NSDictionary *params = @{@"uid":@([YConfig getOwnID]),
                                         @"province":[ary firstObject] ,
                                         @"city":[ary firstObject],
                                         @"area":[ary lastObject],
                                         @"sign":[YConfig getSign]};
                
                [self Networking:params];

                
            }else if (ary.count == 3){
                NSDictionary *params = @{@"uid":@([YConfig getOwnID]),
                                         @"province":[ary firstObject] ,
                                         @"city":[ary objectAtIndex:1],
                                         @"area":[ary lastObject],
                                         @"sign":[YConfig getSign]};
                [self Networking:params];

            }else{
                [NHUtils alertAction:@selector(locationerror) alertControllerWithTitle:@"错误" Message:@"目前没有定位到任何位置,请稍后再试" Vctl:self Cancel:NO];
                
            }}

        
        
    }
    if (section == 1) {
        city = [[YCity alloc] initWithStyle:UITableViewStylePlain];
        city.title = [[_provinceAry objectAtIndex:indexPath.row] objectForKey:@"state"];
        city.citiesAry = [[_provinceAry objectAtIndex:indexPath.row] objectForKey:@"cities"];
        [self.navigationController pushViewController:city animated:YES];
        

    }

    
}

- (void)locationerror{}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;

    if (section == 0) {
        return [SizeProportion SizeProportionWithHeight:50.f];
    }
    if (section == 1) {
        return [SizeProportion SizeProportionWithHeight:45.f];

    }
    return 0;

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [SizeProportion SizeProportionWithHeight:10.f];
    }
    if (section == 1) {
        return [SizeProportion SizeProportionWithHeight:10.f];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return @"全部";
//    }
//    if (section == 1) {
//        return nil;
//    }
//    return nil;
//}



- (void)Networking:(NSDictionary *)params{
    WEAKSELF;
    [YNetworking postRequestWithUrl:editInfo params:params cache:NO successBlock:^(id returnData, int code, NSString *msg) {
        if (code == 1) {
            userInfor.province = [params objectForKey:@"province"];
            userInfor.city = [params objectForKey:@"city"];
            userInfor.area = [params objectForKey:@"area"];
            kAppDelegate.userInfo = userInfor;
            [weakSelf.navigationController popViewControllerAnimated:YES];
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
            NSLog(@"错误%@" ,msg);
            [weakSelf.navigationController.view showError:msg];
        }
    } failureBlock:^(NSError *error) {
        
        [weakSelf.navigationController.view showError:error.localizedDescription];

    } showHUD:YES];
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
