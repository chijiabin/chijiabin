//
//  RoutePlanning.m
//  Ubate
//
//  Created by sunbin on 2017/1/25.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "RoutePlanning.h"

//气泡文字表述
static  NSString *RoutePlanningViewControllerStartTitle       = @"起点";
static  NSString *RoutePlanningViewControllerDestinationTitle = @"终点";

@interface RoutePlanning ()<MKMapViewDelegate ,CLLocationManagerDelegate>

@property(nonatomic,weak) MKMapItem * sourceItem;  //起点
@property(nonatomic,weak) MKMapItem * destItem;    //终点描述
@property(nonatomic ,strong) CLLocation *sourceItemLocation;


@property (nonatomic,strong)CLPlacemark *sourceMark;
@property (nonatomic,strong)CLPlacemark *toMark;
@property(nonatomic,strong) CLGeocoder  *geocoder;
@property(nonatomic,strong) MKDirectionsRequest * request;
@property (nonatomic, strong) NSString *urlScheme;
@property (nonatomic, strong) NSString *appName;


@end

@implementation RoutePlanning
{
    
    UIView   *titleView ;                 //自定义titleView 放置2种换成方式
    UIButton *Tempbtn;
    UIButton *btn;     //取反按钮
    NSInteger  indexMake;

    CLLocationManager *locationManager;
}

-(CLGeocoder *)geocoder{
    if (_geocoder==nil) {
        _geocoder=[[CLGeocoder alloc] init];
    }
    return _geocoder;
}

-(void)initLocation {
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 10.0;

    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [locationManager requestWhenInUseAuthorization];
    }
    if(![CLLocationManager locationServicesEnabled]){
        NSLog(@"请开启定位:设置 > 隐私 > 位置 > 定位服务");
    }
    if([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization]; // 永久授权
        [locationManager requestWhenInUseAuthorization]; //使用中授权
    }
    [locationManager startUpdatingLocation];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.urlScheme = @"Ubate://";
    self.appName = @"Ubate";

    
    [_mapView setShowsUserLocation:YES];
    [self initLocation];
    [self initView];

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)initView{
    [self initTitileView];
    
    //当前位置
    WEAKSELF;
    [kAppDelegate getlocation:^(CLLocation *location, CLPlacemark *placeMark, NSString *error) {
        [weakSelf.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable sourcemarks, NSError * _Nullable error) {
            CLLocation *destinationLocation = [[CLLocation alloc] initWithLatitude:[_geolng floatValue] longitude:[_geolat floatValue]];

            [weakSelf.geocoder reverseGeocodeLocation:destinationLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable destmarks, NSError * _Nullable error) {
                
                _sourceMark=[sourcemarks firstObject];
                _toMark    =[destmarks firstObject];
                
                [MKMapView animateWithDuration:0.8 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    //显示 中心位置
                    [weakSelf.mapView setCenterCoordinate:_toMark.location.coordinate animated:YES];
                } completion:^(BOOL finished) {
                }];
                
                
                
                //1 增加自定义大头针
                MKPointAnnotation * source=[[MKPointAnnotation alloc] init];
                source.title= RoutePlanningViewControllerStartTitle;
                source.subtitle=_sourceMark.name;
                source.coordinate=_sourceMark.location.coordinate;
                [self.mapView addAnnotation:source];
                
                
                
                MKPointAnnotation * dest=[[MKPointAnnotation alloc] init];
                dest.title= weakSelf.company_name;
                dest.subtitle = weakSelf.address;
                dest.coordinate=_toMark.location.coordinate;
                [self.mapView addAnnotation:dest];
                [self.mapView selectAnnotation:dest animated:YES];
                
                //2 划线
                [self drawLine:_sourceMark destinationCLPm:_toMark];
            }];
        }];
        
    }];
    
    
}


- (void)initTitileView{
    titleView    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 88, 30)];
    NSArray *ary = @[@"car.png" ,@"work.png"];
    
    CGFloat btn_width = (WIDTH(titleView)-15)/ary.count;
    CGFloat btn_Y     = (HEIGHT(titleView) - btn_width-10)/2;
    
    [ary enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(idx * (btn_width)+15, btn_Y+10, btn_width-5, btn_width-5)];
        [btn setBackgroundImage:Icon(obj) forState:UIControlStateNormal];
        [btn setBackgroundImage:Icon([obj stringByAppendingString:@"_"]) forState:UIControlStateSelected];
