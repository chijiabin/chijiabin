//
//  RoutePlanning.h
//  Ubate
//
//  Created by sunbin on 2017/1/25.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface RoutePlanning : BaseViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic ,copy) NSString * geolat;
@property (nonatomic ,copy) NSString * geolng;
@property (nonatomic ,copy) NSString * store_name;
@property (nonatomic ,copy) NSString * address;
@property (nonatomic ,copy) NSString * company_name;

@end
