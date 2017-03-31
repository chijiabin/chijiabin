//
//  ProvinceCell.h
//  Ubate
//
//  Created by sunbin on 2016/12/22.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProvinceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *areInfor;
- (void)locationResult:(NSString *)loc;
@end
