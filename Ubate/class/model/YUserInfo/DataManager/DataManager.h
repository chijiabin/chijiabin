//
//  DataManager.h
//  Ubate-UV
//
//  Created by sunbin on 2017/1/22.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject
@property (strong) NSMutableDictionary *jsonDic;

+ (DataManager *)sharedManager;

- (void)startAsyncRequest:(NSArray *)urlArray modelsArray:(NSArray *)modelsArray parameterAry:(NSArray *)parameterAry refreshHeadler:(void (^)(int index))refresh completionHeadler:(void (^) (int index))completion;

@end
