//
//  LeftHeader.m
//  Ubate
//
//  Created by sunbin on 2017/1/10.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "LeftHeader.h"

@interface LeftHeader()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *leftHeadTapView;
@end

@implementation LeftHeader
-(void)awakeFromNib{
    [super awakeFromNib];
    //设置圆角属性
    _userImage.aliCornerRadius = _userImage.mj_size.height/2;
    //添加手势 实现代理跳转->个人中心
    WEAKSELF;
    [_leftHeadTapView addTapGestureRecognizer:^(UITapGestureRecognizer *recognizer, NSString *gestureId) {
        recognizer.delegate = self;
        if ([weakSelf.delegate respondsToSelector:@selector(skipToPersonalCenter)]) {
            [weakSelf.delegate skipToPersonalCenter];
        }
    }];
}

#pragma make -UIGestureRecognizerDelegate 避免手势与tableview冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //Tip:我们可以通过打印touch.view来看看具体点击的view是具体是什么名称,像点击UITableViewCell时响应的View则是UITableViewCellContentView.
    if ([NSStringFromClass([touch.view class])    isEqualToString:@"UITableViewCellContentView"]) {
        //返回为NO则屏蔽手势事件
        return NO;
    }
    return YES;
}

@end
