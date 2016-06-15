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
    self.navigationItem.title = @"BX201601010001";
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
//        _detailStoreTableView = [UITableView newAutoLayoutView];
        _detailStoreTableView.translatesAutoresizingMaskIntoConstraints = NO;
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
        
        //            NSString *str1 = @"5.6";
        //            NSString *str2 = @"%";
        //            NSString *str = [NSString stringWithFormat:@"%@%@",str1,str2];
        //            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        //            [attributeStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:50],NSForegroundColorAttributeName:kNavColor} range:NSMakeRange(0, str1.length)];
        //            [attributeStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],NSForegroundColorAttributeName:kNavColor} range:NSMakeRange(str1.length, str2.length)];
        //            [cell.deRateLabel1 setAttributedText:attributeStr];
        
        if ([proModel.category intValue] == 1) {//融资
            //上边
            cell.deRateLabel.text = @"返点(%)";
            cell.deRateLabel1.text = proModel.rebate;
            
            //右边
            if ([proModel.rate_cat integerValue] == 1) {
                cell.deTypeView.fLabel1.text = @"借款利率(天)";
            }else{
                cell.deTypeView.fLabel1.text = @"借款利率(月)";
            }
            cell.deTypeView.fLabel2.text = proModel.rate;
            
        }else if ([proModel.category intValue] == 2){//催收
            //上边
            cell.deRateLabel.text = @"代理费率(%)";
            cell.deRateLabel1.text = proModel.agencycommission;
            
            //右边
            cell.deTypeView.fLabel1.text = @"债权类型";
            if ([proModel.loan_type isEqualToString:@"1"]) {
                cell.deTypeView.fLabel2.text = @"房产抵押";
            }else if ([proModel.loan_type isEqualToString:@"2"]){
                cell.deTypeView.fLabel2.text = @"应收账款";
            }else if ([proModel.loan_type isEqualToString:@"3"]){
                cell.deTypeView.fLabel2.text = @"机动车抵押";
            }else if([proModel.loan_type isEqualToString:@"4"]){
                cell.deTypeView.fLabel2.text = @"无抵押";
            }
            
        }else if ([proModel.category intValue] == 3){//诉讼
            //上边
            if ([proModel.agencycommissiontype isEqualToString:@"1"]) {
                cell.deRateLabel.text = @"固定费用(万)";
            }else{
                cell.deRateLabel.text = @"风险费率(%)";
            }
            cell.deRateLabel1.text = proModel.agencycommission;
            
            //右边
            cell.deTypeView.fLabel1.text = @"债权类型";
            if ([proModel.loan_type isEqualToString:@"1"]) {
                cell.deTypeView.fLabel2.text = @"房产抵押";
            }else if ([proModel.loan_type isEqualToString:@"2"]){
                cell.deTypeView.fLabel2.text = @"应收账款";
            }else if ([proModel.loan_type isEqualToString:@"3"]){
                cell.deTypeView.fLabel2.text = @"机动车抵押";
            }else if([proModel.loan_type isEqualToString:@"4"]){
                cell.deTypeView.fLabel2.text = @"无抵押";
            }
        }
        
        //左边－－－－通用
        cell.deMoneyView.fLabel1.text = @"借款本金(万)";
        cell.deMoneyView.fLabel2.text = proModel.money;
        
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
                checkDetailPublishVC.evaTypeString = @"launchevaluation";
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
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
        PublishingResponse *respModel = [PublishingResponse objectWithKeyValues:responseObject];
        
        self.navigationItem.title = respModel.product.codeString;
        [self.detailStoreArray addObject:respModel];
        [self.detailStoreTableView reloadData];
        
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
