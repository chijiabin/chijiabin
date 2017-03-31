//
//  YStaticCell.m
//  Ubate
//
//  Created by sunbin on 2017/2/5.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "YStaticCell.h"

@interface YStaticCell ()

@end

@implementation YStaticCell

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_NoNeedTapGesture) {
        
    }else{
        [self tapGestureRecognizer];
        
    }
    
    [self tableViewAttributes];
    
}

- (void)tableViewAttributes
{

    self.tableView.separatorColor = [UIColor appSeparatorColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    
    self.tableView.tableFooterView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.clearsSelectionOnViewWillAppear = NO;
    /**Grouped
     *  设置sectionFooterHeight sectionHeaderHeight =0 代理高度设置才有效果
     */
    
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 0;
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
}



- (void)tapGestureRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)
                                   ];
    tap.cancelsTouchesInView = NO;
    tap.numberOfTapsRequired = 1;tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void)endEditing
{
    [self.view endEditing:YES];
}




#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_NoShowHead) {
        return 0;
    }else{
        return 10;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
