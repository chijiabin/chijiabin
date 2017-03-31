//
//  ShopForDetails.m
//  Ubate
//
//  Created by sunbin on 2017/2/8.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "ShopForDetails.h"
#import "StoreDetailCell.h"
#import "RecommendationCell.h"
#import "InstructionCell.h"
#import "HeaderTitle.h"
#import "HeaderLogView.h"

#import <MJPhotoBrowser/MJPhotoBrowser.h>
#import "RoutePlanning.h"
#import "TelPhone.h"
static NSString * HeaderLogViewIDen  =    @"HeaderLogView_Identifier";
static NSString * InstructionIDen    =    @"Instruction_Identifier";
static NSString * RecommendationIDen =    @"Recommendation_Identifier";
static NSString * StoreDetailIDen    =    @"StoreDetail_Identifier";
static NSString * HeaderTitleIDen    =    @"HeaderTitle_Identifier";


@interface ShopForDetails ()
@property (strong, nonatomic) NSDictionary *dataDic;
@property (nonatomic) JHUD *hudView;

@end

@implementation ShopForDetails

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"商家详情";
    WEAKSELF;
    NSLog(@"store_id=%@" ,_store_id);
    self.hudView = [[JHUD alloc]initWithFrame:SCREEN_RECT];

    [self loadData];
    [self initView];
    
    //加载
    [self.hudView setJHUDReloadButtonClickedBlock:^() {
        NSLog(@"refreshButton");
        [weakSelf dotAnimation];

    }];


}

#pragma make 点 摆钟
- (void)dotAnimation
{
    WEAKSELF;
    self.hudView.messageLabel.text = @"正在加载,请等候";
    self.hudView.indicatorBackGroundColor = [UIColor whiteColor];
    self.hudView.indicatorForegroundColor = [UIColor orangeColor];
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeDot];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf loadData];
    });

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.backgroundColor= [UIColor py_colorWithHexString:@"f5f5f5"];
}

- (void)initView{
    WEAKSELF;
    weakSelf.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    weakSelf.tableView.separatorColor = [UIColor appSeparatorColor];
    
    weakSelf.tableView.showsVerticalScrollIndicator = NO;
    weakSelf.tableView.showsHorizontalScrollIndicator = NO;
    
    [weakSelf registerNib];
}

- (void)registerNib{
    WEAKSELF;
    [weakSelf.tableView registerNib:[UINib nibWithNibName:@"InstructionCell" bundle:nil] forCellReuseIdentifier:InstructionIDen];
    [weakSelf.tableView registerNib:[UINib nibWithNibName:@"StoreDetailCell" bundle:nil] forCellReuseIdentifier:StoreDetailIDen];
    [weakSelf.tableView registerNib:[UINib nibWithNibName:@"RecommendationCell" bundle:nil] forCellReuseIdentifier:RecommendationIDen];
    [weakSelf.tableView registerNib:[UINib nibWithNibName:@"HeaderLogView" bundle:nil] forHeaderFooterViewReuseIdentifier:HeaderLogViewIDen];
    [weakSelf.tableView registerNib:[UINib nibWithNibName:@"HeaderTitle" bundle:nil] forHeaderFooterViewReuseIdentifier:HeaderTitleIDen];
    
}

- (NSDictionary *)uid:(NSString *)mUid sign:(NSString *)mSign idMake:(NSString *)idMake{
    NSDictionary *dic = @{@"uid" : mUid,
                          @"sign": mSign,
                          @"id"  : idMake
                          };
    return dic;
}

