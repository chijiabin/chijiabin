//
//  RecommendationCell.h
//  Ubate
//
//  Created by sunbin on 2016/12/9.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendationCell : UITableViewCell

@property (nonatomic,copy) void (^selectIndexHandler)(NSInteger selectidx,NSArray *imagesAry ,UIImageView *imageView);


- (void)recommendation:(NSArray *)ary;
@end
