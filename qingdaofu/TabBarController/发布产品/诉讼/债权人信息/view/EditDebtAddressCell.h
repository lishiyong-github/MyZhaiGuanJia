//
//  EditDebtAddressCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/18.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "RequestTextView.h"
#import "PlaceHolderTextView.h"

@interface EditDebtAddressCell : UITableViewCell

@property (nonatomic,strong) UILabel *ediLabel;
@property (nonatomic,strong) PlaceHolderTextView *ediTextView;

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) NSLayoutConstraint *leftTextViewConstraints;
@property (nonatomic,strong) NSLayoutConstraint *textHeightConstraint;

@end
