//
//  TakePictureCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/18.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakePictureCell : UITableViewCell

@property (nonatomic,strong) UICollectionView *pictureCollection;

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) NSMutableArray *collectionDataList;

@property (nonatomic,strong) void (^didSelectedItem)(NSInteger);

- (void)reloadData;
@end
