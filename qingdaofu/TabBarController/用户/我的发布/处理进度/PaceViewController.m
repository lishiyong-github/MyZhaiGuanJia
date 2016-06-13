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
    return self.scheArray.count;
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
    

    ScheduleModel *model = self.scheArray[indexPath.section];
    
    
    NSArray *suitArray = @[@"债权人上传处置资产",@"律师接单",@"双方洽谈",@"向法院起诉(财产保全)",@"整理诉讼材料",@"法院立案",@"向当事人发出开庭传票",@"开庭前调解",@"开庭",@"判决",@"二次开庭",@"二次判决",@"移交执行局申请执行",@"执行中提供借款人的财产线索",@"调查(公告)",@"拍卖",@"流拍",@"拍卖成功",@"付费"];
    NSArray *suitNoArray = @[@"一审",@"二审",@"再审",@"执行"];
    NSInteger auditInt = [model.audit intValue];
    NSInteger statusInt = [model.status intValue];
    
    cell.deadlineLabel.text = [NSString stringWithFormat:@"案号类型：%@",suitNoArray[auditInt]];
    //@"案号类型：二审";
    cell.dateLabel.text = [NSString stringWithFormat:@"案        号：%@",model.caseString];
    //@"案        号：20160530";
    cell.areaLabel.text = [NSString stringWithFormat:@"处置类型：%@",suitArray[statusInt]];
    //@"处置类型：拍卖";
    cell.addressLabel.text = [NSString stringWithFormat:@"详        情：%@",model.content];
    //@"详        情：详情详情详情详情";
    cell.timeLabel.text = [NSDate getYMDFormatterTime:model.create_time];
    //@"2016-05-30";
    
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
