//
//  LoginView.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/27.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "LoginView.h"

#import "MineCell.h"
#import "MineUserCell.h"

@interface LoginView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation LoginView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.loginTableView];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.loginTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UITableView *)loginTableView
{
    if (!_loginTableView) {
//        _loginTableView = [UITableView newAutoLayoutView];
        _loginTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _loginTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _loginTableView.delegate = self;
        _loginTableView.dataSource = self;
        _loginTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _loginTableView.backgroundColor = kBackColor;
        _loginTableView.separatorColor = kSeparateColor;
    }
    return _loginTableView;
}

#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3) {
        return 3;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 || indexPath.section == 2) {
        return 120;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.section == 0) {//认证
        identifier = @"lFirst";
        
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        BaseModel *authenModel = [BaseModel objectWithKeyValues:self.authenDic];
        
        [cell.userNameButton swapImage];
        [cell.userNameButton setTitle:authenModel.code forState:0];
        [cell.userNameButton setImage:[UIImage imageNamed:@"publish_list_authentication"] forState:0];
        
        if ([authenModel.code isEqualToString:@"4001"]) {//未认证
            [cell.userActionButton setTitle:@"未认证" forState:0];
        }else{
            [cell.userActionButton setTitle:@"已认证" forState:0];
        }
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        cell.userNameButton.userInteractionEnabled = NO;
        cell.userActionButton.userInteractionEnabled = NO;
        
        return cell;
        
    }else if (indexPath.section == 1){//我的发布
        identifier = @"lSecond";
        
        MineCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = kBigFont;
        cell.imageView.frame = CGRectMake(0, 0, 21, 21);
        [cell setSeparatorInset:UIEdgeInsetsMake(0, kBigPadding, 0, 0)];
        
        [cell.topNameButton setTitle:@"我的发布" forState:0];
        cell.button1.label1.text = @"已发布";
        [cell.button1.imageView1 setImage:[UIImage imageNamed:@"list_icon_publish"]];
        
        QDFWeakSelf;
        [cell.topGoButton addAction:^(UIButton *btn) {
            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(10);
            }
        }];
        [cell.button1 addAction:^(UIButton *btn) {
            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(11);
            }
        }];
        [cell.button2 addAction:^(UIButton *btn) {
            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(12);
            }
        }];
        [cell.button3 addAction:^(UIButton *btn) {
            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(13);
            }
        }];
        [cell.button4 addAction:^(UIButton *btn) {
            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(14);
            }
        }];
        
        return cell;

    }else if (indexPath.section == 2){//我的接单
        identifier = @"lSecond";
        MineCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = kBigFont;
        cell.imageView.frame = CGRectMake(0, 0, 21, 21);
        [cell setSeparatorInset:UIEdgeInsetsMake(0, kBigPadding, 0, 0)];
        
        [cell.topNameButton setTitle:@"我的接单" forState:0];
        cell.button1.label1.text = @"申请中";
        cell.button1.imageView1.image = [UIImage imageNamed:@"list_icon_apply"];
        
        QDFWeakSelf;
        [cell.topGoButton addAction:^(UIButton *btn) {
            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(20);
            }
        }];
        [cell.button1 addAction:^(UIButton *btn) {
            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(21);
            }
        }];
        [cell.button2 addAction:^(UIButton *btn) {
            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(22);
            }
        }];
        [cell.button3 addAction:^(UIButton *btn) {
            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(23);
            }
        }];
        [cell.button4 addAction:^(UIButton *btn) {
            if (weakself.didSelectedButton) {
                weakself.didSelectedButton(24);
            }
        }];

        return cell;
    }
    //收藏保存设置
    identifier = @"lForth";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSArray *imageArray = @[@[@"list_icon_agent",@"list_icon_preservation",@"list_icon_collection"],@[@"list_icon_setting"]];
    NSArray *titileArray = @[@[@"  我的代理",@"  我的保存",@"  我的收藏"],@[@"  我的设置"]];
    
    NSString *imageStr = imageArray[indexPath.section-3][indexPath.row];
    NSString *titleStr = titileArray[indexPath.section-3][indexPath.row];
    [cell.userNameButton setImage:[UIImage imageNamed:imageStr] forState:0];
    [cell.userNameButton setTitle:titleStr forState:0];
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
    
    if (self.didSelectedIndex) {
        self.didSelectedIndex(indexPath);
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
