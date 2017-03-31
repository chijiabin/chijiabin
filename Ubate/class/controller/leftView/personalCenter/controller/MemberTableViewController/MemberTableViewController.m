//
//  MemberTableViewController.m
//  Ubate
//
//  Created by sunbin on 2017/2/5.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "MemberTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import <AFNetworking/AFNetworking.h>
#import "YSex.h"
#import "Province.h"


static NSString *cellID = @"cellID";
@interface MemberTableViewController ()<LCActionSheetDelegate ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic ,strong) NSMutableArray *sourceData;
@end

@implementation MemberTableViewController
{
    YUserInfo *userInfor;    UIImageView *user_img;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     self.title = NSLocalizedString(@"个人资料", @"Personal center");
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    self.view.backgroundColor= [UIColor py_colorWithHexString:@"#f5f5f5"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfor) name:@"SET_USERINFO" object:nil];
}
- (void)initView{
    
    self.tableView.backgroundColor = [UIColor py_colorWithHexString:@"#ffffff"];
    
    [self tableViewAttributes];
    [self tableViewSetSeparatorInset];
}
- (void)tableViewAttributes
{
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
}


- (void)tableViewSetSeparatorInset{
    self.tableView.separatorColor = [UIColor appSeparatorColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}
- (void)loadData{
    userInfor = [YConfig myProfile];
    
    [self cellData];
}

- (void)cellData
{
    _sourceData = [[NSMutableArray alloc] init];
    NSArray *cellDefs = @[@[@"头像" ,@"用户名" ,@"性别" ,@"地区"] ,
                          @[@"实名认证" ,@"更改密码" ,@"更改或绑定手机号码" ,@"更改或绑定邮箱"]];
    self.sourceData = [[NSMutableArray alloc] initWithArray:cellDefs];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sourceData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionAry = [_sourceData objectAtIndex:section];
    return sectionAry.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionAry = [_sourceData objectAtIndex:indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor appCellColor];
        
        [cell.textLabel setTextColor:[UIColor py_colorWithHexString:@"333333"]];
        [cell.textLabel setFont:FONT_FONTMicrosoftYaHei(14.f)];
        
        [cell.detailTextLabel setTextColor:[UIColor py_colorWithHexString:@"5e5e5e"]];
        [cell.detailTextLabel setFont:FONT_FONTMicrosoftYaHei(12.f)];
        
        if (indexPath.section == 0 && indexPath.row == 2) {
            [self cell:cell showText:userInfor.sex];
        }
        if (indexPath.section == 0 && indexPath.row == 3) {
            [self cell:cell showText:userInfor.province];
        }
        if (indexPath.section == 1 && indexPath.row == 0) {
            [self cell:cell showText:userInfor.real_name];
        }
        if (indexPath.section == 1 && indexPath.row == 2) {
            [self cell:cell showText:userInfor.user_phone];
        }
        if (indexPath.section == 1 && indexPath.row == 3) {
            [self cell:cell showText:userInfor.user_email];
        }
    }

    cell.textLabel.text = [sectionAry objectAtIndex:indexPath.row];

    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.accessoryView       = [self YMprofile:HEIGHT(cell.contentView)];
    }else{
        NSArray *dataAry = @[
                             @[@"" ,
                               userInfor.nickname ,
                             [NHUtils isBlankString:userInfor.sex]?@"未设置":userInfor.sex,
                               [self YMarea]],
                             @[[NHUtils isBlankString:userInfor.real_name]?@"未实名":[NHUtils cipherShowText:RelaName cipherData:userInfor.real_name],
                               @"" ,
                               [userInfor.user_phone  isEmpty:@"请绑定手机"],
                               [userInfor.user_email  isEmpty:@"请绑定邮箱"]]];
        
        cell.detailTextLabel.text = [[dataAry objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    return cell;
}


- (void)cell:(UITableViewCell *)cell showText:(NSString *)text{
    if ([NHUtils isBlankString:text]) {
        [cell.detailTextLabel setTextColor:[UIColor py_colorWithHexString:@"b4b4b4"]];
    }else{
        [cell.detailTextLabel setTextColor:[UIColor py_colorWithHexString:@"5e5e5e"]];
    }
}
- (UIImageView*)YMprofile:(CGFloat)ROW_H{
    user_img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, [SizeProportion SizeProportionWithHeight:50.f], [SizeProportion SizeProportionWithHeight:50.f])];
//        user_img.aliCornerRadius = user_img.width/2;
    [user_img mac_setImageWithURL:[NSURL URLWithString:[adress stringByAppendingString:IF_NULL_TO_STRING(userInfor.user_img)]] placeholderImage:Icon(@"touxiang")];
    return user_img;
}

