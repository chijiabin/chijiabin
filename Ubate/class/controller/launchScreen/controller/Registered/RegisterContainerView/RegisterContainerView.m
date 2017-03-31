//
//  RegisterContainerView.m
//  Ubate
//
//  Created by sunbin on 2016/12/20.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "RegisterContainerView.h"

@interface RegisterContainerView()<UITextFieldDelegate ,RTLabelDelegate>{
    NSString    *_previousTextFieldContent;
    UITextRange *_previousSelection;
}

@property (weak, nonatomic) IBOutlet RTLabel *terms;
@property (weak, nonatomic) IBOutlet UIButton *registerType;
@property (weak, nonatomic) IBOutlet UIView *nav;
@property (nonatomic ,assign) NSInteger currentRegisterType;

@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;


@end

@implementation RegisterContainerView

+ (instancetype)RegisterView:(RegisterMethod)method{
    RegisterContainerView *registerContainerView = [self loadFromNib];
    
    
    NSString *accountType;
    // 设置控件属性
    if (method == RegisterPhone) {
        accountType = @"手机号  ";
        registerContainerView.currentRegisterType = 0;
        [registerContainerView.registerType setTitle:@"邮箱注册" forState:UIControlStateNormal];
        
        registerContainerView.account.delegate = registerContainerView;
        [registerContainerView.account setPlaceholder:@"请输入11位手机号"];
        
        registerContainerView.lab1.text = @"通过手机号";
        registerContainerView.lab2.text = @"注册账号";
        
        registerContainerView.account.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    if (method == Registeremail) {
        accountType = @"邮箱  ";
        registerContainerView.currentRegisterType = 1;
        [registerContainerView.registerType setTitle:@"手机注册" forState:UIControlStateNormal];
        
        [registerContainerView.account setPlaceholder:@"请输入邮箱地址"];
        registerContainerView.lab1.text = @"通过邮箱地址";
        registerContainerView.lab2.text = @"注册账号";
        registerContainerView.account.keyboardType = UIKeyboardTypeEmailAddress;

        
    }
    
    [registerContainerView.account leftViewModeWithConstrainedToWidth:100.f text:accountType isLaunchScreen:YES fon:18.f leftFonColor:@"e5e5e5" bodyFonColor:@"e5e5e5" PlaceholderColor:@"666666"];

    [registerContainerView.pwd leftViewModeWithConstrainedToWidth:100.f text:@"密码  " isLaunchScreen:YES fon:18.f leftFonColor:@"e5e5e5" bodyFonColor:@"e5e5e5" PlaceholderColor:@"666666"];

    
    
    registerContainerView.pwd.delegate = registerContainerView;
    [registerContainerView.account setPlaceholderColor:[UIColor py_colorWithHexString:@"999999"]];
    [registerContainerView.pwd setPlaceholderColor:[UIColor py_colorWithHexString:@"999999"]];

    [registerContainerView termsAndAgreement];
    registerContainerView.configBtn.enabled = NO;
    
    [registerContainerView.configBtn setTitleColor:[UIColor py_colorWithHexString:@"666666"] forState:UIControlStateDisabled];
    [registerContainerView.configBtn setTitleColor:[UIColor py_colorWithHexString:@"e5e5e5"] forState:UIControlStateNormal];
    
    [registerContainerView.configBtn setBackgroundColor:[UIColor py_colorWithHexString:@"208dcf" alpha:1] forState:UIControlStateNormal];
    [registerContainerView.configBtn setBackgroundColor:[UIColor py_colorWithHexString:@"333333" alpha:0.6] forState:UIControlStateDisabled];
    [registerContainerView.configBtn setLayerBorderWidth:0 borderColor:nil];
    
    
    return registerContainerView;
}

// 加载xib
+ (instancetype)loadFromNib{
    
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RegisterContainerView" owner:nil options:nil];
    return [objects lastObject];
    
}

// 文本输入内容监听
- (IBAction)editingchang:(UITextField *)sender {
    if (![NHUtils isBlankString:_account.text] && ![NHUtils isBlankString:_pwd.text]) {
        _configBtn.enabled = YES;
        
    }else{
        _configBtn.enabled = NO;
    }
}

// 确认按钮事件触发
- (IBAction)registered {
    // 结束编辑
    [self endEditing:YES];
    // block传值
    self.registerHandler(self.account.text,self.pwd.text);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (![NHUtils isBlankString:_pwd.text] && ![NHUtils isBlankString:_account.text]) {
        [self registered];
    }else{
        [_pwd becomeFirstResponder];
    }
    return YES;

}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (Iphone4) {
        _nav.hidden = YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (Iphone4) {
        _nav.hidden = NO;
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
}


- (void)termsAndAgreement{
    
    NSString *sample_text =  @"<p align=center>注册表示您已同意<a href='2'>服务使用协议</a>和<a href='3'>隐私条款</a></p>";
    _terms.delegate = self;
    [_terms setText:sample_text];
    _terms.font = FONT_FONTADOBEGEITI(12);
    _terms.textColor = [UIColor py_colorWithHexString:@"#999999"];

}


#define RTLabelDelegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    NSString *str = [url absoluteString];
    if ([self.delegate respondsToSelector:@selector(terms:)]) {
        [self.delegate terms:[str integerValue]];
    }
    
}




- (IBAction)navOperation:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if ([self.delegate respondsToSelector:@selector(navBtnIdex:)]) {
        [self.delegate navBtnIdex:tag];
    }
}




