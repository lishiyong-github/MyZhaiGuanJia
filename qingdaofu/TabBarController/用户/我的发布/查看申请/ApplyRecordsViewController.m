//
//  ApplyRecordsViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplyRecordsViewController.h"
#import "CheckDetailPublishViewController.h"   //申请人信息

#import "ApplyRecordsCell.h"

#import "RecordResponse.h"
#import "UserModel.h"

@interface ApplyRecordsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *applyRecordsTableView;
@property (nonatomic,strong) NSMutableArray *recordsDataArray;

@property (nonatomic,assign) NSInteger pageRecords;

@end

@implementation ApplyRecordsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self headerRefreshOfRecords];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请记录";
    self.navigationItem.leftBarButtonItem = self.leftItem;

    [self.view addSubview:self.applyRecordsTableView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    [self.applyRecordsTableView addHeaderWithTarget:self action:@selector(headerRefreshOfRecords)];
    [self.applyRecordsTableView addFooterWithTarget:self action:@selector(footerRefreshOfRecords)];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.applyRecordsTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];

        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)applyRecordsTableView
{
    if (!_applyRecordsTableView) {
        _applyRecordsTableView = [UITableView newAutoLayoutView];
        _applyRecordsTableView.delegate = self;
        _applyRecordsTableView.dataSource = self;
        _applyRecordsTableView.tableFooterView = [[UIView alloc] init];
        _applyRecordsTableView.backgroundColor = kBackColor;
        _applyRecordsTableView.separatorInset = UIEdgeInsetsZero;
        
        if ([_applyRecordsTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_applyRecordsTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_applyRecordsTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_applyRecordsTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
    }
    return _applyRecordsTableView;
}

- (NSMutableArray *)recordsDataArray
{
    if (!_recordsDataArray) {
        _recordsDataArray = [NSMutableArray array];
    }
    return _recordsDataArray;
}

#pragma mark - tableView deleagte and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.recordsDataArray.count > 0) {
        return 1+self.recordsDataArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
        identifier = @"aRecords0";
        
        ApplyRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ApplyRecordsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    
    if (indexPath.row == 0) {
        
        cell.personLabel.textColor = kBlackColor;
        cell.personLabel.font = kBigFont;
        cell.personLabel.text = @"申请人";
        
        cell.dateLabel.textColor = kBlackColor;
        cell.dateLabel.font = kBigFont;
        cell.dateLabel.text = @"申请时间";
        
        [cell.actButton setTitleColor:kBlackColor forState:0];
        cell.actButton.titleLabel.font = kBigFont;
        [cell.actButton setTitle:@"操作" forState:0];
    }else{
        
        [cell.lineLabel11 setHidden:YES];
        [cell.lineLabel12 setHidden:YES];
        
        UserModel *userModel;
        if (self.recordsDataArray.count > 0) {
            userModel = self.recordsDataArray[indexPath.row-1];
            cell.personLabel.text = userModel.mobile;
            cell.dateLabel.text = [NSDate getYMDFormatterTime:userModel.create_time];
            [cell.actButton setTitle:@"查看" forState:0];
            cell.actButton.layer.borderWidth = kLineWidth;
            cell.actButton.layer.borderColor = kBlueColor.CGColor;
            cell.actButton.layer.cornerRadius = corner;
            QDFWeakSelf;
            [cell.actButton addAction:^(UIButton *btn) {
                CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
                checkDetailPublishVC.typeString = @"申请人";
                checkDetailPublishVC.idString = self.idStr;
                checkDetailPublishVC.categoryString = self.categaryStr;
                checkDetailPublishVC.pidString = userModel.uidInner;
//                checkDetailPublishVC.evaTypeString = @"launchevaluation";
                [weakself.navigationController pushViewController:checkDetailPublishVC animated:YES];
            }];
        }
    }
    
    return cell;
}

#pragma mark - method
- (void)getApplyRecordsListWithPage:(NSString *)page
{
    NSString *listString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyRecordsString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idStr,
                             @"category" : self.categaryStr,
                             @"page" : page
                             };
    [self requestDataPostWithString:listString params:params successBlock:^(id responseObject){
        
        if ([page integerValue] == 0) {
            [self.recordsDataArray removeAllObjects];
        }
        
        RecordResponse *response = [RecordResponse objectWithKeyValues:responseObject];
        
        if (response.user.count == 0) {
            _pageRecords--;
            [self showHint:@"没有更多了"];
        }
        
        for (UserModel *model in response.user) {
            [self.recordsDataArray addObject:model];
        }
        
        if (self.recordsDataArray.count > 0) {
            [self.baseRemindImageView setHidden:YES];
        }else{
            [self.baseRemindImageView setHidden:NO];
        }
        
        [self.applyRecordsTableView reloadData];
        
    } andFailBlock:^(id responseObject){
        
    }];
}

- (void)headerRefreshOfRecords
{
    [self getApplyRecordsListWithPage:@"0"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.applyRecordsTableView headerEndRefreshing];
    });
}

- (void)footerRefreshOfRecords
{
    _pageRecords++;
    NSString *page = [NSString stringWithFormat:@"%d",_pageRecords];
    [self getApplyRecordsListWithPage:page];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.applyRecordsTableView footerEndRefreshing];
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
