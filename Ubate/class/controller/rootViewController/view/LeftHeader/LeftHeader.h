//
//  LeftHeader.h
//  Ubate
//
//  Created by sunbin on 2017/1/10.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftHeaderDelegate <NSObject>

- (void)skipToPersonalCenter;

@end

@interface LeftHeader : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIImageView *userImage; //用户图像
@property (weak, nonatomic) IBOutlet UILabel *nickName;      //用户昵称

@property (nonatomic, weak) id<LeftHeaderDelegate> delegate; //代理-个人中心跳转

@end
