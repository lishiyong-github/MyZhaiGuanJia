//
//  ProductsDetailsViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ProductsDetailsViewController.h"
#import "ProductsDetailsProViewController.h"   //产品信息
#import "CheckDetailPublishViewController.h" //发布人信息

#import "UIImage+Color.h"
#import "BaseCommitButton.h"
#import "EvaTopSwitchView.h"  //切换
#import "ProdLeftView.h"  //产品基本信息

//cell
#import "MineUserCell.h"
#import "ProDetailCell.h"
#import "ProDetailNumberCell.h"  //浏览次数
#import "UserPublishCell.h"  //产品信息／发布方信息

//model
//产品信息
#import "PublishingResponse.h"
#import "PublishingModel.h"

//发布人信息
#import "CompleteResponse.h"
#import "CertificationModel.h"

//收藏状态
#import "ApplicationStateModel.h"



@interface ProductsDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIImage *shadowImage;
@property (nonatomic,strong) UIButton *leftItemButton;
@property (nonatomic,strong) UIButton *rightItemButton;
@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *productsDetailsTableView;
@property (nonatomic,strong) BaseCommitButton *proDetailsCommitButton;

@property (nonatomic,strong) ProdLeftView *leftTableView;

//json
@property (nonatomic,strong) NSMutableArray *recommendDataArray;
@property (nonatomic,strong) NSString *typetString;//收藏状态
@property (nonatomic,strong) NSArray *messageArray1;
@property (nonatomic,strong) NSArray *messageArray11;
@property (nonatomic,strong) NSArray *messageArray2;
@property (nonatomic,strong) NSArray *messageArray22;
@property (nonatomic,strong) NSArray *certificationArray1;
@property (nonatomic,strong) NSArray *certificationArray11;

@property (nonatomic,strong) NSString *switchType; //切换产品详情or发布方信息


@property (nonatomic,strong) NSMutableArray *certifiDataArray;
@property (nonatomic,strong) NSMutableArray *allEvaResponse;
@property (nonatomic,strong) NSMutableArray *allEvaDataArray;

@end

@implementation ProductsDetailsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kNavColor,NSFontAttributeName:kNavFont}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNavColor1] forBarMetrics:UIBarMetricsDefault];
    
    self.shadowImage = self.navigationController.navigationBar.shadowImage;
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:kNavColor1]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:self.shadowImage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftItemButton];
    
    self.switchType = @"34";
    
    [self.view addSubview:self.productsDetailsTableView];
    [self.view addSubview:self.proDetailsCommitButton];
    [self.view setNeedsUpdateConstraints];
    
    [self getDetailMessage];
}

