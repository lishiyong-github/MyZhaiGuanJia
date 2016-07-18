//
//  MyDetailStoreViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyDetailStoreViewController.h"

#import "ProductsDetailsProViewController.h"   //产品信息
#import "CheckDetailPublishViewController.h" //发布人信息
#import "MyOrderViewController.h"   //我的接单

#import "ProDetailCell.h"
#import "MineUserCell.h"
#import "BaseCommitButton.h"

#import "PublishingResponse.h"
#import "PublishingModel.h"

@interface MyDetailStoreViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstarints;
@property (nonatomic,strong) UITableView *detailStoreTableView;
@property (nonatomic,strong) BaseCommitButton *detailStoreCommitButton;

@property (nonatomic,strong) NSMutableArray *detailStoreArray;

@end

@implementation MyDetailStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.codeString;
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.detailStoreTableView];
    [self.view addSubview:self.detailStoreCommitButton];
    [self.view setNeedsUpdateConstraints];
    
    [self getStoreDetailMessage];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstarints) {
        
        [self.detailStoreTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.detailStoreTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.detailStoreCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.detailStoreCommitButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstarints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)detailStoreTableView
{
    if (!_detailStoreTableView) {
        _detailStoreTableView.translatesAutoresizingMaskIntoConstraints = YES;
        _detailStoreTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _detailStoreTableView.delegate = self;
        _detailStoreTableView.dataSource = self;
        _detailStoreTableView.backgroundColor = kBackColor;
    }
    return _detailStoreTableView;
}
- (BaseCommitButton *)detailStoreCommitButton
{
    if (!_detailStoreCommitButton) {
        _detailStoreCommitButton = [BaseCommitButton newAutoLayoutView];
        [_detailStoreCommitButton setTitle:@"立即申请" forState:0];
        
        [_detailStoreCommitButton addTarget:self action:@selector(requestApply:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailStoreCommitButton;
}

-(NSMutableArray *)detailStoreArray
{
    if (!_detailStoreArray) {
        _detailStoreArray = [NSMutableArray array];
    }
    return _detailStoreArray;
}

#pragma mark - 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.detailStoreArray.count > 0) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 210;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    PublishingResponse *ewModel = self.detailStoreArray[0];
    PublishingModel *proModel = ewModel.product;
    
    if (indexPath.section == 0) {
        ProDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ProDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kNavColor1;
        
        if ([proModel.category intValue] == 1) {//融资
            //上边
            cell.deRateLabel.text = @"返点(%)";
            cell.deRateLabel1.text = [NSString getValidStringFromString:proModel.rebate toString:@"0"];
            
            //右边
            if ([proModel.rate_cat integerValue] == 1) {
                cell.deTypeView.fLabel1.text = @"借款利率(%/天)";
            }else{
                cell.deTypeView.fLabel1.text = @"借款利率(%/月)";
            }
            cell.deTypeView.fLabel2.text = [NSString getValidStringFromString:proModel.rate toString:@"0"];
            
        }else if ([proModel.category intValue] == 2){//清收
            //上边
            if ([proModel.agencycommissiontype isEqualToString:@"1"]) {
                cell.deRateLabel.text = @"提成比例(%)";
            }else{
                cell.deRateLabel.text = @"固定费用(万元)";
            }
            cell.deRateLabel1.text = [NSString getValidStringFromString:proModel.agencycommission toString:@"0"];
            
            //右边
            cell.deTypeView.fLabel1.text = @"债权类型";
            if ([proModel.loan_type isEqualToString:@"1"]) {
                cell.deTypeView.fLabel2.text = @"房产抵押";
            }else if ([proModel.loan_type isEqualToString:@"2"]){
                cell.deTypeView.fLabel2.text = @"应收账款";
            }else if ([proModel.loan_type isEqualToString:@"3"]){
                cell.deTypeView.fLabel2.text = @"机动车抵押";
            }else{
                cell.deTypeView.fLabel2.text = @"无抵押";
            }
            
        }else if ([proModel.category intValue] == 3){//诉讼
            //上边
            if ([proModel.agencycommissiontype isEqualToString:@"1"]) {
                cell.deRateLabel.text = @"固定费用(万元)";
            }else{
                cell.deRateLabel.text = @"风险费率(%)";
            }
            cell.deRateLabel1.text = [NSString getValidStringFromString:proModel.agencycommission toString:@"0"];
            
            //右边
            cell.deTypeView.fLabel1.text = @"债权类型";
            if ([proModel.loan_type isEqualToString:@"1"]) {
                cell.deTypeView.fLabel2.text = @"房产抵押";
            }else if ([proModel.loan_type isEqualToString:@"2"]){
                cell.deTypeView.fLabel2.text = @"应收账款";
            }else if ([proModel.loan_type isEqualToString:@"3"]){
                cell.deTypeView.fLabel2.text = @"机动车抵押";
            }else{
                cell.deTypeView.fLabel2.text = @"无抵押";
            }
        }
        
        //左边－－－－通用
        cell.deMoneyView.fLabel1.text = @"借款本金(万元)";
        cell.deMoneyView.fLabel2.text = [NSString getValidStringFromString:proModel.money toString:@"0"];
        
        return cell;
    }
    
        identifier = @"detailStore1";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[MineUserCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *detailTextArray = @[@"  产品信息",@"  发布人信息"];
    NSArray *detailImageArray = @[@"list_icon_product",@"list_icon_user"];
    [cell.userNameButton setImage:[UIImage imageNamed:detailImageArray[indexPath.row]] forState:0];
    [cell.userNameButton setTitle:detailTextArray[indexPath.row] forState:0];
    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    
    if (indexPath.row ==1) {
        [cell.userActionButton setTitle:@"已认证" forState:0];
        [cell.userActionButton setTitleColor:kYellowColor forState:0];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.detailStoreArray.count > 0) {
        PublishingResponse *qModel = self.detailStoreArray[0];
        PublishingModel *pModel = qModel.product;
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                ProductsDetailsProViewController *productsDetailsProVC = [[ProductsDetailsProViewController alloc] init];
                productsDetailsProVC.yyModel = qModel;
                [self.navigationController pushViewController:productsDetailsProVC animated:YES];
            }else{
                CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
                checkDetailPublishVC.idString = self.idString;
                checkDetailPublishVC.categoryString = self.categoryString;
                checkDetailPublishVC.pidString = pModel.uidInner;
                checkDetailPublishVC.typeString = @"发布方";
                [self.navigationController pushViewController:checkDetailPublishVC animated:YES];
            }
        }
    }
}

#pragma mark - method
- (void)getStoreDetailMessage
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProdutsDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categoryString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
        PublishingResponse *respModel = [PublishingResponse objectWithKeyValues:responseObject];
        
        [weakself.detailStoreArray addObject:respModel];
        [weakself.detailStoreTableView reloadData];
        
    } andFailBlock:^(NSError *error){
        
    }];
}


- (void)requestApply:(UIButton *)sender
{
    NSString *applyString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProductHouseString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categoryString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:applyString params:params successBlock:^(id responseObject) {
        BaseModel *appModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:appModel.msg];
        if ([appModel.code isEqualToString:@"0000"]) {
            [sender setBackgroundColor:kSelectedColor];
            [sender setTitle:@"申请中" forState:0];
            [sender setTitleColor:kBlackColor forState:0];
            sender.userInteractionEnabled = NO;
            
            UINavigationController *nav = weakself.navigationController;
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
            
            MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
            myOrderVC.status = @"0";
            myOrderVC.progresStatus = @"1";
            myOrderVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:myOrderVC animated:NO];
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
