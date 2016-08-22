//
//  MyApplyingViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyApplyingViewController.h"
#import "CheckDetailPublishViewController.h"  //查看发布方
#import "AdditionMessageViewController.h"  //查看更多
#import "AgreementViewController.h"

#import "MineUserCell.h"
#import "BidMessageCell.h"
#import "BidOneCell.h"

#import "PublishingResponse.h"
#import "PublishingModel.h"

@interface MyApplyingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *myApplyingTableView;
@property (nonatomic,strong) NSMutableArray *myApplyArray;


@property (nonatomic,strong) NSString *loanTypeString1;  //债权类型
@property (nonatomic,strong) NSString *loanTypeString2;  //债权类型内容
@property (nonatomic,strong) NSString *loanTypeImage;//债权类型图片

@end

@implementation MyApplyingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
//    if (self.pidString) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看发布方" style:UIBarButtonItemStylePlain target:self action:@selector(checkDetails)];
//    }
//    
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self.view addSubview:self.myApplyingTableView];
    [self.view setNeedsUpdateConstraints];
    
    [self getDetailMessageOfApplying];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.myApplyingTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - setter and getter
- (UITableView *)myApplyingTableView
{
    if (!_myApplyingTableView) {
        _myApplyingTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _myApplyingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _myApplyingTableView.delegate = self;
        _myApplyingTableView.dataSource = self;
        _myApplyingTableView.separatorColor = kSeparateColor;
        _myApplyingTableView.backgroundColor = kBackColor;
    }
    return _myApplyingTableView;
}

