//
//  Record.m
//  Ubate
//
//  Created by sunbin on 2017/2/6.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "Record.h"
#import "RecordCell.h"

static NSString *RecordCellIden = @"RecordCellReuseIdentifier";

@interface Record ()

@property (nonatomic ,strong) NSMutableArray *cellData;
@property (nonatomic ,strong) NSMutableArray *sourceData;

@property (nonatomic) JHUD *hudView;

@end

@implementation Record
{
    NSInteger pageIndex;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self deselect:self.tableView];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat padding = 0;
    self.hudView.frame = CGRectMake(padding,
                                    padding,
                                    self.view.frame.size.width - padding*2,
                                    self.view.frame.size.height - padding*2);
}
-(NSMutableArray *)cellData
{
    if (!_cellData) {
        _cellData = [NSMutableArray array];}
    return _cellData;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self loadData];

    WEAKSELF;
    self.hudView = [[JHUD alloc]initWithFrame:self.view.bounds];
    self.hudView.backgroundColor = [UIColor themeColor];
    self.hudView.messageLabel.text = NSLocalizedString(@"正在加载数据", @"Loading data");
    self.hudView.indicatorForegroundColor = kRGBAColor(60, 139, 246, .5);
    self.hudView.indicatorBackGroundColor = [UIColor clearColor];
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCircleJoin];
    // 隐藏
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(disafter * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [JHUD hideForView:weakSelf.view];//隐藏加载view 这里最好实现数据加载
        NSLog(@"index===%ld" ,(long)weakSelf.index);
        [weakSelf getNetWork:weakSelf.index pageCount:10];
    });

    // 重新加载
    [self.hudView setJHUDReloadButtonClickedBlock:^() {
        NSLog(@"重新加载 refreshButton");
        weakSelf.hudView.messageLabel.text = NSLocalizedString(@"正在加载数据", @"Loading data");
;
        [weakSelf.hudView showAtView:weakSelf.view hudType:JHUDLoadingTypeCircleJoin];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(disafter * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JHUD hideForView:weakSelf.view];
            NSLog(@"index===%ld" ,(long)weakSelf.index);
            [weakSelf getNetWork:weakSelf.index pageCount:10];
        });
    }];

    self.tableView.separatorColor = [UIColor py_colorWithHexString:@"#cccccc"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


- (void)initView{
    self.clearsSelectionOnViewWillAppear = NO;
    [NHUtils tableViewProperty:self.tableView registerNib:@"RecordCell" forCellReuseIdentifier:RecordCellIden];
}

- (void)loadData{
    pageIndex = 10;
    WEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex+=10;
        [weakSelf getNetWork:weakSelf.index pageCount:pageIndex];
        [weakSelf.tableView.mj_header endRefreshing];            // 结束刷新
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(disafter * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            pageIndex+=10;
            [weakSelf getNetWork:weakSelf.index pageCount:pageIndex];
            // 结束刷新
            [weakSelf.tableView.mj_footer endRefreshing];
        });
    }];

}

-(void)setIndex:(NSInteger)index{
#pragma make 判断每次传入的index是否相同情况下做网请求
    _index = index;
    if (pageIndex == 0) {
        pageIndex = 10;
    }
    [self getNetWork:index pageCount:pageIndex];
}


-(void)getNetWork:(NSInteger)index pageCount:(NSInteger)page{
    NSDictionary *params = @{
                             @"uid": @([YConfig getOwnID]),
                             @"start":@(0),
                             @"count":@(page),
                             @"type":@(index),
                             @"sign":[YConfig getSign]
                             };
    __weak typeof(self) weakSelf = self;
    [YNetworking postRequestWithUrl:userMoneyLog params:params cache:YES successBlock:^(id returnData, int code, NSString *msg) {
        
        NSDictionary *responseBodyDic = (NSDictionary *)returnData;
        if (code == 1) {
            [JHUD hideForView:weakSelf.view];
            NSArray *data = [responseBodyDic objectForKey:@"data"];
            
            [data enumerateObjectsUsingBlock:^(NSDictionary *objDic, NSUInteger idx, BOOL * _Nonnull stop) {
            }];
            weakSelf.sourceData = [NSMutableArray arrayWithArray:[responseBodyDic objectForKey:@"data"]];
            
            [weakSelf.tableView reloadData];
            
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

        else{
            [weakSelf failure:NO];
        }
        
    } failureBlock:^(NSError *error) {
        NSLog(@"%@" ,[error localizedDescription]);
        //因为做的有数据缓存
        
        if (_sourceData.count != 0) {
        }else{
            [weakSelf failure:YES];
            
        }
        
    } showHUD:NO];
    
    
}

#pragma 熊猫闭眼  失败  按钮
- (void)failure:(BOOL)isNoNet
{
    
    self.hudView.indicatorViewSize = CGSizeMake(76, 57);
    self.hudView.messageLabel.text = isNoNet?NSLocalizedString(@"Data acquisition failure", @"Data acquisition failure"):NSLocalizedString(@"没有任何交易记录", @"At present no data");
    self.hudView.messageLabel.textColor = [UIColor py_colorWithHexString:@"#808080"];
//    [self.hudView.refreshButton setTitle:NSLocalizedString(@"refresh", @"Refresh?") forState:UIControlStateNormal];
    self.hudView.customImage = [UIImage imageNamed:@"kong-1"];
   [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCustomAnimations];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RecordCell *recordCell = [tableView dequeueReusableCellWithIdentifier:RecordCellIden forIndexPath:indexPath];
    
    NSDictionary *sectionAry = [_sourceData objectAtIndex:indexPath.row];
    [recordCell recordData:sectionAry];
    return recordCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RECORDSELECTINDEX object:nil userInfo:[_sourceData objectAtIndex:indexPath.row]];
}


- (void)deselect:(UITableView *)tableView {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [SizeProportion SizeProportionWithHeight:0.1f];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SizeProportion SizeProportionWithHeight:60.f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
