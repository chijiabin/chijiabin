//
//  NearCtl.m
//  Ubate
//
//  Created by sunbin on 2017/2/8.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "NearCtl.h"
#define time 0.1f
#import "NeartheshopCell.h"
#import "NeartheshopModel.h"
#import "ShopForDetails.h"
static NSString *NeartheshopCellIden = @"NeartheshopCellIden";

@interface NearCtl ()
{
    UIImageView *_imageviewLeft , *_imageviewRight;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation NearCtl
{
    NSInteger pageIndex;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加左右滑动手势pan
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:pan];
    self.view.backgroundColor = [UIColor yellowColor];
    
    
    pageIndex = 10;
    WEAKSELF;
    self.hudRect =  SCREEN_RECT;

   // self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self initView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf loadData:pageIndex];
    });
    
    // 刷新
    [weakSelf.hudView setJHUDReloadButtonClickedBlock:^{
        NSLog(@"refreshButton");
        [weakSelf loading:weakSelf];
        
    }];
    
    self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            pageIndex+=10;
            [weakSelf loadData:pageIndex];
            // 结束刷新
            [weakSelf.tableview.mj_footer endRefreshing];
        });
    }];
    
    
}

- (void)loading:(NearCtl *)ctl{
    
    [ctl circleJoinAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ctl loadData:pageIndex];
    });
    
}


- (void)initView{
    [self.tableview registerNib:[UINib nibWithNibName:@"NeartheshopCell" bundle:nil] forCellReuseIdentifier:NeartheshopCellIden];
}






- (void)loadData:(NSInteger)pageCount{
    
    WEAKSELF;    

        
        NSDictionary *params = [weakSelf reqquest:1 lat:kAppDelegate.location.coordinate.latitude lng:kAppDelegate.location.coordinate.longitude pageCount:pageCount];
        
        [weakSelf postRequestWithparams:params];
    
    
    
}
//*  type：不传时显示附近，1餐饮，2购物，3其他

- (NSDictionary *)reqquest:(NSInteger)index lat:(CLLocationDegrees)lat lng:(CLLocationDegrees)lng pageCount:(NSInteger)page{
    NSDictionary *dic;
    dic = @{@"uid" : @([YConfig getOwnID]),
            @"type": @(2) ,
            @"sign": [YConfig getSign]     ,
            @"lat" : @(kAppDelegate.location.coordinate.latitude)    ,
            @"lng" : @(kAppDelegate.location.coordinate.longitude)    ,
            @"scope":@(kScope),
            @"start":@"0"     ,
            @"count":@(page)
            };
    return dic;
}



- (void)postRequestWithparams:(NSDictionary *)params{
    WEAKSELF;
    
    [YNetworking postRequestWithUrl:nearbyStore params:params cache:YES successBlock:^(id returnData, int code, NSString *msg) {
        if (code == 1) {
            
            weakSelf.dataArray = [NeartheshopModel mj_objectArrayWithKeyValuesArray:[(NSDictionary *)returnData objectForKey:@"data"]];
            
            [weakSelf.tableview reloadData];
        }else{
            NSLog(@"%@" ,msg);
            if (_dataArray.count == 0) {
                [weakSelf failure:NONet indicatorViewSize:CGSizeMake(150.f, 150.f) messageLabel:@"周围附近还没开发" customImageName:@"tishi"];
            }
            
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"%@" ,error.localizedDescription);
        if (_dataArray.count == 0) {
            [weakSelf failure:NONet indicatorViewSize:CGSizeMake(150.f, 150.f) messageLabel:@"网络出现故障 ,请检查网络是否设置正确" customImageName:@"tishi"];
        }
    } showHUD:NO];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NeartheshopCell *cell = [tableView dequeueReusableCellWithIdentifier:NeartheshopCellIden forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
#pragma make 配置其高度
    if (Iphone4) {
        return ScaleHeight(102.f);
    }else if (Iphone5){
        return ScaleHeight(102.f);
    }else if (Iphone6){
        return ScaleHeight(102.f);
    }else{
        return ScaleHeight(110.f);
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NeartheshopModel *model = (NeartheshopModel *)self.dataArray[indexPath.row];
    
    ShopForDetails *details = [[ShopForDetails alloc] initWithStyle:UITableViewStyleGrouped];
    details.store_id = model.cID;
    [self.navigationController pushViewController:details animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    /********用于创建pan********/    //将左右的tab页面绘制出来，并把UIView添加到当前的self.view中
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    
    UIViewController* v2 = [self.tabBarController.viewControllers objectAtIndex:selectedIndex+1];
    UIImage* image2 = [self imageByCropping:v2.view toRect:v2.view.bounds];
    _imageviewRight = [[UIImageView alloc] initWithImage:image2];
    _imageviewRight.frame = CGRectMake(_imageviewRight.frame.origin.x + [UIScreen mainScreen].bounds.size.width, 0, _imageviewRight.frame.size.width, _imageviewRight.frame.size.height);
    [self.view addSubview:_imageviewRight];
    /********用于创建pan********/
}

- (void)viewDidDisappear:(BOOL)animated{
    /********用于移除pan时的左右两边的view********/
    [_imageviewRight removeFromSuperview];
    /********用于移除pan时的左右两边的view********/
}

#pragma mark 绘制图片
//与pan结合使用 截图方法，图片用来做动画
-(UIImage*)imageByCropping:(UIView*)imageToCrop toRect:(CGRect)rect
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize pageSize = CGSizeMake(scale*rect.size.width, scale*rect.size.height) ;
    UIGraphicsBeginImageContext(pageSize);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    
    CGContextRef resizedContext =UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(resizedContext,-1*rect.origin.x,-1*rect.origin.y);
    [imageToCrop.layer renderInContext:resizedContext];
    UIImage*imageOriginBackground =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageOriginBackground = [UIImage imageWithCGImage:imageOriginBackground.CGImage scale:scale orientation:UIImageOrientationUp];
    
    return imageOriginBackground;
}

#pragma mark Pan手势
- (void) handlePan:(UIPanGestureRecognizer*)recongizer{
    NSLog(@"UIPanGestureRecognizer");
    
    NSUInteger index = [self.tabBarController selectedIndex];
    
    CGPoint point = [recongizer translationInView:self.view];
    NSLog(@"%f,%f",point.x,point.y);
    
    if (recongizer.view.center.x + point.x >  [UIScreen mainScreen].bounds.size.width/2) {
        recongizer.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, recongizer.view.center.y);
    } else {
        recongizer.view.center = CGPointMake(recongizer.view.center.x + point.x, recongizer.view.center.y);
    }
    [recongizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (recongizer.state == UIGestureRecognizerStateEnded) {
        if (recongizer.view.center.x <= [UIScreen mainScreen].bounds.size.width && recongizer.view.center.x > 0 ) {
            [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                recongizer.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2 ,[UIScreen mainScreen].bounds.size.height/2);
            }completion:^(BOOL finished) {
                
            }];
        } else if (recongizer.view.center.x <= 0 ){
            [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                recongizer.view.center = CGPointMake(-[UIScreen mainScreen].bounds.size.width/2 ,[UIScreen mainScreen].bounds.size.height/2);
            }completion:^(BOOL finished) {
                [self.tabBarController setSelectedIndex:index+1];
                recongizer.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2 ,[UIScreen mainScreen].bounds.size.height/2);
            }];
        } else {
            
        }
    }
}

@end
