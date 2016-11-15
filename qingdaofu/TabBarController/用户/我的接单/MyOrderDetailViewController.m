//
//  MyOrderDetailViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/11/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyOrderDetailViewController.h"

#import "CheckDetailPublishViewController.h"  //查看发布方
#import "AgreementViewController.h"  //居间协议
#import "SignProtocolViewController.h"  //签约协议
#import "OperatorListViewController.h"  //经办人列表
#import "AddProgressViewController.h"  //添加进度
#import "RequestCloseViewController.h"  //申请结案
#import "RequestEndViewController.h"  //申请终止
#import "AdditionalEvaluateViewController.h"  //评价
#import "MoreMessagesViewController.h"  //更多信息
#import "DealingCloseViewController.h"  //结清证明

#import "BaseRemindButton.h"
#import "BaseCommitView.h"

#import "NewPublishDetailsCell.h"//进度
#import "NewPublishStateCell.h"//状态
#import "MineUserCell.h"//完善信息
#import "OrderPublishCell.h"
#import "ProductCloseCell.h"  //结案

#import "PublishingResponse.h"
#import "UserNameModel.h"


#import "MyOrderDetailResponse.h"
#import "OrderModel.h"
#import "OrdersModel.h"
#import "RowsModel.h"
#import "PublishingModel.h"
#import "ApplyRecordModel.h"

@interface MyOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *myOrderDetailTableView;
@property (nonatomic,strong) BaseCommitView *processinCommitButton;

//json
@property (nonatomic,strong) NSMutableArray *myOrderDetailArray;

@end

