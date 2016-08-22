//
//  ProdLeftView.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ProdLeftView.h"
#import "MineUserCell.h"

@implementation ProdLeftView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = kBackColor;
        self.separatorColor = kSeparateColor;
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 12.5)];
        self.tableFooterView = [[UIView alloc] init];
    }
    return self;
}

- (NSMutableArray *)leftDataArray1
{
    if (!_leftDataArray1) {
        _leftDataArray1 = [NSMutableArray array];
    }
    return _leftDataArray1;
}

- (NSMutableArray *)leftDataArray2
{
    if (!_leftDataArray2) {
        _leftDataArray2 = [NSMutableArray array];
    }
    return _leftDataArray2;
}

#pragma mark - delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.leftDataArray1.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"left";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.userActionButton autoSetDimension:ALDimensionWidth toSize:kScreenWidth-150];
    
    [cell.userNameButton setTitle:self.leftDataArray1[indexPath.row] forState:0];
    [cell.userActionButton setTitle:self.leftDataArray2[indexPath.row] forState:0];
    [cell.userActionButton setTitleColor:kBlueColor forState:0];
    
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
