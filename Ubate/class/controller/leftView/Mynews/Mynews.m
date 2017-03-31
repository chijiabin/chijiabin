//
//  Mynews.m
//  Ubate
//
//  Created by 池先生 on 17/3/15.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "Mynews.h"
#import "YMTextView.h"

#define LHHeight  [UIScreen mainScreen].bounds.size.height
#define LHWIDTH  [UIScreen mainScreen].bounds.size.width
@interface Mynews ()<UITextViewDelegate,UIScrollViewDelegate>
@property (nonatomic, weak) YMTextView *textView;
@property (nonatomic, weak) YMTextView *email;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic,strong)UIScrollView *myScrollView;
@property (nonatomic, strong) UITapGestureRecognizer *cancelKeyBoard;//!< 取消键盘
@end

@implementation Mynews{
    
    YUserInfo *userInfor;
    
    BOOL _wasKeyboardManagerEnabled;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];    
    self.title = NSLocalizedString(@"我有意见", @"My news");
    
    
    // 添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mynews_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mynews_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用当前界面IQKeyBoardManager
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 启动当前界面IQKeyBoardManager
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
}


- (void)cancelKeyBoardAction
{
    [self.view endEditing:YES];
}

#pragma mark - keyboard events -

//键盘显示事件
- (void)mynews_keyboardWillShow:(NSNotification *)notification {
    
    if ([_textView isFirstResponder]) {
        //获取键盘高度，在不同设备上，以及中英文下是不同的
        CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        
        //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
        CGFloat offset = (self.textView.frame.origin.y+self.textView.frame.size.height - 10) - (self.view.frame.size.height - kbHeight);
        
        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
        double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        //将视图上移计算好的偏移
        if(offset > 0) {
            [UIView animateWithDuration:duration animations:^{
                self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
    }else{
        //获取键盘高度，在不同设备上，以及中英文下是不同的
        CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        
        //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
        CGFloat offset = (self.email.frame.origin.y+self.email.frame.size.height+20) - (self.view.frame.size.height - kbHeight);
        
        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
        double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        //将视图上移计算好的偏移
        if(offset > 0) {
            [UIView animateWithDuration:duration animations:^{
                self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
    }
}

///键盘消失事件
- (void)mynews_keyboardWillHide:(NSNotification *)notify {
    
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
     userInfor = [YConfig myProfile];
    
    _myScrollView=[[UIScrollView alloc]init];
    _myScrollView.frame=CGRectMake(0, 0, LHWIDTH, LHHeight);
    // 是否反弹
    //_myScrollView.bounces = NO;
    _myScrollView.userInteractionEnabled=YES;
    // 是否滚动
    _myScrollView.scrollEnabled = YES;
    _myScrollView.delegate=self;
    _myScrollView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.myScrollView];
    
    //设置输入控件
    [self setupTextView];
    //邮箱
    [self Email];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor py_colorWithHexString:@"fafafa"];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(65, 480, self.view.frame.size.width-130, 50);
    self.button.backgroundColor = [UIColor redColor];
    [self.button setTitle:@"确认发送" forState:UIControlStateNormal];
    [self.button setLayerCornerRadius:8.0f borderWidth:0.5f borderColor:[UIColor clearColor]];
    [self.button addTarget:self action:@selector(Mynewsrequest) forControlEvents:UIControlEventTouchUpInside];
    [self.myScrollView addSubview:self.button];
    
    self.button.userInteractionEnabled=NO;
    self.button.backgroundColor = [UIColor py_colorWithHexString:@"82b4d6"];
 
    self.textView.delegate = self ;
    self.email.delegate = self;
    
    [self.view addGestureRecognizer:self.cancelKeyBoard];
    
    [self lableview];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)lableview{

    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 205 , 410, 180, 20)];
    lable.text = @"我们将会以邮件的形式回复您的反馈";
    lable.font = [UIFont systemFontOfSize:11];
    lable.textColor = [UIColor py_colorWithHexString:@"#999999"];
    
    [self.myScrollView addSubview:lable];


}

-(void)Email{

    YMTextView *Email = [[YMTextView alloc] init];
    Email.frame = CGRectMake(25, 360, self.view.frame.size.width-50, 35);
    Email.backgroundColor = [UIColor whiteColor];
    Email.font = [UIFont systemFontOfSize:13];
    
    if ([userInfor.user_email isEqualToString:@""]) {        
        Email.placeholder = @"请输入您的邮箱";
    }else{
        
        Email.placeholder = userInfor.user_email;
        
    }
    
    Email.placeholderColor = [UIColor py_colorWithHexString:@"#999999"];
    Email.textColor = [UIColor py_colorWithHexString:@"#666666"];
    
    [Email setLayerCornerRadius:8.0f borderWidth:0.5f borderColor:[UIColor py_colorWithHexString:@"#999999"]];

    Email.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    [self.myScrollView addSubview:Email];
    
    self.email = Email;
}


//添加输入控件
-(void)setupTextView {
    // 在这个控制器中，textView的contentInset.top默认会等于64
    YMTextView *textView = [[YMTextView alloc] init];
    textView.frame = CGRectMake(25, 90, self.view.frame.size.width-50, 260);
    textView.backgroundColor = [UIColor whiteColor];
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholder = @"为了UBATE优现成为你最喜欢的工具应用，如果你有任何产品或体验上的建议或意见，请大胆的联系我们，我们会尽快给您反馈。";
    textView.placeholderColor = [UIColor py_colorWithHexString:@"#999999"];
    
    textView.textColor = [UIColor py_colorWithHexString:@"#666666"];
    [textView setLayerCornerRadius:8.0f borderWidth:0.5f borderColor:[UIColor py_colorWithHexString:@"#999999"]];

    textView.layer.shadowColor = [UIColor blackColor].CGColor;
    textView.layer.shadowOpacity = 0.8f;
    textView.layer.shadowOffset = CGSizeMake(1,1);
    textView.layer.shadowRadius = 1.0f;
    textView.layer.shouldRasterize = YES;
    textView.keyboardType = UIKeyboardTypeEmailAddress;
    textView.keyboardType = UIKeyboardTypeDefault;
    
    [self.myScrollView addSubview:textView];
    self.textView = textView;
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
}
/**
 *  监听文字改变
 */
-(void)textDidChange {
    
    if (self.textView.hasText) {
        NSLog(@"文字发生改变----%@",self.textView.text);
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//输入框监听
- (void)textViewDidChange:(UITextView *)textView
{
    if ((self.textView.text.length > 0 && self.email.text.length > 0)
        ||(self.textView.text.length > 0 && [self.email.placeholder isEqualToString:userInfor.user_email]) )
    {
        self.button.userInteractionEnabled=YES;
            self.button.backgroundColor = [UIColor py_colorWithHexString:@"1074b7"];
    }else{
        
        self.button.userInteractionEnabled=NO;
        self.button.backgroundColor = [UIColor py_colorWithHexString:@"82b4d6"];
        
    }
}

//一旦滚动就一直调用 直到停止
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"111");
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    _myScrollView.contentSize = CGSizeMake(LHWIDTH, LHHeight+height-100);
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    _myScrollView.contentSize = CGSizeMake(LHWIDTH, LHHeight);
}


-(void)Mynewsrequest{

    if (self.email.text.length == 0) {
        
        if ([self.email.placeholder isEqualToString:userInfor.user_email]) {
            [self request];
        }else{
             [self.view showSuccess:@"邮箱格式有误,请重新输入"];
        }
    }else{
        if ([self.email.text isEmailAddress]){
        
            [self request];
        }
        else{
        
            [self.view showSuccess:@"邮箱格式有误,请重新输入"];
        
        }
    }
}

- (void)request{

    NSDictionary *params = @{
                             @"uid":  @([YConfig getOwnID]),
                             @"content":self.textView.text,
                             @"email":[NHUtils isBlankString:userInfor.user_email]?self.email.text : userInfor.user_email,
                             @"sign":[YConfig getSign]
                             };

    [YNetworking postRequestWithUrl:MyNews params:params cache:YES successBlock:^(id returnData, int code, NSString *msg) {
        
        
        if (code == 1) {
            [self.view showSuccess:msg];
            
            dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
            dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else if(code == 201){

            [self.view showSuccess:@"登录过期，请重新登录"];
            
            dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
            dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                [YConfig outlog];
            });
            
        }else if(code == 202){
        
            [self.view showSuccess:@"您的帐号在另一处登录，请重新登录"];
            
            dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
            dispatch_after(timer, dispatch_get_main_queue(), ^(void){
                [YConfig outlog];
            });
        
        }

        
        } failureBlock:^(NSError *error) {
        
        [self.view showSuccess:@"反馈失败"];
        
    } showHUD:NO];
    
}

#pragma mark 懒加载

- (UITapGestureRecognizer *)cancelKeyBoard
{
    if (!_cancelKeyBoard) {
        _cancelKeyBoard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyBoardAction)];
    }
    return _cancelKeyBoard;
}





@end
