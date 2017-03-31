//
//  代码地址: https://github.com/iphone5solo/PYSearch
//  代码地址: http://www.code4app.com/thread-11175-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYSearchViewController.h"
#import "PYSearchConst.h"
#import "PYSearchSuggestionViewController.h"

#import "HotSearchModel.h"

#define PYRectangleTagMaxCol 3 // 矩阵标签时，最多列数
#define PYTextColor PYColor(113, 113, 113)  // 文本字体颜色
#define PYColorPolRandomColor self.colorPol[arc4random_uniform((uint32_t)self.colorPol.count)] // 随机选取颜色池中的颜色

// 搜索历史存储路径
#define PYSearchHistoriesPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PYRexentSearchs.plist"]

@interface PYSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource >



/** 热门搜索 */
@property (nonatomic, copy) NSArray<NSString *> *hotSearches;
/** 搜索历史 */
@property (nonatomic, strong) NSMutableArray *searchHistories;




/** 搜索栏 */
@property (nonatomic, weak) UISearchBar *searchBar;






/** 键盘正在移动 */
@property (nonatomic, assign) BOOL keyboardshowing;
/** 记录键盘高度 */
@property (nonatomic, assign) CGFloat keyboardHeight;




/** 搜索建议（推荐）控制器  搜索数据显示的搜索列表控制器 */
@property (nonatomic, weak) PYSearchSuggestionViewController *searchSuggestionVC;




/**********************************************************
 *headerContentView=hotSearchTagsContentView+热门搜索文本
 *
 ***/
/** 头部内容view   */
@property (nonatomic, weak) UIView *headerContentView;


/** 热门标签容器 不包括头部（热门搜索文字） */
@property (nonatomic, weak) UIView *hotSearchTagsContentView;
/** 所有的热门标签 */
@property (nonatomic, copy) NSArray<UILabel *> *hotSearchTags;
/** 热门标签头部 */
@property (nonatomic, weak) UILabel *hotSearchHeader;

/** 排名标签(第几名) */
@property (nonatomic, copy) NSArray<UILabel *> *rankTags;
/** 排名内容 */
@property (nonatomic, copy) NSArray<UILabel *> *rankTextLabels;
/** 排名整体标签（包含第几名和内容） */
@property (nonatomic, copy) NSArray<UIView *> *rankViews;

/** 搜索历史标签容器，只有在PYSearchHistoryStyle值为PYSearchHistoryStyleTag才有值 */
@property (nonatomic, weak) UIView *searchHistoryTagsContentView;
/** 存储搜索历史标签 */
@property (nonatomic, copy) NSArray<UILabel *> *searchHistoryTags;
/** 搜索历史标题 */
@property (nonatomic, weak) UILabel *searchHistoryHeader;
/** 搜索历史标签的清空按钮 */
@property (nonatomic, weak) UIButton *emptyButton;

#pragma make -添加到当前控制器view的单元格view
/** 基本搜索TableView(显示历史搜索和搜索记录) */
@property (nonatomic, strong) UITableView *baseSearchTableView;
/** 记录是否点击搜索建议 */
@property (nonatomic, assign) BOOL didClickSuggestionCell;

@end

@implementation PYSearchViewController

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}


#pragma make -实例化操作

//实例化操作
//赋值 热门搜索数据源   搜索框占位文
+ (PYSearchViewController *)searchViewControllerWithHotSearches:(NSArray<NSString *> *)hotSearches searchBarPlaceholder:(NSString *)placeholder
{
    PYSearchViewController *searchVC = [[PYSearchViewController alloc] init];
    searchVC.hotSearches = hotSearches;
    searchVC.searchBar.placeholder = placeholder;
    return searchVC;
}

+ (PYSearchViewController *)searchViewControllerWithHotSearches:(NSArray<NSString *> *)hotSearches searchBarPlaceholder:(NSString *)placeholder didSearchBlock:(PYDidSearchBlock)block
{
    PYSearchViewController *searchVC = [self searchViewControllerWithHotSearches:hotSearches searchBarPlaceholder:placeholder];
    searchVC.didSearchBlock = [block copy];
    return searchVC;
}





#pragma make   贯穿搜索栏状态（没用搜索时 正在搜索时）
#pragma mark - 懒加载 (显示历史搜索和搜索记录)UITableView
- (UITableView *)baseSearchTableView
{
    if (!_baseSearchTableView) {
        UITableView *baseSearchTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        baseSearchTableView.delegate = self;
        baseSearchTableView.dataSource = self;
        
        //添加到当前控制器里
        [self.view addSubview:baseSearchTableView];
        _baseSearchTableView = baseSearchTableView;
    }
    return _baseSearchTableView;
}


#pragma mark - 搜索结果控制器
- (UITableViewController *)searchResultController
{
    if (!_searchResultController) {
        _searchResultController = [[UITableViewController alloc] init];
        self.searchResultTableView = _searchResultController.tableView;
    }
    return _searchResultController;
}


