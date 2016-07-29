//
//  ApplicationCourtViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/7/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplicationCourtViewController.h"
#import "MineUserCell.h"


@interface ApplicationCourtViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *courtChooseTableView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) NSMutableArray *courtListArray;

@end

@implementation ApplicationCourtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择法院";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.courtChooseTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.courtChooseTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)courtChooseTableView
{
    if (!_courtChooseTableView) {
        _courtChooseTableView = [UITableView newAutoLayoutView];
        _courtChooseTableView.delegate = self;
        _courtChooseTableView.dataSource = self;
        _courtChooseTableView.separatorColor = kSeparateColor;
        _courtChooseTableView.tableFooterView = [[UIView alloc] init];
    }
    return _courtChooseTableView;
}

- (NSMutableArray *)courtListArray
{
    if (!_courtListArray) {
        _courtListArray = [NSMutableArray array];
        _courtListArray = [NSMutableArray arrayWithObjects:@"长宁区法院",@"崇明法院",@"宝山法院",@"嘉定法院", nil];
    }
    return _courtListArray;
}

#pragma mark - delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courtListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    identifier = @"assess00";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell.userNameButton setTitle:self.courtListArray[indexPath.row] forState:0];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.text = @"     目前仅支持上海地区的查询";
    headerLabel.textColor = kLightGrayColor;
    headerLabel.font = kTabBarFont;
    headerLabel.backgroundColor = kBackColor;
    
    return headerLabel;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.didSelectedRow) {
        self.didSelectedRow(self.courtListArray[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
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
