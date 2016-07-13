//
//  TakePictureCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/18.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "TakePictureCell.h"
#import "UIImageView+WebCache.h"
#import "CollectionViewCell.h"

@interface TakePictureCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation TakePictureCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.pictureCollection];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
       [self.pictureCollection autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UICollectionView *)pictureCollection
{
    if (!_pictureCollection) {
                
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _pictureCollection = [[UICollectionView alloc ] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80) collectionViewLayout:layout];
        _pictureCollection.translatesAutoresizingMaskIntoConstraints = NO;
        _pictureCollection.delegate = self;
        _pictureCollection.dataSource = self;
        [_pictureCollection registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
        [_pictureCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"picture"];
        [_pictureCollection setBackgroundColor:[UIColor whiteColor]];
    }
    return _pictureCollection;
}

- (NSMutableArray *)collectionDataList
{
    if (!_collectionDataList) {
        _collectionDataList = [NSMutableArray array];
        
    }
    return _collectionDataList;
}

- (void)reloadData
{
    [self.pictureCollection reloadData];
}

#pragma mark - collectionView deleagte datasource DelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionDataList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CollectionViewCell";
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[CollectionViewCell alloc] init];
    }
    
    if ([self.collectionDataList[indexPath.item] isKindOfClass:[NSURL class]]) {
        //account_bitmap
        NSURL *url = self.collectionDataList[indexPath.item];
        if (url.fileURL) {
            cell.cellImageView.image = [UIImage imageWithContentsOfFile:url.path];
        }else{
            [cell.cellImageView sd_setImageWithURL:self.collectionDataList[indexPath.item] placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
        }
    }else if([self.collectionDataList[indexPath.item] isKindOfClass:[UIImage class]]){
        cell.cellImageView.image = self.collectionDataList[indexPath.item];

    }else if ([self.collectionDataList[indexPath.item] isKindOfClass:[NSString class]]){
        NSString *file = self.collectionDataList[indexPath.item];
        if ([file containsString:@"/"]) {
            cell.cellImageView.image = [UIImage imageWithContentsOfFile:file];
        }else{
            cell.cellImageView.image = [UIImage imageNamed:file];
        }
    }
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = CGSizeMake(50, 50);
    return itemSize;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets itemInserts = UIEdgeInsetsMake(kBigPadding, kBigPadding, kBigPadding, kBigPadding);
    return itemInserts;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectedItem) {
        self.didSelectedItem(indexPath.item);
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
