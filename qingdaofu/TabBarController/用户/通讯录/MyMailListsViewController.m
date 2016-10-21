//
//  MyMailListsViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyMailListsViewController.h"

#import "MineUserCell.h"

@interface MyMailListsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *myMailListsTableView;
@property (nonatomic,strong) UIView *chooseOperatorView;

@end

@implementation MyMailListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    [self.rightButton setTitle:@"添加" forState:0];
    
    [self.view addSubview:self.myMailListsTableView];
    
    if ([self.mailType integerValue] == 2) {
        [self.view addSubview:self.chooseOperatorView];
    }
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        if ([self.mailType integerValue] == 2) {
            [self.myMailListsTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
            [self.myMailListsTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.chooseOperatorView];
            
            [self.chooseOperatorView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
            [self.chooseOperatorView autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        }else{
            [self.myMailListsTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        }
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)myMailListsTableView
{
    if (!_myMailListsTableView) {
        _myMailListsTableView = [UITableView newAutoLayoutView];
        _myMailListsTableView.backgroundColor = kBackColor;
        _myMailListsTableView.separatorColor = kSeparateColor;
        _myMailListsTableView.delegate = self;
        _myMailListsTableView.dataSource = self;
        _myMailListsTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _myMailListsTableView.tableFooterView = [[UIView alloc] init];
    }
    return _myMailListsTableView;
}

- (UIView *)chooseOperatorView
{
    if (!_chooseOperatorView) {
        _chooseOperatorView = [UIView newAutoLayoutView];
        _chooseOperatorView.backgroundColor = kRedColor;
    }
    return _chooseOperatorView;
}

#pragma mark - delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myMail";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//蓝色选中， 未选择selected@2x ,select ,灰色已选中selected_dis@2x
    
    [cell.userActionButton setTitle:@"1234567899" forState:0];
    
    if ([self.mailType integerValue] == 2) {
        cell.userNameButton.userInteractionEnabled = YES;
        [cell.userNameButton setImage:[UIImage imageNamed:@"select"] forState:0];
        [cell.userNameButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [cell.userNameButton setTitle:@"    张三" forState:0];
        
        [cell.userNameButton addAction:^(UIButton *btn) {
            btn.selected = !btn.selected;
        }];
    }else{
        [cell.userNameButton setTitle:@"张三" forState:0];
    }
    
    return cell;
}

#pragma mark - method
- (void)rightItemAction
{
    [self showHint:@"添加"];
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
