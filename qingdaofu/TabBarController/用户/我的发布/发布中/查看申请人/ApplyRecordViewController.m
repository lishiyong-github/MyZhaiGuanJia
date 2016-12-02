//
//  ApplyRecordViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/9/2.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplyRecordViewController.h"

#import "CheckDetailPublishViewController.h"   //申请人信息

#import "MineUserCell.h"

#import "ApplyRecordResponse.h"


@interface ApplyRecordViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *applyRecordsTableView;
@property (nonatomic,strong) NSMutableArray *recordsDataArray;

@property (nonatomic,strong) NSString *showString;  //1-显示提示信息，2-不显示

@property (nonatomic,assign) NSInteger pageRecords;


@end

@implementation ApplyRecordViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self getApplyRecordsList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请记录";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.applyRecordsTableView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
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
        _applyRecordsTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _applyRecordsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _applyRecordsTableView.delegate = self;
        _applyRecordsTableView.dataSource = self;
        _applyRecordsTableView.tableFooterView = [[UIView alloc] init];
        _applyRecordsTableView.backgroundColor = kBackColor;
        _applyRecordsTableView.separatorColor = kSeparateColor;
        _applyRecordsTableView.separatorInset = UIEdgeInsetsZero;
//        [_applyRecordsTableView addHeaderWithTarget:self action:@selector(headerRefreshOfRecords)];
//        [_applyRecordsTableView addFooterWithTarget:self action:@selector(footerRefreshOfRecords)];
        
        //        if ([_applyRecordsTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        //            [_applyRecordsTableView setSeparatorInset:UIEdgeInsetsZero];
        //        }
        //        if ([_applyRecordsTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        //            [_applyRecordsTableView setLayoutMargins:UIEdgeInsetsZero];
        //        }
        
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recordsDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"aRecords1";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userNameButton.userInteractionEnabled = NO;
    cell.userNameButton.titleLabel.numberOfLines = 0;
    cell.userActionButton.layer.cornerRadius = corner1;
    cell.userActionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [cell.userActionButton autoSetDimension:ALDimensionWidth toSize:75];
    
    ApplyRecordModel *recordModel = self.recordsDataArray[indexPath.row];
    
    NSString *apply1 = [NSString stringWithFormat:@"申请人：%@",recordModel.mobile];
    NSString *apply2 = [NSDate getYMDhmFormatterTime:recordModel.create_at];
    NSString *applySrt = [NSString stringWithFormat:@"%@\n%@",apply1,apply2];
    NSMutableAttributedString *applyAttribute = [[NSMutableAttributedString alloc] initWithString:applySrt];
    [applyAttribute addAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, apply1.length)];
    [applyAttribute addAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(apply1.length+1, apply2.length)];
    
    NSMutableParagraphStyle *stytty = [[NSMutableParagraphStyle alloc] init];
    [stytty setLineSpacing:kSpacePadding];
    [applyAttribute addAttribute:NSParagraphStyleAttributeName value:stytty range:NSMakeRange(0, applySrt.length)];
    
    [cell.userNameButton setAttributedTitle:applyAttribute forState:0];
    
    cell.userActionButton.titleLabel.font = kFourFont;
    [cell.userActionButton setTitleColor:kWhiteColor forState:0];
    
    if ([recordModel.status integerValue] == 10) {
        cell.userActionButton.backgroundColor = kButtonColor;
        [cell.userActionButton setTitle:@"选择TA" forState:0];
        cell.userActionButton.userInteractionEnabled = YES;
    }else if ([recordModel.status integerValue] == 20){
        cell.userActionButton.backgroundColor = kLightGrayColor;
        [cell.userActionButton setTitle:@"已选择" forState:0];
        cell.userActionButton.userInteractionEnabled = NO;
    }else if ([recordModel.status integerValue] == 30){
        cell.userActionButton.backgroundColor = kLightGrayColor;
        [cell.userActionButton setTitle:@"面谈失败" forState:0];
        cell.userActionButton.userInteractionEnabled = NO;
    }else{//接单方取消申请
        cell.userActionButton.backgroundColor = kLightGrayColor;
        [cell.userActionButton setTitle:@"取消申请" forState:0];
        cell.userActionButton.userInteractionEnabled = NO;
    }
    
    QDFWeakSelf;
    [cell.userActionButton addAction:^(UIButton *btn) {
        if (weakself.didChooseApplyUser) {
            weakself.didChooseApplyUser(recordModel);
        }
        [weakself back];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.recordsDataArray.count > 0) {
        UIButton *footerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        footerButton.titleLabel.numberOfLines = 0;
        [footerButton setContentEdgeInsets:UIEdgeInsetsMake(kBigPadding, kBigPadding, 0, kBigPadding)];
        NSString *ffff = @"选择申请记录中其中一个作为意向接单方，如果选择后面谈结果不符合可以选择其他申请方作为意向接单方。";
        NSMutableAttributedString *attributeFF = [[NSMutableAttributedString alloc] initWithString:ffff];
        [attributeFF setAttributes:@{NSFontAttributeName:kSmallFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, ffff.length)];
        NSMutableParagraphStyle *atype = [[NSMutableParagraphStyle alloc] init];
        [atype setLineSpacing:kSpacePadding];
        [attributeFF addAttribute:NSParagraphStyleAttributeName value:atype range:NSMakeRange(0, ffff.length)];
        [footerButton setAttributedTitle:attributeFF forState:0];
        
        return footerButton;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
//        recordModel *uModel = self.recordsDataArray[indexPath.row];
//        CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
//        checkDetailPublishVC.typeString = @"申请人";
//        checkDetailPublishVC.idString = self.idStr;
//        checkDetailPublishVC.categoryString = self.categaryStr;
//        checkDetailPublishVC.pidString = uModel.uidInner;
//        //                checkDetailPublishVC.evaTypeString = @"launchevaluation";
//        [self.navigationController pushViewController:checkDetailPublishVC animated:YES];
    }
}

#pragma mark - method
- (void)getApplyRecordsList
{
    NSString *listString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseOfApplyRecordsString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"productid" : self.productid
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:listString params:params successBlock:^(id responseObject){
        
        ApplyRecordResponse *response = [ApplyRecordResponse objectWithKeyValues:responseObject];
        
        for (ApplyRecordModel *recordModel in response.apply) {
            [weakself.recordsDataArray addObject:recordModel];
        }
        
        if (weakself.recordsDataArray.count > 0) {
            [weakself.baseRemindImageView setHidden:YES];
        }else{
            [weakself.baseRemindImageView setHidden:NO];
        }
        
        [weakself.applyRecordsTableView reloadData];
        
    } andFailBlock:^(id responseObject){
        
    }];
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
