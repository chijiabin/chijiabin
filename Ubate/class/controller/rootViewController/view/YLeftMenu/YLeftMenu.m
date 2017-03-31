//
//  YLeftMenu.m
//  Ubate
//
//  Created by sunbin on 2016/12/1.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "YLeftMenu.h"
#import "LeftHeader.h"
#import "MenuItemCell.h"
@interface YLeftMenu()<UITableViewDelegate ,UITableViewDataSource ,LeftHeaderDelegate>

@property (nonatomic ,strong) UITableView    *contentTableView;
@property (nonatomic, strong) NSMutableArray *cellDefs;
@end


@implementation YLeftMenu
{
    NSString *nickName;
    NSString *imageName;
    
    BOOL idfixing;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self cellData];[self initView];
    }
    return  self;
}


-(void)initView{
    _contentTableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
    _contentTableView.dataSource    = self;
    _contentTableView.delegate      = self;
    _contentTableView.scrollEnabled = NO;
    
    _contentTableView.backgroundColor = [UIColor themeColor];
    _contentTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;

    [self.contentTableView  registerNib:[UINib nibWithNibName:@"MenuItemCell" bundle:nil] forCellReuseIdentifier:@"MenuItemCellID"];
    [self.contentTableView  registerNib:[UINib nibWithNibName:@"LeftHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"LeftHeaderID"];
    
    [self addSubview:_contentTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNikeName:) name:@"SET_USERINFO" object:nil];
}

- (void)cellData
{
    _cellDefs = [[NSMutableArray alloc] init];
    _cellDefs = [NSMutableArray arrayWithContentsOfFile:LOADPathResource(@"LeftMenu", @"plist")];
}


#pragma mark- NSNotification
-(void)changeNikeName:(NSNotification*)object{
    idfixing = YES;

    [self loadData];//刷新数据
    [self.contentTableView reloadData];

}

- (void)loadData{
    NSLog(@"%@" ,[self reloadUserName]);
    nickName = [self reloadUserName];
    if ([NHUtils isBlankString:IF_NULL_TO_STRING([YConfig myProfile].user_img)]) {
        imageName = @"touxiang";
    }else{
        imageName = [adress stringByAppendingString:[self reloadUser_Img]];
    }
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cellDefs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuItemCell *cell   = [tableView dequeueReusableCellWithIdentifier:@"MenuItemCellID" forIndexPath:indexPath];
    NSDictionary *def    = [self.cellDefs objectAtIndex:indexPath.row];
    cell.textlabe.text   = NSLocalizedString([def objectForKey:@"title"], [def objectForKey:@"englishTitle"]);
    
    
    
    cell.menuIcon.image  = Icon([def objectForKey:@"imageName"]);
    cell.backgroundColor = [UIColor themeColor];

    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    LeftHeader *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LeftHeaderID"];
    headView.delegate = self;
    headView.backgroundView = [[UIImageView alloc] initWithImage:[NHUtils imageWithColor:[UIColor appNavigationBarColor] size:CGSizeMake(ScaleHeight(220.f), ScaleHeight(90.f)) alpha:1]];

    if (!idfixing) {
        [self loadData];//无通知
    }
    
    if ([NHUtils isBlankString:[self reloadUser_Img]]) {
        headView.userImage.image = Icon(imageName);
    }else{
        [headView.userImage mac_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:Icon(@"touxiang")];
    }
    
    
    headView.nickName.text =  nickName;

    headView.nickName.font = [UIFont systemFontOfSize:17];
    
    return headView;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.customDelegate respondsToSelector:@selector(LeftMenuViewClick:)]) {
        [self.customDelegate LeftMenuViewClick:indexPath.row + 1];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScaleHeight(50.f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ScaleHeight(90.f);
}


//刷新用户名与图片
- (NSString *)reloadUser_Img
{
    return [YConfig myProfile].user_img;
}

- (NSString *)reloadUserName
{
    if ([NHUtils isBlankString:[YConfig myProfile].nickname]) {
        return [[YConfig getOwnAccountAndPassword] firstObject] ;
    }else{
        return [YConfig myProfile].nickname ;
    }
}


#pragma make -LeftHeaderDelegate 切换至个人中心
- (void)skipToPersonalCenter{
    if ([self.customDelegate respondsToSelector:@selector(LeftMenuViewClick:)]) {
        [self.customDelegate LeftMenuViewClick:0];
    }
}


@end






