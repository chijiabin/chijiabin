//
//  YSex.m
//  Ubate
//
//  Created by sunbin on 2017/2/8.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "YSex.h"

@interface YSex ()
@property (nonatomic ,strong) NSArray *cellDefs;
@property (nonatomic, retain) NSIndexPath* checkedIndexPath;

@end

@implementation YSex
{
    YUserInfo *userInfor;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    userInfor = [YConfig myProfile];
    NSInteger selectedIndex ;
    NSArray *sexAry = @[@"男" ,@"女"];
    NSLog(@"%@" ,userInfor.sex);
    /**
     *  当未选中为空时
     */
    if ([userInfor.sex isBlankString]) {
    }else{
        if ([[sexAry objectAtIndex:0] isEqualToString:userInfor.sex]) {
            selectedIndex = 0;
        }else if ([[sexAry objectAtIndex:1] isEqualToString:userInfor.sex]){
            selectedIndex = 1;
        }else{
        }
        _checkedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_checkedIndexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData]; [self initView];
}
- (void)loadData{
    
    self.title = @"性别";
    _cellDefs = @[@"男" ,@"女"];
}

- (void)initView{
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor  = [UIColor appSeparatorColor];
    self.tableView.backgroundColor = [UIColor themeColor];
    [self tableViewAttributes];
    
}

- (void)tableViewAttributes
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellDefs.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if ([userInfor.sex isBlankString]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        if([self.checkedIndexPath isEqual:indexPath])
        {cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    cell.backgroundColor = [UIColor appCellColor];
    cell.textLabel.text = [_cellDefs objectAtIndex:indexPath.row];
    return cell;
    
}

#pragma make 当前选中  注意当未选中时为空==bug checkedIndexPath为空
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    WEAKSELF;
    
#pragma make ruo选择之前一样的就不做网络请求
    if ([userInfor.sex isBlankString]) {
        NSString *sex;
        if (indexPath.row == 0){
            sex = @"男";
        }else{
            sex = @"女";
        }
        
        NSDictionary *params = @{
                                 @"uid": @([YConfig getOwnID]),
                                 @"sex":sex,
                                 @"sign":[YConfig getSign]};
        
        
         [YNetworking postRequestWithUrl:editInfo params:params cache:YES successBlock:^(id returnData, int code, NSString *msg) {
             if (code == 1) {
                 if(weakSelf.checkedIndexPath)
                 {
                     UITableViewCell* uncheckCell = [tableView
                                                     cellForRowAtIndexPath:weakSelf.checkedIndexPath];
                     uncheckCell.accessoryType = UITableViewCellAccessoryNone;
                 }
                 UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
                 cell.accessoryType = UITableViewCellAccessoryCheckmark;
                 weakSelf.checkedIndexPath = indexPath;
                 [weakSelf.navigationController popViewControllerAnimated:YES];
                 
                 userInfor.sex = sex;
                 kAppDelegate.userInfo = userInfor;

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
                 [weakSelf.navigationController.view showError:msg];
                 
             }
             
         } failureBlock:^(NSError *error) {
             
         } showHUD:YES];
        
        
        
//        [self requestWithUrl:editInfo params:params isCache:NO showHUD:YES myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg) {
//            if (state == Succeed) {
//                if(weakSelf.checkedIndexPath)
//                {
//                    UITableViewCell* uncheckCell = [tableView
//                                                    cellForRowAtIndexPath:weakSelf.checkedIndexPath];
//                    uncheckCell.accessoryType = UITableViewCellAccessoryNone;
//                }
//                UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//                cell.accessoryType = UITableViewCellAccessoryCheckmark;
//                weakSelf.checkedIndexPath = indexPath;
//                [weakSelf.navigationController popViewControllerAnimated:YES];
//                
//                userInfor.sex = sex;
//                kAppDelegate.userInfo = userInfor;
// 
//            }else{
//                [weakSelf.navigationController.view showError:msg];
//
//            }
//        }];
        
        
        
    }else{
        NSLog(@"checkedIndexPath=%ld   ,indexPath=%ld" ,(long)_checkedIndexPath.row ,(long)indexPath.row);
        if (self.checkedIndexPath.row == indexPath.row) {
            NSLog(@"相同");
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString *sex;
            if (indexPath.row == 0){
                sex = @"男";
            }else{
                sex = @"女";
            }
            NSDictionary *params = @{
                                     @"uid": @([YConfig getOwnID]),
                                     @"sex":sex,
                                     @"sign":[YConfig getSign]};
            
             [YNetworking postRequestWithUrl:editInfo params:params cache:YES successBlock:^(id returnData, int code, NSString *msg) {
                 if (code == 1) {
                     if(self.checkedIndexPath)
                     {
                         UITableViewCell* uncheckCell = [tableView
                                                         cellForRowAtIndexPath:self.checkedIndexPath];
                         uncheckCell.accessoryType = UITableViewCellAccessoryNone;
                     }
                     UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
                     cell.accessoryType = UITableViewCellAccessoryCheckmark;
                     self.checkedIndexPath = indexPath;
                     [self.navigationController popViewControllerAnimated:YES];
                     
                     userInfor.sex = sex;
                     kAppDelegate.userInfo = userInfor;
                 }
                 else if(code == 201){
                     
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
                     [weakSelf.navigationController.view showError:msg];
                     
                 }
                 
             } failureBlock:^(NSError *error) {
                 
             } showHUD:YES];
            
            
            
//            [self requestWithUrl:editInfo params:params isCache:NO showHUD:YES myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg) {
//                if (state == Succeed) {
//                    if(self.checkedIndexPath)
//                    {
//                        UITableViewCell* uncheckCell = [tableView
//                                                        cellForRowAtIndexPath:self.checkedIndexPath];
//                        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
//                    }
//                    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//                    self.checkedIndexPath = indexPath;
//                    [self.navigationController popViewControllerAnimated:YES];
//                    
//                    userInfor.sex = sex;
//                    kAppDelegate.userInfo = userInfor;
//
//                }else{
//                    [weakSelf.navigationController.view showError:msg];
//
//                }
//            }];
        }}
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [SizeProportion SizeProportionWithHeight:45.f];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [SizeProportion SizeProportionWithHeight:10.f];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
