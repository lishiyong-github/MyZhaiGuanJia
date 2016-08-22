//
//  ProdRightView.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ProdRightView.h"
#import "MineUserCell.h"


@implementation ProdRightView


-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
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

- (NSMutableArray *)dataList1
{
    if (!_dataList1) {
        _dataList1 = [NSMutableArray array];
    }
    return _dataList1;
}

#pragma mark - delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList1.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"proRight";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.userNameButton setTitle:self.dataList1[indexPath.row] forState:0];
    [cell.userActionButton setTitleColor:kBlueColor forState:0];
    [cell.userActionButton setTitle:self.dataList2[indexPath.row] forState:0];
    cell.userActionButton.userInteractionEnabled = NO;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectedRow) {
        self.didSelectedRow(indexPath.row);
    }
    
//    if (indexPath.row == self.dataList1.count-1) {
//        if (self.didSelectedRow) {
//            self.didSelectedRow(11);
//        }
//    }else if (indexPath.row == 12){
//        if (self.didSelectedRow) {
//            self.didSelectedRow(12);
//        }
//    }else if (indexPath.row == 13){
//        if (self.didSelectedRow) {
//            self.didSelectedRow(13);
//        }
//    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
