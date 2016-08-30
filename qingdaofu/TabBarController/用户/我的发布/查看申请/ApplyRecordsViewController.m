//
//  ApplyRecordsViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplyRecordsViewController.h"
#import "CheckDetailPublishViewController.h"   //申请人信息
#import "AgreementViewController.h" //同意申请

#import "MineUserCell.h"
#import "BidOneCell.h"

#import "RecordResponse.h"
#import "UserModel.h"

@interface ApplyRecordsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *applyRecordsTableView;
@property (nonatomic,strong) NSMutableArray *recordsDataArray;

@property (nonatomic,strong) NSString *showString;  //1-显示提示信息，2-不显示

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
        [_applyRecordsTableView addHeaderWithTarget:self action:@selector(headerRefreshOfRecords)];
        [_applyRecordsTableView addFooterWithTarget:self action:@selector(footerRefreshOfRecords)];

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
    if (self.recordsDataArray.count > 0) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.recordsDataArray.count > 0) {
        return self.recordsDataArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return kCellHeight;
    if (indexPath.section == 0) {
        return kRemindHeight;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.section == 0) {
        identifier = @"aRecords0";//BidOneCell.h
        BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.cancelButton setHidden:YES];
        cell.backgroundColor = kBlueColor;
        [cell.oneButton setTitle:@"只能选择一个作为接单方，选择后不能修改" forState:0];
        [cell.oneButton setTitleColor:kNavColor forState:0];
        cell.oneButton.titleLabel.font = kFourFont;
        
        return cell;
    }
    
    identifier = @"aRecords1";
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
    
    UserModel *userModel;
    if (self.recordsDataArray.count > 0) {
        userModel = self.recordsDataArray[indexPath.row];
    }
    
    NSString *apply1 = [NSString stringWithFormat:@"申请人：%@",userModel.username];
    NSString *apply2 = [NSDate getYMDhmFormatterTime:userModel.create_time];
    NSString *applySrt = [NSString stringWithFormat:@"%@\n%@",apply1,apply2];
    NSMutableAttributedString *applyAttribute = [[NSMutableAttributedString alloc] initWithString:applySrt];
    [applyAttribute addAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, apply1.length)];
    [applyAttribute addAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(apply1.length+1, apply2.length)];
    
    NSMutableParagraphStyle *stytty = [[NSMutableParagraphStyle alloc] init];
    [stytty setLineSpacing:kSpacePadding];
    [applyAttribute addAttribute:NSParagraphStyleAttributeName value:stytty range:NSMakeRange(0, applySrt.length)];
    
    [cell.userNameButton setAttributedTitle:applyAttribute forState:0];
    
    [cell.userActionButton setTitle:@"同意" forState:0];
    [cell.userActionButton setTitleColor:kNavColor forState:0];
    cell.userActionButton.titleLabel.font = kFourFont;
    cell.userActionButton.backgroundColor = kBlueColor;
    
    QDFWeakSelf;
    [cell.userActionButton addAction:^(UIButton *btn) {
        AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
        agreementVC.flagString = @"1";
        agreementVC.idString = userModel.idString;
        agreementVC.categoryString = userModel.category;
        agreementVC.pidString = userModel.uidInner;
        [weakself.navigationController pushViewController:agreementVC animated:YES];
    }];
    
    return cell;
    
    /*
    ApplyRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ApplyRecordsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
    
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
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return kBigPadding;
    }
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        UserModel *uModel = self.recordsDataArray[indexPath.row];
        CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
        checkDetailPublishVC.typeString = @"申请人";
        checkDetailPublishVC.idString = self.idStr;
        checkDetailPublishVC.categoryString = self.categaryStr;
        checkDetailPublishVC.pidString = uModel.uidInner;
        //                checkDetailPublishVC.evaTypeString = @"launchevaluation";
        [self.navigationController pushViewController:checkDetailPublishVC animated:YES];
    }
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
    QDFWeakSelf;
    [self requestDataPostWithString:listString params:params successBlock:^(id responseObject){
            
        if ([page integerValue] == 1) {
            [weakself.recordsDataArray removeAllObjects];
        }
        
        RecordResponse *response = [RecordResponse objectWithKeyValues:responseObject];
        
        if (response.user.count == 0) {
            _pageRecords--;
        }
        
        for (UserModel *model in response.user) {
            [weakself.recordsDataArray addObject:model];
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

- (void)headerRefreshOfRecords
{
    _pageRecords = 1;
    [self getApplyRecordsListWithPage:@"1"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.applyRecordsTableView headerEndRefreshing];
    });
}

- (void)footerRefreshOfRecords
{
    _pageRecords++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pageRecords];
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
