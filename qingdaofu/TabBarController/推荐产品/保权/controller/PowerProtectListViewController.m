//
//  PowerProtectListViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PowerProtectListViewController.h"

#import "PowerProtectViewController.h" //申请保全
#import "PowerDetailsViewController.h"  //保权详情

#import "BaseCommitView.h"
#import "EvaTopSwitchView.h"

#import "MineUserCell.h"
#import "MessageCell.h"

@interface PowerProtectListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) EvaTopSwitchView *powerSwitchView;
@property (nonatomic,strong) UITableView *powerListTableView;
@property (nonatomic,strong) BaseCommitView *powerListCommitView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation PowerProtectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的保全";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.powerSwitchView];
    [self.view addSubview:self.powerListTableView];
    [self.view addSubview:self.powerListCommitView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.powerSwitchView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.powerSwitchView autoSetDimension:ALDimensionHeight toSize:50];
        
        [self.powerListTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.powerSwitchView];
        [self.powerListTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.powerListTableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.powerListTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.powerListCommitView];
        
        [self.powerListCommitView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.powerListCommitView autoSetDimension:ALDimensionHeight toSize:60];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (EvaTopSwitchView *)powerSwitchView
{
    if (!_powerSwitchView) {
        _powerSwitchView = [EvaTopSwitchView newAutoLayoutView];
        [_powerSwitchView.shortLineLabel setHidden:YES];
        _powerSwitchView.leftBlueConstraints.constant = 0;
        _powerSwitchView.widthBlueConstraints.constant = kScreenWidth/2;
        _powerSwitchView.backgroundColor = kNavColor;
        
        [_powerSwitchView.getbutton setTitle:@"未完成的订单" forState:0];
        [_powerSwitchView.sendButton setTitle:@"已完成的订单" forState:0];
        
        QDFWeakSelf;
        [_powerSwitchView setDidSelectedButton:^(NSInteger tag) {
            if (tag == 33) {
                weakself.powerSwitchView.leftBlueConstraints.constant = 0;
                [weakself.powerSwitchView.getbutton setTitleColor:kBlueColor forState:0];
                [weakself.powerSwitchView.sendButton setTitleColor:kBlackColor forState:0];
            }else if (tag == 34){
                weakself.powerSwitchView.leftBlueConstraints.constant = kScreenWidth/2;
                [weakself.powerSwitchView.sendButton setTitleColor:kBlueColor forState:0];
                [weakself.powerSwitchView.getbutton setTitleColor:kBlackColor forState:0];
            }
        }];
    }
    return _powerSwitchView;
}

- (UITableView *)powerListTableView
{
    if (!_powerListTableView) {
        _powerListTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _powerListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _powerListTableView.delegate = self;
        _powerListTableView.dataSource = self;
        _powerListTableView.backgroundColor = kBackColor;
        _powerListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _powerListTableView;
}

- (BaseCommitView *)powerListCommitView
{
    if (!_powerListCommitView) {
        _powerListCommitView = [BaseCommitView newAutoLayoutView];
        [_powerListCommitView.button setTitle:@"申请保全" forState:0];
        
        QDFWeakSelf;
        [_powerListCommitView.button addAction:^(UIButton *btn) {
            UINavigationController *nav = weakself.navigationController;
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
            
            PowerProtectViewController *powerProtectVC = [[PowerProtectViewController alloc] init];
            powerProtectVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:powerProtectVC animated:NO];
        }];
    }
    return _powerListCommitView;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 65;
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

        [cell.userNameButton setTitle:@"  BH20160928009" forState:0];
        [cell.userNameButton setTitleColor:kGrayColor forState:0];
        [cell.userNameButton setImage:[UIImage imageNamed:@"right"] forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        return cell;
    }else if(indexPath.row == 1){
        identifier = @"listas1";
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.countLabel setHidden:YES];
        [cell.actButton setHidden:YES];
        cell.userLabel.textColor = kGrayColor;
        cell.newsLabel.textColor = kGrayColor;
        cell.userLabel.font = kFirstFont;
        cell.newsLabel.font = kFirstFont;

        cell.userLabel.text = [NSString stringWithFormat:@"金额：%@万",@"1000"];
        cell.timeLabel.text = @"2016-09-09 12:12";
        cell.newsLabel.text = [NSString stringWithFormat:@"法院：%@",@"上海市高级人民法院"];
        
        return cell;
        
        
        /*
        NSString *moneyStr1 = [NSString stringWithFormat:@"保全金额：%@",@"1000万"];
        NSString *moneyStr2 = @"2014-09-09 12:12";
        NSString *moneyStr = [NSString stringWithFormat:@"%@\n%@",moneyStr1,moneyStr2];
        NSMutableAttributedString *attributeMoneyStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        [attributeMoneyStr addAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, moneyStr1.length)];
        [attributeMoneyStr addAttributes:@{NSFontAttributeName:kSmallFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(moneyStr1.length+1, moneyStr2.length)];
        NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:kSpacePadding];
        [attributeMoneyStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [moneyStr length])];
        
        [cell.powerMoneyLabel setAttributedText:attributeMoneyStr];
        cell.powerStateLabel.text = @"审核中";//审核中－黑色；审核失败－红色；审核成功蓝色
        
        
        return cell;
         */
    }
    /*
    else{
        identifier = @"listas2";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userNameButton setHidden:YES];
        [cell.userActionButton setTitleColor:kBlackColor forState:0];
        [cell.userActionButton setTitle:@"  查看进度  " forState:0];
        cell.userActionButton.layer.borderColor = kBorderColor.CGColor;
        cell.userActionButton.layer.borderWidth = kLineWidth;
        
        QDFWeakSelf;
        [cell.userActionButton addAction:^(UIButton *btn) {
            PowerPaceViewController *powerPaceVC = [[PowerPaceViewController alloc] init];
            [weakself.navigationController pushViewController:powerPaceVC animated:YES];
        }];
        
        return cell;
    }
     */
    
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
        PowerDetailsViewController *powerDetailsVC = [[PowerDetailsViewController alloc] init];
        [self.navigationController pushViewController:powerDetailsVC animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based powerlication, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