- (NSString *)YMarea{
    
    if ( [[userInfor.province isEmpty:@""] isEmpty] ) {
        return @"未设置";
    }else{
        if ( [[userInfor.province isEmpty:@""] isEqualToString:[userInfor.city isEmpty:@""]]) {
            return [NSString stringWithFormat:@"%@-%@", [userInfor.province isEmpty:@""],[userInfor.area isEmpty:@""]];
        }else{
            return [NSString stringWithFormat:@"%@-%@-%@", [userInfor.province isEmpty:@""],[userInfor.city isEmpty:@""],[userInfor.area isEmpty:@""]];
        } }
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
    __block UIViewController *vCtl;

    NSArray *ctlAry = @[@[kVCFromSb(@"YNickNameID", @"YMember"),
                          [[YSex alloc] initWithStyle:UITableViewStylePlain],kVCFromSb(@"ProvinceID", @"YMember"),
                          ] ,@[[userInfor.real_name isEmpty]?kVCFromSb(@"YReal_NameAuthenticationID", @"YMember"):kVCFromSb(@"YReal_NameInformationID", @"YMember"),kVCFromSb(@"YChangePasswordID", @"YMember"),kVCFromSb(@"YModifyAndBindingAccountID", @"YMember"),kVCFromSb(@"YModifyAndBindingAccountID", @"YMember")
                          ]
                        ];

    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                [self profileSelectType];
                return;
            }else{
                vCtl = [[ctlAry objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1];
            }        }
            break;
        case 1:{
            vCtl = [[ctlAry objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        }
            break;
        default:
            break;
    }

    
    
    if (vCtl) {
        vCtl.title = cell.textLabel.text;
        if (indexPath.row == 3 && indexPath.section == 0) {
            [self location:^(BOOL state, NSString *str) {
                
                NSDictionary *dic = @{@"content":IF_NULL_TO_STRING(str),@"res":[NSString stringWithFormat:@"%d" ,state]};
                Province  *proviceTl = (Province *)vCtl;
                proviceTl.dic = dic;
                [self.navigationController pushViewController:proviceTl animated:YES];
            }];
            
        }else{
            [self.navigationController pushViewController:vCtl animated:YES];
        }
    }
}