@implementation MyOrderDetailViewController
- (void)viewWillAppear:(BOOL)animated
{
    [self getDetailMessageOfMyOrder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    [self.rightButton setHidden:YES];
    
    [self.view addSubview:self.myOrderDetailTableView];
    [self.view addSubview:self.processinCommitButton];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.myOrderDetailTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.myOrderDetailTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.processinCommitButton];
        
        [self.processinCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.processinCommitButton autoSetDimension:ALDimensionHeight toSize:kCellHeight4];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - setter and getter
- (UITableView *)myOrderDetailTableView
{
    if (!_myOrderDetailTableView) {
        _myOrderDetailTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _myOrderDetailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myOrderDetailTableView.delegate = self;
        _myOrderDetailTableView.dataSource = self;
        _myOrderDetailTableView.separatorColor = kSeparateColor;
        _myOrderDetailTableView.backgroundColor = kBackColor;
    }
    return _myOrderDetailTableView;
}

- (BaseCommitView *)processinCommitButton
{
    if (!_processinCommitButton) {
        _processinCommitButton = [BaseCommitView newAutoLayoutView];
        [_processinCommitButton.button setTitle:@"上传居间协议" forState:0];
        
        //上传居间协议，，上传签约协议，申请结案
        
        //        QDFWeakSelf;
        //        [_processinCommitButton addAction:^(UIButton *btn) {
        //
        //            if (weakself.sectionArray.count == 3) {
        //                AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
        //                agreementVC.navTitleString = @"居间协议";
        //                agreementVC.idString = weakself.idString;
        //                agreementVC.categoryString = weakself.categaryString;
        //                agreementVC.pidString = weakself.pidString;
        //                agreementVC.flagString = @"1";
        //                [weakself.navigationController pushViewController:agreementVC animated:YES];
        //
        //            }else if (weakself.sectionArray.count == 4){//签约协议
        //                SignProtocolViewController *signProtocolVC = [[SignProtocolViewController alloc] init];
        //                [weakself.navigationController pushViewController:signProtocolVC animated:YES];
        //
        //            }else if (weakself.sectionArray.count == 6){//申请结案
        //                RequestCloseViewController *requestCloseVC = [[RequestCloseViewController alloc] init];
        //                [weakself.navigationController pushViewController:requestCloseVC animated:YES];
        //            }
        //            
        //            
        //        }];
    }
    return _processinCommitButton;
}


- (NSMutableArray *)myOrderDetailArray
{
    if (!_myOrderDetailArray) {
        _myOrderDetailArray = [NSMutableArray array];
    }
    return _myOrderDetailArray;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.myOrderDetailArray.count > 0) {
        OrderModel *orderModel = self.myOrderDetailArray[0];
        OrdersModel *ordersModel = orderModel.orders;
        if ([orderModel.status integerValue] == 40) {//处理中
            if ([ordersModel.status integerValue] == 0) {
                return 3;
            }else if ([ordersModel.status integerValue] == 10) {
                return 4;
            }else if ([ordersModel.status integerValue] == 20) {
                return 6;
            }else if ([ordersModel.status integerValue] == 30) {
                return 6;
            }else{
                return 3;//已结案
            }
        }else{//处理之前
            return 3;
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.myOrderDetailArray.count > 0) {
        OrderModel *orderModel = self.myOrderDetailArray[0];
        OrdersModel *ordersModel = orderModel.orders;
        if ([orderModel.status integerValue] == 40) {
            
            if ([ordersModel.status integerValue] == 40) {//已结案
                if (section == 0) {
                    return 2;
                }
                return 1;
            }else{
                if (section == 0) {
                    return 2;
                }else if (section == 1){
                    return 4;
                }
                return 1;
            }
        }else{
            if (section == 0) {
                return 2;
            }else if (section == 2){
                return 7;
            }
            return 1;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.myOrderDetailArray.count > 0) {
        OrderModel *orderModel = self.myOrderDetailArray[0];
        OrdersModel *ordersModel = orderModel.orders;
        if ([orderModel.status integerValue] == 40) {
            if ([ordersModel.status integerValue] == 40) {
                if (indexPath.section == 0) {
                    if (indexPath.row == 0) {
                        return 72;
                    }else{
                        return kCellHeight3;
                    }
                }else if (indexPath.section == 2){
                    return 395;
                }
                return kCellHeight;
                
            }else{
                if (indexPath.section == 0) {
                    if (indexPath.row == 0) {
                        return 72;
                    }else{
                        return kCellHeight3;
                    }
                }else if (indexPath.section == 1){//112
                    return kCellHeight;
                }
                return kCellHeight;
                
            }
            
        }else{
            
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    return 72;
                }else if (indexPath.row == 1){
                    kCellHeight3;
                }
            }else if (indexPath.section == 1){
//                if ([self.status integerValue] == 20) {
//                    return 220;
//                }else{
//                    return 200;
//                }
                return 220;
            }
            return kCellHeight;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    OrderModel *orderModel = self.myOrderDetailArray[0];
    RowsModel *rowModel = orderModel.product;
    
    if ([orderModel.status integerValue] == 40) {//处理以后
        if ([orderModel.orders.status integerValue] == 40) {//已结案
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {//状态
                    identifier = @"close00";
                    NewPublishDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[NewPublishDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = kBackColor;
                    [cell.progress1 setText:@"申请中"];
                    
                    [cell.point2 setImage:[UIImage imageNamed:@"succee"] forState:0];
                    [cell.progress2 setTextColor:kTextColor];
                    [cell.line2 setBackgroundColor:kButtonColor];
                    
                    
                    [cell.point3 setImage:[UIImage imageNamed:@"succee"] forState:0];
                    [cell.progress3 setTextColor:kTextColor];
                    [cell.line3 setBackgroundColor:kButtonColor];

                    [cell.point4 setImage:[UIImage imageNamed:@"succee"] forState:0];
                    [cell.progress4 setTextColor:kTextColor];
                    
                    return cell;
                }else{//查看发布发
                    identifier = @"close01";
                    
                    OrderPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    
                    if (!cell) {
                        cell = [[OrderPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    NSString *nameStr = [NSString getValidStringFromString:orderModel.product.fabuuser.mobile toString:@"未认证"];
                    NSString *checkStr = [NSString stringWithFormat:@"发布方：%@",nameStr];
                    [cell.checkButton setTitle:checkStr forState:0];
                    [cell.contactButton setTitle:@" 联系TA" forState:0];
                    [cell.contactButton setImage:[UIImage imageNamed:@"phone_blue"] forState:0];
                    
                    //接单方详情
                    QDFWeakSelf;
                    [cell.checkButton addAction:^(UIButton *btn) {
                        [weakself checkDetailsOfPublisherWithNameStr:nameStr andOrderModel:orderModel];
                    }];
                    
                    //电话
                    [cell.contactButton addAction:^(UIButton *btn) {
                        [weakself callDetailsOfPublisherWithNameStr:nameStr andOrderModel:orderModel];
                    }];
                    
                    return cell;
                }
            }else if(indexPath.section == 1){
                identifier = @"close1";
                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell.userNameButton setTitle:@"经办人" forState:0];
                [cell.userActionButton setTitle:@"查看" forState:0];
                [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                
                return cell;
            }else{
                identifier = @"close2";
                ProductCloseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[ProductCloseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = kBackColor;
                
                NSString *code1 = [NSString stringWithFormat:@"%@\n",rowModel.number];
                NSString *code2 = @"订单已结案";
                NSString *codeStr = [NSString stringWithFormat:@"%@%@",code1,code2];
                NSMutableAttributedString *attributeCC = [[NSMutableAttributedString alloc] initWithString:codeStr];
                [attributeCC setAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, code1.length)];
                [attributeCC setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(code1.length, code2.length)];
                NSMutableParagraphStyle *stylerr = [[NSMutableParagraphStyle alloc] init];
                [stylerr setLineSpacing:kSpacePadding];
                [attributeCC addAttribute:NSParagraphStyleAttributeName value:stylerr range:NSMakeRange(0, codeStr.length)];
                [cell.codeLabel setAttributedText:attributeCC];
                
                NSString *proText1 = @"产品信息\n";
                NSString *proText2 = [NSString stringWithFormat:@"债权类型：%@\n",rowModel.categoryLabel];
                NSString *proText3;
                if ([rowModel.typeLabel isEqualToString:@"万"]) {
                    proText3 = [NSString stringWithFormat:@"固定费用：%@%@\n",rowModel.typenumLabel,rowModel.typeLabel];
                }else if ([rowModel.typeLabel isEqualToString:@"%"]){
                    proText3 = [NSString stringWithFormat:@"风险费率：%@%@\n",rowModel.typenumLabel,rowModel.typeLabel];
                }
                NSString *proText4 = [NSString stringWithFormat:@"委托金额：%@",rowModel.accountLabel];
                NSString *proTextStr = [NSString stringWithFormat:@"%@%@%@%@",proText1,proText2,proText3,proText4];
                NSMutableAttributedString *attributePP = [[NSMutableAttributedString alloc] initWithString:proTextStr];
                [attributePP setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(0, proText1.length)];
                [attributePP setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(proText1.length, proText2.length+proText3.length+proText4.length)];
                NSMutableParagraphStyle *styler = [[NSMutableParagraphStyle alloc] init];
                [styler setLineSpacing:8];
                styler.alignment = NSTextAlignmentLeft;
                [attributePP addAttribute:NSParagraphStyleAttributeName value:styler range:NSMakeRange(0, proTextStr.length)];
                [cell.productTextButton setAttributedTitle:attributePP forState:0];
                
                QDFWeakSelf;
                [cell setDidselectedBtn:^(NSInteger tag) {
                    switch (tag) {
                        case 330:{//结清证明
                            DealingCloseViewController *dealingCloseVC = [[DealingCloseViewController alloc] init];
                            dealingCloseVC.perTypeString = @"2";
                            dealingCloseVC.productDealModel = rowModel.productOrdersTerminationsApply;
                            [weakself.navigationController pushViewController:dealingCloseVC animated:YES];
                        }
                            break;
                        case 331:{//查看全部产品信息
                            MoreMessagesViewController *moreMessagesVC = [[MoreMessagesViewController alloc] init];
                            moreMessagesVC.productid = orderModel.productid;
                            [self.navigationController pushViewController:moreMessagesVC animated:YES];
                        }
                            break;
                        case 332:{//查看签约协议
                            SignProtocolViewController *signProtocolVC = [[SignProtocolViewController alloc] init];
                            signProtocolVC.ordersid = orderModel.orders.ordersid;
                            signProtocolVC.isShowString = @"0";
                            [self.navigationController pushViewController:signProtocolVC animated:YES];
                        }
                            break;
                        case 333:{//查看尽职调查
                            
                        }
                            break;
                        case 334:{//查看居间协议
                            AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
                            agreementVC.navTitleString = @"居间协议";
                            agreementVC.flagString = @"0";
                            agreementVC.productid = orderModel.productid;
                            [self.navigationController pushViewController:agreementVC animated:YES];
                        }
                            break;
                        default:
                            break;
                    }
                }];
                
                return cell;
            }
        }else if([orderModel.orders.status integerValue] == 0){//3
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {//状态
                    identifier = @"process00";
                    NewPublishDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[NewPublishDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = kBackColor;
                    [cell.progress1 setText:@"申请中"];
                    [cell.point2 setImage:[UIImage imageNamed:@"succee"] forState:0];
                    [cell.progress2 setTextColor:kTextColor];
                    [cell.line2 setBackgroundColor:kButtonColor];
                    
                    if ([orderModel.product.status integerValue] <= 20) {
                        [cell.point3 setImage:[UIImage imageNamed:@"succee"] forState:0];
                        [cell.progress3 setTextColor:kTextColor];
                        [cell.line3 setBackgroundColor:kButtonColor];
                    }else{
                        [cell.point3 setImage:[UIImage imageNamed:@"fail"] forState:0];
                        [cell.progress3 setTextColor:kRedColor];
                        [cell.line3 setBackgroundColor:kRedColor];
                    }
                    
                    return cell;
                }else{//查看发布发
                    identifier = @"processing01";
                    
                    OrderPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    
                    if (!cell) {
                        cell = [[OrderPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    NSString *nameStr = [NSString getValidStringFromString:orderModel.product.fabuuser.mobile toString:@"未认证"];
                    NSString *checkStr = [NSString stringWithFormat:@"发布方：%@",nameStr];
                    [cell.checkButton setTitle:checkStr forState:0];
                    [cell.contactButton setTitle:@" 联系TA" forState:0];
                    [cell.contactButton setImage:[UIImage imageNamed:@"phone_blue"] forState:0];
                    
                    //接单方详情
                    QDFWeakSelf;
                    [cell.checkButton addAction:^(UIButton *btn) {
                        [weakself checkDetailsOfPublisherWithNameStr:nameStr andOrderModel:orderModel];
                    }];
                    
                    //电话
                    [cell.contactButton addAction:^(UIButton *btn) {
                        [weakself callDetailsOfPublisherWithNameStr:nameStr andOrderModel:orderModel];
                    }];
                    
                    return cell;
                }
            }else if (indexPath.section == 1){//产品信息
                identifier = @"process1";
                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                NSArray *textArr = @[@"产品详情",@"债权类型",@"委托费用",@"委托金额"];
                [cell.userNameButton setTitle:textArr[indexPath.row] forState:0];
                
                if (indexPath.row == 0) {
                    [cell.userNameButton setTitleColor:kBlackColor forState:0];
                    cell.userNameButton.titleLabel.font = kBigFont;
                    
                    [cell.userActionButton setTitleColor:kLightGrayColor forState:0];
                    cell.userActionButton.titleLabel.font = kSecondFont;
                    [cell.userActionButton setTitle:@"更多信息" forState:0];
                    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                }else if (indexPath.row == 1){
                    [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
                    cell.userNameButton.titleLabel.font = kFirstFont;
                    
                    [cell.userActionButton setTitleColor:kGrayColor forState:0];
                    cell.userActionButton.titleLabel.font = kBigFont;
                    [cell.userActionButton setTitle:rowModel.categoryLabel forState:0];
                    [cell.userActionButton setImage:[UIImage imageNamed:@""] forState:0];
                }else if (indexPath.row == 2){
                    [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
                    cell.userNameButton.titleLabel.font = kFirstFont;
                    
                    [cell.userActionButton setTitleColor:kGrayColor forState:0];
                    cell.userActionButton.titleLabel.font = kBigFont;
                    
                    NSString *typenum = [NSString stringWithFormat:@"%@%@",rowModel.typenumLabel,rowModel.typeLabel];
                    [cell.userActionButton setTitle:typenum forState:0];
                    [cell.userActionButton setImage:[UIImage imageNamed:@""] forState:0];
                }else if (indexPath.row == 3){
                    [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
                    cell.userNameButton.titleLabel.font = kFirstFont;
                    
                    [cell.userActionButton setTitleColor:kGrayColor forState:0];
                    cell.userActionButton.titleLabel.font = kBigFont;
                    [cell.userActionButton setTitle:rowModel.accountLabel forState:0];
                    [cell.userActionButton setImage:[UIImage imageNamed:@""] forState:0];
                }
                
                return cell;
                
            }else{//尽职调查
                identifier = @"process2";
                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            }
        }else if ([orderModel.orders.status integerValue] == 10){//4
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {//状态
                    identifier = @"processing00";
                    NewPublishDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[NewPublishDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = kBackColor;
                    [cell.progress1 setText:@"申请中"];
                    [cell.point2 setImage:[UIImage imageNamed:@"succee"] forState:0];
                    [cell.progress2 setTextColor:kTextColor];
                    [cell.line2 setBackgroundColor:kButtonColor];
                    
                    if ([orderModel.product.status integerValue] <= 20) {
                        [cell.point3 setImage:[UIImage imageNamed:@"succee"] forState:0];
                        [cell.progress3 setTextColor:kTextColor];
                        [cell.line3 setBackgroundColor:kButtonColor];
                    }else{
                        [cell.point3 setImage:[UIImage imageNamed:@"fail"] forState:0];
                        [cell.progress3 setTextColor:kRedColor];
                        [cell.line3 setBackgroundColor:kRedColor];
                    }
                    
                    return cell;
                }else{//查看发布发
                    identifier = @"processing01";
                    
                    OrderPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    
                    if (!cell) {
                        cell = [[OrderPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    NSString *nameStr = [NSString getValidStringFromString:orderModel.product.fabuuser.mobile toString:@"未认证"];
                    NSString *checkStr = [NSString stringWithFormat:@"发布方：%@",nameStr];
                    [cell.checkButton setTitle:checkStr forState:0];
                    [cell.contactButton setTitle:@" 联系TA" forState:0];
                    [cell.contactButton setImage:[UIImage imageNamed:@"phone_blue"] forState:0];
                    
                    //接单方详情
                    QDFWeakSelf;
                    [cell.checkButton addAction:^(UIButton *btn) {
                        [weakself checkDetailsOfPublisherWithNameStr:nameStr andOrderModel:orderModel];
                    }];
                    
                    //电话
                    [cell.contactButton addAction:^(UIButton *btn) {
                        [weakself callDetailsOfPublisherWithNameStr:nameStr andOrderModel:orderModel];
                    }];
                    
                    return cell;
                }
            }else if (indexPath.section == 1){//产品信息
                identifier = @"processing1";
                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                NSArray *textArr = @[@"产品详情",@"债权类型",@"委托费用",@"委托金额"];
                [cell.userNameButton setTitle:textArr[indexPath.row] forState:0];
                
                if (indexPath.row == 0) {
                    [cell.userNameButton setTitleColor:kBlackColor forState:0];
                    cell.userNameButton.titleLabel.font = kBigFont;
                    
                    [cell.userActionButton setTitleColor:kLightGrayColor forState:0];
                    cell.userActionButton.titleLabel.font = kSecondFont;
                    [cell.userActionButton setTitle:@"更多信息" forState:0];
                    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                }else if (indexPath.row == 1){
                    [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
                    cell.userNameButton.titleLabel.font = kFirstFont;
                    
                    [cell.userActionButton setTitleColor:kGrayColor forState:0];
                    cell.userActionButton.titleLabel.font = kBigFont;
                    [cell.userActionButton setTitle:rowModel.categoryLabel forState:0];
                    [cell.userActionButton setImage:[UIImage imageNamed:@""] forState:0];
                }else if (indexPath.row == 2){
                    [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
                    cell.userNameButton.titleLabel.font = kFirstFont;
                    
                    [cell.userActionButton setTitleColor:kGrayColor forState:0];
                    cell.userActionButton.titleLabel.font = kBigFont;
                    
                    NSString *typenum = [NSString stringWithFormat:@"%@%@",rowModel.typenumLabel,rowModel.typeLabel];
                    [cell.userActionButton setTitle:typenum forState:0];
                    [cell.userActionButton setImage:[UIImage imageNamed:@""] forState:0];
                }else if (indexPath.row == 3){
                    [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
                    cell.userNameButton.titleLabel.font = kFirstFont;
                    
                    [cell.userActionButton setTitleColor:kGrayColor forState:0];
                    cell.userActionButton.titleLabel.font = kBigFont;
                    [cell.userActionButton setTitle:rowModel.accountLabel forState:0];
                    [cell.userActionButton setImage:[UIImage imageNamed:@""] forState:0];
                }
                
                return cell;
                
            }else if(indexPath.section == 2){//居间协议
                identifier = @"processing2";
                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell.userNameButton setTitle:@"居间协议" forState:0];
                [cell.userActionButton setTitle:@"查看" forState:0];
                [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                
                return cell;
                
            }else{//尽职调查
                identifier = @"processing3";
                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.userNameButton setTitle:@"尽职调查" forState:0];
                [cell.userActionButton setTitle:@"查看" forState:0];
                [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                
                return cell;
            }
        }else{//6
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {//状态
                    identifier = @"processed00";
                    NewPublishDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[NewPublishDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = kBackColor;
                    [cell.progress1 setText:@"申请中"];
                    [cell.point2 setImage:[UIImage imageNamed:@"succee"] forState:0];
                    [cell.progress2 setTextColor:kTextColor];
                    [cell.line2 setBackgroundColor:kButtonColor];
                    
                    if ([orderModel.product.status integerValue] <= 20) {
                        [cell.point3 setImage:[UIImage imageNamed:@"succee"] forState:0];
                        [cell.progress3 setTextColor:kTextColor];
                        [cell.progress3 setText:@"订单处理"];
                        [cell.line3 setBackgroundColor:kButtonColor];
                    }else{
                        [cell.point3 setImage:[UIImage imageNamed:@"fail"] forState:0];
                        [cell.progress3 setTextColor:kRedColor];
                        [cell.progress3 setText:@"已终止"];
                        [cell.line3 setBackgroundColor:kRedColor];
                    }
                    
                    return cell;
                }else{//查看发布发
                    identifier = @"processed01";
                    
                    OrderPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    
                    if (!cell) {
                        cell = [[OrderPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    NSString *nameStr = [NSString getValidStringFromString:orderModel.product.fabuuser.mobile toString:@"未认证"];
                    NSString *checkStr = [NSString stringWithFormat:@"发布方：%@",nameStr];
                    [cell.checkButton setTitle:checkStr forState:0];
                    [cell.contactButton setTitle:@" 联系TA" forState:0];
                    [cell.contactButton setImage:[UIImage imageNamed:@"phone_blue"] forState:0];
                    
                    //接单方详情
                    QDFWeakSelf;
                    [cell.checkButton addAction:^(UIButton *btn) {
                        [weakself checkDetailsOfPublisherWithNameStr:nameStr andOrderModel:orderModel];
                    }];
                    
                    //电话
                    [cell.contactButton addAction:^(UIButton *btn) {
                        [weakself callDetailsOfPublisherWithNameStr:nameStr andOrderModel:orderModel];
                    }];
                    return cell;
                }
            }else if (indexPath.section == 1){//产品信息
                identifier = @"processed1";
                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                NSArray *textArr = @[@"产品详情",@"债权类型",@"委托费用",@"委托金额"];
                [cell.userNameButton setTitle:textArr[indexPath.row] forState:0];
                
                if (indexPath.row == 0) {
                    [cell.userNameButton setTitleColor:kBlackColor forState:0];
                    cell.userNameButton.titleLabel.font = kBigFont;
                    
                    [cell.userActionButton setTitleColor:kLightGrayColor forState:0];
                    cell.userActionButton.titleLabel.font = kSecondFont;
                    [cell.userActionButton setTitle:@"更多信息" forState:0];
                    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                }else if (indexPath.row == 1){
                    [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
                    cell.userNameButton.titleLabel.font = kFirstFont;
                    
                    [cell.userActionButton setTitleColor:kGrayColor forState:0];
                    cell.userActionButton.titleLabel.font = kBigFont;
                    [cell.userActionButton setTitle:rowModel.categoryLabel forState:0];
                    [cell.userActionButton setImage:[UIImage imageNamed:@""] forState:0];
                }else if (indexPath.row == 2){
                    [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
                    cell.userNameButton.titleLabel.font = kFirstFont;
                    
                    [cell.userActionButton setTitleColor:kGrayColor forState:0];
                    cell.userActionButton.titleLabel.font = kBigFont;
                    
                    NSString *typenum = [NSString stringWithFormat:@"%@%@",rowModel.typenumLabel,rowModel.typeLabel];
                    [cell.userActionButton setTitle:typenum forState:0];
                    [cell.userActionButton setImage:[UIImage imageNamed:@""] forState:0];
                }else if (indexPath.row == 3){
                    [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
                    cell.userNameButton.titleLabel.font = kFirstFont;
                    
                    [cell.userActionButton setTitleColor:kGrayColor forState:0];
                    cell.userActionButton.titleLabel.font = kBigFont;
                    [cell.userActionButton setTitle:rowModel.accountLabel forState:0];
                    [cell.userActionButton setImage:[UIImage imageNamed:@""] forState:0];
                }
                
                return cell;
                
            }else if (indexPath.section == 2){//居间协议
                identifier = @"processed2";
                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell.userNameButton setTitle:@"居间协议" forState:0];
                [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                [cell.userActionButton setTitle:@"查看" forState:0];
                
                return cell;
            }else if (indexPath.section == 3){//签约协议
                identifier = @"processed3";
                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell.userNameButton setTitle:@"签约协议" forState:0];
                [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                [cell.userActionButton setTitle:@"查看" forState:0];
                
                return cell;
            }else if (indexPath.section == 4){//经办人
                identifier = @"processed4";
                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell.userNameButton setTitle:@"经办人" forState:0];
                [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                [cell.userActionButton setTitle:@"查看" forState:0];
                
                return cell;
            }else if(indexPath.section == 5){//尽职调查
                if (indexPath.row == 0) {
                    identifier = @"processed5";
                    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    
                    if (!cell) {
                        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    [cell.userNameButton setTitle:@"尽职调查" forState:0];
                    
                    [cell.userActionButton setHidden:NO];
                    cell.userActionButton.userInteractionEnabled = YES;
                    cell.userActionButton.layer.borderWidth = kLineWidth;
                    [cell.userActionButton setContentHorizontalAlignment:0];
                    [cell.userActionButton setTitle:@"  添加进度  " forState:0];
                    cell.userActionButton.layer.borderColor = kButtonColor.CGColor;
                    [cell.userActionButton setTitleColor:kTextColor forState:0];
                    cell.userActionButton.userInteractionEnabled = YES;
                    
//                    if ([orderModel.product.status integerValue] <= 20) {
//                    }else{
//                        cell.userActionButton.layer.borderColor = kBorderColor.CGColor;
//                        [cell.userActionButton setTitleColor:kLightGrayColor forState:0];
//                        cell.userActionButton.userInteractionEnabled = NO;
//                    }
                    
                    QDFWeakSelf;
                    [cell.userActionButton addAction:^(UIButton *btn) {
                        [weakself showHint:@"添加进度"];
                        AddProgressViewController *addProgressVC = [[AddProgressViewController alloc] init];
                        //                    paceVC.idString = weakself.idString;
                        //                    paceVC.categoryString = self.categaryString;
                        //                    paceVC.existence = @"2";
                        [weakself.navigationController pushViewController:addProgressVC animated:YES];
                    }];
                    
                    return cell;
                }
            }
        }
        
    }else{//处理之前
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                identifier = @"applying00";
                NewPublishDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[NewPublishDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = kBackColor;
                
                if ([orderModel.status integerValue] == 10) {//申请中
                    [cell.progress1 setText:@"申请中"];
                    
                }else if ([orderModel.status integerValue] == 20) {//面谈中
                    [cell.progress1 setText:@"申请中"];
                    
                    [cell.point2 setImage:[UIImage imageNamed:@"succee"] forState:0];
                    [cell.progress2 setTextColor:kTextColor];
                    [cell.line2 setBackgroundColor:kButtonColor];
                    
                }else if ([orderModel.status integerValue] == 30) {//面谈失败
                    [cell.progress1 setText:@"申请中"];
                    
                    [cell.point2 setImage:[UIImage imageNamed:@"fail"] forState:0];
                    [cell.progress2 setText:@"面谈失败"];
                    [cell.progress2 setTextColor:kRedColor];
                    [cell.line2 setBackgroundColor:kRedColor];
                }else if ([orderModel.status integerValue] == 50) {//取消申请
                    [cell.point1 setImage:[UIImage imageNamed:@"fail"] forState:0];
                    [cell.progress1 setText:@"取消申请"];
                    [cell.progress1 setTextColor:kRedColor];
                    [cell.line1 setBackgroundColor:kRedColor];
                }else if ([orderModel.status integerValue] == 60) {//申请失败
                    [cell.point1 setImage:[UIImage imageNamed:@"fail"] forState:0];
                    [cell.progress1 setText:@"申请失败"];
                    [cell.progress1 setTextColor:kRedColor];
                    [cell.line1 setBackgroundColor:kRedColor];
                }
                
                return cell;
                
            }else if (indexPath.row == 1){
                identifier = @"applying01";
                if ([orderModel.status integerValue] == 10 || [orderModel.status integerValue] == 50 || [orderModel.status integerValue] == 60) {
                    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    NSString *nameStr = [NSString getValidStringFromString:orderModel.product.fabuuser.mobile toString:@"未认证"];
                    NSString *checkStr = [NSString stringWithFormat:@"发布方：%@",nameStr];
                    [cell.userNameButton setTitle:checkStr forState:0];
                    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                    [cell.userActionButton setTitle:@"查看  " forState:0];
                    return cell;
                    
                }else if ([orderModel.status integerValue] == 20 || [orderModel.status integerValue] == 30){
                    OrderPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    
                    if (!cell) {
                        cell = [[OrderPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    NSString *nameStr = [NSString getValidStringFromString:orderModel.product.fabuuser.mobile toString:@"未认证"];
                    NSString *checkStr = [NSString stringWithFormat:@"发布方：%@",nameStr];
                    [cell.checkButton setTitle:checkStr forState:0];
                    [cell.contactButton setTitle:@" 联系TA" forState:0];
                    [cell.contactButton setImage:[UIImage imageNamed:@"phone_blue"] forState:0];
                    
                    //发布方详情
                    QDFWeakSelf;
                    [cell.checkButton addAction:^(UIButton *btn) {
                        [weakself checkDetailsOfPublisherWithNameStr:nameStr andOrderModel:orderModel];
                    }];
                    
                    //电话
                    [cell.contactButton addAction:^(UIButton *btn) {
                        [weakself callDetailsOfPublisherWithNameStr:nameStr andOrderModel:orderModel];
                    }];
                    return cell;
                }
            }
        }else if (indexPath.section == 1){
            identifier = @"applying1";
            
            NewPublishStateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[NewPublishStateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kWhiteColor;
            
            if ([orderModel.status integerValue] == 10) {
                cell.stateLabel1.text = @"申请中";
                cell.stateLabel2.text = @"申请中，等待发布方同意";
                
            }else if ([orderModel.status integerValue] == 20){
                cell.stateLabel1.text = @"等待面谈";
                
                cell.stateLabel2.numberOfLines = 0;
                NSString *staetc = @"双方联系并约见面谈，面谈后由发布方确定\n是否由您来接单";
                NSMutableAttributedString *attributeSt = [[NSMutableAttributedString alloc]initWithString:staetc];
                NSMutableParagraphStyle *syudy = [[NSMutableParagraphStyle alloc] init];
                [syudy setLineSpacing:2];
                syudy.alignment = NSTextAlignmentCenter;
                [attributeSt addAttribute:NSParagraphStyleAttributeName value:syudy range:NSMakeRange(0, staetc.length)];
                [cell.stateLabel2 setAttributedText:attributeSt];
            }else if ([orderModel.status integerValue] == 30){
                cell.stateLabel1.text = @"面谈失败";
                cell.stateLabel2.text = @"面谈失败";
            }else if ([orderModel.status integerValue] == 50){
                cell.stateLabel1.text = @"取消申请";
                cell.stateLabel2.text = @"取消申请，您可以在产品列表中再次申请";
            }else if ([orderModel.status integerValue] == 60){
                cell.stateLabel1.text = @"申请失败";
                cell.stateLabel2.text = @"申请失败";
            }
            
            return cell;
            
        }else if (indexPath.section == 2){
            identifier = @"applying2";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.userActionButton setTitleColor:kGrayColor forState:0];
            cell.userActionButton.titleLabel.font = kBigFont;
            
            NSArray *textArr = @[@"产品详情",@"债权类型",@"委托事项",@"委托金额",@"委托费用",@"违约期限",@"合同履行地"];
            [cell.userNameButton setTitle:textArr[indexPath.row] forState:0];
                        
            if (indexPath.row == 0) {
                [cell.userNameButton setTitleColor:kBlackColor forState:0];
                cell.userNameButton.titleLabel.font = kBigFont;
                [cell.userActionButton setTitle:@"" forState:0];
            }else if (indexPath.row == 1){
                [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
                cell.userNameButton.titleLabel.font = kFirstFont;
                [cell.userActionButton setTitle:orderModel.product.categoryLabel forState:0];
            }else if (indexPath.row == 2){
                [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
                cell.userNameButton.titleLabel.font = kFirstFont;
                [cell.userActionButton setTitle:orderModel.product.entrustLabel forState:0];
            }else if (indexPath.row == 3){
                [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
                cell.userNameButton.titleLabel.font = kFirstFont;
                [cell.userActionButton setTitle:orderModel.product.accountLabel forState:0];
            }else if (indexPath.row == 4){
                [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
                cell.userNameButton.titleLabel.font = kFirstFont;
                
                NSString *typenumStr = [NSString stringWithFormat:@"%@%@",orderModel.product.typenumLabel,orderModel.product.typeLabel];
                [cell.userActionButton setTitle:typenumStr forState:0];
            }else if (indexPath.row == 5){
                [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
                cell.userNameButton.titleLabel.font = kFirstFont;
                
                NSString *overdueStr = [NSString stringWithFormat:@"%@个月",orderModel.product.overdue];
                [cell.userActionButton setTitle:overdueStr forState:0];
            }else if (indexPath.row == 6){
                [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
                cell.userNameButton.titleLabel.font = kFirstFont;
                [cell.userActionButton setTitle:orderModel.product.addressLabel forState:0];
            }
            
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
    OrderModel *orderModel = self.myOrderDetailArray[0];
    
    if ([orderModel.status integerValue] == 40) {//处理之后
        if ([orderModel.orders.status integerValue] == 0) {//3
            if (indexPath.section == 1 && indexPath.row == 0) {
                MoreMessagesViewController *moreMessagesVC = [[MoreMessagesViewController alloc] init];
                moreMessagesVC.productid = orderModel.productid;
                [self.navigationController pushViewController:moreMessagesVC animated:YES];
            }
        }else if ([orderModel.orders.status integerValue] == 10){//4
            if (indexPath.section == 1 && indexPath.row == 0) {
                MoreMessagesViewController *moreMessagesVC = [[MoreMessagesViewController alloc] init];
                moreMessagesVC.productid = orderModel.productid;
                [self.navigationController pushViewController:moreMessagesVC animated:YES];
            }else if (indexPath.section == 2){
                AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
                agreementVC.navTitleString = @"居间协议";
                agreementVC.flagString = @"0";
                agreementVC.productid = orderModel.productid;
                [self.navigationController pushViewController:agreementVC animated:YES];
            }
        }else if ([orderModel.orders.status integerValue] == 20 || [orderModel.orders.status integerValue] == 30){//处理中6,已终止
            if (indexPath.section == 1 && indexPath.row == 0) {//更多信息
                MoreMessagesViewController *moreMessageVC = [[MoreMessagesViewController alloc] init];
                moreMessageVC.productid = orderModel.productid;
                [self.navigationController pushViewController:moreMessageVC animated:YES];
            }else if (indexPath.section == 2){//居间协议
                AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
                agreementVC.navTitleString = @"居间协议";
                agreementVC.flagString = @"0";
                agreementVC.productid = orderModel.productid;
                [self.navigationController pushViewController:agreementVC animated:YES];
            }else if (indexPath.section == 3){//签约协议
                SignProtocolViewController *signProtocolVC = [[SignProtocolViewController alloc] init];
                signProtocolVC.ordersid = orderModel.orders.ordersid;
                signProtocolVC.isShowString = @"0";
                [self.navigationController pushViewController:signProtocolVC animated:YES];
            }else if (indexPath.section == 4){//经办人
                OperatorListViewController *operatorListVC = [[OperatorListViewController alloc] init];
                operatorListVC.ordersid = orderModel.orders.ordersid;
                [self.navigationController pushViewController:operatorListVC animated:YES];
            }
        }else if ([orderModel.orders.status integerValue] == 40){//已结案
            if (indexPath.section == 1) {//经办人
                OperatorListViewController *operatorListVC = [[OperatorListViewController alloc] init];
                operatorListVC.ordersid = orderModel.orders.ordersid;
                [self.navigationController pushViewController:operatorListVC animated:YES];
            }
        }
    }else if ([orderModel.status integerValue] == 10 || [orderModel.status integerValue] == 50 || [orderModel.status integerValue] == 60) {//申请中，申请失败，取消申请
        if (indexPath.section == 0 && indexPath.row == 1) {//查看发布方
            CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
            checkDetailPublishVC.navTitle = @"发布方详情";
            checkDetailPublishVC.productid = orderModel.productid;
            checkDetailPublishVC.userid = orderModel.product.create_by;
            [self.navigationController pushViewController:checkDetailPublishVC animated:YES];
        }
    }
}

#pragma mark - method
- (void)getDetailMessageOfMyOrder
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrderDetailsString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"applyid" : self.applyid
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
        
        [weakself.myOrderDetailArray removeAllObjects];
        
        MyOrderDetailResponse *response = [MyOrderDetailResponse objectWithKeyValues:responseObject];
        
        OrderModel *orderModel = response.data;
        
        if ([orderModel.status integerValue] == 40) {//处理中以后
            if ([orderModel.orders.status integerValue] == 0) {
                [self.rightButton setHidden:YES];
                [weakself.processinCommitButton setHidden:NO];
                [weakself.myOrderDetailTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.processinCommitButton];
                [weakself.processinCommitButton.button setTitle:@"签订居间协议" forState:0];
                [weakself.processinCommitButton addAction:^(UIButton *btn) {
                    [weakself actionOfBottomWithType:@"1" andOrderModel:orderModel];
                }];
            }else if ([orderModel.orders.status integerValue] == 10){
                [self.rightButton setHidden:YES];
                [weakself.processinCommitButton setHidden:NO];
                [weakself.processinCommitButton.button setTitle:@"上传签约协议" forState:0];
                [weakself.processinCommitButton addAction:^(UIButton *btn) {
                    [weakself actionOfBottomWithType:@"2" andOrderModel:orderModel];
                }];
            }else if ([orderModel.orders.status integerValue] == 20){
                [self.rightButton setHidden:NO];
                [self.rightButton setTitle:@"申请终止" forState:0];
                [self.rightButton addAction:^(UIButton *btn) {
                    RequestEndViewController *requestEndVC = [[RequestEndViewController alloc] init];
                    requestEndVC.ordersid = orderModel.orders.ordersid;
                    [weakself.navigationController pushViewController:requestEndVC animated:YES];
                }];

                [weakself.processinCommitButton setHidden:NO];
                [weakself.processinCommitButton.button setTitle:@"申请结案" forState:0];
                [weakself.processinCommitButton addAction:^(UIButton *btn) {
                    [weakself actionOfBottomWithType:@"3" andOrderModel:orderModel];
                }];
                
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
                [self.rightButton setTitle:@"申请终止" forState:0];
                
            }else if ([orderModel.orders.status integerValue] == 40){
                [self.rightButton setHidden:YES];
                [weakself.processinCommitButton setHidden:NO];
                [weakself.processinCommitButton.button setTitle:@"评价" forState:0];
                [weakself.processinCommitButton addAction:^(UIButton *btn) {
                    [weakself actionOfBottomWithType:@"4" andOrderModel:orderModel];
                }];
            }else{//终止
                [self.rightButton setHidden:YES];
                [weakself.processinCommitButton setHidden:YES];
                [weakself.myOrderDetailTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
            }
        }else{//处理中以前
            [weakself.processinCommitButton setHidden:YES];
            [weakself.myOrderDetailTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
            
            if ([orderModel.status integerValue] == 10) {//申请中
                [self.rightButton setHidden:NO];
                [self.rightButton setTitle:@"取消申请" forState:0];
                [self.rightButton addTarget:self action:@selector(cancelApplyAction) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [self.rightButton setHidden:YES];
            }
        }
        
        [weakself.myOrderDetailArray addObject:orderModel];
        [weakself.myOrderDetailTableView reloadData];
        
    } andFailBlock:^(NSError *error){
        
    }];
}

- (void)rightItemAction
{
    
}


- (void)cancelApplyAction //取消申请
{
    OrderModel *orderModel = self.myOrderDetailArray[0];
    
    if ([orderModel.status integerValue] == 10) {
        [self showHint:@"取消申请"];
        NSString *rifhtString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrderDetailOfCancelApplyString];
        NSDictionary *params = @{@"applyid" : self.applyid,
                                 @"token" : [self getValidateToken]
                                 };
        QDFWeakSelf;
        [self requestDataPostWithString:rifhtString params:params successBlock:^(id responseObject) {
            
            BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
            [weakself showHint:baseModel.msg];
            
            if ([baseModel.code isEqualToString:@"0000"]) {
                [weakself getDetailMessageOfMyOrder];
            }
            
        } andFailBlock:^(NSError *error) {
            
        }];
    }else if([orderModel.status integerValue] == 40 && [orderModel.orders.status integerValue] == 20){
        [self showHint:@"申请终止"];
        RequestEndViewController *requestEndVC = [[RequestEndViewController alloc] init];
        requestEndVC.ordersid = orderModel.orders.ordersid;
        [self.navigationController pushViewController:requestEndVC animated:YES];
    }
}

- (void)actionOfBottomWithType:(NSString *)actType andOrderModel:(OrderModel *)orderModel//1-确认居间协议，2-上传签约协议，3-申请结案
{
    if ([actType integerValue] == 1) {
        AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
        agreementVC.navTitleString = @"居间协议";
        agreementVC.productid = orderModel.productid;
        agreementVC.ordersid = orderModel.orders.ordersid;
        agreementVC.flagString = @"1";
        [self.navigationController pushViewController:agreementVC animated:YES];
    }else if ([actType integerValue] == 2){
        [self showHint:@"上传签约协议"];
        SignProtocolViewController *signProtocolVC = [[SignProtocolViewController alloc] init];
        signProtocolVC.ordersid = orderModel.orders.ordersid;
        signProtocolVC.isShowString = @"1";
        [self.navigationController pushViewController:signProtocolVC animated:YES];
    }else if([actType integerValue] == 3){
        [self showHint:@"申请结案"];
        RequestCloseViewController *requestCloseVC = [[RequestCloseViewController alloc] init];
        requestCloseVC.ordersid = orderModel.orders.ordersid;
        [self.navigationController pushViewController:requestCloseVC animated:YES];
        
    }else{//评价
        AdditionalEvaluateViewController *additionalEvaluateVC = [[AdditionalEvaluateViewController alloc] init];
        additionalEvaluateVC.ordersid = orderModel.orders.ordersid;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:additionalEvaluateVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)checkDetailsOfPublisherWithNameStr:(NSString *)nameStr andOrderModel:(OrderModel *)orderModel
{
    if ([nameStr isEqualToString:@"未认证"]) {
        [self showHint:@"发布方未认证，不能查看相关信息"];
    }else{
        CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
        checkDetailPublishVC.navTitle = @"发布方详情";
        checkDetailPublishVC.productid = orderModel.productid;
        checkDetailPublishVC.userid = orderModel.product.create_by;
        [self.navigationController pushViewController:checkDetailPublishVC animated:YES];
    }
}

- (void)callDetailsOfPublisherWithNameStr:(NSString *)nameStr andOrderModel:(OrderModel *)orderModel
{
    if ([nameStr isEqualToString:@"未认证"]) {
        [self showHint:@"发布方未认证，不能打电话"];
    }else{
        NSMutableString *phone = [NSMutableString stringWithFormat:@"telprompt://%@",orderModel.product.fabuuser.mobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
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