- (NSMutableArray *)myApplyArray
{
    if (!_myApplyArray) {
        _myApplyArray = [NSMutableArray array];
    }
    return _myApplyArray;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.myApplyArray.count > 0) {
        return 3;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.myApplyArray.count > 0) {
        if (section == 2) {
            PublishingResponse *response = self.myApplyArray[0];
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
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    PublishingResponse *responseModel = self.myApplyArray[0];
    PublishingModel *applyModel = responseModel.product;
    
    if (indexPath.section == 0) {
        identifier = @"applying0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0x42566d);
        
//        = [NSString stringWithFormat:@"产品编号：%@",applyModel.codeString];
        NSString *nameStrss;
        if ([applyModel.category integerValue] == 2) {
            nameStrss = @"清收";
        }else if ([applyModel.category integerValue] == 3){
            nameStrss = @"诉讼";
        }
        NSString *nameStr = [NSString stringWithFormat:@"%@%@",nameStrss,applyModel.codeString];

        [cell.userNameButton setTitle:nameStr forState:0];
        [cell.userNameButton setTitleColor:UIColorFromRGB(0xcfd4e8) forState:0];
        cell.userNameButton.titleLabel.font = kFirstFont;

        [cell.userActionButton setTitle:@"申请中" forState:0];
        [cell.userActionButton setTitleColor:kNavColor forState:0];
        cell.userActionButton.titleLabel.font = kBigFont;
        
        return cell;
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row < 5) {
            identifier = @"applying1";
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
            if ([applyModel.category intValue] == 1) {//融资
                string22 = @"融资";
                if ([applyModel.rate_cat intValue] == 1) {
                    string3 = @"  借款利率(%/天)";
                }else if ([applyModel.rate_cat intValue] == 2){
                    string3 = @"  借款利率(%/月)";
                }
                imageString3 = @"conserve_interest_icon";
                string33 = [NSString getValidStringFromString:applyModel.rate toString:@"0"];
                string4 = @"  返点(%)";
                imageString4 = @"conserve_rebate_icon";
                string44 = [NSString getValidStringFromString:applyModel.rebate toString:@"0"];
                
                _loanTypeString1 = @"  抵押物地址";
                _loanTypeString2 = [NSString getValidStringFromString:applyModel.seatmortgage toString:@"无抵押物地址"];
                _loanTypeImage = @"conserve_seat_icon";
                
            }else if ([applyModel.category intValue] == 2){//清收
                string22 = @"清收";
                if ([applyModel.agencycommissiontype intValue] == 1) {
                    string3 = @"  服务佣金(%)";
                    imageString3 =  @"conserve_rights_icon";
                }else if ([applyModel.agencycommissiontype intValue] == 2){
                    string3 = @"  固定费用(万元)";
                    imageString3 =  @"conserve_fixed_icons";
                }
                string33 = [NSString getValidStringFromString:applyModel.agencycommission toString:@"0"];
                string4 = @"  债权类型";
                imageString4 = @"conserve_loantype_icon";
                if ([applyModel.loan_type intValue] == 1) {
                    string44 = @"房产抵押";
                    _loanTypeString1 = [NSString stringWithFormat:@"  %@",string44];
                    _loanTypeString2 = [NSString getValidStringFromString:applyModel.seatmortgage toString:@"无抵押物地址"];
                    _loanTypeImage = @"conserve_seat_icon";

                }else if ([applyModel.loan_type intValue] == 2){
                    string44 = @"应收账款";
                    _loanTypeString1 = [NSString stringWithFormat:@"  %@(万元)",string44];
                    _loanTypeString2 = [NSString getValidStringFromString:applyModel.accountr toString:@"0"];
                    _loanTypeImage = @"conserve_account_icon";
                }else if ([applyModel.loan_type intValue] == 3){
                    string44 = @"机动车抵押";
                    _loanTypeString1 = [NSString stringWithFormat:@"  %@",string44];
                    NSString *carS2 = [NSString getValidStringFromString:responseModel.car];
                    NSString *licenseS2 = [NSString getValidStringFromString:responseModel.license];
                    _loanTypeString2 = [NSString stringWithFormat:@"%@/%@",carS2,licenseS2];
                    _loanTypeImage = @"conserve_car_icon";
                }else{
                    string44 = @"无抵押";
                }
            }else if ([applyModel.category intValue] == 3){//诉讼
                string22 = @"诉讼";
                if ([applyModel.agencycommissiontype intValue] == 1) {
                    string3 = @"  固定费用(万元)";
                    imageString3 =  @"conserve_fixed_icons";
                }else if ([applyModel.agencycommissiontype intValue] == 2){
                    string3 = @"  风险费率(%)";
                    imageString3 =  @"conserve_fixed_icon";
                }
                string33 = [NSString getValidStringFromString:applyModel.agencycommission toString:@"0"];
                string4 = @"  债权类型";
                imageString4 = @"conserve_loantype_icon";
                if ([applyModel.loan_type intValue] == 1) {
                    string44 = @"房产抵押";
                    _loanTypeString1 = [NSString stringWithFormat:@"  %@",string44];
                    _loanTypeString2 = [NSString getValidStringFromString:applyModel.seatmortgage toString:@"无抵押物地址"];
                    _loanTypeImage = @"conserve_seat_icon";

                }else if ([applyModel.loan_type intValue] == 2){
                    string44 = @"应收账款";
                    _loanTypeString1 = [NSString stringWithFormat:@"  %@(万元)",string44];
                    _loanTypeString2 = [NSString getValidStringFromString:applyModel.accountr toString:@"0"];
                    _loanTypeImage = @"conserve_account_icon";
                }else if ([applyModel.loan_type intValue] == 3){
                    string44 = @"机动车抵押";
                    _loanTypeString1 = [NSString stringWithFormat:@"  %@",string44];
                    NSString *carS3 = [NSString getValidStringFromString:responseModel.car];
                    NSString *licenseS3 = [NSString getValidStringFromString:responseModel.license];
                    _loanTypeString2 = [NSString stringWithFormat:@"%@/%@",carS3,licenseS3];
                    _loanTypeImage = @"conserve_car_icon";
                }else{
                    string44 = @"无抵押";
                }
            }
            
            NSString *moneyS1 = [NSString getValidStringFromString:applyModel.money toString:@"0"];
            NSArray *dataArray = @[@"|  基本信息",@"  产品类型",@"  借款本金(万元)",string3,string4];
            NSArray *imageArray = @[@"",@"conserve_investment_icon",@"conserve_loan_icon",imageString3,imageString4];
            NSArray *detailArray = @[@"",string22,moneyS1,string33,string44];
            
            [cell.userNameButton setTitle:dataArray[indexPath.row] forState:0];
            [cell.userNameButton setImage:[UIImage imageNamed:imageArray[indexPath.row]] forState:0];
            [cell.userActionButton setTitle:detailArray[indexPath.row] forState:0];
            
            if (indexPath.row == 0) {
                [cell.userNameButton setTitleColor:kBlueColor forState:0];
            }
            
            return cell;
        }
        
        if ([applyModel.loan_type isEqualToString:@"4"]) {//无抵押
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
    if (indexPath.section == 1) {
        
        PublishingResponse *resModel = self.myApplyArray[0];
        PublishingModel *dealModel = resModel.product;
        if ([dealModel.loan_type isEqualToString:@"4"]) {
            if (indexPath.row == 5) {
                AdditionMessageViewController *additionMessageVC = [[AdditionMessageViewController alloc] init];
                additionMessageVC.idString = dealModel.idString;
                additionMessageVC.categoryString = dealModel.category;
                [self.navigationController pushViewController:additionMessageVC animated:YES];
            }
        }else{
            if (indexPath.row == 6) {
                AdditionMessageViewController *additionMessageVC = [[AdditionMessageViewController alloc] init];
                additionMessageVC.idString = dealModel.idString;
                additionMessageVC.categoryString = dealModel.category;
                [self.navigationController pushViewController:additionMessageVC animated:YES];
            }
        }
    }
}

#pragma mark - method
//查看发布方
- (void)checkDetails
{
    PublishingResponse *responde;
    if (self.myApplyArray.count > 0) {
        responde = self.myApplyArray[0];
    }
    
    if ([responde.state isEqualToString:@"1"]) {
        CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
        checkDetailPublishVC.idString = self.idString;
        checkDetailPublishVC.categoryString = self.categaryString;
        checkDetailPublishVC.pidString = self.pidString;
        checkDetailPublishVC.typeString = @"发布方";
        [self.navigationController pushViewController:checkDetailPublishVC animated:YES];
    }else{
        [self showHint:@"发布方未认证，不能查看相关信息"];
    }
}

- (void)getDetailMessageOfApplying
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProdutsDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        [weakself.myApplyArray addObject:response];
        [weakself.myApplyingTableView reloadData];
        
    } andFailBlock:^(NSError *error){
        
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
