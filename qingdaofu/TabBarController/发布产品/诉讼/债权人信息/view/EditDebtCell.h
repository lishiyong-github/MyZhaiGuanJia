//
//  EditDebtCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/18.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleButton.h"


@interface EditDebtCell : UITableViewCell

@property (nonatomic,strong) SingleButton *editImageButton1;
@property (nonatomic,strong) SingleButton *editImageButton2;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end
