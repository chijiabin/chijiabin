//
//  LoadHtml.m
//  Ubate
//
//  Created by sunbin on 2017/2/7.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "LoadHtml.h"

@interface LoadHtml ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LoadHtml

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   // self.title = NSLocalizedString(@"限额说明", @"Limit description");
}
- (void)viewDidLoad {
    [super viewDidLoad];

    if (_makeType == 0 ) {
        self.title = @"服务条款";
    }else{
    
        self.title = @"隐私政策";
    }
    
    if (_loadType == Local) {
        NSArray *htmlAry = @[@"account" ,@"bank_instructions" ,@"limit"];
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        NSString * htmlPath = [[NSBundle mainBundle] pathForResource:[htmlAry objectAtIndex:_makeType] ofType:@".html"];
        
        
        NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
        [self.webView loadHTMLString:htmlCont baseURL:baseURL];
        return;
    }
    
    
    if (_loadType == Online) {
        NSArray *htmlAry = @[UserTC,PrivacyPolicy ];
        NSURL *url = [[NSURL alloc] initWithString:[htmlAry objectAtIndex:_makeType]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        return;

    }
    

}
- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType{
    NSURL* url = [request URL];
    NSString* urlstring = [NSString stringWithFormat:@"%@",url];
    NSLog(@"urlstring = >%@",urlstring);
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
