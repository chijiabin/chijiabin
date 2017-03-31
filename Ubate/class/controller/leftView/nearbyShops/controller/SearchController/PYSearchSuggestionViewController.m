//
//  代码地址: https://github.com/iphone5solo/PYSearch
//  代码地址: http://www.code4app.com/thread-11175-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//  搜索内容显示

#import "PYSearchSuggestionViewController.h"
#import "PYSearchConst.h"
#import "NeartheshopCell.h"
#import "CustomerCell.h"
#import "SearchStoreModelData.h"
#import "JHUD.h"

static NSString *CustomerCell_IDEN = @"CustomerCell_IDEN";
static NSString *NeartheshopCel_IDEN = @"NeartheshopCel_IDEN";

@interface PYSearchSuggestionViewController ()

@property (nonatomic) JHUD *hudView;


@end

@implementation PYSearchSuggestionViewController
{
    NSInteger makeIndex;
}
+ (instancetype)searchSuggestionViewControllerWithDidSelectCellBlock:(PYSearchSuggestionDidSelectCellBlock)didSelectCellBlock
{
    PYSearchSuggestionViewController *searchSuggestionVC = [[PYSearchSuggestionViewController alloc] init];
    searchSuggestionVC.didSelectCellBlock = didSelectCellBlock;
    return searchSuggestionVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hudView = [[JHUD alloc]initWithFrame:self.view.bounds];

    __weak typeof(self)  _self = self;
    //点击
    [_self.hudView setJHUDReloadButtonClickedBlock:^() {
        NSLog(@"refreshButton");

    }];
    

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor appSeparatorColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomerCell" bundle:nil] forCellReuseIdentifier:CustomerCell_IDEN];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NeartheshopCell" bundle:nil] forCellReuseIdentifier:NeartheshopCel_IDEN];

}

- (void)setSearchSuggestions:(NSArray<NSString *> *)searchSuggestions
{
    
     [JHUD showAtView:self.view message:@"正在加载搜索数据"];
    //bug修复  程序走两次
    _searchSuggestions = [searchSuggestions copy];
    NSLog(@"%@" ,_searchSuggestions);
    makeIndex += 1;
    NSLog(@"makeIndex===%ld" ,(long)makeIndex);
    
    WEAKSELF;
//    weakSelf.hudView.indicatorForegroundColor = kRGBAColor(60, 139, 246, .5);
//    weakSelf.hudView.indicatorBackGroundColor = [UIColor clearColor];
//    [JHUD showAtView:self.view message:nil];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(disafter * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.searchSuggestions.count != 0) {
            [JHUD hideForView:self.view];
            // 刷新数据
            [self.tableView reloadData];
        }else{
            if (makeIndex != 1) {
            
                [weakSelf failure];
                
            }
            //[JHUD hideForView:self.view];
        }
    });
}


- (void)loadInng{


}

- (void)classMethod
{
    
   

    WEAKSELF;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.searchSuggestions.count != 0) {
            [JHUD hideForView:self.view];
        }else{
            [weakSelf failure];
        }
    });
    
}



#pragma 熊猫闭眼  失败  按钮
- (void)failure
{
    self.hudView.indicatorViewSize = CGSizeMake(150, 150);
    self.hudView.messageLabel.text = @"暂无搜索到任何内容,可尝试搜索其他商铺";
    [self.hudView.refreshButton setTitle:@"Refresh ?" forState:UIControlStateNormal];
    self.hudView.customImage = [UIImage imageNamed:@"tishi"];
    
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeFailure];
    
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.searchSuggestions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SearchStoreModelData *storeModelData = (SearchStoreModelData *)[_searchSuggestions objectAtIndex:indexPath.row];

    //输入后显示的样式
    if (_searchType == EnterText) {
        CustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomerCell_IDEN];
        cell.storeModelData = storeModelData;
        return cell;
    }

    //搜索按确定后的样式
    if (_searchType == OnclickSearch) {        
        NeartheshopCell *cell = [tableView dequeueReusableCellWithIdentifier:NeartheshopCel_IDEN forIndexPath:indexPath];
        [cell setSearchStoreModel:storeModelData];
        
        return cell;
    }
    return [UITableViewCell new];
    
   }


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_searchType == EnterText) {
        return 130/2;
    }
    if (_searchType == OnclickSearch) {
        if (Iphone4) {
            return [SizeProportion SizeProportionWithHeight:102.f];
        }else if (Iphone5){
            return [SizeProportion SizeProportionWithHeight:102.f];
        }else if (Iphone6){
            return [SizeProportion SizeProportionWithHeight:102.f];
        }else{
            return [SizeProportion SizeProportionWithHeight:110.f];
        }
    }
    return 0;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    SearchStoreModelData *storeModelData = (SearchStoreModelData *)[_searchSuggestions objectAtIndex:indexPath.row];

    if (self.didSelectCellBlock) self.didSelectCellBlock(storeModelData.company_name ,storeModelData.cID);
}

@end
