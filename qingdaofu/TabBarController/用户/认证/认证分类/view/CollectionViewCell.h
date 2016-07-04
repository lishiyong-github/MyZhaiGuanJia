//
//  CollectionViewCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/7/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIImageView *cellImageView;

@end
