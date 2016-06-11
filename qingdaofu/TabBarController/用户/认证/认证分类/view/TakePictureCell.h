//
//  TakePictureCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/18.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PictureCollectionView.h"

@interface TakePictureCell : UITableViewCell

@property (nonatomic,strong) UICollectionView *pictureCollection;

@property (nonatomic,strong) UIButton *pictureButton1;
@property (nonatomic,strong) UIButton *pictureButton2;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
