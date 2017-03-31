//
//  Messageswitch.m
//  Ubate
//
//  Created by sunbin on 2016/12/13.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "Messageswitch.h"
#import "SwitchGroup.h"
#import "MessagesType.h"
#import "logOut.h"

@interface Messageswitch ()
@property (nonatomic, strong) NSMutableArray *cellDefs;

@end

@implementation Messageswitch
{
    UISwitch *switchView;
    NSUserDefaults *userDefaults;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self loadData];
}
- (void)initView{
    [self tableViewAttributes];
    [self addSwitchView];

}

- (void)tableViewAttributes
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = [UIColor appSeparatorColor];
    self.tableView.backgroundColor = [UIColor themeColor];

}

- (void)addSwitchView{
    switchView = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-67, 9, 32, 32)];
    
    if ([[USER_DEFAULT stringForKey:@"MainSwitch"] isEqualToString:@"1"]) {
        switchView.on = YES;
        
    }else if([[USER_DEFAULT stringForKey:@"MainSwitch"] isEqualToString:@"0"]){
        switchView.on = NO;
        
    }else{
    
        switchView.on = YES;
    }
    
    
    [switchView addTarget:self action:@selector(switchOn:) forControlEvents:UIControlEventValueChanged];


}

- (void)loadData{
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    _cellDefs = [[NSMutableArray alloc] init];
    self.title = NSLocalizedString(@"新消息提醒", @"New message reminder");
    NSArray *titles = @[NSLocalizedString(@"新消息提醒", @"New message reminder")];
    for (int i = 0; i < titles.count; i++)
    {
        SwitchGroup*group = [[SwitchGroup alloc] init];
        group.title = titles[i];
//        NSArray *MType = @[NSLocalizedString(@"新资讯提醒",@"New information reminder") ,
//                           NSLocalizedString(@"转出回赠提醒", @"Turn back to remind"),
//                           NSLocalizedString(@"新增共享用户提醒", @"Add shared user alerts") ,
//                           NSLocalizedString(@"共享回赠增加提醒", @"Share rebate increase reminder")];
//        [MType enumerateObjectsUsingBlock:^(NSString *messageType, NSUInteger idx, BOOL * _Nonnull stop) {
//            MessagesType *model = [[MessagesType alloc] init];
//            model.messageType = messageType;
//            if (!group.members)
//            {
//                group.members = [NSMutableArray array];
//            }
//            [group.members addObject:model];
//        }];
        [self.cellDefs addObject:group];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SwitchGroup *group = _cellDefs[0];
    
#pragma make-默认都关闭
   NSString *MainSwitchState = [USER_DEFAULT objectForKey:@"MainSwitch"];
    if ([NHUtils isBlankString:MainSwitchState]) {
        return 0;
    }else{
        if ([[USER_DEFAULT objectForKey:@"MainSwitch"] isEqualToString:@"0"]) {
            return 0;
        }else{
            return group.members.count;
            
        }

    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.backgroundColor = [UIColor appCellColor];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.textLabel.font = FONT_FONTMicrosoftYaHei(14.f);
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UISwitch *switchV = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, [SizeProportion SizeProportionWithHeight:32], [SizeProportion SizeProportionWithHeight:32])];

    NSInteger row = indexPath.row;
    switch (row) {
        case 0:{
            if ([USER_DEFAULT objectForKey:@"MAKE0"]) {
                switchV.on = NO;
            }else{
                switchV.on = YES;}}
            
            break;
//        case 1:{
//            
//            if ([USER_DEFAULT objectForKey:@"MAKE1"]) {
//                switchV.on = NO;
//            }else{
//                switchV.on = YES;}}
//            break;
//            
//        case 2:{
//            if ([USER_DEFAULT objectForKey:@"MAKE2"]) {
//                switchV.on = NO;
//            }else{
//                switchV.on = YES;
//            }}
//            
//            break;
//            
//        case 3:{
//            if ([USER_DEFAULT objectForKey:@"MAKE3"]) {
//                switchV.on = NO;
//            }else{
//                switchV.on = YES;
//            }}
//            break;
            
        default:
            break;
    }
    switchV.tag = indexPath.row;
    [switchV addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = switchV;
    cell.backgroundColor = [UIColor py_colorWithHexString:@"FAFAFA"];
    cell.contentView.backgroundColor =  [UIColor py_colorWithHexString:@"FAFAFA"];
    
    
    SwitchGroup *group = _cellDefs[indexPath.section];
    
    if ([[USER_DEFAULT objectForKey:@"MainSwitch"] isEqualToString:@"0"]) {
        cell.textLabel.text = group.title;
    }else{
        MessagesType * model = group.members[indexPath.row];
        cell.textLabel.text = model.messageType;
    }

    return cell;
}





- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScaleHeight(50.f))];
    view.backgroundColor = [UIColor appCellColor];
    SwitchGroup *group = _cellDefs[section];
    if (group.isShow)
    {
    }
    else
    {
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, ScaleHeight(50.f))];
    label.font = FONT_FONTMicrosoftYaHei(15.f);
    label.text = [_cellDefs[section] title];
    [view addSubview:label];
    
    view.tag = 100+section;
    
    view.layer.shadowOffset = CGSizeMake(0, 0.03);
    view.layer.shadowOpacity = 0.1;
    
    
    [view addSubview:switchView];
    switchView.py_centerY =view.py_centerY;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScaleHeight(50.f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScaleHeight(50.f);
}

