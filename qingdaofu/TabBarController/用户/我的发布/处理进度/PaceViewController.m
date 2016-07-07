//
//  PaceViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/5.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PaceViewController.h"

#import "BidMessageCell.h"

#import "PaceResponse.h"
#import "PaceModel.h"

@interface PaceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstarits;
@property (nonatomic,strong) UITableView *paceTableView;
@property (nonatomic,strong) NSMutableArray *paceDataArray;

@property (nonatomic,assign) NSInteger pagePace;

@end

@implementation PaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"处理进度";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.view.backgroundColor = kBackColor;
    
    [self.view addSubview:self.paceTableView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.paceTableView addHeaderWithTarget:self action:@selector(headerRefreshOfPace)];
    [self.paceTableView addFooterWithTarget:self action:@selector(footerRefreshOfPace)];
    
    [self.view setNeedsUpdateConstraints];
    
    [self headerRefreshOfPace];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstarits) {
        
        [self.paceTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        self.didSetupConstarits = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)paceTableView
{
    if (!_paceTableView) {
        _paceTableView.translatesAutoresizingMaskIntoConstraints = YES;
        _paceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _paceTableView.delegate = self;
        _paceTableView.dataSource = self;
        _paceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _paceTableView.backgroundColor = kBackColor;
    }
    return _paceTableView;
}

- (NSMutableArray *)paceDataArray
{
    if (!_paceDataArray) {
        _paceDataArray = [NSMutableArray array];
    }
    return _paceDataArray;
}

#pragma mark - delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.paceDataArray.count > 0) {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.paceDataArray.count;
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
    cell.backgroundColor = kNavColor;
    
    PaceModel *model;
    if (self.paceDataArray.count > 0) {
        model = self.paceDataArray[indexPath.section];
    }
    
    cell.timeLabel.text = [NSDate getYMDFormatterTime:model.create_time];
    [cell.remindImageButton setHidden:YES];
    
    if ([self.categoryString intValue] == 3) {//诉讼，有案号及案号类型
        NSArray *array1 = @[@"债权人上传处置资产",@"律师接单",@"双方洽谈",@"向法院起诉(财产保全)",@"整理诉讼材料",@"法院立案",@"向当事人发出开庭传票",@"开庭前调解",@"开庭",@"判决",@"二次开庭",@"二次判决",@"移交执行局申请执行",@"执行中提供借款人的财产线索",@"调查(公告)",@"拍卖",@"流拍",@"拍卖成功",@"付费"];
        //诉讼的案号状态：0=>一审,1=>二审,2=>再审,3=>执行
        NSArray *array2 = @[@"一审",@"二审",@"再审",@"执行"];
        NSInteger a1 = [model.audit intValue];
        NSInteger a2 = [model.status intValue]-1;
        NSString *caseString = [NSString getValidStringFromString:model.caseString];
        NSString *content = [NSString getValidStringFromString:model.content];
        
        cell.deadlineLabel.text = [NSString stringWithFormat:@"案号类型：%@",array1[a1]];
        cell.dateLabel.text = [NSString stringWithFormat:@"案        号：%@",caseString];
        cell.areaLabel.text = [NSString stringWithFormat:@"处置类型：%@",array2[a2]];
        cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",@"详        情：",content];

    }else if([self.categoryString intValue] == 1){//融资
        
        NSArray *array3 = @[@"尽职调查",@"公证",@"抵押",@"放款",@"返点",@"其他"];
        NSInteger a3 = [model.status intValue]-1;
        NSString *content = [NSString getValidStringFromString:model.content];
        
        cell.deadlineLabel.text = [NSString stringWithFormat:@"案号类型：暂无"];
        cell.dateLabel.text = [NSString stringWithFormat:@"案        号：暂无"];
        cell.areaLabel.text = [NSString stringWithFormat:@"处置类型：%@",array3[a3]];
        cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",@"详        情：",content];
    }else{//清收
        NSArray *array4 = @[@"电话",@"上门",@"面谈"];
        NSInteger a4 = [model.status intValue]-1;
        NSString *content = [NSString getValidStringFromString:model.content];
        
        cell.deadlineLabel.text = [NSString stringWithFormat:@"案号类型：暂无"];
        cell.dateLabel.text = [NSString stringWithFormat:@"案        号：暂无"];
        cell.areaLabel.text = [NSString stringWithFormat:@"处置类型：%@",array4[a4]];
        cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",@"详        情：",content];
    }
    
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

#pragma mark - method
- (void)getPaceMessagesListWithPage:(NSString *)page
{
    NSString *paceString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kLookUpScheduleString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categoryString,
                             @"page" : page
                             };
    [self requestDataPostWithString:paceString params:params successBlock:^(id responseObject) {
        if ([page integerValue] == 0) {
            [self.paceDataArray removeAllObjects];
        }
        
        PaceResponse *response = [PaceResponse objectWithKeyValues:responseObject];
        
        if (response.disposing.count == 0) {
            _pagePace--;
            [self showHint:@"没有更多了"];
        }
        
        for (PaceModel *paceModel in response.disposing) {
            [self.paceDataArray addObject:paceModel];
        }
        
        if (self.paceDataArray.count > 0) {
            [self.baseRemindImageView setHidden:YES];
        }else{
            [self.baseRemindImageView setHidden:NO];
        }
        
        [self.paceTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)headerRefreshOfPace
{
    [self getPaceMessagesListWithPage:@"0"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.paceTableView headerEndRefreshing];
    });
}

- (void)footerRefreshOfPace
{
    _pagePace++;
    NSString *page = [NSString stringWithFormat:@"%d",_pagePace];
    [self getPaceMessagesListWithPage:page];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.paceTableView footerEndRefreshing];
    });
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