#if 0
#pragma mkae -手机格式符号
-(void)reformatAsPhoneNumber:(UITextField *)textField {
    /**
     *  判断正确的光标位置
     */
    NSUInteger targetCursorPostion = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    NSString *phoneNumberWithoutSpaces = [self removeNonDigits:textField.text andPreserveCursorPosition:&targetCursorPostion];
    
    
    if([phoneNumberWithoutSpaces length]>11) {
        /**
         *  避免超过11位的输入
         */
        
        [textField setText:_previousTextFieldContent];
        textField.selectedTextRange = _previousSelection;
        
        return;
    }
    
    
    NSString *phoneNumberWithSpaces = [self insertSpacesEveryFourDigitsIntoString:phoneNumberWithoutSpaces andPreserveCursorPosition:&targetCursorPostion];
    
    textField.text = phoneNumberWithSpaces;
    UITextPosition *targetPostion = [textField positionFromPosition:textField.beginningOfDocument offset:targetCursorPostion];
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPostion toPosition:targetPostion]];
    
}

/**
 *  除去非数字字符，确定光标正确位置
 *
 *  @param string         当前的string
 *  @param cursorPosition 光标位置
 *
 *  @return 处理过后的string
 */
- (NSString *)removeNonDigits:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition {
    NSUInteger originalCursorPosition =*cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    
    for (NSUInteger i=0; i<string.length; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        
        if(isdigit(characterToAdd)) {
            NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
            [digitsOnlyString appendString:stringToAdd];
        }
        else {
            if(i<originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    return digitsOnlyString;
}

/**
 *  将空格插入我们现在的string 中，并确定我们光标的正确位置，防止在空格中
 *
 *  @param string         当前的string
 *  @param cursorPosition 光标位置
 *
 *  @return 处理后有空格的string
 */
- (NSString *)insertSpacesEveryFourDigitsIntoString:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    
    for (NSUInteger i=0; i<string.length; i++) {
        if(i>0)
        {
            if(i==3 || i==7) {
                [stringWithAddedSpaces appendString:@"-"];
                
                if(i<cursorPositionInSpacelessString) {
                    (*cursorPosition)++;
                }
            }
        }
        
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    return stringWithAddedSpaces;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (_currentRegisterType == 0) {
        _previousSelection = textField.selectedTextRange;
        _previousTextFieldContent = textField.text;
        
        if(range.location==0) {
            if(string.integerValue >1)
            {
                return NO;
            }
        }
        
        return YES;
        
    }
    
    if (_currentRegisterType == 1) {
        return YES;
    }
    
    return YES;
}



#endif





@end