- (UIButton *)leftItemButton
{
    if (!_leftItemButton) {
        _leftItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_leftItemButton setImage:[UIImage imageNamed:@"nav_back"] forState:0];
        QDFWeakSelf;
        [_leftItemButton addAction:^(UIButton *btn) {
            [weakself.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _leftItemButton;
}

- (UIButton *)rightItemButton
{
    if (!_rightItemButton) {
        _rightItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    }
    return _rightItemButton;
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.productsDetailsTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.productsDetailsTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.proDetailsCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.proDetailsCommitButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)productsDetailsTableView
{
    if (!_productsDetailsTableView) {
        _productsDetailsTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _productsDetailsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _productsDetailsTableView.delegate = self;
        _productsDetailsTableView.dataSource = self;
        _productsDetailsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _productsDetailsTableView.backgroundColor = kBackColor;
    }
    return _productsDetailsTableView;
}

- (BaseCommitButton *)proDetailsCommitButton
{
    if (!_proDetailsCommitButton) {
        _proDetailsCommitButton = [BaseCommitButton newAutoLayoutView];
    }
    return _proDetailsCommitButton;
}

- (NSMutableArray *)recommendDataArray
{
    if (!_recommendDataArray) {
        _recommendDataArray = [NSMutableArray array];
    }
    return _recommendDataArray;
}

- (NSMutableArray *)certifiDataArray
{
    if (!_certifiDataArray) {
        _certifiDataArray = [NSMutableArray array];
    }
    return _certifiDataArray;
}

#pragma mark - tableView deleagate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.recommendDataArray.count > 0) {
        return 2;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.recommendDataArray.count > 0) {
        if (section == 0) {
            return 2;
        }else{//section==1
            if ([self.switchType isEqualToString:@"33"]) {
                //产品信息
                return 1+self.messageArray1.count+1+1+self.messageArray2.count;
            }else{
                //发布人信息
                if (self.certificationArray1.count > 0) {
                    return self.certificationArray1.count;
                }
            }
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 200;
        }
        return 60;
    }
    
    //section==1
    if ([self.switchType isEqualToString:@"33"]) {
        if (indexPath.row == self.messageArray1.count+1) {
            return kBigPadding;
        }
        return kCellHeight;
    }else{
        return kCellHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    PublishingResponse *ewModel;
    PublishingModel *proModel;
    if (self.recommendDataArray.count > 0) {
        ewModel = self.recommendDataArray[0];
        proModel = ewModel.product;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//产品详情
            identifier = @"proDetais00";
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
        
        //row == 1  ProDetailNumberCell
        identifier = @"proDetais01";
        ProDetailNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ProDetailNumberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.numberButton1.fLabel1.text = @"浏览次数";
        cell.numberButton1.fLabel2.text = @"30";
        cell.numberButton2.fLabel1.text = @"申请次数";
        cell.numberButton2.fLabel2.text = @"3";
        cell.numberButton3.fLabel1.text = @"收藏次数";
        cell.numberButton3.fLabel2.text = @"3";

        return cell;
    }
    //section == 1
    if ([self.switchType isEqualToString:@"33"]) {//产品详情
        if (indexPath.row == 0) {
            identifier = @"proDetais10";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.userNameButton setTitle:@"基本信息" forState:0];
            [cell.userActionButton setHidden:YES];
            
            return cell;
        }else if(indexPath.row > 0 && indexPath.row < self.messageArray1.count+1){//基本信息详情
            identifier = @"proDetais11";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
            cell.userNameButton.titleLabel.font = kFirstFont;
            [cell.userActionButton setTitleColor:kGrayColor forState:0];
            cell.userActionButton.titleLabel.font = kFirstFont;
            
            [cell.userNameButton setTitle:self.messageArray1[indexPath.row-1] forState:0];
            [cell.userActionButton setTitle:self.messageArray11[indexPath.row-1] forState:0];
            return cell;
        }else if (indexPath.row == self.messageArray1.count+1){
            identifier = @"proDetais12";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.userNameButton setHidden:YES];
            [cell.userActionButton setHidden:YES];
            cell.backgroundColor = kBackColor;
            
            return cell;
        }else if (indexPath.row == self.messageArray1.count+2){//补充信息
            identifier = @"proDetais13";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.userActionButton setHidden:YES];
            [cell.userNameButton setTitle:@"补充信息" forState:0];
            
            return cell;
            
        }else if (indexPath.row > self.messageArray1.count+2){//补充信息详情
            identifier = @"proDetais14";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
            cell.userNameButton.titleLabel.font = kFirstFont;
            [cell.userActionButton setTitleColor:kGrayColor forState:0];
            cell.userActionButton.titleLabel.font = kFirstFont;
            
            [cell.userNameButton setTitle:self.messageArray2[indexPath.row-self.messageArray1.count-3] forState:0];
            [cell.userActionButton setTitle:self.messageArray22[indexPath.row-self.messageArray11.count-3] forState:0];
            
            return cell;
        }
        
    }else{
        if (indexPath.row < self.certificationArray1.count) {
            identifier = @"proDetais20";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.userNameButton setTitle:self.certificationArray1[indexPath.row] forState:0];
            [cell.userActionButton setTitle:self.certificationArray11[indexPath.row] forState:0];
            
            if (indexPath.row == 0) {
                [cell.userActionButton setTitleColor:kYellowColor forState:0];
            }else{
                [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
                cell.userNameButton.titleLabel.font = kFirstFont;
                [cell.userActionButton setTitleColor:kGrayColor forState:0];
                cell.userActionButton.titleLabel.font = kFirstFont;
            }
            
            return cell;
        }
        
    }
    
    
