//
//  UpwardTableView.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpwardTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *upwardDataList;

@property (nonatomic,strong) void (^didSelectedButton)(NSInteger);
@property (nonatomic,strong) void (^didSelectedRow)(NSString *text);

@property (nonatomic,strong) NSLayoutConstraint *heightTableConstraints;

@property (nonatomic,strong) NSString *upwardTitleString;  //选择的类型
@property (nonatomic,strong) NSString *upwardSelectedTitle;  //选中的类型
@end
