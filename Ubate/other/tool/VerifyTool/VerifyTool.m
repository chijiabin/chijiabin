//
//  VerifyTool.m
//  Ubate
//
//  Created by sunbin on 2016/12/15.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "VerifyTool.h"

@implementation VerifyTool

+(BOOL)check:(NSDictionary *)dict
{
    BOOL isFlag = YES;
    NSArray *valueArray = [dict[@"verify"] allValues];
    for (NSInteger i = 0; i < valueArray.count; i++)
    {
        NSNumber *typeNumber = valueArray[i][@"type"];
        VerifyType verifyType = (VerifyType)typeNumber.integerValue;
        
        NSNumber *emptyNumber = valueArray[i][@"flagEmpty"];
        VerifyFlag emptyFlag = (VerifyFlag)emptyNumber.integerValue;
        
        if (![self character:valueArray[i][@"text"] check:verifyType verifyFlag:emptyFlag length:valueArray[i][@"length"]])
        {
            isFlag = NO;
            NSNumber *verifyTipNumber = dict[@"verifyTip"];
            VerifyTip verifyTip = (VerifyTip)verifyTipNumber.integerValue;
            
            if(verifyTip == VerifyTipShow)
            {
                //                [[HudTool sharedManager]showMessageWithText:@"请按要求输入"];
            }
            
            break;
        };
    }
    
    return isFlag;
}


+(BOOL)character:(NSString *)character check:(VerifyType)verifyType verifyFlag:(VerifyFlag)VerifyFlag length:(NSString *)length {
    __block BOOL isFlag = YES;
    [self characterLength:character verifyType:verifyType vertifyFlag:VerifyFlag length:length  result:^(bool flag) {
        isFlag = flag;
    }];
    return isFlag;
}


+(void)characterLength:(NSString *)character verifyType:(VerifyType)verifyType vertifyFlag:(VerifyFlag)verifyFlag length:(NSString *)length  result:(void(^)(bool))result
{
    if(character.length <= 0 )
    {
        if (verifyFlag == VerifyFlagUnEmpty) {
            result(NO);
        }
        return;
    }
    if (character.length < length.intValue) {
        
        result(NO);
        return;
    }
    
    switch (verifyType) {
        case VerifyTypeChinese:
            if (![self isChinese:character])
            {
                result(NO);
            }
            break;
            
        case VerifyTypeNum:
            if (![self isNumber:character]) {
                result(NO);
            }
            break;
            
        case VerifyTypeLetter:
            if (![self isLetter:character]) {
                result(NO);
            }
            break;
            
        case VerifyTypeNumAndLetter:
            if (![self isHaveSpecialCharacter:character]) {
                result(NO);
            }
            break;
            
        case VerifyTypeIncludeSpace:
            if (![self isHaveSpace:character]) {
                result(NO);
            }
            break;
            
        case VerifyTypePhone:
            if (![self isPhone:character]) {
                result(NO);
            }
            break;
            
        case VerifyTypePassword:
            if (![self isPassword:character]) {
                result(NO);
            }
            break;
            
        case VerifyTpeEmail:
            if (![self isEmail:character]) {
                result(NO);
            }
            break;
            
        case VerifyTypeCardID:
            if (![self isCardID:character]) {
                result(NO);
            }
            break;
            
        case VerifyTypeBankCard:
            if (![self isBankCard:character]) {
                result(NO);
            }
            break;
            
        case VerifyTypeCarNo:
            if (![self isCarNo:character]) {
                result(NO);
            }
            break;
        default:
            break;
    }
}


//调用加载框方法
+(void)showTip:(VerifyTip)verifyTip
{
    if (verifyTip == VerifyTipShow) {
        //        [[HudTool sharedManager]showMessageWithText:@"请输入合法字符"];
    }
}

//判断是否都是数字
+(BOOL)isNumber:(NSString *)string
{
    NSString *condition = @"^[0-9]*$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",condition];
    return [predicate evaluateWithObject:string];
}

//只能输入由26个英文字母组成的字符串
+(BOOL)isLetter:(NSString *)string
{
    NSString *condition = @"^[A-Za-z]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",condition];
    return [predicate evaluateWithObject:string];
}

//只能输入由数字和26个英文字母组成的字符串
+(BOOL)isHaveSpecialCharacter:(NSString *)string
{
    NSString *condition = @"^[A-Za-z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",condition];
    return [predicate evaluateWithObject:string];
}


//只能输入汉字
+(BOOL)isChinese:(NSString *)string
{
    NSString *condition = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",condition];
    return [predicate evaluateWithObject:string];
}

//手机号码验证
+(BOOL)isPhone:(NSString *)string
{
    NSString *condition = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",condition];
    return [predicate evaluateWithObject:string];
}

//验证身份证号（15位或18位数字）
+(BOOL)isCardID:(NSString *)cardID
{
    BOOL flag;
    if (cardID.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *condition = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",condition];
    
    return [identityCardPredicate evaluateWithObject:cardID];
    
}

//密码验证
+(BOOL)isPassword:(NSString *)password
{
    NSString *condition =@"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    
    NSPredicate *prediction = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",condition];
    
    return [prediction evaluateWithObject:password];
}

//银行卡验证
+(BOOL)isBankCard:(NSString *)bankCard
{
    if (bankCard.length < 16) {
        return NO;
    }
    
    NSInteger oddsum = 0;     //奇数求和
    NSInteger evensum = 0;    //偶数求和
    NSInteger allsum = 0;
    NSInteger cardNoLength = (NSInteger)[bankCard length];
    // 取了最后一位数
    NSInteger lastNum = [[bankCard substringFromIndex:cardNoLength-1] intValue];
    //测试的是除了最后一位数外的其他数字
    bankCard = [bankCard substringToIndex:cardNoLength - 1];
    for (NSInteger i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [bankCard substringWithRange:NSMakeRange(i-1, 1)];
        NSInteger tmpVal = [tmpString integerValue];
        if (cardNoLength % 2 ==1 ) {//卡号位数为奇数
            if((i % 2) == 0){//偶数位置
                
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{//奇数位置
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}

//车牌号验证
+(BOOL)isCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:carNo];
}

//验证邮箱地址
+(BOOL)isEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//是否包含有空格
+(BOOL)isHaveSpace:(NSString *)string
{
    NSRange _range = [string rangeOfString:@" "];
    if (_range.location == NSNotFound) {
        //        有空格
        return YES;
    }
    else
    {
        return NO;
    }
}



@end
