//
//  UpwardTableView.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "UpwardTableView.h"


#import "BidOneCell.h"
#import "MineUserCell.h"

@implementation UpwardTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.tableFooterView = [[UIView alloc] init];
        self.delegate = self;
        self.dataSource = self;
        self.separatorColor = kSeparateColor;
        self.backgroundColor = kBackColor;
        
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return self;
}

- (NSArray *)upwardDataList
{
    if (!_upwardDataList) {
        _upwardDataList = [NSArray array];
    }
    return _upwardDataList;
}

- (NSLayoutConstraint *)heightTableConstraints
{
    if (!_heightTableConstraints) {
        _heightTableConstraints = [self autoSetDimension:ALDimensionHeight toSize:0];
    }
    return _heightTableConstraints;
}

#pragma mark - delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.tableType isEqualToString:@"有"]) {
        return self.upwardDataList.count+1;
    }
    return self.upwardDataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if ([self.tableType isEqualToString:@"有"]) {
        
        identifier = @"upward0";
        BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.oneButton.userInteractionEnabled = NO;
        
        if (indexPath.row == 0) {
            cell.backgroundColor = UIColorFromRGB(0xd8e5ee);
            [cell.cancelButton setTitleColor:kBlueColor forState:0];
            [cell.cancelButton setTitle:@"取消" forState:0];
            [cell.oneButton setTitleColor:kBlackColor forState:0];
            [cell.oneButton setTitle:self.upwardTitleString forState:0];
            
            QDFWeakSelf;
            [cell.cancelButton addAction:^(UIButton *btn) {
                if (weakself.didSelectedButton) {
                    weakself.didSelectedButton(99);
                }
            }];
        }else{
            cell.backgroundColor = kNavColor;
            [cell.cancelButton setTitleColor:kBlackColor forState:0];
            [cell.oneButton setHidden:YES];
            [cell.cancelButton setTitle:self.upwardDataList[indexPath.row-1] forState:0];
        }
        
        return cell;
    }
    
    identifier = @"upward1";
    BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.oneButton.userInteractionEnabled = NO;
    [cell.oneButton setTitle:self.upwardDataList[indexPath.row] forState:0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableType isEqualToString:@"有"]) {
        if (indexPath.row > 0) {
            if (self.didSelectedRow) {
                self.didSelectedRow(self.upwardDataList[indexPath.row-1],indexPath.row);
            }
        }
    }else{
        if (self.didSelectedRow) {
            self.didSelectedRow(self.upwardDataList[indexPath.row],indexPath.row);
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
