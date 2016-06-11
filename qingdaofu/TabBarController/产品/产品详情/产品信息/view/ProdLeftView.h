//
//  ProdLeftView.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProdLeftView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *leftDataArray1;
@property (nonatomic,strong) NSMutableArray *leftDataArray2;
@end
