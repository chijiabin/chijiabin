//
//  SwitchGroup.h
//  Ubate
//
//  Created by sunbin on 2016/12/13.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwitchGroup : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSMutableArray *members;
@property (nonatomic) BOOL isShow;

@end
