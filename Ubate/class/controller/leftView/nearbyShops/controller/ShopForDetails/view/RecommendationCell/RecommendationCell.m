//
//  RecommendationCell.m
//  Ubate
//
//  Created by sunbin on 2016/12/9.
//  Copyright © 2016年 Quanli. All rights reserved.
//

#import "RecommendationCell.h"
#import "ImageCell.h"
//#import "StoreDetailImages.h"
static NSString *ImageCell_Iden = @"ImageCell_Identifier";

@interface RecommendationCell()

@property (weak, nonatomic) IBOutlet UICollectionView *imageCell;
@property (nonatomic ,strong) NSArray *images;

@end

@implementation RecommendationCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self initView];
}

- (void)recommendation:(NSArray *)ary{
    _images = ary;
    [self.imageCell reloadData];
}


- (void)initView{
    
    [_imageCell registerNib:[UINib nibWithNibName:@"ImageCell" bundle:nil] forCellWithReuseIdentifier:ImageCell_Iden];
    }


#pragma mark -UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCell_Iden forIndexPath:indexPath];
    
    NSDictionary *img_urlDic = [_images objectAtIndex:indexPath.row];
  
    NSString *img_url = [img_urlDic objectForKey:@"img_url"];
    
    [cell.log mac_setImageWithURL:[NSURL URLWithString:[adress stringByAppendingString:img_url]] placeholderImage:Icon(@"jiazai")];
    
    return cell;
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 10);//分别为上、左、下、右
}

//定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat span = 10;
    CGFloat width = (SCREEN_WIDTH - 2*span)/3;
    
    return CGSizeMake(width, width-20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(10, 10);
}

//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    ImageCell *cell = (ImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    UIImageView *imageView = [cell.contentView.subviews firstObject];
    
    if (_selectIndexHandler) {
        _selectIndexHandler(indexPath.row ,_images ,imageView);
    }
    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}



@end
