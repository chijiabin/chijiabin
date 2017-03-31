//
//  RootViewController.h
//  Ubate
//
//  Created by sunbin on 2017/1/25.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "BaseViewController.h"
#import "YMenuView.h"
#import "YLeftMenu.h"

@interface RootViewController : BaseViewController
{
    NSMutableArray *_messageContents;
    int _messageCount;
    int _notificationCount;
}
@property (nonatomic ,strong)YMenuView *menu;
@property (nonatomic ,strong)YLeftMenu *left;

- (void)addNotificationCount;

@end