//        [btn setTitle:obj forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        
      //  [btn setImagePosition:LXMImagePositionTop spacing:5];
        btn.tag =100+idx;
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        if (idx == 0) {
            btn.selected = YES;
            indexMake = 0;
            Tempbtn = btn;
        }
        [btn addTarget:self action:@selector(changeRoutePlanType:) forControlEvents:UIControlEventTouchUpInside];

        [titleView addSubview:btn];
    }];
    self.navigationItem.titleView = titleView;
    
    
}



#pragma make -选择路线规划方式
- (void)changeRoutePlanType:(UIButton *)sender{
    NSInteger index = sender.tag-100;
    UIButton *senderBtn = [titleView.subviews objectAtIndex:index];
    Tempbtn.selected = NO;
    senderBtn.selected = YES;
    Tempbtn =sender;
    
    NSLog(@"index==%ld" ,(long)index);
    
    if (indexMake == index) {
        return;
    }else{
        //切换动画
        if (index == 0) {
            [self drawLine:_sourceMark destinationCLPm:_toMark];
        }
        if (index == 1) {
            [self drawLineWithSourceCLPm:_sourceMark destinationCLPm:_toMark];
        }
        indexMake = index;
    }
}

#pragma mark  - 导航之前划线

- (void)_mapGuilderFromMark:(CLPlacemark * ) sourceMark toMark:(CLPlacemark *) destMark transportType:(MKDirectionsTransportType)transportType{
    
    //使所有Annotation都可见
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];

    if (sourceMark == nil || destMark == nil) return;
    
    //1 定义方向请求
    _request=[[MKDirectionsRequest alloc] init];
    _request.transportType = transportType;
    //2 定义开始和结束位置
    
    //1> 开始
    MKPlacemark *sourcemkpm=[[MKPlacemark alloc] initWithPlacemark:sourceMark];
    MKMapItem * sourceItem=[[MKMapItem alloc] initWithPlacemark:sourcemkpm];
    _request.source=sourceItem;
    self.sourceItem=sourceItem;
    //2> 结束
    MKPlacemark *destmkpm=[[MKPlacemark alloc] initWithPlacemark:destMark];
    MKMapItem * destItem=[[MKMapItem alloc] initWithPlacemark:destmkpm];
    _request.destination=destItem;
    self.destItem=destItem;
    
    //3 根据方向请求获取方向
    MKDirections *dirction=[[MKDirections alloc] initWithRequest:_request];
    WEAKSELF;
    //4 计算路线模型
    [dirction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if(error) return ;
        NSArray * routesArray=response.routes;
        for (MKRoute * root in routesArray) {
            [weakSelf clearline];
            //添加路线遮盖，传递路线遮盖模型
            [weakSelf.mapView addOverlay:root.polyline];
        }
    }];
    
    
    
}

-(void)clearline{
    //清除线条
    [_mapView removeOverlays:_mapView.overlays];
}

#pragma mark - mapViewDelegate

//返回遮盖渲染器
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer * render=[[MKPolylineRenderer alloc]initWithPolyline:overlay];
    render.lineWidth = 5;
    render.strokeColor=[UIColor blueColor];
    render.fillColor = [UIColor redColor];
    return render;
}



//返回大头针渲染器
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        MKAnnotationView* aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKPointAnnotation"];
        NSString *imageName;
        if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle]){
            imageName = @"default_navi_route_startpoint";
        }else if ([[annotation title] isEqualToString:(NSString*)self.company_name]){
            imageName = @"default_navi_route_endpoint";
        }
        aView.image = [UIImage imageNamed:imageName];
        aView.canShowCallout = YES;
        
        
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 50)];
        leftButton.backgroundColor = [UIColor grayColor];
        [leftButton setBackgroundColor:[UIColor py_colorWithHexString:@"208dcf"] forState:UIControlStateNormal];
        [leftButton setTitle:@"导航" forState:UIControlStateNormal];
        leftButton.titleLabel.font = FONT_FONTMicrosoftYaHei(13.f);
        aView.rightCalloutAccessoryView = leftButton;
        
        
        NSLog(@"%ld" ,(long)indexMake);
        
        UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myimage"]];
        aView.leftCalloutAccessoryView = myCustomImage;

        
        return aView;
    }
    return nil;
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSLog(@"点击了查看详情");
    [self jumpToApp];
}

