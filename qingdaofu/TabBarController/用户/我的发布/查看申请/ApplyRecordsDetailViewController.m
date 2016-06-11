//
//  ApplyRecordsDetailViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/30.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplyRecordsDetailViewController.h"


#import "BaseCommitButton.h"

#import "MineUserCell.h"
#import "EvaluatePhotoCell.h"

@interface ApplyRecordsDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *applyDetailTableView;

@property (nonatomic,strong) BaseCommitButton *applyStateButton;

@property (nonatomic,strong) UIButton *ApplyRightBarBtn;

@end

@implementation ApplyRecordsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请人详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.ApplyRightBarBtn];
    
    [self.view addSubview:self.applyDetailTableView];
    [self.view addSubview:self.applyStateButton];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.applyDetailTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.applyDetailTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.applyStateButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.applyStateButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UIButton *)ApplyRightBarBtn
{
    if (!_ApplyRightBarBtn) {
        _ApplyRightBarBtn = [UIButton buttonWithType:0];
        _ApplyRightBarBtn.bounds = CGRectMake(0, 0, 24, 24);
        [_ApplyRightBarBtn setImage:[UIImage imageNamed:@"information_nav_remind"] forState:0];
        QDFWeakSelf;
        [_ApplyRightBarBtn addAction:^(UIButton *btn) {
            [weakself warnning];
        }];
    }
    return _ApplyRightBarBtn;
}

#pragma mark - method
- (void)warnning
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"是否提醒发布方完善信息" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确认发布方信息");
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:actionOK];
    [alertController addAction:actionCancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UITableView *)applyDetailTableView
{
    if (!_applyDetailTableView) {
//        _applyDetailTableView = [UITableView newAutoLayoutView];
        _applyDetailTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _applyDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _applyDetailTableView.delegate = self;
        _applyDetailTableView.dataSource = self;
        _applyDetailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _applyDetailTableView;
}

- (BaseCommitButton *)applyStateButton
{
    if (!_applyStateButton) {
        _applyStateButton = [BaseCommitButton newAutoLayoutView];
        [_applyStateButton setTitle:@"申请中" forState:0];
    }
    return _applyStateButton;
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 1) && (indexPath.row >0)) {
        return 170;
    }
    
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.section == 0) {
        identifier = @"publish0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *pubArray = @[@"|  申请人信息",@"姓名",@"身份证号码",@"身份图片",@"邮箱",@"经典案例"];
        NSArray *pubArray1 = @[@"",@"沥沥沥",@"12345566666666",@"已上传",@"24234345345@qq.com",@"查看"];
        
        [cell.userNameButton setTitle:pubArray[indexPath.row] forState:0];
        [cell.userActionButton setTitle:pubArray1[indexPath.row] forState:0];
        
        if (indexPath.row == 0) {
            [cell.userNameButton setTitleColor:kBlueColor forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"publish_list_authentication"] forState:0];
        }else if (indexPath.row == 5){
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        }
        return cell;
    }
    
    //评价
    if (indexPath.row == 0) {
        identifier = @"publish10";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.userNameButton setTitle:@"|  收到的评价（4.0分）" forState:0];
        [cell.userNameButton setTitleColor:kBlueColor forState:0];
        [cell.userActionButton setTitle:@"查看全部" forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        return cell;
    }
    identifier = @"publish11";
    EvaluatePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[EvaluatePhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.evaNameLabel.text = @"1234567778";
    cell.evaStarImage.currentIndex = 5;
    cell.evaTextLabel.text = @"很好";
    cell.evaProImageView1.backgroundColor = kRedColor;
    cell.evaProImageView2.backgroundColor = kRedColor;
    [cell.evaProductButton setHidden:YES];
    
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
