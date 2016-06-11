//
//  AllProView.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/18.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllProView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *dataList;

@property (nonatomic,strong) void (^didSelectedRow)(NSIndexPath *);

@property (nonatomic,strong) NSLayoutConstraint *heightTableConstraints;
@property (nonatomic,strong) NSLayoutConstraint *topTableConstraints;

@end
