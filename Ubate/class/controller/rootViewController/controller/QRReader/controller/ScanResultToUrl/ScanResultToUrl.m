//
//  ScanResultToUrl.m
//  Ubate
//
//  Created by sunbin on 2017/2/10.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "ScanResultToUrl.h"

@interface ScanResultToUrl ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ScanResultToUrl
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"扫描结果";
    [self pop];

}
- (void)pop{
    [NHUtils pushAndPop:@"QRReader" range:NSMakeRange(1, 1) currentCtl:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [[NSURL alloc] initWithString:_contans];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