//    [cell.userNameButton setTitle:@"性情" forState:0];
    
    //////////////////////
    
    ///////////////////
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1f;
    }
    return 50+kBigPadding;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *headerView = [[UIView alloc] init];
        
        EvaTopSwitchView *productSwitchView = [[EvaTopSwitchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        productSwitchView.backgroundColor = kNavColor;
        [productSwitchView.getbutton  setTitle:@"产品信息" forState:0];//33
        [productSwitchView.sendButton  setTitle:@"发布方信息" forState:0];//34
        [headerView addSubview:productSwitchView];
        
        QDFWeak(productSwitchView);
        QDFWeakSelf;
        [productSwitchView setDidSelectedButton:^(NSInteger tag) {
            if (tag == 33) {
                [weakproductSwitchView.getbutton setTitleColor:kBlueColor forState:0];
                [weakproductSwitchView.sendButton setTitleColor:kBlackColor forState:0];
                weakself.switchType = @"33";
//                [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            }else{
                [weakproductSwitchView.sendButton setTitleColor:kBlueColor forState:0];
                [weakproductSwitchView.getbutton setTitleColor:kBlackColor forState:0];
                weakself.switchType = @"34";
                [weakself getMessageOfPublishPerson];
            }
//            [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        return headerView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kBigPadding;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.recommendDataArray.count > 0) {
        PublishingResponse *qModel = self.recommendDataArray[0];
        PublishingModel *pModel = qModel.product;
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            ProductsDetailsProViewController *productsDetailsProVC = [[ProductsDetailsProViewController alloc] init];
            productsDetailsProVC.yyModel = qModel;
            [self.navigationController pushViewController:productsDetailsProVC animated:YES];
        }else{
            if ([qModel.state isEqualToString:@"1"]) {
                CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
                checkDetailPublishVC.idString = self.idString;
                checkDetailPublishVC.categoryString = self.categoryString;
                checkDetailPublishVC.pidString = pModel.uidInner;
                checkDetailPublishVC.typeString = @"发布方";
                [self.navigationController pushViewController:checkDetailPublishVC animated:YES];
            }else{
                [self showHint:@"发布方未认证，不能查看相关信息"];
            }
        }
      }
    }
}