//显示搜索内容控制器 点击搜索数据单元格
- (PYSearchSuggestionViewController *)searchSuggestionVC
{
    if (!_searchSuggestionVC) {
        //创建PYSearchSuggestionViewController控制器
        PYSearchSuggestionViewController *searchSuggestionVC = [[PYSearchSuggestionViewController alloc] initWithStyle:UITableViewStyleGrouped];
        __weak typeof(self) _weakSelf = self;
      
        //选中PYSearchSuggestionViewController的某单元格
        searchSuggestionVC.didSelectCellBlock = ^(NSString *searchContent ,NSString *Cid) {
           
#pragma make 注意自定
            // 设置搜索信息 赋值
            _weakSelf.searchBar.text = searchContent;
            [_weakSelf onCell:_weakSelf.searchBar CID:Cid];
        };
        //设置大小
        searchSuggestionVC.view.frame = CGRectMake(0, 64, self.view.mj_w, self.view.mj_h);
        //设置tableView.contentInset
        searchSuggestionVC.tableView.contentInset = UIEdgeInsetsMake(-30, 0, self.keyboardHeight, 0);
        searchSuggestionVC.view.backgroundColor = self.baseSearchTableView.backgroundColor;
        searchSuggestionVC.view.hidden = YES;
        [self.view addSubview:searchSuggestionVC.view];
        [self addChildViewController:searchSuggestionVC];
        _searchSuggestionVC = searchSuggestionVC;
    }
    return _searchSuggestionVC;
}




#pragma make - 在一些历史记录方式中显示
- (UIButton *)emptyButton
{
    if (!_emptyButton) {
        // 添加清空按钮
        UIButton *emptyButton = [[UIButton alloc] init];
        emptyButton.titleLabel.font = self.searchHistoryHeader.font;
        [emptyButton setTitleColor:PYTextColor forState:UIControlStateNormal];
        [emptyButton setTitle:@"清空" forState:UIControlStateNormal];
        [emptyButton setImage:[UIImage imageNamed:@"PYSearch.bundle/empty"] forState:UIControlStateNormal];
        [emptyButton addTarget:self action:@selector(emptySearchHistoryDidClick) forControlEvents:UIControlEventTouchUpInside];
        [emptyButton sizeToFit];
        emptyButton.mj_w += PYMargin;
        emptyButton.mj_h += PYMargin;
        emptyButton.py_centerY = self.searchHistoryHeader.py_centerY;
        emptyButton.mj_x = self.headerContentView.mj_w - emptyButton.mj_w;
        [self.headerContentView addSubview:emptyButton];
        _emptyButton = emptyButton;
    }
    return _emptyButton;
}



//搜索历史标签容器
- (UIView *)searchHistoryTagsContentView
{
    if (!_searchHistoryTagsContentView) {
        UIView *searchHistoryTagsContentView = [[UIView alloc] init];
        searchHistoryTagsContentView.mj_w = PYScreenW - PYMargin * 2;
        searchHistoryTagsContentView.mj_y = CGRectGetMaxY(self.hotSearchTagsContentView.frame) + PYMargin;
        [self.headerContentView addSubview:searchHistoryTagsContentView];
        _searchHistoryTagsContentView = searchHistoryTagsContentView;
    }
    return _searchHistoryTagsContentView;
}


//热门搜索
- (UILabel *)searchHistoryHeader
{
    if (!_searchHistoryHeader) {
        UILabel *titleLabel = [self setupTitleLabel:PYSearchHistoryText];
        titleLabel.textColor = [UIColor blackColor];

        [self.headerContentView addSubview:titleLabel];
        _searchHistoryHeader = titleLabel;
        _searchHistoryHeader.textColor = [UIColor blackColor];
    }
    return _searchHistoryHeader;
}

//获取历史搜索数据记录
- (NSMutableArray *)searchHistories
{
    if (!_searchHistories) {
        _searchHistories = [NSKeyedUnarchiver unarchiveObjectWithFile:PYSearchHistoriesPath];
        if (!_searchHistories) {
            _searchHistories = [NSMutableArray array];
        }
    }
    return _searchHistories;
}

- (NSMutableArray *)colorPol
{
    if (!_colorPol) {
        NSArray *colorStrPol = @[@"009999", @"0099cc", @"0099ff", @"00cc99", @"00cccc", @"336699", @"3366cc", @"3366ff", @"339966", @"666666", @"666699", @"6666cc", @"6666ff", @"996666", @"996699", @"999900", @"999933", @"99cc00", @"99cc33", @"660066", @"669933", @"990066", @"cc9900", @"cc6600" , @"cc3300", @"cc3366", @"cc6666", @"cc6699", @"cc0066", @"cc0033", @"ffcc00", @"ffcc33", @"ff9900", @"ff9933", @"ff6600", @"ff6633", @"ff6666", @"ff6699", @"ff3366", @"ff3333"];
        NSMutableArray *colorPolM = [NSMutableArray array];
        for (NSString *colorStr in colorStrPol) {
            UIColor *color = [UIColor py_colorWithHexString:colorStr];
            [colorPolM addObject:color];
        }
        _colorPol = colorPolM;
    }
    return _colorPol;
}

/** 视图加载完毕 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

/** 视图将要显示 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 没有热门搜索并且搜索历史为默认PYHotSearchStyleDefault就隐藏
    if (self.hotSearches.count == 0 && self.searchHistoryStyle == PYHotSearchStyleDefault) {
        self.baseSearchTableView.tableHeaderView.mj_h = 0;
        self.baseSearchTableView.tableHeaderView.hidden = YES;
                

    }
    
    
    

}

/** 视图完全显示 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 弹出键盘
    [self.searchBar becomeFirstResponder];
}

/** 控制器销毁 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/***********************************************************
 *1baseSearchTableView=添加到self.view上的单元格
 *2设置右侧按钮
 *3设置默认风格 搜索 热门 跳转风格
 *4创建搜索栏
 *5设置baseSearchTableView头部  尾部
 *
 *
 *
 *
 *
 *
 *
 ***/

