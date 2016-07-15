//
//  MyDealingViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/6.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyDealingViewController.h"

#import "CheckDetailPublishViewController.h"  //查看发布方
#import "PaceViewController.h"    //查看进度
#import "AdditionMessageViewController.h"  //补充信息
#import "AgreementViewController.h"

#import "EvaTopSwitchView.h"
#import "BaseCommitButton.h"

#import "MineUserCell.h"
#import "BidMessageCell.h"
#import "BidOneCell.h"

#import "PublishingModel.h"
#import "PublishingResponse.h"

@interface MyDealingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *dealingTableView;
@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) EvaTopSwitchView *dealFootView;
@property (nonatomic,strong) BaseCommitButton *dealCommitButton;

@property (nonatomic,strong) NSMutableArray *dealingDataList;


@property (nonatomic,strong) NSString *loanTypeString1;  //债权类型
@property (nonatomic,strong) NSString *loanTypeString2;  //债权类型内容
@property (nonatomic,strong) NSString *loanTypeImage;//债权类型图片

@end

@implementation MyDealingViewController

- (void)viewWillAppear:(BOOL)animated
{
     [self getDealingMessage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    if (self.pidString) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看接单方" style:UIBarButtonItemStylePlain target:self action:@selector(checkPublishUserDetail)];
    }
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self.view addSubview: self.dealingTableView];
    [self.view addSubview:self.dealFootView];
    [self.view addSubview:self.dealCommitButton];
    [self.dealCommitButton setHidden:YES];
    [self.dealFootView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.dealingTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.dealingTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.dealFootView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.dealFootView autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        [self.dealCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.dealCommitButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)dealingTableView
{
    if (!_dealingTableView) {
        _dealingTableView.translatesAutoresizingMaskIntoConstraints = YES;
        _dealingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _dealingTableView.delegate = self;
        _dealingTableView.dataSource = self;
        _dealingTableView.backgroundColor = kBackColor;
    }
    return _dealingTableView;
}

- (EvaTopSwitchView *)dealFootView
{
    if (!_dealFootView) {
        _dealFootView = [EvaTopSwitchView newAutoLayoutView];
        _dealFootView.heightConstraint.constant = kTabBarHeight;
        _dealFootView.backgroundColor = kNavColor;
        [_dealFootView.blueLabel setHidden:YES];
        [_dealFootView.longLineLabel setHidden:YES];
        
        [_dealFootView.getbutton setTitleColor:kBlueColor forState:0];
        [_dealFootView.getbutton setTitle:@" 终止" forState:0];
        [_dealFootView.getbutton setImage:[UIImage imageNamed:@"stop"] forState:0];
        
        [_dealFootView.sendButton setTitleColor:kBlueColor forState:0];
        [_dealFootView.sendButton setTitle:@" 申请结案" forState:0];
        [_dealFootView.sendButton setImage:[UIImage imageNamed:@"apply"] forState:0];
    }
    return _dealFootView;
}

- (BaseCommitButton *)dealCommitButton
{
    if (!_dealCommitButton) {
        _dealCommitButton = [BaseCommitButton newAutoLayoutView];
    }
    return _dealCommitButton;
}

- (NSMutableArray *)dealingDataList
{
    if (!_dealingDataList) {
        _dealingDataList = [NSMutableArray array];
    }
    return _dealingDataList;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dealingDataList.count > 0) {
        return 4;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dealingDataList.count > 0) {
        if (section == 1){
            PublishingResponse *response = self.dealingDataList[0];
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
    if (self.dealingDataList.count > 0) {
        PublishingResponse *resModel = self.dealingDataList[0];
        PublishingModel *dealModel = resModel.product;
        
        if (indexPath.section == 0) {
            identifier = @"dealing0";
            
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = UIColorFromRGB(0x42566d);
            
            NSString *code = [NSString stringWithFormat:@"产品编号:%@",dealModel.codeString];
            [cell.userNameButton setTitle:code forState:0];
            [cell.userNameButton setTitleColor:UIColorFromRGB(0xcfd4e8) forState:0];
            
            /*0为待发布（保存未发布的）。 1为发布中（已发布的）。
             2为处理中（有人已接单发布方也已同意）。
             3为终止（只用发布方可以终止）。
             4为结案（双方都可以申请，一方申请一方同意*/
            if ([dealModel.progress_status intValue] == 0) {
                [cell.userActionButton setTitle:@"待发布" forState:0];
            }else if ([dealModel.progress_status intValue] == 1){
                [cell.userActionButton setTitle:@"发布中" forState:0];
            }else if ([dealModel.progress_status intValue] == 2){
                [cell.userActionButton setTitle:@"处理中" forState:0];
            }else if ([dealModel.progress_status intValue] == 3){
                [cell.userActionButton setTitle:@"终止" forState:0];
            }else if ([dealModel.progress_status intValue] == 4){
                [cell.userActionButton setTitle:@"结案" forState:0];
            }
            [cell.userActionButton setTitleColor:kNavColor forState:0];
            cell.userActionButton.titleLabel.font = kBigFont;
            
            return cell;
            
        }else if (indexPath.section == 1){
            if (indexPath.row < 5) {
                identifier = @"dealing1";
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
                if ([dealModel.category intValue] == 1) {//融资
                    string22 = @"融资";
                    if ([dealModel.rate_cat intValue] == 1) {
                        string3 = @"  借款利率(%/天)";
                    }else if ([dealModel.rate_cat intValue] == 2){
                        string3 = @"  借款利率(%/月)";
                    }
                    imageString3 = @"conserve_interest_icon";
                    string33 = dealModel.rate;
                    string4 = @"  返点(%)";
                    imageString4 = @"conserve_rebate_icon";
                    string44 = dealModel.rebate;
                    
                    _loanTypeString1 = @"  抵押物地址";
                    _loanTypeString2 = [NSString stringWithFormat:@"%@",dealModel.seatmortgage];
                    _loanTypeImage = @"conserve_seat_icon";
                    
                }else if ([dealModel.category intValue] == 2){//清收
                    string22 = @"清收";
                    if ([dealModel.agencycommissiontype intValue] == 1) {
                        string3 = @"  提成比例(%)";
                        imageString3 =  @"conserve_rights_icon";
                    }else if ([dealModel.agencycommissiontype intValue] == 2){
                        string3 = @"  固定费用(万元)";
                        imageString3 =  @"conserve_fixed_icons";
                    }
                    string33 = dealModel.agencycommission;
                    string4 = @"  债权类型";
                    imageString4 = @"conserve_loantype_icon";
                    if ([dealModel.loan_type intValue] == 1) {
                        string44 = @"房产抵押";
                        _loanTypeString1 = [NSString stringWithFormat:@"  %@",string44];
                        _loanTypeString2 = [NSString stringWithFormat:@"%@",dealModel.seatmortgage];
                        _loanTypeImage = @"conserve_seat_icon";

                    }else if ([dealModel.loan_type intValue] == 2){
                        string44 = @"应收账款";
                        _loanTypeString1 = [NSString stringWithFormat:@"  %@(万元)",string44];
                        _loanTypeString2 = dealModel.accountr;
                        _loanTypeImage = @"conserve_account_icon";
                        
                    }else if ([dealModel.loan_type intValue] == 3){
                        string44 = @"机动车抵押";
                        _loanTypeString1 = [NSString stringWithFormat:@"  %@",string44];
                        _loanTypeString2 = [NSString stringWithFormat:@"%@/%@",resModel.car,resModel.license];
                        _loanTypeImage = @"conserve_car_icon";
                        
                    }else if ([dealModel.loan_type intValue] == 4){
                        string44 = @"无抵押";
                    }
                }else if ([dealModel.category intValue] == 3){//诉讼
                    string22 = @"诉讼";
                    if ([dealModel.agencycommissiontype intValue] == 1) {
                        string3 = @"  固定费用(万元)";
                        imageString3 =  @"conserve_fixed_icons";

                    }else if ([dealModel.agencycommissiontype intValue] == 2){
                        string3 = @"  风险费率(%)";
                        imageString3 =  @"conserve_fixed_icon";
                    }
                    imageString3 = @"conserve_fixed_icon";
                    string33 = dealModel.agencycommission;
                    string4 = @"  债权类型";
                    imageString4 = @"conserve_loantype_icon";
                    if ([dealModel.loan_type intValue] == 1) {
                        string44 = @"房产抵押";
                        _loanTypeString1 = [NSString stringWithFormat:@"  %@",string44];
                        _loanTypeString2 = [NSString stringWithFormat:@"%@",dealModel.seatmortgage];
                        _loanTypeImage = @"conserve_seat_icon";

                    }else if ([dealModel.loan_type intValue] == 2){
                        string44 = @"应收账款";
                        _loanTypeString1 = [NSString stringWithFormat:@"  %@(万元)",string44];
                        _loanTypeString2 = dealModel.accountr;
                        _loanTypeImage = @"conserve_account_icon";

                    }else if ([dealModel.loan_type intValue] == 3){
                        string44 = @"机动车抵押";
                        _loanTypeString1 = [NSString stringWithFormat:@"  %@",string44];
                        _loanTypeString2 = [NSString stringWithFormat:@"%@/%@",resModel.car,resModel.license];
                        _loanTypeImage = @"conserve_car_icon";
                        
                    }else if ([dealModel.loan_type intValue] == 4){
                        string44 = @"无抵押";
                    }
                }
                
                NSArray *dataArray = @[@"|  基本信息",@"  产品类型",@"  借款本金(万元)",string3,string4];
                NSArray *imageArray = @[@"",@"conserve_investment_icon",@"conserve_loan_icon",imageString3,imageString4];
                NSArray *detailArray = @[@"",string22,dealModel.money,string33,string44];
                
                [cell.userNameButton setTitle:dataArray[indexPath.row] forState:0];
                [cell.userNameButton setImage:[UIImage imageNamed:imageArray[indexPath.row]] forState:0];
                [cell.userActionButton setTitle:detailArray[indexPath.row] forState:0];
                
                if (indexPath.row == 0) {
                    [cell.userNameButton setTitleColor:kBlueColor forState:0];
                }
                
                return cell;
            }
            
            if ([dealModel.loan_type isEqualToString:@"4"]) {//无抵押
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
        }else{//服务协议，进度详情
            identifier = @"dealing23";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSArray *pArray = @[@"|  服务协议",@"|  查看进度"];
            [cell.userNameButton setTitle:pArray[indexPath.section-2] forState:0];
            [cell.userNameButton setTitleColor:kBlueColor forState:0];
            [cell.userActionButton setTitle:@"点击查看" forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            cell.userActionButton.userInteractionEnabled = NO;
            
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
    PublishingResponse *resModel = self.dealingDataList[0];
    PublishingModel *dealModel = resModel.product;
    
    if ((indexPath.section == 1) && (indexPath.row == 5)) {//补充信息
        AdditionMessageViewController *additionMessageVC = [[AdditionMessageViewController alloc] init];
        additionMessageVC.categoryString = dealModel.category;
        additionMessageVC.idString = dealModel.idString;
        [self.navigationController pushViewController:additionMessageVC animated:YES];
    }else if (indexPath.section == 2) {//协议
        AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
        agreementVC.idString = dealModel.idString;
        agreementVC.categoryString = dealModel.category;
        agreementVC.flagString = @"0";
        [self.navigationController pushViewController:agreementVC animated:YES];
    }else if (indexPath.section == 3) {//查看进度
        PaceViewController *paceVC = [[PaceViewController alloc] init];
        paceVC.idString = dealModel.idString;
        paceVC.categoryString = dealModel.category;
        [self.navigationController pushViewController:paceVC animated:YES];
    }
}

#pragma mark - method
- (void)checkPublishUserDetail
{
    CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
    checkDetailPublishVC.idString = self.idString;
    checkDetailPublishVC.categoryString = self.categaryString;
    checkDetailPublishVC.pidString = self.pidString;
    checkDetailPublishVC.typeString = @"接单方";
    checkDetailPublishVC.typeDegreeString = @"处理中";
    [self.navigationController pushViewController:checkDetailPublishVC animated:YES];
}

- (void)getDealingMessage
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProdutsDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        
        [weakself.dealingDataList addObject:response];
        [weakself.dealingTableView reloadData];
        
        if ([response.product.progress_status integerValue] == 2 && [response.uidString isEqualToString:response.product.uidInner]) {
            if ([response.product.applyclose integerValue] == 0) {//终止／申请结案
                [weakself.dealCommitButton setHidden:YES];
                [weakself.dealFootView setHidden:NO];
                
                QDFWeakSelf;
                [_dealFootView setDidSelectedButton:^(NSInteger tag) {
                    NSString *messages;
                    if (tag == 33) {//终止
                        messages = @"确认终止?";
                    }else{//申请结案
                        messages = @"确认申请结案?";
                    }
                    [weakself showAlertRemindWithTitle:messages withTag:tag];
                }];
            }else if ([response.product.applyclose integerValue] == 4 && ![response.product.applyclosefrom isEqualToString:response.product.uidInner]){
                [weakself.dealFootView setHidden:YES];
                [weakself.dealCommitButton setHidden:NO];
                [weakself.dealCommitButton setTitle:@"申请同意结案" forState:0];
                [weakself.dealCommitButton addAction:^(UIButton *btn) {
                    [weakself endProductWithStatusString:@"4"];
                }];
            }else{
                [weakself.dealFootView setHidden:YES];
                [weakself.dealCommitButton setHidden:NO];
                [weakself.dealCommitButton setTitle:@"结案申请中" forState:0];
                [weakself.dealCommitButton setBackgroundColor:kSelectedColor];
                [weakself.dealCommitButton setTitleColor:kBlackColor forState:0];
                weakself.dealCommitButton.userInteractionEnabled = NO;
            }
        }

        
    } andFailBlock:^(NSError *error){
        
    }];
}

- (void)endProductWithStatusString:(NSString *)status //status:3为终止。4为结案。
{
    NSString *endpString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyreleaseDealingEndString];
    NSDictionary *params = @{@"id" : self.idString,
                             @"category" : self.categaryString,
                             @"status" : status,
                             @"token" : [self getValidateToken]
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:endpString params:params successBlock:^(id responseObject) {
        BaseModel *sModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:sModel.msg];
        
        if ([sModel.code isEqualToString:@"0000"]) {//成功
            [weakself.dealFootView setHidden:YES];
            [weakself.dealCommitButton setHidden:NO];
            [weakself.navigationController popViewControllerAnimated:YES];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

#pragma mark - alert
- (void)showAlertRemindWithTitle:(NSString *)string withTag:(NSInteger)tag
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:string preferredStyle:UIAlertControllerStyleAlert];
    
    QDFWeakSelf;
    UIAlertAction *ace1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (tag == 33) {
            [weakself endProductWithStatusString:@"3"];
        }else{
            [weakself endProductWithStatusString:@"4"];
        }

    }];
    UIAlertAction *ace2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:ace1];
    [alert addAction:ace2];
    
    [self presentViewController:alert animated:YES completion:nil];
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