- (void)loadData{
    WEAKSELF;
    
    NSDictionary *params = [weakSelf uid:[NSString stringWithFormat:@"%lld" ,[YConfig getOwnID]] sign:[YConfig getSign] idMake:_store_id];
    [YNetworking postRequestWithUrl:storeDetail params:params cache:YES successBlock:^(id returnData, int code, NSString *msg) {
        NSLog(@"%@" ,returnData);
        if (code == 1) {
            [JHUD hideForView:weakSelf.view];
            weakSelf.dataDic = [returnData objectForKey:@"data"];
            [weakSelf.tableView reloadData];
        }else{
            
            if (weakSelf.dataDic.count == 0) {
                [weakSelf failure:@"数据超时"];
            }
            
        }
    } failureBlock:^(NSError *error) {
        if (weakSelf.dataDic.count == 0) {
            [weakSelf failure:@"无网络"];

        }

    } showHUD:NO];
}
#pragma 熊猫闭眼  失败  按钮
- (void)failure:(NSString *)messageLabel
{
    self.hudView.indicatorViewSize = CGSizeMake(150, 150);
    self.hudView.messageLabel.text = messageLabel;
    [self.hudView.refreshButton setTitle:@"Refresh ?" forState:UIControlStateNormal];
    self.hudView.customImage = [UIImage imageNamed:@"tishi"];
    
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeFailure];
    
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *instruction = [self.dataDic objectForKey:@"instruction"];
    NSString *row = @[@"4" ,@"1" ,[NSString stringWithFormat:@"%lu" ,(unsigned long)[instruction componentsSeparatedByString:@"\r\n"].count]][section];
    return [row integerValue];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *images = [_dataDic objectForKey:@"images"];
    NSString *instruction = [self.dataDic objectForKey:@"instruction"];
    
    if (indexPath.section == 0) {
        StoreDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:StoreDetailIDen forIndexPath:indexPath];

        NSArray *logMakeAry = @[@"返现: " ,@"地址: " ,@"电话: " ,@"营业时间: "];
        NSArray *detailDataAry = @[
                                   [NSString stringWithFormat:@"%@%%",IF_NULL_TO_STRING([_dataDic objectForKey:@"valueR1"]) ],
                                   IF_NULL_TO_STRING([_dataDic objectForKey:@"address"]) ,
                                   IF_NULL_TO_STRING([_dataDic objectForKey:@"store_phone"]) ,
                                   IF_NULL_TO_STRING([_dataDic objectForKey:@"shop_hours"])];
        NSArray *logAry = @[IMAGE(@"fanxian") ,IMAGE(@"local") ,IMAGE(@"contact") ,IMAGE(@"time")];
        
        cell.logMake.text    = logMakeAry[indexPath.row];
        cell.logMake.textColor = [UIColor py_colorWithHexString:@"#333333"];
        cell.detailData.text = detailDataAry[indexPath.row];
        cell.detailData.textColor = [UIColor py_colorWithHexString:@"#333333"];
        cell.log.image       = logAry[indexPath.row];
        
        if (indexPath.row == 1 || indexPath.row == 2) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor py_colorWithHexString:@"fafafa"];
        cell.contentView.backgroundColor = [UIColor py_colorWithHexString:@"fafafa"];
        
        
        return cell;
    }

    
    if (indexPath.section == 1) {
        RecommendationCell *cell = [tableView dequeueReusableCellWithIdentifier:RecommendationIDen forIndexPath:indexPath];
        [cell recommendation:images];
        
        cell.selectIndexHandler = ^(NSInteger selectidx,NSArray *imagesAry ,UIImageView *imageView){
            NSInteger count = imagesAry.count;
            NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
            
            for (int i = 0; i<count; i++) {
                
                
                NSDictionary *img_urlDic = [imagesAry objectAtIndex:i];
                
                NSString *imageUrl =  [adress stringByAppendingString:[img_urlDic objectForKey:@"img_url"]];
                // 替换为中等尺寸图片
                NSString *url = [imageUrl stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
                MJPhoto *photo = [[MJPhoto alloc] init];
                photo.url = [NSURL URLWithString:url]; // 图片路径
                
                
                photo.srcImageView = imageView; // 来源于哪个UIImageView
                [photos addObject:photo];
            }
            
            
            // 2.显示相册
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.currentPhotoIndex = selectidx; // 弹出相册时显示的第一张图片是？
            browser.photos = photos; // 设置所有的图片
            [browser show];
        };
        return cell;
    }
    
    
    if (indexPath.section == 2) {
        InstructionCell *cell = [tableView dequeueReusableCellWithIdentifier:InstructionIDen forIndexPath:indexPath];
        //字符串转为数组
        NSArray *InstructionData =[instruction componentsSeparatedByString:@"\r\n"];
        cell.instructionStr.text = [InstructionData objectAtIndex:indexPath.row];
        cell.instructionStr.textColor = [UIColor py_colorWithHexString:@"#333333"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryNone;
        return cell;
        
    }
    return [UITableViewCell new];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        HeaderLogView *logView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderLogViewIDen];
        
        NSString *cBanner = IF_NULL_TO_STRING([_dataDic objectForKey:@"cBanner"]);
        
        [logView.cLogo mac_setImageWithURL:[NSURL URLWithString:IF_NULL_TO_STRING([adress stringByAppendingString:cBanner])] placeholderImage:Icon(@"jiazai")];
        return logView;
    }else{
        
        HeaderTitle *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderTitleIDen];
        head.titleMake.text = @[@"" ,@"特色推荐",@"使用细则"][section];
        head.titleMake.textColor = [UIColor py_colorWithHexString:@"#333333"];
        head.titleMake.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        head.backgroundView = [[UIImageView alloc] initWithImage:[NHUtils imageWithColor:[UIColor py_colorWithHexString:@"FAFAFA"] size:CGSizeMake(511, 45) alpha:1]];
        
        return head;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 1) {
        return ScaleHeight(50.f);
    }else{
        return ScaleHeight(90.f);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return ScaleHeight(200.f);
    }else{
        return ScaleHeight(50.f);
    }
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.tableView)
//    {
//        CGFloat sectionHeaderHeight = 200.f; //sectionHeaderHeight
//        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y+80, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=sectionHeaderHeight)
//        {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight+80, 0, 0, 0);
//        }
//    }
//}


- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger  sectionMake = indexPath.section;
    NSInteger  rowMake = indexPath.row;
    
    if (sectionMake == 0) {
        if (rowMake == 1) {
            NSString *geolat = [_dataDic objectForKey:@"geolat"];
            NSString *geolng = [_dataDic objectForKey:@"geolng"];
            NSString *store_name = [_dataDic objectForKey:@"store_name"];
            NSString *address = [_dataDic objectForKey:@"address"];
            NSString *company_name = [_dataDic objectForKey:@"company_name"];
            
            RoutePlanning *routePlanning = [[RoutePlanning alloc] initWithNibName:@"RoutePlanning" bundle:nil];
            routePlanning.geolat = geolat;
            routePlanning.geolng = geolng;
            routePlanning.store_name = store_name;
            routePlanning.address = address;
            routePlanning.company_name = company_name;
            [self.navigationController pushViewController:routePlanning animated:YES];
        }
        if (rowMake == 2) {
            NSString *store_phone = [_dataDic objectForKey:@"store_phone"];
            [self.view addSubview:(UIWebView *)[[TelPhone sharedTelPhone] telPhoneNum:store_phone]];        }


    }else{
     
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
