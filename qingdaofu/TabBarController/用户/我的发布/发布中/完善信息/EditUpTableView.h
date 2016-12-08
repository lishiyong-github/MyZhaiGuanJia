//
//  EditUpTableView.h
//  qingdaofu
//
//  Created by zhixiang on 16/11/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreMessageModel.h"

@interface EditUpTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *upwardDataList;
@property (nonatomic,strong) NSLayoutConstraint *heightTableConstraints;

@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *category;
@property (nonatomic,strong) MoreMessageModel *moreModel;  //编辑信息

@property (nonatomic,strong) void (^didSelectedBtn)(NSInteger);
@property (nonatomic,strong) void (^didEndEditting)(NSString *); //详细地址

- (void)reloadDatas;

@end