#pragma mark - method
//产品详情
- (void)getDetailMessage
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProdutsDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categoryString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){        
        
        PublishingResponse *respModel = [PublishingResponse objectWithKeyValues:responseObject];
        
        NSArray *categoryArr = @[@"清收",@"诉讼"];
        NSArray *cateStr = categoryArr[[weakself.categoryString integerValue] -2];
        weakself.navigationItem.title = [NSString stringWithFormat:@"%@%@",cateStr,respModel.product.codeString];
        [weakself.recommendDataArray addObject:respModel];
        [weakself applicationForOrdersStates];
        
        //*********************///
        //金额
        NSString *moneyStr1 = [NSString getValidStringFromString:respModel.product.money toString:@"0"];
        //代理费用
        NSString *agencycommissionStr1 = [NSString getValidStringFromString:respModel.product.agencycommission toString:@"0"];
        
        NSString *loan_typeStr = @"暂无";//债权类型
        if ([respModel.product.loan_type intValue] == 1) {
            loan_typeStr = @"房产抵押";
        }else if ([respModel.product.loan_type intValue] == 2){
            loan_typeStr = @"应收账款";
        }else if ([respModel.product.loan_type intValue] == 3){
            loan_typeStr = @"机动车抵押";
        }else{
            loan_typeStr = @"无抵押";
        }
        
        NSString *agencycommissiontypeStr = @"暂无";  //代理费用类型
        if ([respModel.product.agencycommissiontype intValue] == 1) {
            if ([respModel.product.category integerValue] == 2) {
                agencycommissiontypeStr = @"提成比例(%)";
            }else{
                agencycommissiontypeStr = @"固定费用(万元)";
            }
        }else if ([respModel.product.agencycommissiontype intValue] ==2){
            if ([respModel.product.category integerValue] == 2) {
                agencycommissiontypeStr = @"固定费用(万元)";
            }else{
                agencycommissiontypeStr = @"风险费率(%)";
            }
        }
        
        if ([respModel.product.loan_type intValue] == 1) {//房产抵押
            NSString *mortorage_communityStr1 = [NSString getValidStringFromString:respModel.product.mortorage_community];
            NSString *seatmortgageStr1 = [NSString getValidStringFromString:respModel.product.seatmortgage];
            
            weakself.messageArray1 = @[@"借款本金(万元)",@"代理费用类型",@"代理费用",@"债权类型",@"抵押物地址",@"详细地址"];
            weakself.messageArray11 = @[moneyStr1,agencycommissiontypeStr,agencycommissionStr1,loan_typeStr,mortorage_communityStr1,seatmortgageStr1];
        }else if ([respModel.product.loan_type intValue] == 3){//机动车抵押
            NSString *carStr1 = [NSString getValidStringFromString:respModel.car];
            NSString *licenseStr1 = [NSString getValidStringFromString:respModel.license];
            
            weakself.messageArray1 = @[@"借款本金(万元)",@"代理费用类型",@"代理费用",@"债权类型",@"机动车抵押",@"车牌类型"];
            weakself.messageArray11 = @[moneyStr1,agencycommissiontypeStr,agencycommissionStr1,loan_typeStr,carStr1,licenseStr1];
        }else if ([respModel.product.loan_type intValue] == 2){//应收帐款
            NSString *accountrStr1 = [NSString getValidStringFromString:respModel.product.accountr toString:@"0"];
            
            weakself.messageArray1 = @[@"借款本金(万元)",@"代理费用类型",@"代理费用",@"债权类型",@"应收帐款(万元)"];
            weakself.messageArray11 = @[moneyStr1,agencycommissiontypeStr,agencycommissionStr1,loan_typeStr,accountrStr1];
        }else{
            
            weakself.messageArray1 = @[@"借款本金(万元)",@"代理费用类型",@"代理费用",@"债权类型"];
            weakself.messageArray11 = @[moneyStr1,agencycommissiontypeStr,agencycommissionStr1,loan_typeStr];
        }
        ///*************////
        
        
        //补充信息
        NSString *rate = [NSString getValidStringFromString:respModel.product.rate]; //借款利率
        NSString *rate_cat = @"暂无"; //借款期限类型
        NSString *term = [NSString getValidStringFromString:respModel.product.term];   //借款期限
        NSString *repaymethod = @"暂无";//还款方式
        NSString *obligor = @"暂无";  //债务人主体
        NSString *commitment = @"暂无";  //委托事项
        NSString *commissionperiod = [NSString getValidStringFromString:respModel.product.commissionperiod];   //委托代理期限
        NSString *paidmoney = [NSString getValidStringFromString:respModel.product.paidmoney];  //已付本金
        NSString *interestpaid = [NSString getValidStringFromString:respModel.product.interestpaid];  //已付利息
        NSString *performancecontract = [NSString getValidStringFromString:respModel.product.performancecontract];  //合同履行地
        NSString *creditorfile = @"查看";  //债权文件
        NSString *creditorinfo;  //债权人信息
        NSString *borrowinginfo;  //债务人信息
        
        if (respModel.product.rate_cat) {
            if ([respModel.product.rate_cat intValue] == 1) {
                rate_cat = @"天";
            }else{
                rate_cat = @"月";
            }
        }
        if (respModel.product.repaymethod) {
            if ([respModel.product.repaymethod intValue] == 1) {
                repaymethod = @"一次性到期还本付息";
            }else if([respModel.product.repaymethod intValue] == 2){
                repaymethod = @"按月付息，到期还本";
            }else{
                repaymethod = @"其他";
            }
        }
        if (respModel.product.obligor) {
            if ([respModel.product.obligor intValue] == 1) {
                obligor = @"自然人";
            }else if([respModel.product.obligor intValue] == 2){
                obligor = @"法人";
            }else{
                obligor = @"其他";
            }
        }
        if (respModel.product.commitment) {
            if ([respModel.product.commitment intValue] == 1) {
                commitment = @"代理诉讼";
            }else if([respModel.product.commitment intValue] == 2){
                commitment = @"代理仲裁";
            }else{
                commitment = @"代理执行";
            }
        }
        
        if (respModel.creditorinfos.count > 0) {
            creditorinfo = @"查看";
        }else{
            creditorinfo = @"暂无";
        }
        
        if (respModel.borrowinginfos.count > 0) {
            borrowinginfo = @"查看";
        }else{
            borrowinginfo = @"暂无";
        }
        
        weakself.messageArray2 = @[@"借款利率(%)",@"借款利率类型",@"借款期限",@"借款期限类型",@"还款方式",@"债务人主体",@"委托事项",@"委托代理期限(月)",@"已付本金(元)",@"已付利息(元)",@"合同履行地",@"债权文件",@"债权人信息",@"债务人信息"];
        weakself.messageArray22 = @[rate,rate_cat,term,rate_cat,repaymethod,obligor,commitment,commissionperiod,paidmoney,interestpaid,performancecontract,creditorfile,creditorinfo,borrowinginfo];
        
        [weakself.productsDetailsTableView reloadData];
    } andFailBlock:^(NSError *error){
    }];
}

