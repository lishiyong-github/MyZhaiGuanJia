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

@end

@implementation MyDealingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看接单方" style:UIBarButtonItemStylePlain target:self action:@selector(checkPublishUserDetail)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self.view addSubview: self.dealingTableView];
    [self.view addSubview:self.dealFootView];
    [self.view addSubview:self.dealCommitButton];
    [self.dealCommitButton setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
    
    [self getDealingMessage];
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
        _dealingTableView = [UITableView newAutoLayoutView];
        _dealingTableView.translatesAutoresizingMaskIntoConstraints = NO;
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

        QDFWeakSelf;
        [_dealFootView setDidSelectedButton:^(NSInteger tag) {
            if (tag == 33) {//终止
                UIAlertController *getAlertVC = [UIAlertController alertControllerWithTitle:@"" message:@"确定选择终止?" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *act0 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakself.dealFootView setHidden:YES];
                    [weakself.dealCommitButton setHidden:NO];
                    [weakself.dealCommitButton setTitle:@"已终止" forState:0];
                }];
                
                UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil];
                
                [getAlertVC addAction:act0];
                [getAlertVC addAction:act1];
                
                [weakself presentViewController:getAlertVC animated:YES completion:nil];
                
            }else{//已结案
                UIAlertController *sendAlertVC = [UIAlertController alertControllerWithTitle:@"" message:@"确定申请结案?" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *acti0 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakself.dealFootView setHidden:YES];
                    [weakself.dealCommitButton setHidden:NO];
                    [weakself.dealCommitButton setTitle:@"已结案" forState:0];
                }];
                
                UIAlertAction *acti1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil];
                
                [sendAlertVC addAction:acti0];
                [sendAlertVC addAction:acti1];
                [weakself presentViewController:sendAlertVC animated:YES completion:nil];

            }
        }];
    }
    return _dealFootView;
}

- (BaseCommitButton *)dealCommitButton
{
    if (!_dealCommitButton) {
        _dealCommitButton = [BaseCommitButton newAutoLayoutView];
        [_dealCommitButton setBackgroundColor:kLightGrayColor];
        [_dealCommitButton setBackgroundColor:kSelectedColor];
        _dealCommitButton.userInteractionEnabled = NO;
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
                        string3 = @"  借款利率(天)";
                    }else if ([dealModel.rate_cat intValue] == 2){
                        string3 = @"  借款利率(月)";
                    }
                    imageString3 = @"conserve_interest_icon";
                    string33 = dealModel.rate;
                    string4 = @"  返点";
                    imageString4 = @"conserve_rebate_icon";
                    string44 = dealModel.rebate;
                }else if ([dealModel.category intValue] == 2){//催收
                    string22 = @"催收";
                    string3 = @"  代理费用(万)";
                    imageString3 = @"conserve_fixed_icon";
                    string33 = dealModel.agencycommission;
                    string4 = @"  债权类型";
                    imageString4 = @"conserve_rights_icon";
                    if ([dealModel.loan_type intValue] == 1) {
                        string44 = @"房产抵押";
                    }else if ([dealModel.loan_type intValue] == 2){
                        string44 = @"应收账款";
                    }else if ([dealModel.loan_type intValue] == 3){
                        string44 = @"机动车抵押";
                    }else if ([dealModel.loan_type intValue] == 4){
                        string44 = @"无抵押";
                    }
                }else if ([dealModel.category intValue] == 3){//诉讼
                    string22 = @"诉讼";
                    if ([dealModel.agencycommissiontype intValue] == 1) {
                        string3 = @"  固定费用(万)";
                    }else if ([dealModel.agencycommissiontype intValue] == 2){
                        string3 = @"  风险费率(%)";
                    }
                    imageString3 = @"conserve_fixed_icon";
                    string33 = dealModel.agencycommission;
                    string4 = @"  债权类型";
                    imageString4 = @"conserve_rights_icon";
                    if ([dealModel.loan_type intValue] == 1) {
                        string44 = @"房产抵押";
                    }else if ([dealModel.loan_type intValue] == 2){
                        string44 = @"应收账款";
                    }else if ([dealModel.loan_type intValue] == 3){
                        string44 = @"机动车抵押";
                    }else if ([dealModel.loan_type intValue] == 4){
                        string44 = @"无抵押";
                    }
                }
                
                NSArray *dataArray = @[@"|  基本信息",@"  投资类型",@"  借款本金(万)",string3,string4];
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
            
            identifier = @"dealing11";
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
        additionMessageVC.idString = dealModel.idString;
        additionMessageVC.categoryString = dealModel.category;
        [self.navigationController pushViewController:additionMessageVC animated:YES];
    }else if (indexPath.section == 2) {//协议
        AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
        agreementVC.idString = dealModel.idString;
        agreementVC.categoryString = dealModel.category;
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
    checkDetailPublishVC.evaTypeString = @"evaluate";
    [self.navigationController pushViewController:checkDetailPublishVC animated:YES];
}

- (void)getDealingMessage
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        
        [self.dealingDataList addObject:response];
        [self.dealingTableView reloadData];
        
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
