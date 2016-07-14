//
//  MyDetailSaveViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyDetailSaveViewController.h"
#import "AdditionMessageViewController.h"

#import "ReportFinanceViewController.h"   //发布融资
#import "ReportCollectViewController.h"  //发布清收
#import "ReportSuitViewController.h"  //发布诉讼

#import "MyReleaseViewController.h"   //我的发布

#import "BaseCommitButton.h"

#import "MineUserCell.h"
#import "BidMessageCell.h"
#import "BidOneCell.h"

#import "PublishingResponse.h"
#import "PublishingModel.h"

@interface MyDetailSaveViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *detailSaveTableView;
@property (nonatomic,strong) BaseCommitButton *saveCommitView;

@property (nonatomic,strong) NSMutableArray *saveDetailArray;
@property (nonatomic,strong) NSString *loanTypeString1;  //债权类型
@property (nonatomic,strong) NSString *loanTypeString2;  //债权类型内容
@property (nonatomic,strong) NSString *loanTypeImage;//债权类型图片

@end

@implementation MyDetailSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.detailSaveTableView];
    [self.view addSubview:self.saveCommitView];
    
    [self.view setNeedsUpdateConstraints];
    
    [self getSaveDetailMessage];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.detailSaveTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.detailSaveTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.saveCommitView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.saveCommitView autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)detailSaveTableView
{
    if (!_detailSaveTableView) {

        _detailSaveTableView.translatesAutoresizingMaskIntoConstraints = YES;
        _detailSaveTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _detailSaveTableView.delegate = self;
        _detailSaveTableView.dataSource = self;
        _detailSaveTableView.tableFooterView = [[UIView alloc] init];
        _detailSaveTableView.backgroundColor = kBackColor;
    }
    return _detailSaveTableView;
}

- (BaseCommitButton *)saveCommitView
{
    if (!_saveCommitView) {
        _saveCommitView = [BaseCommitButton newAutoLayoutView];
        [_saveCommitView setTitle:@"立即发布" forState:0];
        
        QDFWeakSelf;
        [_saveCommitView addAction:^(UIButton *btn) {
            [weakself goToPublish];
        }];
    }
    return _saveCommitView;
}