- (void)tap{
    
    SwitchGroup *group = _cellDefs[0];
    
    [UIView animateWithDuration:0.1 animations:^{
        if (group.isShow){}else{}
    } completion:^(BOOL finished) {
        if (finished)
        { [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic]; }
    }];
}




-(void)switchOn:(UISwitch *)sender
{
    
//    [USER_DEFAULT removeObjectForKey:@"MainSwitch"];
//    [USER_DEFAULT synchronize];
    
    UISwitch *mySwitch = (UISwitch *)sender;
    if (mySwitch.isOn) {
        NSLog(@"sectionView开启");
        
    
        //注册远程推送
        [[UIApplication sharedApplication] registerForRemoteNotifications];

        
        
        mySwitch.on = YES;
      //  [self jPush];
        
        
        [USER_DEFAULT setObject:@"1" forKey:@"MainSwitch"];
    }else{
        
         mySwitch.on = NO;
        NSLog(@"sectionView关闭");
        
        //注销远程推送
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        

        
        //注销极光推送
      //  [[logOut sharedlogOut]Outaurora];
        
        
        [USER_DEFAULT setObject:@"0" forKey:@"MainSwitch"];
        
        
//        
//        for (int i = 0; i<4; i++) {
//            NSString * senderNO = [NSString stringWithFormat:@"%d",i];
//            NSString *switch_make = [@"MAKE" stringByAppendingString:senderNO];
//            //全部关闭
//            [USER_DEFAULT setObject:senderNO forKey:switch_make];
//        }
    }
//    [USER_DEFAULT synchronize];
//    [self tap];
    
}



-(void)switchAction:(UISwitch *)sender{
    
    NSString * senderNO = [NSString stringWithFormat:@"%ld" ,(long)sender.tag];
    NSString *switch_make = [@"MAKE" stringByAppendingString:senderNO];
    
    [USER_DEFAULT removeObjectForKey:switch_make];
    [USER_DEFAULT synchronize];
    
    UISwitch *mySwitch = (UISwitch *)sender;
    if (mySwitch.isOn) {
        NSLog(@"开启 %ld" , (long)sender.tag);
        [USER_DEFAULT removeObjectForKey:switch_make];
        
    }else{
        NSLog(@"关闭=%ld" ,(long)sender.tag);
        [USER_DEFAULT setObject:senderNO forKey:switch_make];
    }
    
}

- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    //  NSLog(@"%@", error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}


@end
