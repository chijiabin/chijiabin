//
//  TextFilterHeader.h
//  Ubate
//
//  Created by sunbin on 2016/11/27.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#ifndef TextFilterHeader_h
#define TextFilterHeader_h


#if 0
输入文本类型规定
.h
#import <UIKit/UIKit.h>
#import "TextFilter.h"


@class TextFilter;

@interface ViewController : UIViewController<TextFilterDelegate>
{
    TextFilter *filterLen;
    TextFilter *filterNum;
    TextFilter *filterEn;
    TextFilter *filterCH;
    TextFilter *filterMoney;
}
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtLen;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtNum;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtEn;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtCH;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtMoney;
@end

#import "ViewController.h"
#import "TextFilter.h"


@implementation ViewController
@synthesize txtLen;
@synthesize txtNum;
@synthesize txtEn;
@synthesize txtCH;
@synthesize txtMoney;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        filterLen = [[TextFilter alloc] init];
        filterNum = [[TextFilter alloc] init];
        filterEn = [[TextFilter alloc] init];
        filterCH = [[TextFilter alloc] init];
        filterMoney = [[TextFilter alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [filterLen SetFilter:txtLen
                delegate:self
                maxCHLen:5
                allowNum:YES
                 allowCH:YES
             allowLetter:YES
             allowLETTER:YES
             allowSymbol:YES
             allowOthers:nil];
    
    [filterNum SetFilter:txtNum
                delegate:self
                maxCHLen:100
                allowNum:YES
                 allowCH:NO
             allowLetter:NO
             allowLETTER:NO
             allowSymbol:NO
             allowOthers:nil];
    
    [filterEn SetFilter:txtEn
               delegate:self
               maxCHLen:100
               allowNum:NO
                allowCH:NO
            allowLetter:YES
            allowLETTER:YES
            allowSymbol:NO
            allowOthers:nil];
    
    [filterCH SetFilter:txtCH
               delegate:self
               maxCHLen:100
               allowNum:NO
                allowCH:YES
            allowLetter:YES
            allowLETTER:NO
            allowSymbol:NO
            allowOthers:nil];
    
    [filterMoney SetMoneyFilter:txtMoney delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#endif

#endif
