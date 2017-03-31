//
//  YNickName.h
//  Ubate
//
//  Created by sunbin on 2017/2/8.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "YStaticCell.h"
#import "TextFilter.h"
@class TextFilter;

@interface YNickName : YStaticCell<TextFilterDelegate>
{
    TextFilter *filterLen;
}

@end
