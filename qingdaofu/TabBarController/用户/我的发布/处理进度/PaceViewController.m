//
//  PaceViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/5.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PaceViewController.h"

#import "BidMessageCell.h"

@interface PaceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstarits;
@property (nonatomic,strong) UITableView *paceTableView;

@end

@implementation PaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"处理进度";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.paceTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstarits) {
        
        [self.paceTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        self.didSetupConstarits = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)paceTableView
{
    if (!_paceTableView) {
        _paceTableView = [UITableView newAutoLayoutView];
        _paceTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _paceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _paceTableView.delegate = self;
        _paceTableView.dataSource = self;
        _paceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _paceTableView;
}

#pragma mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"pace";
    
    BidMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[BidMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.deadlineLabel.text = @"案号类型：二审";
    cell.dateLabel.text = @"案        号：20160530";
    cell.areaLabel.text = @"处置类型：拍卖";
    cell.addressLabel.text = @"详        情：详情详情详情详情";
    cell.timeLabel.text = @"2016-05-30";
    
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