/** 初始化 */
- (void)setup
{
    
    self.baseSearchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
   
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 40, 40)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor py_colorWithHexString:@"fafafa"] forState:UIControlStateNormal];
    [btn.titleLabel setFont:FONT_FONTNEWACDEMY(18.f)];
    [btn addTarget:self action:@selector(cancelDidClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    // 热门搜索风格设置
    self.hotSearchStyle = PYHotSearchStyleDefault;
    // 设置搜索历史风格
    self.searchHistoryStyle = PYHotSearchStyleDefault;
    // 设置搜索结果显示模式
    self.searchResultShowMode = PYSearchResultShowModeDefault;
    // 显示搜索建议      searchSuggestionHidden当为NO显示搜索时获取数据
    self.searchSuggestionHidden = NO;
    
    // 创建搜索框
    UIView *titleView = [[UIView alloc] init];
    titleView.mj_x = PYMargin * 0.5;
    titleView.mj_y = 7;
    titleView.mj_w = self.view.mj_w - 64 - titleView.mj_x * 2;
    titleView.mj_h = 30;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:titleView.bounds];
    searchBar.mj_w -= PYMargin * 1.5;
    
    searchBar.tintColor   = [UIColor py_colorWithHexString:@"fafafa"];
    searchBar.placeholder = PYSearchPlaceholderText;
    searchBar.backgroundImage = [UIImage imageNamed:@"PYSearch.bundle/clearImage"];
    searchBar.delegate = self;
    [titleView addSubview:searchBar];
    
    self.searchBar = searchBar;
    
    UIView *textView = [[[self.searchBar.subviews firstObject] subviews] lastObject];
    textView.backgroundColor = [UIColor py_colorWithHexString:@"0d0d0d"];
    
    
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.placeholder = @"请输入商铺名称 如:7天";
    searchField.textColor = [UIColor py_colorWithHexString:@"fafafa"];
    searchField.font = FONT_FONTMicrosoftYaHei(13.f);
    [searchField setValue:[UIColor py_colorWithHexString:@"999999"] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    self.navigationItem.titleView = titleView;
    
    
    // 设置头部（热门搜索）
    UIView *headerView = [[UIView alloc] init];
    UIView *contentView = [[UIView alloc] init];
    contentView.mj_y = PYMargin * 2;
    contentView.mj_x = PYMargin * 1.5;
    contentView.mj_w = PYScreenW - contentView.mj_x * 2;
    [headerView addSubview:contentView];
    UILabel *titleLabel = [self setupTitleLabel:PYHotSearchText];
    //热门搜索字体颜色
    titleLabel.textColor = [UIColor blackColor];
    self.hotSearchHeader = titleLabel;//头部标签显示热门搜索
    [contentView addSubview:titleLabel];
    
    
    // 创建热门搜索标签容器
    UIView *hotSearchTagsContentView = [[UIView alloc] init];
    hotSearchTagsContentView.mj_w = contentView.mj_w;
    hotSearchTagsContentView.mj_y = CGRectGetMaxY(titleLabel.frame) + PYMargin;
    [contentView addSubview:hotSearchTagsContentView];
    self.hotSearchTagsContentView = hotSearchTagsContentView;
    self.headerContentView = contentView;
    //self.headerContentView.backgroundColor = [UIColor redColor];
    self.baseSearchTableView.tableHeaderView = headerView;
    
    
    
    
    // 设置底部(清除历史搜索)
    UIView *footerView = [[UIView alloc] init];
    footerView.mj_w = PYScreenW;
    UILabel *emptySearchHistoryLabel = [[UILabel alloc] init];
    //清空历史搜索记录字体颜色
    emptySearchHistoryLabel.textColor = [UIColor blackColor];
    emptySearchHistoryLabel.font = [UIFont systemFontOfSize:13];
    emptySearchHistoryLabel.userInteractionEnabled = YES;
    emptySearchHistoryLabel.text = PYEmptySearchHistoryText;//清空搜索历史
    emptySearchHistoryLabel.textAlignment = NSTextAlignmentCenter;
    emptySearchHistoryLabel.mj_h = 30;
    [emptySearchHistoryLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptySearchHistoryDidClick)]];
    emptySearchHistoryLabel.mj_w = PYScreenW;
    
    CGFloat height = 0.0f;
    if (Iphone4) {
        height = 80.f;
    }else if (Iphone5) {
        height = 80.f;
    }else if (Iphone6) {
        height = 110.f;
    }else if(Iphone6Plus){
        height = 120.f;
    }else{
        height = 130.f;
    }
    
    //添加垃圾桶图片
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"shanchu"];
    image.mj_w = 20;
    image.mj_h = 25;
    image.frame = CGRectMake(height, 0, image.mj_w, image.mj_h);
    [footerView addSubview:image];
    
    [footerView addSubview:emptySearchHistoryLabel];
    footerView.mj_h = 30;
    self.baseSearchTableView.tableFooterView = footerView;
    
    
    

}

