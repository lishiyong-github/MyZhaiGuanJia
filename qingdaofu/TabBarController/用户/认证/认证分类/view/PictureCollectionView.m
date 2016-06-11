//
//  PictureCollectionView.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/27.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PictureCollectionView.h"

@implementation PictureCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"picture"];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:@"take" withReuseIdentifier:@"picture"];
    }
    return self;
}

//- (void)setPictureDataArray:(NSMutableArray *)pictureDataArray
//{
//    NSMutableArray *array = [NSMutableArray array];
//    _pictureDataArray = array;
//}
//
//- (NSMutableArray *)pictureDataArray
//{
//    if (!_pictureDataArray) {
//        _pictureDataArray = [NSMutableArray array];
//    }
//    return _pictureDataArray;
//}

#pragma mark - collectionView deleagte datasource DelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"picture";
    UICollectionViewCell *collection = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
