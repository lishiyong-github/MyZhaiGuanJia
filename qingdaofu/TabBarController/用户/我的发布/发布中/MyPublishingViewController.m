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

#import "ReportFinanceViewController.h"  //发布融资
#import "ReportSuitViewController.h"  //发布催收，发布诉讼

#import "BaseCommitButton.h"

#import "MineUserCell.h"
#import "BidMessageCell.h"
#import "BidOneCell.h"

#import "PublishingModel.h"
#import "PublishingResponse.h"

@interface MyPublishingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *publishingTableView;
@property (nonatomic,strong) NSMutableArray *publishingDataArray;

@end

@implementation MyPublishingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"申请记录" style:UIBarButtonItemStylePlain target:self action:@selector(showRecordList)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self.view addSubview: self.publishingTableView];
    [self.view setNeedsUpdateConstraints];
    
    [self getDetailMessages];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.publishingTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)publishingTableView
{
    if (!_publishingTableView) {
        _publishingTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _publishingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _publishingTableView.delegate = self;
        _publishingTableView.dataSource = self;
        _publishingTableView.backgroundColor = kBackColor;
    }
    return _publishingTableView;
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
            return 6;
        }
            return 1;
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
        
        NSString *code = [NSString stringWithFormat:@"产品编号:%@",publishModel.codeString];
        [cell.userNameButton setTitle:code forState:0];
        [cell.userNameButton setTitleColor:UIColorFromRGB(0xcfd4e8) forState:0];
        
        /*0为待发布（保存未发布的）。 1为发布中（已发布的）。
         2为处理中（有人已接单发布方也已同意）。
         3为终止（只用发布方可以终止）。
         4为结案（双方都可以申请，一方申请一方同意*/
        if ([publishModel.progress_status intValue] == 0) {
            [cell.userActionButton setTitle:@"待发布" forState:0];
        }else if ([publishModel.progress_status intValue] == 1){
            [cell.userActionButton setTitle:@"发布中" forState:0];
        }else if ([publishModel.progress_status intValue] == 2){
            [cell.userActionButton setTitle:@"处理中" forState:0];
        }else if ([publishModel.progress_status intValue] == 3){
            [cell.userActionButton setTitle:@"终止" forState:0];
        }else if ([publishModel.progress_status intValue] == 4){
            [cell.userActionButton setTitle:@"结案" forState:0];
        }
        [cell.userActionButton setTitleColor:kNavColor forState:0];
        cell.userActionButton.titleLabel.font = kBigFont;
        
        return cell;
        
    }else if (indexPath.section == 1){
        if (indexPath.row < 5) {
            identifier = @"detailSave1";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSString *string22;
            NSString *string3;
            NSString *imageString3;
            NSString *string33;
            NSString *string4;
            NSString *imageString4;
            NSString *string44;
            if ([publishModel.category intValue] == 1) {//融资
                string22 = @"融资";
                if ([publishModel.rate_cat intValue] == 1) {
                    string3 = @"  借款利率(天)";
                }else if ([publishModel.rate_cat intValue] == 2){
                    string3 = @"  借款利率(月)";
                }
                imageString3 = @"conserve_interest_icon";
                string33 = publishModel.rate;
                string4 = @"  返点";
                imageString4 = @"conserve_rebate_icon";
                string44 = publishModel.rebate;
            }else if ([publishModel.category intValue] == 2){//清收
                string22 = @"清收";
                string3 = @"  代理费用(万)";
                imageString3 = @"conserve_fixed_icon";
                string33 = publishModel.agencycommission;
                string4 = @"  债权类型";
                imageString4 = @"conserve_rights_icon";
                if ([publishModel.loan_type intValue] == 1) {
                    string44 = @"房产抵押";
                }else if ([publishModel.loan_type intValue] == 2){
                    string44 = @"应收账款";
                }else if ([publishModel.loan_type intValue] == 3){
                    string44 = @"机动车抵押";
                }else if ([publishModel.loan_type intValue] == 4){
                    string44 = @"无抵押";
                }
            }else if ([publishModel.category intValue] == 3){//诉讼
                string22 = @"诉讼";
                if ([publishModel.agencycommissiontype intValue] == 1) {
                    string3 = @"  固定费用(万)";
                }else if ([publishModel.agencycommissiontype intValue] == 2){
                    string3 = @"  风险费率(%)";
                }
                imageString3 = @"conserve_fixed_icon";
                string33 = publishModel.agencycommission;
                string4 = @"  债权类型";
                imageString4 = @"conserve_rights_icon";
                if ([publishModel.loan_type intValue] == 1) {
                    string44 = @"房产抵押";
                }else if ([publishModel.loan_type intValue] == 2){
                    string44 = @"应收账款";
                }else if ([publishModel.loan_type intValue] == 3){
                    string44 = @"机动车抵押";
                }else if ([publishModel.loan_type intValue] == 4){
                    string44 = @"无抵押";
                }
            }
            
            NSArray *dataArray = @[@"|  基本信息",@"  投资类型",@"  借款本金(万)",string3,string4];
            NSArray *imageArray = @[@"",@"conserve_investment_icon",@"conserve_loan_icon",imageString3,imageString4];
            NSArray *detailArray = @[@"",string22,publishModel.money,string33,string44];
            
            [cell.userNameButton setTitle:dataArray[indexPath.row] forState:0];
            [cell.userNameButton setImage:[UIImage imageNamed:imageArray[indexPath.row]] forState:0];
            [cell.userActionButton setTitle:detailArray[indexPath.row] forState:0];
            
            if (indexPath.row == 0) {
                [cell.userNameButton setTitleColor:kBlueColor forState:0];
                
                if ([publishModel.progress_status intValue] < 2) {
                    [cell.userActionButton setTitle:@"编辑" forState:0];
                    [cell.userActionButton setTitleColor:kBlueColor forState:0];
                    
                    [cell.userActionButton addTarget:self action:@selector(editAllMessages) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            return cell;
        }
        
        identifier = @"detailSave2";
        BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.oneButton setTitle:@"查看补充信息" forState:0];
        [cell.oneButton setImage:[UIImage imageNamed:@"more"] forState:0];
        cell.oneButton.userInteractionEnabled = NO;
        return cell;
    }
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
    PublishingResponse *response = self.publishingDataArray[0];
    PublishingModel *model = response.product;
    
    if ((indexPath.section == 1) && (indexPath.row == 5)) {//补充信息
        AdditionMessageViewController *additionMessageVC = [[AdditionMessageViewController alloc] init];
        additionMessageVC.idString = model.idString;
        additionMessageVC.categoryString = model.category;
        [self.navigationController pushViewController:additionMessageVC animated:YES];
    }
}

#pragma mark - method
- (void)getDetailMessages
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){        
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        [self.publishingDataArray addObject:response];
        [self.publishingTableView reloadData];
        
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
        
        if ([rModel.category integerValue] == 1) {//融资
            ReportFinanceViewController *reportFinanceVC = [[ReportFinanceViewController alloc] init];
            reportFinanceVC.fiModel = rModel;
            [self.navigationController pushViewController:reportFinanceVC animated:YES];
        }else{//清收，诉讼
            ReportSuitViewController *reportSuiVC = [[ReportSuitViewController alloc] init];
            reportSuiVC.categoryString = rModel.category;
            reportSuiVC.suResponse = response;
            [self.navigationController pushViewController:reportSuiVC animated:YES];
        }
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