/** 快速创建并设置头部标题（热门 历史） */
- (UILabel *)setupTitleLabel:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.tag = 1;
    titleLabel.textColor = [UIColor blackColor];
    [titleLabel sizeToFit];
    titleLabel.mj_x = 0;
    titleLabel.mj_y = 0;
    return titleLabel;
}













/** 设置热门搜索矩形标签 PYHotSearchStyleRectangleTag */
- (void)setupHotSearchRectangleTags
{
    // 获取标签容器
    UIView *contentView = self.hotSearchTagsContentView;
    // 调整容器布局
    contentView.mj_w = PYScreenW;
    contentView.mj_x = -PYMargin * 1.5;
    contentView.mj_y += 2;
    contentView.backgroundColor = [UIColor whiteColor];
    // 设置tableView背景颜色
    self.baseSearchTableView.backgroundColor = [UIColor py_colorWithHexString:@"#efefef"];
    // 清空标签容器的子控件
    [self.hotSearchTagsContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 添加热门搜索矩形标签
    CGFloat rectangleTagH = 40; // 矩形框高度
    for (int i = 0; i < self.hotSearches.count; i++) {
        // 创建标签
        UILabel *rectangleTagLabel = [[UILabel alloc] init];
        // 设置属性
        rectangleTagLabel.userInteractionEnabled = YES;
        rectangleTagLabel.font = [UIFont systemFontOfSize:14];
        rectangleTagLabel.textColor = PYTextColor;
        rectangleTagLabel.backgroundColor = [UIColor clearColor];
        
        HotSearchModel *model = (HotSearchModel *)self.hotSearches[i];
        rectangleTagLabel.text = model.store_name;
        rectangleTagLabel.mj_w = contentView.mj_w / PYRectangleTagMaxCol;
        rectangleTagLabel.mj_h = rectangleTagH;
        rectangleTagLabel.textAlignment = NSTextAlignmentCenter;
        [rectangleTagLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        // 计算布局
        rectangleTagLabel.mj_x = rectangleTagLabel.mj_w * (i % PYRectangleTagMaxCol);
        rectangleTagLabel.mj_y = rectangleTagLabel.mj_h * (i / PYRectangleTagMaxCol);
        // 添加标签
        [contentView addSubview:rectangleTagLabel];
    }
    
    // 设置标签容器高度
    contentView.mj_h = CGRectGetMaxY(contentView.subviews.lastObject.frame);
    // 设置tableHeaderView高度
    self.baseSearchTableView.tableHeaderView.mj_h  = self.headerContentView.mj_h = CGRectGetMaxY(contentView.frame) + PYMargin * 2;
    // 添加分割线
    for (int i = 0; i < PYRectangleTagMaxCol - 1; i++) { // 添加垂直分割线
        UIImageView *verticalLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PYSearch.bundle/cell-content-line-vertical"]];
        verticalLine.mj_h = contentView.mj_h;
        verticalLine.alpha = 0.7;
        verticalLine.mj_x = contentView.mj_w / PYRectangleTagMaxCol * (i + 1);
        verticalLine.mj_w = 0.5;
        [contentView addSubview:verticalLine];
    }
    for (int i = 0; i < ceil(((double)self.hotSearches.count / PYRectangleTagMaxCol)) - 1; i++) { // 添加水平分割线, ceil():向上取整函数
        UIImageView *verticalLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PYSearch.bundle/cell-content-line"]];
        verticalLine.mj_h = 0.5;
        verticalLine.alpha = 0.7;
        verticalLine.mj_y = rectangleTagH * (i + 1);
        verticalLine.mj_w = contentView.mj_w;
        [contentView addSubview:verticalLine];
    }
}

/** 设置热门搜索标签（带有排名）PYHotSearchStyleRankTag */
- (void)setupHotSearchRankTags
{
    // 获取标签容器
    UIView *contentView = self.hotSearchTagsContentView;
    // 清空标签容器的子控件
    [self.hotSearchTagsContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 添加热门搜索标签
    NSMutableArray *rankTextLabelsM = [NSMutableArray array];
    NSMutableArray *rankTagM = [NSMutableArray array];
    NSMutableArray *rankViewM = [NSMutableArray array];
    for (int i = 0; i < self.hotSearches.count; i++) {
        // 整体标签
        UIView *rankView = [[UIView alloc] init];
        rankView.mj_h = 40;
        rankView.mj_w = (PYScreenW - PYMargin * 3) * 0.5;
        [contentView addSubview:rankView];
        // 排名
        UILabel *rankTag = [[UILabel alloc] init];
        rankTag.textAlignment = NSTextAlignmentCenter;
        rankTag.font = [UIFont systemFontOfSize:10];
        rankTag.layer.cornerRadius = 3;
        rankTag.clipsToBounds = YES;
        rankTag.text = [NSString stringWithFormat:@"%d", i + 1];
        [rankTag sizeToFit];
        rankTag.mj_w = rankTag.mj_h += PYMargin * 0.5;
        rankTag.mj_y = (rankView.mj_h - rankTag.mj_h) * 0.5;
        [rankView addSubview:rankTag];
        [rankTagM addObject:rankTag];
        // 内容
        UILabel *rankTextLabel = [[UILabel alloc] init];
        
        HotSearchModel *model = (HotSearchModel *)self.hotSearches[i];

        rankTextLabel.text =model.store_name;
        rankTextLabel.userInteractionEnabled = YES;
        [rankTextLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        rankTextLabel.textAlignment = NSTextAlignmentLeft;
        rankTextLabel.backgroundColor = [UIColor yellowColor];
        rankTextLabel.textColor = [UIColor blackColor];
        rankTextLabel.font = [UIFont systemFontOfSize:14];
        rankTextLabel.mj_x = CGRectGetMaxX(rankTag.frame) + PYMargin;
        rankTextLabel.mj_w = (PYScreenW - PYMargin * 3) * 0.5 - rankTextLabel.mj_x;
        rankTextLabel.mj_h = rankView.mj_h;
        [rankTextLabelsM addObject:rankTextLabel];
        [rankView addSubview:rankTextLabel];
        // 添加分割线
        UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PYSearch.bundle/cell-content-line"]];
        line.mj_h = 0.5;
        line.alpha = 0.7;
        line.mj_x = -PYScreenW * 0.5;
        line.mj_y = rankView.mj_h - 1;
        line.mj_w = PYScreenW;
        [rankView addSubview:line];
        [rankViewM addObject:rankView];
        
        // 设置排名标签的背景色和字体颜色
        switch (i) {
            case 0: // 第一名
                rankTag.backgroundColor = [UIColor py_colorWithHexString:self.rankTagBackgroundColorHexStrings[0]];
                rankTag.textColor = [UIColor whiteColor];
                break;
            case 1: // 第二名
                rankTag.backgroundColor = [UIColor py_colorWithHexString:self.rankTagBackgroundColorHexStrings[1]];
                rankTag.textColor = [UIColor whiteColor];
                break;
            case 2: // 第三名
                rankTag.backgroundColor = [UIColor py_colorWithHexString:self.rankTagBackgroundColorHexStrings[2]];
                rankTag.textColor = [UIColor whiteColor];
                break;
            default: // 其他
                rankTag.backgroundColor = [UIColor py_colorWithHexString:self.rankTagBackgroundColorHexStrings[3]];
                rankTag.textColor = PYTextColor;
                break;
        }
    }
    self.rankTextLabels = rankTextLabelsM;
    self.rankTags = rankTagM;
    self.rankViews = rankViewM;
    
    // 计算位置
    for (int i = 0; i < self.hotSearchTags.count; i++) { // 每行两个
        UIView *rankView = self.rankViews[i];
        rankView.mj_x = (PYMargin + rankView.mj_w) * (i % 2);
        rankView.mj_y = rankView.mj_h * (i / 2);
    }
    // 设置标签容器高度
    contentView.mj_h = CGRectGetMaxY(self.rankViews.lastObject.frame);
    // 设置tableHeaderView高度
    self.baseSearchTableView.tableHeaderView.mj_h  = self.headerContentView.mj_h = CGRectGetMaxY(contentView.frame) + PYMargin * 2;
    // 重新赋值，注意：当操作系统为iOS 9.x系列的tableHeaderView高度设置失效，需要重新设置tableHeaderView
    [self.baseSearchTableView setTableHeaderView:self.baseSearchTableView.tableHeaderView];
}


/**
 * 设置热门搜索标签(不带排名)
 * PYHotSearchStyleNormalTag || PYHotSearchStyleColorfulTag ||
 * PYHotSearchStyleBorderTag || PYHotSearchStyleARCBorderTag
 */
- (void)setupHotSearchNormalTags
{
    // 添加和布局标签
    self.hotSearchTags = [self addAndLayoutTagsWithTagsContentView:self.hotSearchTagsContentView tagTexts:self.hotSearches];
}



/**
 * 设置搜索历史标签 默认风格（行行显示）
 * PYSearchHistoryStyleTag
 */
- (void)setupSearchHistoryTags
{
    // 隐藏尾部清除按钮
    self.baseSearchTableView.tableFooterView = nil;
    // 添加搜索历史头部
    self.searchHistoryHeader.mj_y = self.hotSearches.count > 0 ? CGRectGetMaxY(self.hotSearchTagsContentView.frame) + PYMargin * 1.5 : 0;
    self.searchHistoryTagsContentView.mj_y = CGRectGetMaxY(self.emptyButton.frame) + PYMargin;
    // 添加和布局标签
    self.searchHistoryTags = [self addAndLayoutTagsWithTagsContentView:self.searchHistoryTagsContentView tagTexts:[self.searchHistories copy]];
}







/**  添加和布局标签 */
- (NSArray *)addAndLayoutTagsWithTagsContentView:(UIView *)contentView tagTexts:(NSArray<NSString *> *)tagTexts;
{
    // 清空标签容器的子控件
    [contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 添加热门搜索标签
    NSMutableArray *tagsM = [NSMutableArray array];
    for (int i = 0; i < tagTexts.count; i++) {
        
        
        HotSearchModel *model = (HotSearchModel *)tagTexts[i];
        UILabel *label = [self labelWithTitle:model.store_name];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        [contentView addSubview:label];
        [tagsM addObject:label];
    }
    
    // 计算位置
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat countRow = 0;
    CGFloat countCol = 0;
    
    // 调整布局
    for (UILabel *subView in tagsM) {
        // 当搜索字数过多，宽度为contentView的宽度
        if (subView.mj_w > contentView.mj_w) subView.mj_w = contentView.mj_w;
        if (currentX + subView.mj_w + PYMargin * countRow > contentView.mj_w) { // 得换行
            subView.mj_x = 0;
            subView.mj_y = (currentY += subView.mj_h) + PYMargin * ++countCol;
            currentX = subView.mj_w;
            countRow = 1;
        } else { // 不换行
            subView.mj_x = (currentX += subView.mj_w) - subView.mj_w + PYMargin * countRow;
            subView.mj_y = currentY + PYMargin * countCol;
            countRow ++;
        }
    }
    // 设置contentView高度
    contentView.mj_h = CGRectGetMaxY(contentView.subviews.lastObject.frame);
    // 设置头部高度
    self.baseSearchTableView.tableHeaderView.mj_h = self.headerContentView.mj_h = CGRectGetMaxY(contentView.frame) + PYMargin * 2;
    // 重新赋值, 注意：当操作系统为iOS 9.x系列的tableHeaderView高度设置失效，需要重新设置tableHeaderView
    [self.baseSearchTableView setTableHeaderView:self.baseSearchTableView.tableHeaderView];
    return [tagsM copy];
}



/** 添加标签 */
- (UILabel *)labelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.userInteractionEnabled = YES;
    label.font = [UIFont systemFontOfSize:12];
    label.text = title;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor py_colorWithHexString:@"#fafafa"];
    label.layer.cornerRadius = 3;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.mj_w += 20;
    label.mj_h += 14;
    return label;
}





#pragma mark - setter  懒加载 搜索到显示的数据
- (void)setSearchSuggestions:(NSArray<NSString *> *)searchSuggestions
{
    if (self.searchSuggestionHidden) return; // 如果隐藏，直接返回，避免刷新操作
    
    _searchSuggestions = [searchSuggestions copy];// 搜索数据内容
    // 赋值给搜索建议控制器 搜索内容
    self.searchSuggestionVC.searchSuggestions = [searchSuggestions copy];
    
}





//排名颜色显示
- (void)setRankTagBackgroundColorHexStrings:(NSArray<NSString *> *)rankTagBackgroundColorHexStrings
{
    if (rankTagBackgroundColorHexStrings.count < 4) { // 不符合要求，使用基本设置
        NSArray *colorStrings = @[@"#f14230", @"#ff8000", @"#ffcc01", @"#ebebeb"];
        _rankTagBackgroundColorHexStrings = colorStrings;
    } else { // 取前四个
        _rankTagBackgroundColorHexStrings = @[rankTagBackgroundColorHexStrings[0], rankTagBackgroundColorHexStrings[1], rankTagBackgroundColorHexStrings[2], rankTagBackgroundColorHexStrings[3]];
    }
    
    // 刷新
    self.hotSearches = self.hotSearches;
}



//热门搜索标签数据
- (void)setHotSearches:(NSArray *)hotSearches
{
    _hotSearches = hotSearches;
    // 没有热门搜索,隐藏相关控件，直接返回
    if (hotSearches.count == 0) {
        self.hotSearchTagsContentView.hidden = YES;
        self.hotSearchHeader.hidden = YES;
        return;
    };
    
    if (self.hotSearchStyle == PYHotSearchStyleDefault
        || self.hotSearchStyle == PYHotSearchStyleColorfulTag
        || self.hotSearchStyle == PYHotSearchStyleBorderTag
        || self.hotSearchStyle == PYHotSearchStyleARCBorderTag) { // 不带排名的标签
        [self setupHotSearchNormalTags];
    } else if (self.hotSearchStyle == PYHotSearchStyleRankTag) { // 带有排名的标签
        [self setupHotSearchRankTags];
    } else if (self.hotSearchStyle == PYHotSearchStyleRectangleTag) { // 矩阵标签
        [self setupHotSearchRectangleTags];
    }
}



//设置历史搜索风格setSearchHistoryStyle
- (void)setSearchHistoryStyle:(PYSearchHistoryStyle)searchHistoryStyle
{
    _searchHistoryStyle = searchHistoryStyle;
    
    
    /****************************************************
     *当默认时走单元格 searchHistoryStyle == UISearchBarStyleDefault
     *当不为默认时 走setupSearchHistoryTags自定义
     *
     */
    // 默认cell，直接返回
    if (searchHistoryStyle == UISearchBarStyleDefault) return;
    
    
    
    
    // 创建、初始化默认标签
    [self setupSearchHistoryTags];
    // 根据标签风格设置标签
    switch (searchHistoryStyle) {
        case PYSearchHistoryStyleColorfulTag: // 彩色标签
            for (UILabel *tag in self.searchHistoryTags) {
                // 设置字体颜色为白色
                tag.textColor = [UIColor whiteColor];
                // 取消边框
                tag.layer.borderColor = nil;
                tag.layer.borderWidth = 0.0;
                tag.backgroundColor = PYColorPolRandomColor;
            }
            break;
        case PYSearchHistoryStyleBorderTag: // 边框标签
            for (UILabel *tag in self.searchHistoryTags) {
                // 设置背景色为clearColor
                tag.backgroundColor = [UIColor clearColor];
                // 设置边框颜色
                tag.layer.borderColor = PYColor(223, 223, 223).CGColor;
                // 设置边框宽度
                tag.layer.borderWidth = 0.5;
            }
            break;
        case PYSearchHistoryStyleARCBorderTag: // 圆弧边框标签
            for (UILabel *tag in self.searchHistoryTags) {
                // 设置背景色为clearColor
                tag.backgroundColor = [UIColor clearColor];
                // 设置边框颜色
                tag.layer.borderColor = PYColor(223, 223, 223).CGColor;
                // 设置边框宽度
                tag.layer.borderWidth = 0.5;
                // 设置边框弧度为圆弧
                tag.layer.cornerRadius = tag.mj_h * 0.5;
                
                
            }
            break;
            
        default:
            break;
    }
}



//设置热门搜索的风格
- (void)setHotSearchStyle:(PYHotSearchStyle)hotSearchStyle
{
    _hotSearchStyle = hotSearchStyle;
    switch (hotSearchStyle) {
        case PYHotSearchStyleColorfulTag: // 彩色标签
            for (UILabel *tag in self.hotSearchTags) {
                // 设置字体颜色为白色
                tag.textColor = [UIColor whiteColor];
                // 取消边框
                tag.layer.borderColor = nil;
                tag.layer.borderWidth = 0.0;
                tag.backgroundColor = PYColorPolRandomColor;
            }
            break;
        case PYHotSearchStyleBorderTag: // 边框标签
            for (UILabel *tag in self.hotSearchTags) {
                // 设置背景色为clearColor
                tag.backgroundColor = [UIColor clearColor];
                // 设置边框颜色
                tag.layer.borderColor = PYColor(223, 223, 223).CGColor;
                // 设置边框宽度
                tag.layer.borderWidth = 0.5;
            }
            break;
        case PYHotSearchStyleARCBorderTag: // 圆弧边框标签
            for (UILabel *tag in self.hotSearchTags) {
                // 设置背景色为clearColor
                tag.backgroundColor = [UIColor clearColor];
                // 设置边框颜色
                tag.layer.borderColor = PYColor(223, 223, 223).CGColor;
                // 设置边框宽度
                tag.layer.borderWidth = 0.5;
                // 设置边框弧度为圆弧
                tag.layer.cornerRadius = tag.mj_h * 0.5;
                // 设置字体颜色
                tag.textColor = [UIColor py_colorWithHexString:@"1074b7"];
            }
            break;
        case PYHotSearchStyleRectangleTag: // 九宫格标签
            self.hotSearches = self.hotSearches;
            break;
        case PYHotSearchStyleRankTag: // 排名标签
            self.rankTagBackgroundColorHexStrings = nil;
            break;
            
        default:
            break;
    }
}





/** 键盘显示完成（弹出） */
- (void)keyboardDidShow:(NSNotification *)noti
{
    // 取出键盘高度
    NSDictionary *info = noti.userInfo;
    self.keyboardHeight = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.keyboardshowing = YES;
}




#pragma mkae even取消事件
/** 点击取消 */
- (void)cancelDidClick
{
    [self.searchBar resignFirstResponder];
    
    // dismiss ViewController
    [self dismissViewControllerAnimated:NO completion:nil];
    
    // 调用代理方法
    if ([self.delegate respondsToSelector:@selector(didClickCancel:)]) {
        [self.delegate didClickCancel:self];
    }
}
#pragma mkae even 点击清空历史按钮
/** 点击清空历史按钮 */
- (void)emptySearchHistoryDidClick
{
    // 移除所有历史搜索
    [self.searchHistories removeAllObjects];
    // 移除数据缓存
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:PYSearchHistoriesPath];
    if (self.searchHistoryStyle == PYSearchHistoryStyleCell) {
        // 刷新cell
        [self.baseSearchTableView reloadData];
    } else {
        // 更新
        self.searchHistoryStyle = self.searchHistoryStyle;
    }
    PYSearchLog(@"清空历史记录");
}


#pragma make -选中热门搜索标签
/** 选中标签 */
- (void)tagDidCLick:(UITapGestureRecognizer *)gr
{
    UILabel *label = (UILabel *)gr.view;
    self.searchBar.text = label.text;
    [self searchBarSearchButtonClicked:self.searchBar];//点击搜索键
    
    if (self.searchHistoryStyle == PYSearchHistoryStyleCell) { // 搜索历史为标签时，刷新标签
        // 刷新tableView
        [self.baseSearchTableView reloadData];
    } else {
        // 更新
        self.searchHistoryStyle = self.searchHistoryStyle;
    }
    PYSearchLog(@"搜索 %@", label.text);
}
#pragma mark - UISearchBarDelegate 搜索列表点击
- (void)onCell:(UISearchBar *)searchBar CID:(NSString *)cid{

    // 回收键盘
    [searchBar resignFirstResponder];
    // 先移除再刷新
    [self.searchHistories removeObject:searchBar.text];
    [self.searchHistories insertObject:searchBar.text atIndex:0];
    // 刷新数据 搜索历史分割searchHistoryStyle
    if (self.searchHistoryStyle == PYSearchHistoryStyleCell) { // 普通风格Cell
        [self.baseSearchTableView reloadData];
    } else { // 搜索历史为标签
        // 更新
        self.searchHistoryStyle = self.searchHistoryStyle;
    }
    // 保存搜索信息
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:PYSearchHistoriesPath];
    // 处理搜索结果
    switch (self.searchResultShowMode) {
        case PYSearchResultShowModePush: // Push
            [self.navigationController pushViewController:self.searchResultController animated:YES];
            break;
        case PYSearchResultShowModeEmbed: // 内嵌
            // 添加搜索结果的视图
            [self.view addSubview:self.searchResultController.tableView];
            [self addChildViewController:self.searchResultController];
            break;
        case PYSearchResultShowModeCustom: // 自定义
            
            break;
        default:
            break;
    }
    
#pragma make - 点击搜索结果列表 方法如下 代理 block
    
    //1 如果代理实现了代理方法则调用代理方法
#if 0
    if ([self.delegate respondsToSelector:@selector(searchViewController:didSearchWithsearchBar:searchText:storeID:)]) {
        [self.delegate searchViewController:self didSearchWithsearchBar:searchBar searchText:searchBar.text storeID:cid];
        return;
    }

#endif
    //2 如果有block则调用
    if (self.didSearchBlock) self.didSearchBlock(self, searchBar, searchBar.text ,cid);

}
#pragma make 搜索键点击

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
    NSLog(@"searchBar.text====%@" ,searchBar.text);

    
    _searchSuggestionVC.searchType = OnclickSearch;

    // 根据输入文本显示建议搜索条件
    self.searchSuggestionVC.view.hidden = self.searchSuggestionHidden || !searchBar.text.length;
    // 放在最上层
    [self.view bringSubviewToFront:self.searchSuggestionVC.view];
    // 如果代理实现了代理方法则调用代理方法
    if ([self.delegate respondsToSelector:@selector(searchViewController:searchTextDidChange:searchText:)]) {
        [self.delegate searchViewController:self searchTextDidChange:searchBar searchText:searchBar.text];
    }

}

