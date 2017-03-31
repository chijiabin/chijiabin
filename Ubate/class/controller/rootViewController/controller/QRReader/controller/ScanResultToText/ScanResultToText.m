//
//  ScanResultToText.m
//  Ubate
//
//  Created by sunbin on 2017/2/10.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "ScanResultToText.h"

@interface ScanResultToText ()
@property (weak, nonatomic) IBOutlet UITextView *textViiew;

@end

@implementation ScanResultToText
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
    _textViiew.text = _contans;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