- (void)jumpToApp{
    //1.系统地图（苹果自身地图）
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(22.645980,113.947637);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]])
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
            
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        }];
        
        [alert addAction:action];
    }
    
   NSString * urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:%@&destination=latlng:%f,%f|name:%@&mode=%@&region=%@&output=html",
                            _sourceMark.location.coordinate.longitude,
                            _sourceMark.location.coordinate.latitude,
                            @"我的位置",
                            _toMark.location.coordinate.longitude,
                            _toMark.location.coordinate.latitude,
                            @"我的位置",
                            @[@"driving" ,@"walking"][indexMake],
                            _company_name]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;

    
        NSString *baiDuString = [NSString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%f,%f&mode=%@&coord_type=gcj02&src=webapp.navi.quanli|Ubate" ,_sourceMark.location.coordinate.latitude, _sourceMark.location.coordinate.longitude,_toMark.location.coordinate.latitude ,_toMark.location.coordinate.longitude,@[@"driving" ,@"walking"][indexMake]];
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *urlString = [[NSString stringWithFormat:baiDuString,coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",urlString);
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }];
        
        [alert addAction:action];
    }
    
    
    
    
    //    x-source=%@&x-success=%@
    //    跟高德一样 这里分别代表APP的名称和URL Scheme
    //    saddr=
    //    这里留空则表示从当前位置触发
    
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
    {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"谷歌地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",
                                    _appName,
                                    _urlScheme,
                                    _toMark.location.coordinate.latitude,
                                    _toMark.location.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%@",urlString);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }];
        
        [alert addAction:action];
    }
    
    
    
    
    //    sourceApplication=%@&backScheme=%@
    //    sourceApplication代表你自己APP的名称 会在之后跳回的时候显示出来 所以必须填写 backScheme是你APP的URL Scheme 不填是跳不回来的哟
    //    dev=0
    //    这里填0就行了 跟上面的gcj02一个意思 1代表wgs84 也用不上
    
    NSURL *scheme = [NSURL URLWithString:@"iosamap://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:scheme];
    
    if (canOpen) {
        NSString *gaoDeString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&slat=%f&slon=%f&sname=我的位置&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&t=%@" ,
                                 _appName,
                                 _sourceMark.location.coordinate.latitude ,
                                 _sourceMark.location.coordinate.longitude ,
                                 _toMark.location.coordinate.latitude ,
                                 _toMark.location.coordinate.longitude ,
                                 _company_name,
                                  @[@"0",@"2"][indexMake]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            //使用iOS提供高德API即可调起高德地图，需要注意的是从iOS10版本起，API有更新。
            
            NSURL *myLocationScheme = [NSURL URLWithString:gaoDeString];
            if ([[UIDevice currentDevice].systemVersion integerValue] >= 10) {
                //iOS10以后,使用新API
                [[UIApplication sharedApplication] openURL:myLocationScheme options:@{} completionHandler:^(BOOL success) {
                    NSLog(@"scheme调用结束");
                }];
            } else {
                //iOS10以前,使用旧API
                [[UIApplication sharedApplication] openURL:myLocationScheme];
            }
        }];
        [alert addAction:action];
        
        
    }else{
        
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];

}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView{}
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{}
- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error{}

- (void)mapViewWillStartRenderingMap:(MKMapView *)mapView NS_AVAILABLE(10_9, 7_0){}
- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered NS_AVAILABLE(10_9, 7_0){}



- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(10_9, 4_0){}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(10_9, 4_0){}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView NS_AVAILABLE(10_9, 4_0){}
- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView NS_AVAILABLE(10_9, 4_0){}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation NS_AVAILABLE(10_9, 4_0){}
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error NS_AVAILABLE(10_9, 4_0){}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState NS_AVAILABLE(10_9, 4_0) __TVOS_PROHIBITED{}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated NS_AVAILABLE(NA, 5_0){}

- (void)mapView:(MKMapView *)mapView didAddOverlayRenderers:(NSArray<MKOverlayRenderer *> *)renderers NS_AVAILABLE(10_9, 7_0){}


- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews{

}



#pragma make -CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%@" ,[NSString stringWithFormat:@"%lf", newLocation.coordinate.longitude]);
    NSLog(@"%@" ,[NSString stringWithFormat:@"%lf", newLocation.coordinate.latitude]);

    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];

}

//主要就是直辖市的城市获得需要拐个弯，iOS7添加了一个新的方法，代替了上面这个方法：


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    [manager stopUpdatingLocation];
    //停止获取位置信息
    [locationManager stopUpdatingLocation];
    
    //获取位置对象
    CLLocation *lastLocation = [locations lastObject];
    
    //提取位置信息里的经度，纬度
    CLLocationCoordinate2D myLocation ;
    //纬度
    myLocation.latitude = [lastLocation coordinate].latitude;
    //经度
    myLocation.longitude = [lastLocation coordinate].longitude;
    
    //地图显示的区域
    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
    MKCoordinateRegion region = MKCoordinateRegionMake(myLocation, span);
    [_mapView setRegion:region animated:NO];
    
    NSLog(@"~~~%f,~~~~%f",myLocation.latitude,myLocation.longitude);

}




