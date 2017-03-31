//
//  SenderEmailView.m
//  Ubate
//
//  Created by sunbin on 2016/12/13.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "SenderEmailView.h"

@interface SenderEmailView()
@property (weak, nonatomic) IBOutlet UILabel *emailAdress;


@end

@implementation SenderEmailView


+ (instancetype)loadSendEmailAdress:(NSString *)Eadress{
 
    SenderEmailView *senderEmailView = [self loadFromNib];
    senderEmailView.emailAdress.text = Eadress;
    return senderEmailView;
}


+ (instancetype)loadFromNib{
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"SenderEmailView" owner:nil options:nil];
    return [objects lastObject];
    
}
- (IBAction)sender:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if ([self.delegate respondsToSelector:@selector(navBtnIdex:)]) {
        [self.delegate navBtnIdex:tag];
    }

    
}



@end
