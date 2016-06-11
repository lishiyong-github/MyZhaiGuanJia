//
//  PictureCollectionView.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/27.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) NSMutableArray *pictureDataArray;

@end
