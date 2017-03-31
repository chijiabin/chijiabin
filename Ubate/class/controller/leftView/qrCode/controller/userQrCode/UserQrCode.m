//
//  UserQrCode.m
//  Ubate-UV
//
//  Created by sunbin on 2017/1/22.
//  Copyright © 2017年 Quanli. All rights reserved.
//

#import "UserQrCode.h"
#import "ShareCell.h"
#import "WXApiRequestHandler.h"

@interface UserQrCode ()
@property (weak, nonatomic) IBOutlet UIImageView *qrImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *city;

@property (weak, nonatomic) IBOutlet UILabel *shareMyQrCodel;

@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@end

@implementation UserQrCode
{
    YUserInfo *userInfor;
    
    NSString  *encryptDate;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"二维码", @"Personal qr code");
}

- (void)initView{
    _shareMyQrCodel.text = NSLocalizedString(@"分享我的二维码", @"share my qr code");

    
    _qrImage.image = (UIImage *)[NHUtils generateQrCode:encryptDate qrCodeAdress:scanAdress qrCodeColorwithRed:37.0f andGreen:38.0f andBlue:39.0f qrCodeSize:250.0f];
    
//    self.qrImage.layer.shadowOffset  = CGSizeMake(0, 2);
//    self.qrImage.layer.shadowRadius  = 2;
//    self.qrImage.layer.shadowColor   = [UIColor blackColor].CGColor;
//    self.qrImage.layer.shadowOpacity = 0.5;

    
    self.nickName.text = [NHUtils isBlankString:userInfor.nickname]?[[YConfig getOwnAccountAndPassword] firstObject]:userInfor.nickname;

    self.city.text     = [userInfor.city isBlank]?NSLocalizedString(@"nosetcity", @"not currently select cities"):[userInfor.city stringByAppendingString:[NSString stringWithFormat:@"-%@" ,userInfor.area]];
  
    // 分享视图创建
    [self initShareType];
    
}

- (void)initShareType{
    _collection.contentInset    = UIEdgeInsetsMake(0, 0, 0, 0);
    _collection.backgroundColor = [UIColor clearColor];
    _collection.pagingEnabled   = YES;
    
    [_collection registerNib:[UINib nibWithNibName:@"ShareCell" bundle:nil] forCellWithReuseIdentifier:@"ShareCellID"];
}

- (void)loadData{
    userInfor = [YConfig myProfile];

    //数据加密 用户版标识+uid  留空格
    NSString *uld       = [NSString stringWithFormat:@"%lld" ,[YConfig getOwnID]];
    NSString *qrcodeStr = [uld stringByAppendingString:[NSString stringWithFormat:@" %@" ,userInfor.member_id]];

    encryptDate = [qrcodeStr aes256_encrypt:AES256_KEY];
    NSLog(@"加密= %@=" ,encryptDate);
    
    NSString *decodeData=[encryptDate aes256_decrypt:AES256_KEY];
    NSLog(@"解密= %@=" ,decodeData);
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
    [self initView];
}


#pragma mark -UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShareCellID" forIndexPath:indexPath];
    
    cell.shareTypeLab.text = @[
                               NSLocalizedString(@"微信", @"Wechat_session") ,
                               NSLocalizedString(@"朋友圈", @"Wechat_timeline") ,
                               NSLocalizedString(@"微信收藏", @"Wechat_favorite")][indexPath.row];
    
    NSString *imageName = @[@"wechat" ,@"pyq" ,@"wxsc"][indexPath.row];
    cell.shareiTypeimage.image = IMAGE(imageName);
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(WIDTH(_collection)/3, HEIGHT(_collection));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [self sendLinkContent:indexPath.item];
}




- (void)sendLinkContent:(enum WXScene)scene {
    
    if (![WXApi isWXAppInstalled])
    {
        NSLog(@"没有安装微信");
        [self showText:NSLocalizedString(@"noInstallWeChat", @"No WeChat installed") showPosition:centre];
        return;
    }
    
    
    NSString * url = @"https://accounts.ubate.cn/wechat/personal/me_qrcode/id/";
    NSString * KlineUrl = [url stringByAppendingString:encryptDate];
    
    BOOL isSuccessful = [WXApiRequestHandler sendLinkURL:KlineUrl
                                                 TagName:kLinkTagName
                                                   Title:kLinkTitle
                                             Description:kLinkDescription
                                              ThumbImage:_qrImage.image
                                                 InScene:scene];
    if (isSuccessful) {
        NSLog(@"isSuccessful");
    }else{
        NSLog(@"isFail");

    }

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
