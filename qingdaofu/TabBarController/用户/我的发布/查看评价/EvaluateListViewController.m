//
//  EvaluateListViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/31.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "EvaluateListViewController.h"
#import "AdditionalEvaluateViewController.h" //追加评价

#import "BaseCommitView.h"
#import "MineUserCell.h"
#import "EvaluatePhotoCell.h"

@interface EvaluateListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *evaluateListTableView;
@property (nonatomic,strong) BaseCommitView *evaluateCommitView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation EvaluateListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.evaluateListTableView];
    [self.view addSubview:self.evaluateCommitView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.evaluateListTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.evaluateListTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.evaluateCommitView];
        
        [self.evaluateCommitView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.evaluateCommitView autoSetDimension:ALDimensionHeight toSize:kCellHeight1];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)evaluateListTableView
{
    if (!_evaluateListTableView) {
        _evaluateListTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _evaluateListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _evaluateListTableView.backgroundColor = kBackColor;
        _evaluateListTableView.separatorColor = kSeparateColor;
        _evaluateListTableView.delegate = self;
        _evaluateListTableView.dataSource = self;
        _evaluateListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _evaluateListTableView;
}

- (BaseCommitView *)evaluateCommitView
{
    if (!_evaluateCommitView) {
        _evaluateCommitView = [BaseCommitView newAutoLayoutView];
        [_evaluateCommitView.button setTitle:@"追加评价" forState:0];
        
        QDFWeakSelf;
        [_evaluateCommitView addAction:^(UIButton *btn) {
            AdditionalEvaluateViewController *additionalEvaluateVC = [[AdditionalEvaluateViewController alloc] init];
            additionalEvaluateVC.typeString = weakself.typeString;
            additionalEvaluateVC.idString = weakself.idString;
            additionalEvaluateVC.categoryString = weakself.categoryString;
            
            UINavigationController *nasi = [[UINavigationController alloc] initWithRootViewController:additionalEvaluateVC];
            [nasi presentViewController:nasi animated:YES completion:nil];
        }];
    }
    return _evaluateCommitView;
}

#pragma mark - delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return kCellHeight;
    }
    
    return 145;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            identifier = @"evaGet0";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.userActionButton setHidden:YES];
            
            NSString *evaGetString = [NSString stringWithFormat:@"收到的评价（ %@ ）",@"2"];
            [cell.userNameButton setTitle:evaGetString forState:0];
            
            return cell;
        }
        
        //收到的评价
        identifier = @"evaGet1";
        EvaluatePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[EvaluatePhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.evaProductButton setHidden:YES];
        
        cell.evaNameLabel.text = @"mimii";
        cell.evaTimeLabel.text = @"2016-09-09 12:12";
        cell.evaStarImage.currentIndex = 3;
        cell.evaTextLabel.text = @"不错不错不错";
        [cell.evaProImageView1 setBackgroundColor:kRedColor];
        [cell.evaProImageView2 setBackgroundColor:kYellowColor];

        return cell;
    }
    
    //section=1
    if (indexPath.row == 0) {
        identifier = @"evaSend0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userActionButton setHidden:YES];
        
        NSString *evaGetString = [NSString stringWithFormat:@"发出的评价（ %@ ）",@"5"];
        [cell.userNameButton setTitle:evaGetString forState:0];
        
        return cell;
    }
    
    //发出的评价
    identifier = @"evaSend1";
    EvaluatePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[EvaluatePhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.evaProductButton setHidden:YES];
    
    cell.evaNameLabel.text = @"自己";
    cell.evaNameLabel.textColor = kBlueColor;
    cell.evaTimeLabel.text = @"2016-12-12 17:20";
    cell.evaStarImage.currentIndex = 1;
    cell.evaTextLabel.text = @"差评差评差评";
    [cell.evaProImageView1 setBackgroundColor:kRedColor];
    [cell.evaProImageView2 setBackgroundColor:kYellowColor];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return kBigPadding;
    }
    return 0.1;
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
