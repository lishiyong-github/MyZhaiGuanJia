//
//  ReportSuitSeCell.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AuthenBaseView.h"
#import "LineLabel.h"
#import "BaseLabel.h"

@interface ReportSuitSeCell : UITableViewCell


@property (nonatomic,strong) AuthenBaseView *ssCell0;
@property (nonatomic,strong) LineLabel *ssLine0;
@property (nonatomic,strong) AuthenBaseView *ssCell1;
@property (nonatomic,strong) LineLabel *ssLine1;
@property (nonatomic,strong) AuthenBaseView *ssCell2;
@property (nonatomic,strong) LineLabel *ssLine2;
@property (nonatomic,strong) BaseLabel *ssCell3;
@property (nonatomic,strong) LineLabel *ssLine3;
@property (nonatomic,strong) BaseLabel *ssCell4;
@property (nonatomic,strong) LineLabel *ssLine4;
@property (nonatomic,strong) BaseLabel *ssCell5;
@property (nonatomic,strong) LineLabel *ssLine5;
@property (nonatomic,strong) BaseLabel *ssCell6;
@property (nonatomic,strong) LineLabel *ssLine6;
@property (nonatomic,strong) AuthenBaseView *ssCell7;
@property (nonatomic,strong) LineLabel *ssLine7;
@property (nonatomic,strong) AuthenBaseView *ssCell8;
@property (nonatomic,strong) LineLabel *ssLine8;
@property (nonatomic,strong) AuthenBaseView *ssCell9;
@property (nonatomic,strong) LineLabel *ssLine9;
@property (nonatomic,strong) BaseLabel *ssCell10;
@property (nonatomic,strong) LineLabel *ssLine10;
@property (nonatomic,strong) BaseLabel *ssCell11;
@property (nonatomic,strong) LineLabel *ssLine11;
@property (nonatomic,strong) BaseLabel *ssCell12;
@property (nonatomic,strong) LineLabel *ssLine12;
@property (nonatomic,strong) BaseLabel *ssCell13;

@property (nonatomic,assign) BOOL didSetupConstarints;

@property (nonatomic,strong) void (^didSelectedIndex)(NSInteger);

@end
