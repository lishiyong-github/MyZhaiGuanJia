//
//  TakePictureCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/18.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "TakePictureCell.h"

@interface TakePictureCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation TakePictureCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self.contentView addSubview:self.pictureButton1];
//        [self.contentView addSubview:self.pictureButton2];
        
        [self.contentView addSubview:self.pictureCollection];
        
//        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
//        [self.pictureButton1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
//        [self.pictureButton1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
//        [self.pictureButton1 autoSetDimensionsToSize:CGSizeMake(50, 50)];
//
//        [self.pictureButton2 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kBigPadding];
//        [self.pictureButton2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.pictureButton1 withOffset:kBigPadding];
//        [self.pictureButton2 autoSetDimensionsToSize:CGSizeMake(50, 50)];
        
//        [self.pictureCollection autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)pictureButton1
{
    if (!_pictureButton1) {
        _pictureButton1 = [UIButton newAutoLayoutView];
        _pictureButton1.layer.cornerRadius = corner;
    }
    return _pictureButton1;
}
//
//- (UIButton *)pictureButton2
//{
//    if (!_pictureButton2) {
//        _pictureButton2 = [UIButton newAutoLayoutView];
//        _pictureButton2.layer.cornerRadius = corner;
//    }
//    return _pictureButton2;
//}

- (UICollectionView *)pictureCollection
{
    if (!_pictureCollection) {
//        _pictureCollection = [UICollectionView newAutoLayoutView];
//        _pictureCollection.translatesAutoresizingMaskIntoConstraints = YES;
        UICollectionViewLayout *layout = [[UICollectionViewLayout alloc] init];
        _pictureCollection = [[PictureCollectionView alloc ] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80) collectionViewLayout:layout];
        _pictureCollection.delegate = self;
        _pictureCollection.dataSource = self;
        [_pictureCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"picture"];
        [_pictureCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:@"take" withReuseIdentifier:@"picture"];
    }
    return _pictureCollection;
}


//- (void)setPictureDataArray:(NSMutableArray *)pictureDataArray
//{
//    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"",@"", nil];
//    _pictureDataArray = array;
//}

#pragma mark - collectionView deleagte datasource DelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
//    return self.pictureDataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"picture";
    UICollectionViewCell *collection = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (!collection) {
        collection = [[UICollectionViewCell alloc] init];
    }
    
    collection.backgroundColor = kYellowColor;
    
    return collection;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
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
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//
//}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