//申请状态及收藏状态
- (void)applicationForOrdersStates
{
    NSString *houseString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProductHouseStateString];
    NSDictionary *params = @{@"id" : self.idString,
                             @"category" : self.categoryString,
                             @"token" : [self getValidateToken]
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:houseString params:params successBlock:^(id responseObject) {
        ApplicationStateModel *stateModel = [ApplicationStateModel objectWithKeyValues:responseObject];
        PublishingResponse *rModel = weakself.recommendDataArray[0];
        
        if ((stateModel.app_id == nil || [stateModel.app_id intValue] == 2) && [rModel.product.progress_status integerValue] == 1) {
            [weakself.proDetailsCommitButton setTitleColor:kNavColor forState:0];
            [weakself.proDetailsCommitButton setTitle:@"立即申请" forState:0];
            [weakself.proDetailsCommitButton addTarget: weakself action:@selector(applicationCommit) forControlEvents:UIControlEventTouchUpInside];
            
            weakself.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:weakself.rightItemButton];
            
            if (stateModel.app_id == nil) {//未收藏
                [_rightItemButton setImage:[UIImage imageNamed:@"nav_collection"] forState:0];
                
                QDFWeakSelf;
                [_rightItemButton addAction:^(UIButton *btn) {
                    
                    if (weakself.typetString) {
                        [weakself saveOrQuitSaveWithType:weakself.typetString WithButton:btn];
                    }else{
                        [weakself saveOrQuitSaveWithType:@"1" WithButton:btn];
                    }
                }];
                
            }else{//已收藏
                [_rightItemButton setImage:[UIImage imageNamed:@"nav_collection_s"] forState:0];
                QDFWeakSelf;
                [_rightItemButton addAction:^(UIButton *btn) {
                    if (weakself.typetString) {
                        [weakself saveOrQuitSaveWithType:weakself.typetString WithButton:btn];
                    }else{
                        [weakself saveOrQuitSaveWithType:@"2" WithButton:btn];
                    }
                }];
            }
            
        }else if (([stateModel.app_id intValue] == 0) && ([rModel.product.progress_status intValue] == 1)) {//已申请
            [weakself.proDetailsCommitButton setTitleColor:kBlackColor forState:0];
            [weakself.proDetailsCommitButton setTitle:@"已申请" forState:0];
            [weakself.proDetailsCommitButton setBackgroundColor:kSelectedColor];
            weakself.proDetailsCommitButton.userInteractionEnabled = NO;
        }else if ([rModel.product.progress_status intValue] == 2){//申请成功
            if ([stateModel.app_id integerValue] == 1) {//自己申请成功
                [weakself.proDetailsCommitButton setTitleColor:kBlackColor forState:0];
                [weakself.proDetailsCommitButton setTitle:@"申请成功" forState:0];
                [weakself.proDetailsCommitButton setBackgroundColor:kSelectedColor];
                
                //添加电话按钮
                UIButton *phoneButton = [UIButton newAutoLayoutView];
                [phoneButton setImage:[UIImage imageNamed:@"phone"] forState:0];
                phoneButton.backgroundColor = kBlueColor;
                [phoneButton addAction:^(UIButton *btn) {
                    NSString *phoneStr = [NSString stringWithFormat:@"telprompt://%@",stateModel.mobile];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
                }];
                [weakself.proDetailsCommitButton addSubview:phoneButton];
                
                [phoneButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_proDetailsCommitButton];
                [phoneButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_proDetailsCommitButton];
                [phoneButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_proDetailsCommitButton];
                [phoneButton autoSetDimension:ALDimensionWidth toSize:kTabBarHeight];
            }else{//别人申请成功，自己显示被接单
                [weakself.proDetailsCommitButton setTitleColor:kBlackColor forState:0];
                [weakself.proDetailsCommitButton setTitle:@"已被接单" forState:0];
                [weakself.proDetailsCommitButton setBackgroundColor:kSelectedColor];
            }
        }else{
            [weakself.proDetailsCommitButton setTitleColor:kBlackColor forState:0];
            [weakself.proDetailsCommitButton setTitle:@"已终止" forState:0];
            [weakself.proDetailsCommitButton setBackgroundColor:kSelectedColor];
        }
    } andFailBlock:^(NSError *error) {
        
    }];
}

