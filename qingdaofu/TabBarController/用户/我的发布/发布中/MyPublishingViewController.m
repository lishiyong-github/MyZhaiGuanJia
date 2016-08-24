//
//  MyPublishingViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/6.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyPublishingViewController.h"
#import "AdditionMessageViewController.h"  //补充信息
#import "ApplyRecordsViewController.h"   //申请记录
#import "AgreementViewController.h"//协议

#import "ReportSuitViewController.h"  //发布催收，发布诉讼

#import "EvaTopSwitchView.h"

#import "MineUserCell.h"
#import "BidMessageCell.h"
#import "BidOneCell.h"

#import "PublishingModel.h"
#import "PublishingResponse.h"

@interface MyPublishingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *publishingTableView;
@property (nonatomic,strong) EvaTopSwitchView *publishSwitchView;
@property (nonatomic,strong) NSMutableArray *publishingDataArray;


@property (nonatomic,strong) NSString *loanTypeString1;  //债权类型
@property (nonatomic,strong) NSString *loanTypeString2;  //债权类型内容
@property (nonatomic,strong) NSString *loanTypeImage;//债权类型图片

@end

@implementation MyPublishingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self getDetailMessages];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"application_record"] style:UIBarButtonItemStylePlain target:self action:@selector(showRecordList)];//application_record_spot@3x
    
    [self.view addSubview: self.publishingTableView];
    [self.view addSubview:self.publishSwitchView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.publishingTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.publishingTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.publishSwitchView];
        
        [self.publishSwitchView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.publishSwitchView autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
    
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)publishingTableView
{
    if (!_publishingTableView) {
        _publishingTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _publishingTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _publishingTableView.backgroundColor = kBackColor;
        _publishingTableView.separatorColor = kSeparateColor;
        _publishingTableView.delegate = self;
        _publishingTableView.dataSource = self;
    }
    return _publishingTableView;
}

