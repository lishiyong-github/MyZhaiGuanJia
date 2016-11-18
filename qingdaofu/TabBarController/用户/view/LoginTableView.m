//
//  LoginTableView.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "LoginTableView.h"

#import "MessageTableViewCell.h"  //个人中心
#import "UserPublishCell.h"//我的发布
#import "MineUserCell.h"//其他

#import "UIButton+WebCache.h"

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
    if (section == 0 || section == 2) {
        return 2;
    }else if (section == 1){
        return 4;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return kCellHeight5;
        }else{
            return kCellHeight4;
        }
    }
    return kCellHeight3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.section == 0) {//认证
        if (indexPath.row == 0) {
            identifier = @"MineUserCell00";
            MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier  ];
            }
            
            [cell.countLabel setHidden:YES];
            cell.imageButton.layer.cornerRadius = 25;
            cell.imageButton.layer.masksToBounds = YES;
            [cell.imageButton sd_setImageWithURL:[NSURL URLWithString:self.completeResponse.pictureurl] forState:0 placeholderImage:[UIImage imageNamed:@"news_system"]];
            
            if (self.completeResponse) {
                cell.contentLabel.numberOfLines = 0;
                NSString *ccc1 = [NSString stringWithFormat:@"%@\n",[NSString getValidStringFromString:self.completeResponse.realname toString:self.completeResponse.username]];
                NSString *ccc2 = self.completeResponse.mobile;
                NSString *ccc = [NSString stringWithFormat:@"%@%@",ccc1,ccc2];
                NSMutableAttributedString *attributeCCC = [[NSMutableAttributedString alloc] initWithString:ccc];
                [attributeCCC setAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, ccc1.length)];
                [attributeCCC setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(ccc1.length, ccc2.length)];
                NSMutableParagraphStyle *styorr = [[NSMutableParagraphStyle alloc] init];
                [styorr setParagraphSpacing:kSpacePadding];
                [attributeCCC addAttribute:NSParagraphStyleAttributeName value:styorr range:NSMakeRange(0, ccc.length)];
                [cell.contentLabel setAttributedText:attributeCCC];
            }else{
                [cell.contentLabel setText:@"未登录"];
            }
            
            [cell.timeButton setTitleColor:kLightGrayColor forState:0];
            [cell.timeButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            [cell.timeButton setTitle:@"个人中心" forState:0];
            
            return cell;
        }
        
        //row==1(我的发布，我的接单)
        identifier = @"MineUserCell01";
        UserPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UserPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.button1 setTitle:@" 我的发布" forState:0];
        [cell.button1 setImage:[UIImage imageNamed:@"publishw"] forState:0];
        
        [cell.button2 setTitle:@" 我的接单" forState:0];
        [cell.button2 setImage:[UIImage imageNamed:@"order"] forState:0];
        
        [cell.button3 setTitle:@" 经办事项" forState:0];
        [cell.button3 setImage:[UIImage imageNamed:@"order"] forState:0];
        
        QDFWeakSelf;
        [cell.button1 addAction:^(UIButton *btn) {
            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(101);
            }
        }];
        
        [cell.button2 addAction:^(UIButton *btn) {
            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(102);
            }
        }];
        
        [cell.button3 addAction:^(UIButton *btn) {
            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(103);
            }
        }];
        
        return cell;
        
    }else if (indexPath.section == 1){//我的保全保函产调评估
        identifier = @"MineUserCell2";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        NSArray *imageArray = @[@"right",@"Lette_of_guarantee",@"property_transfer",@"house_property_evaluation"];
        NSArray *titileArray = @[@"    我的保全",@"    我的保函",@"    我的产调",@"    我的房产评估结果"];
        
        NSString *imageStr = imageArray[indexPath.row];
        NSString *titleStr = titileArray[indexPath.row];
        [cell.userNameButton setImage:[UIImage imageNamed:imageStr] forState:0];
        [cell.userNameButton setTitle:titleStr forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    
        return cell;
    }else if (indexPath.section == 2){//我的草稿，收藏
        
        identifier = @"MineUserCell1";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        NSArray *imageArray = @[@"save",@"list_icon_collection"];
        NSArray *titileArray = @[@"    我的草稿",@"    我的收藏"];
        
        NSString *imageStr = imageArray[indexPath.row];
        NSString *titleStr = titileArray[indexPath.row];
        [cell.userNameButton setImage:[UIImage imageNamed:imageStr] forState:0];
        [cell.userNameButton setTitle:titleStr forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        if (indexPath.row == 0) {
            [cell.userActionButton setTitle:@"未发布的    " forState:0];
        }
        
        return cell;
        
    }else if (indexPath.section == 3){//我的通讯录
        identifier = @"MineUserCell3";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        [cell.userNameButton setImage:[UIImage imageNamed:@"list_icon_agent"] forState:0];
        [cell.userNameButton setTitle:@"    我的通讯录" forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell.userActionButton setTitle:@"添加联系人    " forState:0];
        
//       if (self.model.pid == nil) {//本人登录
//            if ([self.model.state integerValue] == 1 && [self.model.category integerValue] == 1) {
//                cell.userInteractionEnabled = NO;
//                [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
//                [cell.userNameButton setTitle:@"    我的代理(个人用户不能添加代理)" forState:0];
//            }else{
//                cell.userInteractionEnabled = YES;
//                [cell.userNameButton setTitleColor:kBlackColor forState:0];
//                [cell.userNameButton setTitle:@"    我的代理" forState:0];
//            }
//        }else{
//            cell.userInteractionEnabled = NO;
//            [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
//            [cell.userNameButton setTitle:@"    我的代理(代理人不能添加代理)" forState:0];
//        }
        
        return cell;
    }
    
    //帮助中心
    identifier = @"MineUserCell4";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell.userNameButton setImage:[UIImage imageNamed:@"list_icon_setting"] forState:0];
    [cell.userNameButton setTitle:@"    帮助中心" forState:0];
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
            self.didSelectedButton(indexPath.section*4+indexPath.row);
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
