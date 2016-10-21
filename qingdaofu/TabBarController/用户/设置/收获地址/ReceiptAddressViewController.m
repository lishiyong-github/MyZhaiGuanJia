//
//  ReceiptAddressViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReceiptAddressViewController.h"
#import "ReceiptAddressEditViewController.h"

#import "BaseCommitView.h"
#import "ReiceptCell.h"
#import "ReceiptActionCell.h"

#import "ReceiptResponse.h"
#import "ReceiptModel.h"

@interface ReceiptAddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *receiptListTableView;
@property (nonatomic,strong) BaseCommitView *receiptListCommitView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,assign) NSInteger pageReceipt;
@property (nonatomic,strong) NSMutableArray *receiptArray;

@end

@implementation ReceiptAddressViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self headerRefeshOfReceiptAddress];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.receiptListTableView];
    [self.view addSubview:self.receiptListCommitView];
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.receiptListTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.receiptListTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.receiptListCommitView];
        
        [self.receiptListCommitView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.receiptListCommitView autoSetDimension:ALDimensionHeight toSize:60];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)receiptListTableView
{
    if (!_receiptListTableView) {
        _receiptListTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _receiptListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _receiptListTableView.delegate = self;
        _receiptListTableView.dataSource = self;
        _receiptListTableView.backgroundColor = kBackColor;
        _receiptListTableView.separatorColor = kSeparateColor;
        _receiptListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _receiptListTableView;
}

- (BaseCommitView *)receiptListCommitView
{
    if (!_receiptListCommitView) {
        _receiptListCommitView = [BaseCommitView newAutoLayoutView];
        [_receiptListCommitView.button setTitle:@"新增地址" forState:0];
        
        QDFWeakSelf;
        [_receiptListCommitView addAction:^(UIButton *btn) {
            ReceiptAddressEditViewController *reiceptAddressEditVC = [[ReceiptAddressEditViewController alloc] init];
            [weakself.navigationController pushViewController:reiceptAddressEditVC animated:YES];
        }];
    }
    return _receiptListCommitView;
}

- (NSMutableArray *)receiptArray
{
    if (!_receiptArray) {
        _receiptArray = [NSMutableArray array];
    }
    return _receiptArray;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.receiptArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ReceiptModel *receiptModel;
        NSString *addressStr;
        if (self.receiptArray.count > 0) {
            receiptModel = self.receiptArray[indexPath.section];
            addressStr = [NSString stringWithFormat:@"%@%@%@%@",receiptModel.province_name,receiptModel.city_name,receiptModel.area_name,receiptModel.address];
        }
        
        CGSize titleSize = CGSizeMake(kScreenWidth-kBigPadding*2, MAXFLOAT);
        CGSize actualsize = [addressStr boundingRectWithSize:titleSize options:NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName :kSecondFont} context:nil].size;
        
        return 45 + MAX(actualsize.height, 15.5);
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    ReceiptModel *receiptModel;
    if (self.receiptArray.count > 0) {
        receiptModel = self.receiptArray[indexPath.section];
    }
    
    if (indexPath.row == 0) {
        identifier = @"receiptEdit0";
        ReiceptCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ReiceptCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.nameLabel.text = receiptModel.nickname;
        cell.phoneLabel.text = receiptModel.tel;
        cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",receiptModel.province_name,receiptModel.city_name,receiptModel.area_name,receiptModel.address];
        
        return cell;
    }
    
    identifier = @"receiptEdit1";
    ReceiptActionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ReceiptActionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.reActButton1 setTitle:@"  设为默认" forState:0];
    
    if ([receiptModel.isdefault integerValue] == 1){//选择默认
        [cell.reActButton1 setTitleColor:kBlueColor forState:0];
        [cell.reActButton1 setImage:[UIImage imageNamed:@"selected"] forState:0];
    }else{
         [cell.reActButton1 setTitleColor:kGrayColor forState:0];
        [cell.reActButton1 setImage:[UIImage imageNamed:@"selected_dis"] forState:0];
    }
    
    [cell.reActButton2 setImage:[UIImage imageNamed:@"deletes"] forState:0];
    [cell.reActButton2 setTitle:@" 删除" forState:0];
    
    [cell.reActButton3 setImage:[UIImage imageNamed:@"edits"] forState:0];
    [cell.reActButton3 setTitle:@" 编辑" forState:0];
    
    QDFWeakSelf;
    [cell setDidSelectedActbutton:^(NSInteger actTag,UIButton *actButton) {
        if (actTag == 77) {//默认
            [weakself setDefaultAddressWithID:receiptModel.idString];
        }else if (actTag == 78){//删除
            [weakself DeleteReceiptAddressWithID:receiptModel.idString AndType:@"1"];
        }else if (actTag == 79){//编辑
            ReceiptAddressEditViewController *reiceptAddressEditVC = [[ReceiptAddressEditViewController alloc] init];
            reiceptAddressEditVC.receiModel = receiptModel;
            [weakself.navigationController pushViewController:reiceptAddressEditVC animated:YES];
        }
    }];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if ([self.cateString integerValue] == 1) {//点击单元格选择
            ReceiptModel *receiptModel = self.receiptArray[indexPath.section];
            NSString *address = [NSString stringWithFormat:@"%@%@%@%@",receiptModel.province_name,receiptModel.city_name,receiptModel.area_name,receiptModel.address];
            if (self.didSelectedReceiptAddress) {
                self.didSelectedReceiptAddress(receiptModel.nickname,receiptModel.tel,address);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

#pragma mark - refresh
- (void)getReceiptAddressListWithPage:(NSString *)page
{
    NSString *sdeeString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kReceiptAddressListString];
    NSDictionary *params = @{@"token" : [self getValidateToken]};
    
    QDFWeakSelf;
    [self requestDataPostWithString:sdeeString params:params successBlock:^(id responseObject) {        
        
        if ([page integerValue] == 1) {
            [weakself.receiptArray removeAllObjects];
        }
        
        ReceiptResponse *responsea = [ReceiptResponse objectWithKeyValues:responseObject];
        
        for (ReceiptModel *receiptModel in responsea.data) {
            [weakself.receiptArray addObject:receiptModel];
        }
        
        if (responsea.data.count == 0) {
            _pageReceipt--;
        }
        
        if (weakself.receiptArray.count > 0) {
            [weakself.baseRemindImageView setHidden:YES];
        }else{
            [weakself.baseRemindImageView setHidden:NO];
        }
        
        [weakself.receiptListTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)headerRefeshOfReceiptAddress
{
    _pageReceipt = 1;
    [self getReceiptAddressListWithPage:@"1"];
    
    QDFWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.receiptListTableView headerEndRefreshing];
    });
}

- (void)footerRefreshOfReceiptAddress
{
    _pageReceipt++;
    NSString *page = [NSString stringWithFormat:@"%ld",(long)_pageReceipt];
    [self getReceiptAddressListWithPage:page];
    
    QDFWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.receiptListTableView footerEndRefreshing];
    });
}

- (void)setDefaultAddressWithID:(NSString *)idString
{
    NSString *defaultString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kReceiptDefaultAddressString];
    NSDictionary *params = @{@"id" : idString,
                             @"token" : [self getValidateToken]};
    QDFWeakSelf;
    [self requestDataPostWithString:defaultString params:params successBlock:^(id responseObject) {
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself headerRefeshOfReceiptAddress];
        }
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)DeleteReceiptAddressWithID:(NSString *)idString AndType:(NSString *)typeString
{
    NSString *cancelString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kReceiptDefaultCancelString];
    NSDictionary *params = @{@"id" : idString,
                             @"type" : typeString,
                             @"token" : [self getValidateToken]
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:cancelString params:params successBlock:^(id responseObject) {
        BaseModel *baModel = [BaseModel objectWithKeyValues:responseObject];
        if ([baModel.code isEqualToString:@"0000"]) {
            [weakself headerRefeshOfReceiptAddress];
        }else{
            [weakself showHint:baModel.msg];
        }
    } andFailBlock:^(NSError *error) {
        
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