- (EvaTopSwitchView *)publishSwitchView
{
    if (!_publishSwitchView) {
        _publishSwitchView = [EvaTopSwitchView newAutoLayoutView];
        [_publishSwitchView.blueLabel setHidden:YES];
        _publishSwitchView.backgroundColor = kNavColor;
        _publishSwitchView.layer.borderColor = kBorderColor.CGColor;
        _publishSwitchView.layer.borderWidth = kLineWidth;
        
        [_publishSwitchView.getbutton setImage:[UIImage imageNamed:@"delete"] forState:0];
        [_publishSwitchView.getbutton setTitle:@" 删除产品" forState:0];
        [_publishSwitchView.getbutton setTitleColor:kBlackColor forState:0];
        [_publishSwitchView.sendButton setTitle:@" 编辑信息" forState:0];
        [_publishSwitchView.sendButton setImage:[UIImage imageNamed:@"edit"] forState:0];
        [_publishSwitchView.sendButton addTarget:self action:@selector(editAllMessages) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishSwitchView;
}

- (NSMutableArray *)publishingDataArray
{
    if (!_publishingDataArray) {
        _publishingDataArray = [NSMutableArray array];
    }
    return _publishingDataArray;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.publishingDataArray.count > 0) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.publishingDataArray.count > 0) {
        if (section == 1) {
            PublishingResponse *response = self.publishingDataArray[0];
            if ([response.product.loan_type isEqualToString:@"4"]) {
                return 5;
            }
            return 6;
        }
            return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 40;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (self.publishingDataArray.count > 0) {
        PublishingResponse *resModel = self.publishingDataArray[0];
        PublishingModel *publishModel = resModel.product;
        
    if (indexPath.section == 0) {
        identifier = @"detailSave0";
        
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0x42566d);
        
        NSString *nameStrss;
        if ([publishModel.category integerValue] == 2) {
            nameStrss = @"清收";
        }else if ([publishModel.category integerValue] == 3){
            nameStrss = @"诉讼";
        }
        NSString *codea = [NSString stringWithFormat:@"%@产品编号:%@",nameStrss,publishModel.codeString];
        [cell.userNameButton setTitle:codea forState:0];
        [cell.userNameButton setTitleColor:UIColorFromRGB(0xcfd4e8) forState:0];
        cell.userNameButton.titleLabel.font = kFourFont;
        
        [cell.userActionButton setTitle:@"发布中" forState:0];
        [cell.userActionButton setTitleColor:kNavColor forState:0];
        cell.userActionButton.titleLabel.font = kBigFont;
        
        return cell;
        
    }
        //section == 2
    if (indexPath.row == 0) {
        identifier = @"applying20";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userNameButton.userInteractionEnabled = NO;
        cell.userActionButton.userInteractionEnabled = NO;
        
        [cell.userNameButton setTitle:@"产品信息" forState:0];
        [cell.userActionButton setTitle:@"查看全部  " forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        return cell;
    }
    
    //详情
    identifier = @"applying11";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
    cell.userNameButton.titleLabel.font = kFirstFont;
    [cell.userActionButton setTitleColor:kGrayColor forState:0];
    cell.userActionButton.titleLabel.font = kFirstFont;
    
    NSString *rowString1 = @"借款本金";
    NSString *rowString11 = [NSString stringWithFormat:@"%@万",publishModel.money];//具体借款本金
    NSString *rowString2 = @"费用类型";
    NSString *rowString3;//具体费用类型
    NSString *rowString33;//费用
    if ([publishModel.category integerValue] == 2) {
        if ([publishModel.agencycommissiontype integerValue] == 1) {
            rowString3 = @"服务佣金";
            rowString33 = [NSString stringWithFormat:@"%@%@",publishModel.agencycommission,@"%"];
        }else{
            rowString3 = @"固定费用";
            rowString33 = [NSString stringWithFormat:@"%@万",publishModel.agencycommission];
        }
    }else if ([publishModel.category integerValue] == 3){
        if ([publishModel.agencycommissiontype integerValue] == 1) {
            rowString3 = @"固定费用";
            rowString33 = [NSString stringWithFormat:@"%@万",publishModel.agencycommission];
        }else{
            rowString3 = @"代理费率";
            rowString33 = [NSString stringWithFormat:@"%@%@",publishModel.agencycommission,@"%"];
        }
    }
    
    NSString *rowString4 = @"债权类型";
    NSString *rowString44; //具体债权类型
    NSString *rowString5;
    NSString *rowString55;
    if ([publishModel.loan_type integerValue] == 1) {
        rowString44 = @"房产抵押";
        rowString5 = @"抵押物地址";
        rowString55 = publishModel.seatmortgage;
    }else if ([publishModel.loan_type integerValue] == 2) {
        rowString44 = @"应收帐款";
        rowString5 = [NSString stringWithFormat:@"%@万",publishModel.accountr];
        rowString55 = publishModel.seatmortgage;
    }else if ([publishModel.loan_type integerValue] == 3) {
        rowString44 = @"机动车抵押";
        rowString5 = @"机动车抵押";
        rowString55 = resModel.car;
    }else if ([publishModel.loan_type integerValue] == 4) {
        rowString44 = @"无抵押";
        rowString5 = @"1";
        rowString55 = @"1";
    }
    
    NSArray *rowLeftArray = @[rowString1,rowString2,rowString3,rowString4,rowString5];
    NSArray *rowRightArray = @[rowString11,rowString3,rowString33,rowString44,rowString55];
    
    [cell.userNameButton setTitle:rowLeftArray[indexPath.row-1] forState:0];
    [cell.userActionButton setTitle:rowRightArray[indexPath.row-1] forState:0];
    
    return cell;
    }
    return nil;
}

 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kBigPadding;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        AdditionMessageViewController *additionMessageVC = [[AdditionMessageViewController alloc] init];
        additionMessageVC.idString = self.idString;
        additionMessageVC.categoryString = self.categaryString;
        [self.navigationController pushViewController:additionMessageVC animated:YES];
    }
    
//    PublishingResponse *response = self.publishingDataArray[0];
//    PublishingModel *model = response.product;
//    
//    if (indexPath.section == 1) {
//        if ([model.loan_type isEqualToString:@"4"]) {
//            if (indexPath.row == 5) {
//            }
//        }else{
//            if (indexPath.row == 6) {
//                AdditionMessageViewController *additionMessageVC = [[AdditionMessageViewController alloc] init];
//                additionMessageVC.idString = model.idString;
//                additionMessageVC.categoryString = model.category;
//                [self.navigationController pushViewController:additionMessageVC animated:YES];
//            }
//        }
//    }
}

#pragma mark - method
- (void)getDetailMessages
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProdutsDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        [weakself.publishingDataArray addObject:response];
        [weakself.publishingTableView reloadData];  
    } andFailBlock:^(NSError *error){
        
    }];
}

- (void)showRecordList
{
    ApplyRecordsViewController *applyRecordsVC = [[ApplyRecordsViewController alloc] init];
    applyRecordsVC.idStr = self.idString;
    applyRecordsVC.categaryStr = self.categaryString;
    [self.navigationController pushViewController:applyRecordsVC animated:YES];
}

//编辑信息
- (void)editAllMessages
{
    if (self.publishingDataArray.count > 0) {
        PublishingResponse *response = self.publishingDataArray[0];
        PublishingModel *rModel = response.product;
        
        ReportSuitViewController *reportSuiVC = [[ReportSuitViewController alloc] init];
        reportSuiVC.categoryString = rModel.category;
        reportSuiVC.suResponse = response;
        reportSuiVC.tagString = @"2";
        UINavigationController *nsop = [[UINavigationController alloc] initWithRootViewController:reportSuiVC];
        [self presentViewController:nsop animated:YES completion:nil];
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
