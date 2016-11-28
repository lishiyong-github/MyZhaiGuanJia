//
//  EditUpTableView.h
//  qingdaofu
//
//  Created by zhixiang on 16/11/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditUpTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *upwardDataList;
@property (nonatomic,strong) NSLayoutConstraint *heightTableConstraints;

@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *category;

@property (nonatomic,strong) void (^didSelectedBtn)(NSInteger);

@end
