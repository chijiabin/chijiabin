//
//  ReturnHeaderFooterView.h
//  Ubate
//
//  Created by sunbin on 2016/12/6.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReturnHeaderFooterView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *state;

@property (weak, nonatomic) IBOutlet UIImageView *logo;

@property (weak, nonatomic) IBOutlet UILabel *returnType;

@end