#pragma make 输入数据变化
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

    _searchSuggestionVC.searchType = EnterText;
    // 根据输入文本显示建议搜索条件
    self.searchSuggestionVC.view.hidden = self.searchSuggestionHidden || !searchText.length;
    // 放在最上层
    [self.view bringSubviewToFront:self.searchSuggestionVC.view];
    // 如果代理实现了代理方法则调用代理方法
    if ([self.delegate respondsToSelector:@selector(searchViewController:searchTextDidChange:searchText:)]) {
        [self.delegate searchViewController:self searchTextDidChange:searchBar searchText:searchText];
    }
}





#pragma make -单个单元格删除
- (void)closeDidClick:(UIButton *)sender
{
    // 获取当前cell
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    // 移除搜索信息
    [self.searchHistories removeObject:cell.textLabel.text];
    // 保存搜索信息
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:PYSearchHistoriesPath];
    // 刷新
    [self.baseSearchTableView reloadData];
}

#pragma mark - Table view data source 注意当热门搜索无网络时不显示 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 当搜索方式为默认时=就不显示搜索历史标签
    // 没有搜索记录就隐藏
    // 当搜索历史为空时 就隐藏tableFooterView
    self.baseSearchTableView.tableFooterView.hidden = self.searchHistories.count == 0;
    
    
    
    return  self.searchHistoryStyle == PYSearchHistoryStyleCell ? self.searchHistories.count : 0;
    
}