- (NSMutableArray *)saveDetailArray
{
    if (!_saveDetailArray) {
        _saveDetailArray = [NSMutableArray array];
    }
    return _saveDetailArray;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.saveDetailArray.count > 0) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.saveDetailArray.count > 0) {
        
        if (section == 1) {
            PublishingResponse *response = self.saveDetailArray[0];
            if ([response.product.loan_type isEqualToString:@"4"]) {
                return 6;
            }
            return 7;
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
    
    PublishingResponse *response = self.saveDetailArray[0];
    PublishingModel *saveModel = response.product;
    
    if (indexPath.section == 0) {
        identifier = @"detailSave0";
        
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0x42566d);
        
        NSString *codeStr = [NSString stringWithFormat:@"产品编号:%@",saveModel.codeString];
        [cell.userNameButton setTitle:codeStr forState:0];
        cell.userNameButton.titleLabel.font = kFirstFont;
        [cell.userNameButton setTitleColor:UIColorFromRGB(0xcfd4e8) forState:0];

        [cell.userActionButton setTitle:@"待发布" forState:0];
        [cell.userActionButton setTitleColor:kNavColor forState:0];
        cell.userActionButton.titleLabel.font = kBigFont;
        
        return cell;
    }
    
    if (indexPath.row < 5) {
        identifier = @"detailSave1";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userActionButton.titleLabel.font = kSecondFont;
        
        NSString *string22;
        NSString *string3;
        NSString *imageString3;
        NSString *string33;
        NSString *string4;
        NSString *imageString4;
        NSString *string44;
        if ([saveModel.category intValue] == 1) {//融资
            string22 = @"融资";
            if ([saveModel.rate_cat intValue] == 1) {
                string3 = @"  借款利率(%/天)";
            }else if ([saveModel.rate_cat intValue] == 2){
                string3 = @"  借款利率(%/月)";
            }
            imageString3 = @"conserve_interest_icon";
            string33 = saveModel.rate;
            string4 = @"  返点(%)";
            imageString4 = @"conserve_rebate_icon";
            string44 = saveModel.rebate;
            
            _loanTypeString1 = @"  抵押物地址";
            _loanTypeString2 = [NSString stringWithFormat:@"%@",saveModel.seatmortgage];
            _loanTypeImage = @"conserve_seat_icon";
        }else if ([saveModel.category intValue] == 2){//清收
            string22 = @"清收";
            if ([saveModel.agencycommissiontype intValue] == 1) {
                string3 = @"  提成比例(%)";
                imageString3 =  @"conserve_rights_icon";
            }else if ([saveModel.agencycommissiontype intValue] == 2){
                string3 = @"  固定费用(万)";
                imageString3 =  @"conserve_fixed_icons";
            }
            string33 = saveModel.agencycommission;
            string4 = @"  债权类型";
            imageString4 = @"conserve_loantype_icon";
            if ([saveModel.loan_type intValue] == 1) {
                string44 = @"房产抵押";
                _loanTypeString1 = [NSString stringWithFormat:@"  %@",string44];
                _loanTypeString2 = [NSString stringWithFormat:@"%@",saveModel.seatmortgage];
                _loanTypeImage = @"conserve_seat_icon";
            }else if ([saveModel.loan_type intValue] == 2){
                string44 = @"应收账款";
                _loanTypeString1 = [NSString stringWithFormat:@"  %@(万元)",string44];
                _loanTypeString2 = saveModel.accountr;
                _loanTypeImage = @"conserve_account_icon";
            }else if ([saveModel.loan_type intValue] == 3){
                string44 = @"机动车抵押";
                _loanTypeString1 = [NSString stringWithFormat:@"  %@",string44];
                _loanTypeString2 = [NSString stringWithFormat:@"%@/%@",response.car,response.license];
                _loanTypeImage = @"conserve_car_icon";
            }else if ([saveModel.loan_type intValue] == 4){
                string44 = @"  无抵押";
            }
            
        }else if ([saveModel.category intValue] == 3){//诉讼
            string22 = @"诉讼";
            if ([saveModel.agencycommissiontype intValue] == 1) {
                string3 = @"  固定费用(万元)";
                imageString3 =  @"conserve_fixed_icons";
            }else if ([saveModel.agencycommissiontype intValue] == 2){
                string3 = @"  风险费率(%)";
                imageString3 =  @"conserve_fixed_icon";
            }
            string33 = saveModel.agencycommission;
            string4 = @"  债权类型";
            imageString4 = @"conserve_loantype_icon";
            if ([saveModel.loan_type intValue] == 1) {
                string44 = @"房产抵押";
                _loanTypeString1 = [NSString stringWithFormat:@"  %@",string44];
                _loanTypeString2 = [NSString stringWithFormat:@"%@",saveModel.seatmortgage];
                _loanTypeImage = @"conserve_seat_icon";
            }else if ([saveModel.loan_type intValue] == 2){
                string44 = @"应收账款";
                _loanTypeString1 = [NSString stringWithFormat:@"  %@(万元)",string44];
                _loanTypeString2 = saveModel.accountr;
                _loanTypeImage = @"conserve_account_icon";
            }else if ([saveModel.loan_type intValue] == 3){
                string44 = @"机动车抵押";
                _loanTypeString1 = [NSString stringWithFormat:@"  %@",string44];
                _loanTypeString2 = [NSString stringWithFormat:@"%@/%@",response.car,response.license];
                _loanTypeImage = @"conserve_car_icon";
            }else if ([saveModel.loan_type intValue] == 4){
                string44 = @"无抵押";
            }
        }
        
        NSArray *dataArray = @[@"|  基本信息",@"  产品类型",@"  借款本金(万元)",string3,string4];
        NSArray *imageArray = @[@"",@"conserve_investment_icon",@"conserve_loan_icon",imageString3,imageString4];
        NSArray *detailArray = @[@"",string22,saveModel.money,string33,string44];
        
        [cell.userNameButton setTitle:dataArray[indexPath.row] forState:0];
        [cell.userNameButton setImage:[UIImage imageNamed:imageArray[indexPath.row]] forState:0];
        [cell.userActionButton setTitle:detailArray[indexPath.row] forState:0];
        
        if (indexPath.row == 0) {
            [cell.userNameButton setTitleColor:kBlueColor forState:0];
            [cell.userActionButton setTitle:@"编辑" forState:0];
            [cell.userActionButton setTitleColor:kBlueColor forState:0];
            
            QDFWeakSelf;
            [cell.userActionButton addAction:^(UIButton *btn) {
                if ([self.categaryString integerValue] == 1) {//融资
                    ReportFinanceViewController *reportFinanceVC = [[ReportFinanceViewController alloc] init];
                    reportFinanceVC.fiModel = saveModel;
                    [weakself.navigationController pushViewController:reportFinanceVC animated:YES];
                }else{
                    ReportSuitViewController *reportSuitVC = [[ReportSuitViewController alloc] init];
                    reportSuitVC.suResponse = response;
                    reportSuitVC.categoryString = self.categaryString;
                    reportSuitVC.tagString = @"2";
                    [weakself.navigationController pushViewController:reportSuitVC animated:YES];
                }
                
            }];
            
        }
        return cell;
    }
    
    if ([saveModel.loan_type isEqualToString:@"4"]) {//无抵押
        //补充信息
        identifier = @"detailSave4";
        BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.oneButton setTitle:@"查看补充信息" forState:0];
        [cell.oneButton setImage:[UIImage imageNamed:@"more"] forState:0];
        cell.oneButton.userInteractionEnabled = NO;
        
        return cell;
    }else{
        if (indexPath.row == 5) {
            identifier = @"detailSave2";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userActionButton.titleLabel.font = kSecondFont;
            [cell.userActionButton autoSetDimension:ALDimensionWidth toSize:kScreenWidth-150];

            [cell.userNameButton setTitle:_loanTypeString1 forState:0];
            [cell.userNameButton setImage:[UIImage imageNamed:_loanTypeImage] forState:0];
            [cell.userActionButton setTitle:_loanTypeString2 forState:0];
            
            return cell;
        }else{
            //补充信息
            identifier = @"detailSave3";
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
    if (self.saveDetailArray.count > 0) {
        PublishingResponse *responseModel = self.saveDetailArray[0];
        if ([responseModel.product.loan_type isEqualToString:@"4"]) {
            if ((indexPath.section == 1) && (indexPath.row == 5)) {//查看补充信息
                AdditionMessageViewController *additionMessage = [[AdditionMessageViewController alloc] init];
                additionMessage.idString = self.idString;
                additionMessage.categoryString = self.categaryString;
                [self.navigationController pushViewController:additionMessage animated:YES];
            }
        }else{
            if ((indexPath.section == 1) && (indexPath.row == 6)) {//查看补充信息
                AdditionMessageViewController *additionMessage = [[AdditionMessageViewController alloc] init];
                additionMessage.idString = self.idString;
                additionMessage.categoryString = self.categaryString;
                [self.navigationController pushViewController:additionMessage animated:YES];
            }
        }
    }
}

#pragma mark - method
- (void)getSaveDetailMessage
{
    NSString *sDetailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProdutsDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:sDetailString params:params successBlock:^(id responseObject){
        
        PublishingResponse *responseModel = [PublishingResponse objectWithKeyValues:responseObject];
        
        [weakself.saveDetailArray addObject:responseModel];
        [weakself.detailSaveTableView reloadData];
        
    } andFailBlock:^(NSError *error){
        
    }];
}

//发布
- (void)goToPublish
{
    PublishingResponse *response;
    PublishingModel *saveModel;
    if (self.saveDetailArray.count > 0) {
        response = self.saveDetailArray[0];
        saveModel = response.product;
    }
    
    NSString *reportString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMySavePublishString];
    
    NSDictionary *params = @{@"id" : saveModel.idString,
                             @"category" : saveModel.category,
                             @"token" : [self getValidateToken]
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:reportString params:params successBlock:^(id responseObject) {
        BaseModel *model = [BaseModel objectWithKeyValues:responseObject];
        
        if ([model.code isEqualToString:@"0000"]) {
            [weakself showHint:@"发布成功"];
            
            UINavigationController *nav = weakself.navigationController;
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
            
            MyReleaseViewController *myReleaseVC = [[MyReleaseViewController alloc] init];
            myReleaseVC.hidesBottomBarWhenPushed = YES;
            myReleaseVC.progreStatus = @"1";
            [nav pushViewController:myReleaseVC animated:NO];
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
