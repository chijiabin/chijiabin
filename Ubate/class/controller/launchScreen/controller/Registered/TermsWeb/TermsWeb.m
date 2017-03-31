//
//  TermsWeb.m
//  Ubate
//
//  Created by sunbin on 2016/12/22.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "TermsWeb.h"
#import "UIView+EmptyDataSet.h"

#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface TermsWeb ()<BFEmptyDataSetDelegate,BFEmptyDataSetSource,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TermsWeb

- (void)viewDidLoad {
    [super viewDidLoad];

    _webView.emptyDataSetDelegate=self;
    _webView.emptyDataSetSource=self;
    _webView.scrollView.bounces = NO;
    _webView.delegate=self;
    
    [self loadWeb];
}

//加载网页
- (void)loadWeb{
    
    NSURL *url = [NSURL URLWithString:[getArticle stringByAppendingString:[NSString stringWithFormat:@"%ld" ,(long)_index]]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
    
}

- (IBAction)back:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - BFEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"results_tips6"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIView *)view{
    NSString *text = @"哎呀,加载失败了...";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15],
                                 NSForegroundColorAttributeName:Color(0, 174, 239, 1)};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIView *)view{
    NSString *text = @"请检查您的网络设置或点击重试";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13],
                                 NSForegroundColorAttributeName:Color(74, 74, 74, 1)};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIView *)view
{
    return Color(250, 250, 250, 1);
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIView *)view
{
    return 5.0f;
}

//- (UIView *)customViewForEmptyDataSet:(UIView *)view{
//    UIView *customView=[[UIView alloc] initWithFrame:bodyWebView.bounds];
//
//    customView.backgroundColor=[UIColor grayColor];
//
//    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, (customView.frame.size.height-24)*0.5, customView.frame.size.width, 24)];
//    label.text=@"这是自定义的视图";
//    label.textColor=[UIColor blueColor];
//    label.textAlignment=NSTextAlignmentCenter;
//    [customView addSubview:label];
//
//    return customView;
//}


#pragma mark - BFEmptyDataSetDelegate
- (void)emptyDataSetDidTapView:(UIView *)view{
    //    NSLog(@"DidTapView");
    
//    [MBProgressHUD showLoading:self.view];
    
    [self loadWeb];
    
    
}




#pragma mark - UIWebView

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    [_webView removeEmptyDataSet];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
    [_webView reloadEmptyDataSet];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

@end
