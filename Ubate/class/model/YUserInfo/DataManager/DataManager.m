//
//  DataManager.m
//  Ubate-UV
//
//  Created by sunbin on 2017/1/22.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        _jsonDic = [[NSMutableDictionary alloc]init];
    }
    return self;
}

+ (id)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (void)startAsyncRequest:(NSArray *)urlArray modelsArray:(NSArray *)modelsArray parameterAry:(NSArray *)parameterAry refreshHeadler:(void (^)(int index))refresh completionHeadler:(void (^) (int index))completion{

    for (int i = 0; i < urlArray.count; i++) {
    [YNetworking postRequestWithUrl:urlArray[i] params:parameterAry[i] cache:NO successBlock:^(id returnData, int code, NSString *msg) {
        if (code == 1) {
            NSDictionary *jsonDic = returnData;
            NSString *modelStr = modelsArray[i];
            id modelObj = [NSClassFromString(modelStr) modelObjectWithDictionary:jsonDic];
            [_jsonDic setObject:modelObj forKey:@(i)];
            refresh(i);
        }else{}
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
    
    }


}


@end
