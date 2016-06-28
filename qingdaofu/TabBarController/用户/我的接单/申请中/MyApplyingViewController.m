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

@end

@implementation MyApplyingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    if (self.pidString) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看发布方" style:UIBarButtonItemStylePlain target:self action:@selector(checkDetails)];
    }
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
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
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.myApplyArray.count > 0) {
        
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
        
        NSString *nameStr = [NSString stringWithFormat:@"产品编号：%@",applyModel.codeString];
        [cell.userNameButton setTitle:nameStr forState:0];
        [cell.userNameButton setTitleColor:UIColorFromRGB(0xcfd4e8) forState:0];
        cell.userNameButton.titleLabel.font = kFirstFont;
        
        /*0为待发布（保存未发布的）。 1为发布中（已发布的）。
         2为处理中（有人已接单发布方也已同意）。
         3为终止（只用发布方可以终止）。
         4为结案（双方都可以申请，一方申请一方同意*/
        if ([applyModel.progress_status intValue] == 0) {
            [cell.userActionButton setTitle:@"待发布" forState:0];
        }else if ([applyModel.progress_status intValue] == 1){
            [cell.userActionButton setTitle:@"申请中" forState:0];
        }else if ([applyModel.progress_status intValue] == 2){
            [cell.userActionButton setTitle:@"处理中" forState:0];
        }else if ([applyModel.progress_status intValue] == 3){
            [cell.userActionButton setTitle:@"终止" forState:0];
        }else if ([applyModel.progress_status intValue] == 4){
            [cell.userActionButton setTitle:@"结案" forState:0];
        }
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
                    string3 = @"  借款利率(天)";
                }else if ([applyModel.rate_cat intValue] == 2){
                    string3 = @"  借款利率(月)";
                }
                imageString3 = @"conserve_interest_icon";
                string33 = applyModel.rate;
                string4 = @"  返点";
                imageString4 = @"conserve_rebate_icon";
                string44 = applyModel.rebate;
            }else if ([applyModel.category intValue] == 2){//清收
                string22 = @"清收";
                string3 = @"  代理费用(万)";
                imageString3 = @"conserve_fixed_icon";
                string33 = applyModel.agencycommission;
                string4 = @"  债权类型";
                imageString4 = @"conserve_rights_icon";
                if ([applyModel.loan_type intValue] == 1) {
                    string44 = @"房产抵押";
                }else if ([applyModel.loan_type intValue] == 2){
                    string44 = @"应收账款";
                }else if ([applyModel.loan_type intValue] == 3){
                    string44 = @"机动车抵押";
                }else if ([applyModel.loan_type intValue] == 4){
                    string44 = @"无抵押";
                }
            }else if ([applyModel.category intValue] == 3){//诉讼
                string22 = @"诉讼";
                if ([applyModel.agencycommissiontype intValue] == 1) {
                    string3 = @"  固定费用(万)";
                }else if ([applyModel.agencycommissiontype intValue] == 2){
                    string3 = @"  风险费率(%)";
                }
                imageString3 = @"conserve_fixed_icon";
                string33 = applyModel.agencycommission;
                string4 = @"  债权类型";
                imageString4 = @"conserve_rights_icon";
                if ([applyModel.loan_type intValue] == 1) {
                    string44 = @"房产抵押";
                }else if ([applyModel.loan_type intValue] == 2){
                    string44 = @"应收账款";
                }else if ([applyModel.loan_type intValue] == 3){
                    string44 = @"机动车抵押";
                }else if ([applyModel.loan_type intValue] == 4){
                    string44 = @"无抵押";
                }
            }
            
            NSArray *dataArray = @[@"|  基本信息",@"  投资类型",@"  借款本金(万)",string3,string4];
            NSArray *imageArray = @[@"",@"conserve_investment_icon",@"conserve_loan_icon",imageString3,imageString4];
            NSArray *detailArray = @[@"",string22,applyModel.money,string33,string44];
            
            [cell.userNameButton setTitle:dataArray[indexPath.row] forState:0];
            [cell.userNameButton setImage:[UIImage imageNamed:imageArray[indexPath.row]] forState:0];
            [cell.userActionButton setTitle:detailArray[indexPath.row] forState:0];
            
            if (indexPath.row == 0) {
                [cell.userNameButton setTitleColor:kBlueColor forState:0];
            }
            
            return cell;
        }
        
        identifier = @"applying11";
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
    if ((indexPath.section == 1) && (indexPath.row == 5)) {//补充信息
        AdditionMessageViewController *addtionMessageVC = [[AdditionMessageViewController alloc] init];
        addtionMessageVC.idString = self.idString;
        addtionMessageVC.categoryString = self.categaryString;
        [self.navigationController pushViewController:addtionMessageVC animated:YES];
    }
}

#pragma mark - method
- (void)checkDetails
{
    CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
    checkDetailPublishVC.idString = self.idString;
    checkDetailPublishVC.categoryString = self.categaryString;
    checkDetailPublishVC.pidString = self.pidString;
    checkDetailPublishVC.typeString = @"发布方";
    [self.navigationController pushViewController:checkDetailPublishVC animated:YES];
}

- (void)getDetailMessageOfApplying
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        [self.myApplyArray addObject:response];
        [self.myApplyingTableView reloadData];
        
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