//申请收藏或取消收藏
- (void)saveOrQuitSaveWithType:(NSString *)type WithButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    PublishingResponse *rightResponse = self.recommendDataArray[0];
    PublishingModel *rightModel = rightResponse.product;
    
    NSString *rightString;
    NSDictionary *params;
    
    if ([type isEqualToString:@"1"]) {//未收藏 －－ 收藏
       rightString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kRequestStoreString];
        params = @{@"id" : rightModel.idString,
                   @"category" : rightModel.category,
                   @"token" : [self getValidateToken]
                   };
    }else{//收藏 －－ 取消收藏
         rightString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kDeleteStoreString];

        params = @{@"product_id" : rightModel.idString,
                   @"category" : rightModel.category,
                   @"token" : [self getValidateToken]
                   };
    }
    
    QDFWeakSelf;
    [self requestDataPostWithString:rightString params:params successBlock:^(id responseObject){
        BaseModel *rightModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:rightModel.msg];
        
        if ([rightModel.code isEqualToString:@"0000"]) {
            if ([type isEqualToString:@"1"]) {//未收藏 －－ 收藏
                [weakself.rightItemButton setImage:[UIImage imageNamed:@"nav_collection_s"] forState:0];
                weakself.typetString = @"2";
            }else{//收藏 －－ 取消收藏
                [weakself.rightItemButton setImage:[UIImage imageNamed:@"nav_collection"] forState:0];
                weakself.typetString = @"1";
            }
        }
        
    }andFailBlock:^(NSError *error) {
        
    }];
}

