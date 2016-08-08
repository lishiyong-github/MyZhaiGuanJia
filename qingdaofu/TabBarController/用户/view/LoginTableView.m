//
//  LoginTableView.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "LoginTableView.h"
#import "MineUserCell.h"
#import "UserPublishCell.h"

@implementation LoginTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        self.backgroundColor = kBackColor;
        self.separatorColor = kSeparateColor;
    }
    return self;
}

#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < 2) {
        return 2;
    }else if (section == 2){
        return 3;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return kCellHeight;
    }
    return kCellHeight1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.section == 0) {//认证
        if (indexPath.row == 0) {
            identifier = @"MineUserCell00";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier  ];
            }
            cell.userNameButton.userInteractionEnabled = NO;
            cell.userActionButton.userInteractionEnabled = NO;
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            if ([self.model.code isEqualToString:@"3006"]) {//未认证
                
                [cell.userNameButton setTitle:self.model.mobile forState:0];
                [cell.userNameButton setImage:[UIImage imageNamed:@""] forState:0];
                [cell.userActionButton setTitle:@"未认证" forState:0];
                
            }else if([self.model.code isEqualToString:@"3001"]){//未登录
                [cell.userNameButton setTitle:@"未登录" forState:0];
                [cell.userNameButton setImage:[UIImage imageNamed:@""] forState:0];
                [cell.userActionButton setTitle:@"请登录" forState:0];
            }else{
                NSString *mobile = [NSString stringWithFormat:@"%@ ",self.model.mobile];
                [cell.userNameButton setTitle:mobile forState:0];
                [cell.userNameButton setImage:[UIImage imageNamed:@"authentication_icon"] forState:0];
                
                NSString *ererStr;
                if ([self.model.category integerValue] == 1) {
                    ererStr = @"已认证个人";
                }else if ([self.model.category integerValue] == 2){
                    ererStr = @"已认证律所";
                }else if ([self.model.category integerValue] == 3){
                    ererStr = @"已认证公司";
                }
                [cell.userActionButton setTitle:ererStr forState:0];
            }
            [cell swapUserName];
            
            return cell;
        }
        
        //row==1(我的发布，我的接单)
        identifier = @"MineUserCell01";
        UserPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UserPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.button1 setTitle:@"    我的发布" forState:0];
        [cell.button1 setImage:[UIImage imageNamed:@"publishw"] forState:0];
        
        [cell.button2 setTitle:@"    我的接单" forState:0];
        [cell.button2 setImage:[UIImage imageNamed:@"order"] forState:0];
        
        QDFWeakSelf;
        [cell.button1 addAction:^(UIButton *btn) {
            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(1);
            }
        }];
        
        [cell.button2 addAction:^(UIButton *btn) {
            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(2);
            }
        }];
        
        return cell;
        
    }else if (indexPath.section == 1){//我的保存，收藏
        
        identifier = @"MineUserCell1";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        NSArray *imageArray = @[@"save",@"list_icon_collection"];
        NSArray *titileArray = @[@"    我的保存",@"    我的收藏"];
        
        NSString *imageStr = imageArray[indexPath.row];
        NSString *titleStr = titileArray[indexPath.row];
        [cell.userNameButton setImage:[UIImage imageNamed:imageStr] forState:0];
        [cell.userNameButton setTitle:titleStr forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        return cell;
        
    }else if (indexPath.section == 2){//我的保全保函产调
        identifier = @"MineUserCell2";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        NSArray *imageArray = @[@"right",@"Lette_of_guarantee",@"property_transfer"];
        NSArray *titileArray = @[@"    我的保全",@"    我的保函",@"    我的产调"];
        
        NSString *imageStr = imageArray[indexPath.row];
        NSString *titleStr = titileArray[indexPath.row];
        [cell.userNameButton setImage:[UIImage imageNamed:imageStr] forState:0];
        [cell.userNameButton setTitle:titleStr forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    
        return cell;
    }else if (indexPath.section == 3){//我的代理
        identifier = @"MineUserCell3";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        [cell.userNameButton setImage:[UIImage imageNamed:@"list_icon_agent"] forState:0];
        [cell.userNameButton setTitle:@"    我的代理" forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
       if (self.model.pid == nil) {//本人登录
            if ([self.model.state integerValue] == 1 && [self.model.category integerValue] == 1) {
                cell.userInteractionEnabled = NO;
                [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
                [cell.userNameButton setTitle:@"    我的代理(个人用户不能添加代理)" forState:0];
            }else{
                cell.userInteractionEnabled = YES;
                [cell.userNameButton setTitleColor:kBlackColor forState:0];
                [cell.userNameButton setTitle:@"    我的代理" forState:0];
            }
        }else{
            cell.userInteractionEnabled = NO;
            [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
            [cell.userNameButton setTitle:@"    我的代理(代理人不能添加代理)" forState:0];
        }
        
        return cell;
    }
    
    //设置
    identifier = @"MineUserCell4";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell.userNameButton setImage:[UIImage imageNamed:@"list_icon_setting"] forState:0];
    [cell.userNameButton setTitle:@"    我的设置" forState:0];
    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = kBackColor;
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.section == 1) {
        
    }else{
        if (self.didSelectedButton) {
            self.didSelectedButton(indexPath.section*3+indexPath.row);
        }
    }    
    
    
//    if (indexPath.section > 1) {//我的代理收藏保存设置
//    }else if(indexPath.section == 0){//登录
//        if (self.didSelectedIndex) {
//            self.didSelectedIndex(indexPath);
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