//显示3d地图
- (void)show3dMap{
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(29.454686, 106.539259), 5000, 5000) animated:YES];
    CLLocationCoordinate2D ground = CLLocationCoordinate2DMake(29.454686, 106.529259);
    CLLocationCoordinate2D eye = CLLocationCoordinate2DMake(29.545686, 106.628259);
    MKMapCamera *myCamera = [MKMapCamera cameraLookingAtCenterCoordinate:ground fromEyeCoordinate:eye eyeAltitude:100];
    self.mapView.camera = myCamera;
}

//滑动与缩放
- (void)panAndzoom{
    [self performSelector:@selector(pan) withObject:nil afterDelay:3.f];
    [self performSelector:@selector(zoom) withObject:nil afterDelay:6.f];
}

//往左移动当前地图宽度的一半的距离
-(void)pan{
    //    CLLocationCoordinate2D mapCenter = self.mapView.centerCoordinate;
    CLLocationCoordinate2D mapCenter ;
    mapCenter = [self.mapView convertPoint:
                 CGPointMake(1, (self.mapView.frame.size.width/2.0))
                      toCoordinateFromView:self.mapView];
    [self.mapView setCenterCoordinate:mapCenter animated:YES];
}

//放大
-(void)zoom{
    MKCoordinateRegion theRegion = self.mapView.region;
    // Zoom in
    theRegion.span.longitudeDelta *= 0.5;
    theRegion.span.latitudeDelta  *= 0.5;
    [self.mapView setRegion:theRegion animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}





//走路画线
- (void)drawLineWithSourceCLPm:(CLPlacemark *)sourceCLPm destinationCLPm:(CLPlacemark *)destinationCLPm
{
    //使所有Annotation都可见
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    [self clearline];
    MBProgressHUD *hud = [self loadMBProgressHUD];


    if (sourceCLPm == nil || destinationCLPm == nil) return;
    // 1.初始化方向请求
    _request = [[MKDirectionsRequest alloc] init];
    _request.transportType = MKDirectionsTransportTypeWalking;
    // 设置起点
    MKPlacemark *sourceMKPm = [[MKPlacemark alloc] initWithPlacemark:sourceCLPm];
    _request.source = [[MKMapItem alloc] initWithPlacemark:sourceMKPm];
    self.sourceItem = _request.source;
    // 设置终点
    MKPlacemark *destinationMKPm = [[MKPlacemark alloc] initWithPlacemark:destinationCLPm];
    _request.destination = [[MKMapItem alloc] initWithPlacemark:destinationMKPm];
    self.destItem = _request.destination ;
    // 2.根据请求创建方向
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:_request];    
    // 3.执行请求
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        [hud hideAnimated:YES];
        if (error)
        {
            NSLog(@"请求有误");
        }
        for (MKRoute *route in response.routes) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mapView addOverlay:route.polyline];
            });
            
        }
        
    }];
    // 遮盖 overlay
}
//开车
- (void)drawLine:(CLPlacemark *)sourceCLPm destinationCLPm:(CLPlacemark *)destinationCLPm{
    //使所有Annotation都可见
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
   
    [self clearline];
    MBProgressHUD *hud = [self loadMBProgressHUD];
    if (sourceCLPm == nil || destinationCLPm == nil) return;
    // 1.初始化方向请求
    _request = [[MKDirectionsRequest alloc] init];
    _request.transportType = MKDirectionsTransportTypeAutomobile;
    // 设置起点
    MKPlacemark *sourceMKPm = [[MKPlacemark alloc] initWithPlacemark:sourceCLPm];
    _request.source = [[MKMapItem alloc] initWithPlacemark:sourceMKPm];
    self.sourceItem = _request.source;
    // 设置终点
    MKPlacemark *destinationMKPm = [[MKPlacemark alloc] initWithPlacemark:destinationCLPm];
    _request.destination = [[MKMapItem alloc] initWithPlacemark:destinationMKPm];
    self.destItem = _request.destination;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:_request];
    // 3.执行请求
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        [hud hideAnimated:YES];
        if (error)
        {
            NSLog(@"请求有误");
        }
        for (MKRoute *route in response.routes) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mapView addOverlay:route.polyline];
            });

        }
    }];
}



- (MBProgressHUD *)loadMBProgressHUD{
    [self clearline];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Change the background view style and color.
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    return hud;
}


@end