//发布人信息
- (void)getMessageOfPublishPerson
{
    NSString *yyyString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kCheckReleasePeople];
    
    PublishingResponse *rModel = self.recommendDataArray[0];

    NSDictionary *params = @{@"category" : self.categoryString,
                             @"id" : self.idString,
                             @"pid" : rModel.product.uidInner,
                             @"token" : [self getValidateToken]
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:yyyString params:params successBlock:^(id responseObject) {
        
        CompleteResponse *response = [CompleteResponse objectWithKeyValues:responseObject];
        
        if ([response.code isEqualToString:@"0000"]) {
            if (response.certification) {
                [weakself.certifiDataArray addObject:response.certification];
            }
            
            NSString *definedStr;
            if ([response.certification.cardimg isEqualToString:@"undefined"]) {
                definedStr = @"未上传";
            }else{
                definedStr = @"已上传";
            }
            
            if ([response.certification.category integerValue] == 1) {//个人
                weakself.certificationArray1 = @[@"基本信息",@"姓名",@"身份证号码",@"身份图片",@"联系电话",@"邮箱"];
                weakself.certificationArray11 = @[@"已认证个人",response.certification.name,response.certification.cardno,definedStr,response.certification.mobile,response.certification.email];
            }else if ([response.certification.category integerValue] == 2){//律所
                weakself.certificationArray1 = @[@"基本信息",@"律所名称",@"执业证号",@"图片",@"联系人",@"联系方式",@"邮箱",@"经典案例"];
                weakself.certificationArray11 = @[@"已认证律所",response.certification.name,response.certification.cardno,definedStr,response.certification.contact,response.certification.mobile,response.certification.email,@"查看"];
            }else if ([response.certification.category integerValue] == 3){//公司
                weakself.certificationArray1 = @[@"基本信息",@"公司名称",@"营业执照号",@"图片",@"联系人",@"联系方式",@"企业邮箱",@"公司经营地址",@"公司网站",@"经典案例"];
                weakself.certificationArray11 = @[@"已认证公司",response.certification.name,response.certification.cardno,definedStr,response.certification.contact,response.certification.mobile,response.certification.email,response.certification.address,response.certification.enterprisewebsite,@"查看"];
            }
            
            [weakself.productsDetailsTableView reloadData];
//            [weakself getAllEvaluationListWithPage:@"1"];
            
        }else{
            [weakself showHint:response.msg];
        }
    } andFailBlock:^(NSError *error) {
        
    }];
}

/*
- (void)getAllEvaluationListWithPage:(NSString *)page
{
    NSString *evaluateString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kCheckOrderToEvaluationString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"page" : page,
                             @"pid" : self.pidString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:evaluateString params:params successBlock:^(id responseObject) {
        
        EvaluateResponse *response = [EvaluateResponse objectWithKeyValues:responseObject];
        
        [weakself.allEvaResponse addObject:response];
        
        for (EvaluateModel *model in response.evaluate) {
            [weakself.allEvaDataArray addObject:model];
        }
        [weakself.checkDetailTableView reloadData];
        
        
    } andFailBlock:^(NSError *error) {
        
    }];
}
*/

//立即申请
- (void)applicationCommit
{
    NSString *appString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProductHouseString];
    NSDictionary *params = @{@"id" : self.idString,
                             @"category" : self.categoryString,
                             @"token" : [self getValidateToken]
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:appString params:params successBlock:^(id responseObject) {
        BaseModel *appModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:appModel.msg];
        
        if ([appModel.code isEqualToString:@"0000"]) {
            [weakself.proDetailsCommitButton setBackgroundColor:kSelectedColor];
            [weakself.proDetailsCommitButton setTitleColor:kBlackColor forState:0];
            [weakself.proDetailsCommitButton setTitle:@"申请中" forState:0];
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
