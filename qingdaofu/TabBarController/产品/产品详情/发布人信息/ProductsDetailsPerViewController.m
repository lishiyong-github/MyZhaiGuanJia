//
//  ProductsDetailsPerViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ProductsDetailsPerViewController.h"

#import "CaseViewController.h"   //经典案例
#import "AllEvaluationViewController.h"  //所有评价

#import "BaseCommitButton.h"
#import "MineUserCell.h"
#import "EvaluatePhotoCell.h"

@interface ProductsDetailsPerViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *productsDetailPerTableView;
@property (nonatomic,strong) BaseCommitButton *proDetailPerCommitButton;
@end

@implementation ProductsDetailsPerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布人详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"information_nav_remind"] style:UIBarButtonItemStylePlain target:self action:@selector(remindPublisher)];
    
    [self.view addSubview:self.productsDetailPerTableView];
    [self.view addSubview:self.proDetailPerCommitButton];
    [self.view setNeedsUpdateConstraints];
}

- (void)remindPublisher
{
    
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.productsDetailPerTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.productsDetailPerTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.proDetailPerCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.proDetailPerCommitButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
    }
    [super updateViewConstraints];
}

- (UITableView *)productsDetailPerTableView
{
    if (!_productsDetailPerTableView) {
        _productsDetailPerTableView = [UITableView newAutoLayoutView];
        _productsDetailPerTableView.translatesAutoresizingMaskIntoConstraints = YES;
        _productsDetailPerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _productsDetailPerTableView.delegate = self;
        _productsDetailPerTableView.dataSource = self;
        _productsDetailPerTableView.backgroundColor = kBackColor;
        _productsDetailPerTableView.separatorColor = kSeparateColor;
    }
    return _productsDetailPerTableView;
}

- (BaseCommitButton *)proDetailPerCommitButton
{
    if (!_proDetailPerCommitButton) {
        _proDetailPerCommitButton = [BaseCommitButton newAutoLayoutView];
        [_proDetailPerCommitButton setTitle:@"立即申请" forState:0];
    }
    return _proDetailPerCommitButton;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return kCellHeight;
    }else{
        if (indexPath.row == 0) {
            return kCellHeight;
        }
        return 170;
    }
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section == 0) {
        identifier = @"per0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *textArraya = @[@"| 申请人信息",@"姓名",@"身份证号码",@"身份图片",@"邮箱",@"经典案例"];
        [cell.userNameButton setTitle:textArraya[indexPath.row] forState:0];
        
        if (indexPath.row == 0) {
            [cell.userNameButton setTitleColor:kBlueColor forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"publish_list_authentication"] forState:0];
        }else if (indexPath.row ==5){
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            [cell.userActionButton setTitle:@"查看" forState:0];
            QDFWeakSelf;
            [cell.userActionButton addAction:^(UIButton *btn) {
                CaseViewController *caseVC = [[CaseViewController alloc] init];
                [weakself.navigationController pushViewController:caseVC animated:YES];
            }];
        }
        
        return cell;
    }
    //section ＝＝ 1
    if (indexPath.row == 0) {
        identifier = @"per10";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userNameButton setTitle:@"|  收到的评价（4.5分）" forState:0];
        [cell.userNameButton setTitleColor:kBlueColor forState:0];
        [cell.userActionButton setTitle:@"查看全部" forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        QDFWeakSelf;
        [cell.userActionButton addAction:^(UIButton *btn) {
            AllEvaluationViewController *allEvaluationVC = [[AllEvaluationViewController alloc] init];
            [weakself.navigationController pushViewController:allEvaluationVC animated:YES];
        }];
        
        return cell;
    }
    
    identifier = @"per11";
    EvaluatePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[EvaluatePhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.evaNameLabel.text = @"12345678990";
    cell.evaStarImage.currentIndex = 3;
    cell.evaTextLabel.text = @"有信誉有信誉，还会再来";
    cell.evaProImageView1.backgroundColor = kSeparateColor;
    cell.evaProImageView2.backgroundColor = kSeparateColor;
    [cell.evaProductButton setHidden:YES];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section>0) {
//        return kBigPadding;
//    }
//    return 0.1f;
    
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section > 0) {
        return kBigPadding;
    }
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 0) && (indexPath.row == 5)) {
        NSLog(@"经典案例");
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
