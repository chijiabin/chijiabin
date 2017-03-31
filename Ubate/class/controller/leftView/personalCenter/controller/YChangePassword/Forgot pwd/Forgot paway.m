//
//  Forgot paway.m
//  Ubate
//
//  Created by 池先生 on 17/3/20.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "Forgot paway.h"
#import "CodeVC.h"
#import "ForgotTableViewCell.h"
#import "ForgotPasswordModel.h"
@interface Forgot_paway (){

    NSString *titleForHeaderInSection;//头部显示表示文字
    YUserInfo *userInfor;
}
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation Forgot_paway

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userInfor = [YConfig myProfile];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = NSLocalizedString(@"忘记密码", @"Forgot_paway");
    
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor  = [UIColor appSeparatorColor];
    self.tableView.backgroundColor = [UIColor themeColor];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerClass:[ForgotTableViewCell class] forCellReuseIdentifier:@"cellId"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 懒加载
// 设置数据源
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
        
        if (userInfor.user_phone.length > 0 && userInfor.user_email.length > 0) {
            
            NSString *phone = userInfor.user_phone;
            NSString *email = userInfor.user_email;
            
            ForgotPasswordModel *phoneModel = [[ForgotPasswordModel alloc] init];
            phoneModel.type = VerifyPasswordStylePhone;
            phoneModel.number = phone;
            ForgotPasswordModel *emailMode = [[ForgotPasswordModel alloc] init];
            emailMode.type = VerifyPasswordStyleEmail;
            emailMode.number = email;
            
            [_dataSource addObject:phoneModel];
            [_dataSource addObject:emailMode];
            
        }else if (userInfor.user_phone.length > 0){
            
            NSString *phone = userInfor.user_phone;
            
            ForgotPasswordModel *phoneModel = [[ForgotPasswordModel alloc] init];
            phoneModel.type = VerifyPasswordStylePhone;
            phoneModel.number = phone;
            
            [_dataSource addObject:phoneModel];
            
        }else if (userInfor.user_email.length > 0){
            
            NSString *email = userInfor.user_email;
            
            ForgotPasswordModel *emailMode = [[ForgotPasswordModel alloc] init];
            emailMode.type = VerifyPasswordStyleEmail;
            emailMode.number = email;
            
            [_dataSource addObject:emailMode];
        }
    }
    
    return _dataSource;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ForgotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    
    ForgotPasswordModel *model = self.dataSource[indexPath.row];
    
    if (indexPath.row == 0) {
        
        if (model.type == VerifyPasswordStylePhone) {
            NSString *phone = model.number;
            NSString *b = [phone substringWithRange:NSMakeRange(7,4)];
            cell.textLabel.text = [NSString stringWithFormat:@"通过绑定手机尾号%@找回",b];
            
        }else if (model.type == VerifyPasswordStyleEmail){
            NSString *email = model.number;
            NSString *c = [email substringWithRange:NSMakeRange(5,4)];
            cell.textLabel.text = [NSString stringWithFormat:@"通过绑定邮箱号%@找回",c];
        }
        
    } else{
        
        if (model.type == VerifyPasswordStylePhone) {
            NSString *phone = model.number;
            NSString *b = [phone substringWithRange:NSMakeRange(7,4)];
            
            cell.textLabel.text = [NSString stringWithFormat:@"通过绑定手机尾号%@找回",b];
        }else if (model.type == VerifyPasswordStyleEmail){
            NSString *email = model.number;
            NSString *c = [email substringWithRange:NSMakeRange(5,4)];
            
            cell.textLabel.text = [NSString stringWithFormat:@"通过绑定邮箱号%@找回",c];
        }
        
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"通过以下方式找回密码";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ForgotPasswordModel *model = self.dataSource[indexPath.row];
    
    if (model.type == VerifyPasswordStylePhone) {
        // 通过手机号找回密码处理
        [self requestphone];
        
        
    }else if (model.type == VerifyPasswordStyleEmail){
        // 通过邮箱找回密码处理
        [self requestEmail];
    }
}

- (void)requestphone{

    CodeVC * vc = [[CodeVC alloc]init];
    NSDictionary *dic;
    NSString     *requestUrl;
    
    dic = @{@"phone":userInfor.user_phone ,@"send":@(1),@"sign":[YConfig getSign]};
    requestUrl = phoneResetPwd;
    
    [YNetworking postRequestWithUrl:requestUrl params:dic cache:YES successBlock:^(id returnData, int code, NSString *msg) {
        if (code==1) {
            vc.type = VerifyPasswordStylePhone;
            [self.navigationController pushViewController:vc animated:YES];
 
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
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alert addAction:actionNO];
            
            [self presentViewController:alert animated:YES completion:nil];
        }

    } failureBlock:^(NSError *error) {
        
    } showHUD:YES];
    
    
//    [self requestWithUrl:requestUrl params:dic isCache:NO showHUD:YES myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg) {
//        if (state == Succeed) {
//
//            vc.type = VerifyPasswordStylePhone;
//            [self.navigationController pushViewController:vc animated:YES];
//        }else{
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            }];
//
//            [alert addAction:actionNO];
//            
//            [self presentViewController:alert animated:YES completion:nil];
//        }
//    }];

}

- (void)requestEmail{

    CodeVC * vc = [[CodeVC alloc]init];
    NSDictionary *dat;
    NSString     *requestWet;
    
    dat = @{@"email":userInfor.user_email ,@"send":@(1),@"sign":[YConfig getSign]};
    requestWet = emailResetPwd;
    
     [YNetworking postRequestWithUrl:requestWet params:dat cache:YES successBlock:^(id returnData, int code, NSString *msg) {
         if (code == 1) {
             vc.type = VerifyPasswordStyleEmail;
             [self.navigationController pushViewController:vc animated:YES];
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
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
             }];
             
             [alert addAction:actionNO];
             
             [self presentViewController:alert animated:YES completion:nil];
         }

     } failureBlock:^(NSError *error) {
         
     } showHUD:YES];
    
    
//    [self requestWithUrl:requestWet params:dat isCache:NO showHUD:YES myBlock:^(responseState state, NSDictionary *responseResults, NSString *msg) {
//        if (state == Succeed) {
//            
//            vc.type = VerifyPasswordStyleEmail;
//            [self.navigationController pushViewController:vc animated:YES];
//        }else{
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            }];
//            
//            [alert addAction:actionNO];
//            
//            [self presentViewController:alert animated:YES completion:nil];
//        }
//    }];

}






//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel * titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
//    titleLabel.text=@"通过以下方式找回密码";
//    titleLabel.textColor = [UIColor py_colorWithHexString:@"#cccccc"];
//    titleLabel.font = [UIFont systemFontOfSize:11];
//    
//    return titleLabel;
//}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