#pragma make 显示搜索历史的数据 只显示默认历史风格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"PYSearchHistoryCellID";
    // 创建cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.backgroundColor = [UIColor clearColor];
        
        // 添加关闭按钮
        UIButton *closetButton = [[UIButton alloc] init];
        // 设置图片容器大小、图片原图居中
        closetButton.mj_size = CGSizeMake(cell.mj_h, cell.mj_h);
        [closetButton setImage:[UIImage imageNamed:@"PYSearch.bundle/close"] forState:UIControlStateNormal];
        UIImageView *closeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PYSearch.bundle/close"]];
        [closetButton addTarget:self action:@selector(closeDidClick:) forControlEvents:UIControlEventTouchUpInside];
        closeView.contentMode = UIViewContentModeCenter;
        cell.accessoryView = closetButton;
        // 添加分割线
        UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PYSearch.bundle/cell-content-line"]];
        line.mj_h = 0.5;
        line.alpha = 0.7;
        line.mj_x = PYMargin;
        line.mj_y = 43;
        line.mj_w = PYScreenW;
        [cell.contentView addSubview:line];
    }
    
    // 设置数据
    cell.imageView.image = PYSearchHistoryImage;
    cell.textLabel.text = self.searchHistories[indexPath.row];
    
    return cell;
}


//注意优先级
//NSString *const PYSearchHistoryText = @"搜索历史";          // 搜索历史文本 默认为 @"搜索历史"
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.searchHistories.count && self.searchHistoryStyle == PYSearchHistoryStyleCell ? PYSearchHistoryText : nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.searchBar.text = cell.textLabel.text;

    
    _searchSuggestionVC.searchType = EnterText;
    // 根据输入文本显示建议搜索条件
    self.searchSuggestionVC.view.hidden = self.searchSuggestionHidden || !cell.textLabel.text.length;
    // 放在最上层
    [self.view bringSubviewToFront:self.searchSuggestionVC.view];
    // 如果代理实现了代理方法则调用代理方法
    if ([self.delegate respondsToSelector:@selector(searchViewController:searchTextDidChange:searchText:)]) {
        [self.delegate searchViewController:self searchTextDidChange:_searchBar searchText:cell.textLabel.text];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 滚动时，回收键盘
    if (self.keyboardshowing) [self.searchBar resignFirstResponder];
}









@end