// 图像选择
- (void)profileSelectType{
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil
                                            buttonTitles:@[@"拍照选择", @"手机相册选择"]
                                          redButtonIndex:-1
                                                delegate:self];
    [sheet show];
}
#pragma mark - LCActionSheet 代理方法
- (void)actionSheet:(LCActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex {
    WEAKSELF;
    NSLog(@"> Clicked Index: %ld", (long)buttonIndex);
    if (buttonIndex == 0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [NHUtils alertAction:@selector(cancelButton) alertControllerWithTitle:@"Error" Message:@"Device has no camera" Vctl:weakSelf Cancel:NO];
        } else {
//相机
            UIImagePickerController *imagePickerController = [UIImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.allowsEditing = YES;
            imagePickerController.showsCameraControls = YES;
            imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        
        return ;
    }
    
    if (buttonIndex == 1) {
//相册
        
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = YES;
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
        return ;
    }

}
- (void)cancelButton{}
#pragma make UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    _image = [self imageWithImage:info[UIImagePickerControllerEditedImage] scaledToSize:CGSizeMake(150, 150)];
    [picker dismissViewControllerAnimated:YES completion:^ {
        [self updatePortrait];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
}
// *  对图片尺寸进行压缩--

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
// *  上传图片

- (void)updatePortrait{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    
    NSDictionary *paramer = @{@"uid":@([YConfig getOwnID]),
                              @"sign":[YConfig getSign] };
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    __block NSData *imageData;
    
    if (UIImagePNGRepresentation(_image)==nil) {
        imageData = UIImageJPEGRepresentation(_image, 0.5);
        
    }else{
        imageData = UIImagePNGRepresentation(_image);
        
    }
    
    WEAKSELF;
    [self.view showLoading:@"正在上传图像"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [manager POST:headPic parameters:paramer constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            //$imsg = $_FILES['imgsrc']['name'];
            //第一个代表文件转换后data数据，第二个代表图片放入文件夹的名字，第三个代表图片的名字，第四个代表文件的类型
            [formData appendPartWithFileData:imageData name:@"imgsrc" fileName:fileName mimeType:@"image/png"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"进度:%f",uploadProgress.fractionCompleted);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSString *res = TEXT_STRING([jsonDic objectForKey:@"res"]);
            NSString *msg = TEXT_STRING([jsonDic objectForKey:@"msg"]);
            
            
            
            [weakSelf.view  hideHUD];
            
            if (![res isEqualToString:@"1"]){
                NSLog(@"msg==%@" ,msg);
                [weakSelf.view showError:@"上传失败"];
                
            }else if([res isEqualToString:@"201"]){
                
                [self.view showSuccess:@"登录过期，请重新登录"];
                
                dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
                dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                    [YConfig outlog];
                });
                
            }else if([res isEqualToString:@"202"]){
                
                [self.view showSuccess:@"您的帐号在另一处登录，请重新登录"];
                
                dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
                dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                    [YConfig outlog];
                });
                
            }

            
            
            
            else{
                [weakSelf.view showSuccess:@"上传成功"];
                
                userInfor.user_img = TEXT_STRING([jsonDic objectForKey:@"url"]);
                kAppDelegate.userInfo = userInfor;
                [weakSelf.tableView reloadRowsAtIndexPaths:@[
                                                             [NSIndexPath indexPathForRow:0 inSection:0],
                                                             ]
                                          withRowAnimation:UITableViewRowAnimationNone];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"上传错误%@",error);
            [weakSelf.view  hideHUD];
            [weakSelf.view showError:error.localizedDescription];
            
        }];
        
    });

}

- (void)updateUserInfor{
    [self.tableView reloadData];
    [self loadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScaleHeight(10.f);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 0 && indexPath.row == 0) {
        return ScaleHeight(70.f);
        
    }
    return ScaleHeight(50.f);
}




- (void)location:(void (^)(BOOL state,NSString *str))states{
    [kAppDelegate getlocation:^(CLLocation *location, CLPlacemark *placeMark, NSString *error) {
        if (error) {
            NSLog(@"定位出错,错误信息:%@",error);
            states(NO ,@"定位出错");
        }else{
            NSDictionary *locadic = [placeMark addressDictionary];
            //获取城市
            NSString *citys ;
            if (!placeMark.locality) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
            }else{
                citys =[placeMark.locality substringToIndex:2];
            }
            NSString *province = [[locadic objectForKey:@"State"] substringToIndex:2];//省
            
            NSString *are = [locadic objectForKey:@"SubLocality"];//区
            
            NSString *placeAre;
            
            if ([NHUtils isBlankString:citys]) {
                placeAre = [NSString stringWithFormat:@"%@-%@" ,province  ,are];
            }else{
                placeAre = [NSString stringWithFormat:@"%@-%@-%@" ,province , citys ,are];
            }
            states(YES ,placeAre);
            
        }
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
