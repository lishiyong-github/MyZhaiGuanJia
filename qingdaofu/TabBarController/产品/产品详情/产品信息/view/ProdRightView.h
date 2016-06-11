//
//  ProdRightView.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProdRightView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) void (^didSelectedRow)(NSInteger);



@end
