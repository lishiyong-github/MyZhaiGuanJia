//
//  HousePropertyListViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/2.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "HousePropertyListViewController.h"
#import "HouseCopyViewController.h"  //快递信息
#import "HousePropertyViewController.h" //查询产调

#import "BaseCommitView.h"

#import "MineUserCell.h"
#import "MessageCell.h"
#import "PropertyListCell.h"

@interface HousePropertyListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *propertyListTableView;
@property (nonatomic,strong) BaseCommitView *propertyListCommitView;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation HousePropertyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的产调";
    
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshLists)];
    
    [self.view addSubview:self.propertyListTableView];
    [self.view addSubview:self.propertyListCommitView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)refreshLists
{
    
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.propertyListTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.propertyListTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.propertyListCommitView];
        
        [self.propertyListCommitView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.propertyListCommitView autoSetDimension:ALDimensionHeight toSize:60];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)propertyListTableView
{
    if (!_propertyListTableView) {
        _propertyListTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _propertyListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _propertyListTableView.delegate = self;
        _propertyListTableView.dataSource = self;
        _propertyListTableView.backgroundColor = kBackColor;
        _propertyListTableView.separatorColor = kSeparateColor;
        _propertyListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _propertyListTableView;
}

- (BaseCommitView *)propertyListCommitView
{
    if (!_propertyListCommitView) {
        _propertyListCommitView = [BaseCommitView newAutoLayoutView];
        [_propertyListCommitView.button setTitle:@"查询产调" forState:0];
        
        QDFWeakSelf;
        [_propertyListCommitView.button addAction:^(UIButton *btn) {
            UINavigationController *nav = weakself.navigationController;
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
//            [nav popViewControllerAnimated:NO];

            HousePropertyViewController *housePropertyVC = [[HousePropertyViewController alloc] init];
            housePropertyVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:housePropertyVC animated:NO];
        }];
    }
    return _propertyListCommitView;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < 2) {
        return 2;
    }
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 60;
    }else if (indexPath.row == 2){
        return 40;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.row == 0) {
        identifier = @"listas0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userNameButton.userInteractionEnabled = NO;
        cell.userActionButton.userInteractionEnabled = NO;
        
        [cell.userNameButton setTitle:@"12121212" forState:0];
        [cell.userNameButton setTitleColor:kGrayColor forState:0];
        
        //等待处理黑，处理中黑－已用时110分钟，处理成功蓝－用时110分钟，处理失败红－已退款
        [cell.userActionButton setTitle:@"等待处理" forState:0];
        [cell.userActionButton setTitleColor:kBlackColor forState:0];
        
        return cell;
    }else if(indexPath.row == 1){
        identifier = @"listas1";
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.timeLabel.textColor = kGrayColor;
        cell.timeLabel.font = kBigFont;
        [cell.countLabel setHidden:YES];
        [cell.actButton setBackgroundColor:[UIColor clearColor]];
        [cell.actButton setTitleColor:kLightGrayColor forState:0];
        
        cell.userLabel.text = @"浦东新区浦东新区浦东新区浦东新区";
        cell.timeLabel.text = @"¥25";
        cell.newsLabel.text = @"2016-09-09 12:12";
        [cell.actButton setTitle:@"已退款" forState:0];
        
        return cell;
    }else{//row==2
        
        identifier = @"listas2";
        PropertyListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PropertyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *str1 = @"快递原件";
        NSString *str2 = @"(24小时有效)";
        NSString *str = [NSMutableString stringWithFormat:@"%@%@",str1,str2];
        NSMutableAttributedString *kdTitle = [[NSMutableAttributedString alloc] initWithString:str];
        [kdTitle setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, str1.length)];
        [kdTitle setAttributes:@{NSFontAttributeName:kSmallFont,NSForegroundColorAttributeName:kRedColor} range:NSMakeRange(str1.length, str2.length)];
        [cell.leftButton setAttributedTitle:kdTitle forState:0];
        
        [cell.rightButton setTitle:@"查看结果" forState:0];
        
        QDFWeakSelf;
        [cell.leftButton addAction:^(UIButton *btn) {
            HouseCopyViewController *houseCopyVC = [[HouseCopyViewController alloc] init];
            [weakself.navigationController pushViewController:houseCopyVC animated:YES];
        }];
        
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
//        PowerDetailsViewController *powerDetailsVC = [[PowerDetailsViewController alloc] init];
//        [self.navigationController pushViewController:powerDetailsVC animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
