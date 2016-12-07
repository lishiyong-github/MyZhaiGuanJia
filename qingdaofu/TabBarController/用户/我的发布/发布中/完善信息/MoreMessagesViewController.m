//
//  MoreMessagesViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/11/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MoreMessagesViewController.h"
#import "ReportSuitViewController.h"  //编辑
#import "BrandsViewController.h"  //机动车品牌选择
#import "HouseViewController.h"  //抵押物地址

#import "MineUserCell.h"
#import "BidOneCell.h"
#import "AgentCell.h"

#import "PublishingResponse.h"
#import "RowsModel.h"

#import "UIViewController+BlurView.h"

@interface MoreMessagesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *moreMessageTableView;

//json
@property (nonatomic,strong) NSMutableArray *moreMessageArray;
@property (nonatomic,strong) NSMutableDictionary *productDic;  //显示额外添加信息（添加抵押物地址，添加机动车抵押类型，添加合同纠纷类型）

//params
@property (nonatomic,strong) NSMutableDictionary *addMoreDic;

@end

@implementation MoreMessagesViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self getMoreMessagesOfProduct];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.moreMessageTableView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.moreMessageTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)moreMessageTableView
{
    if (!_moreMessageTableView) {
        _moreMessageTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _moreMessageTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _moreMessageTableView.backgroundColor = kBackColor;
        _moreMessageTableView.separatorColor = kSeparateColor;
        _moreMessageTableView.delegate = self;
        _moreMessageTableView.dataSource = self;
    }
    return _moreMessageTableView;
}

- (NSMutableArray *)moreMessageArray
{
    if (!_moreMessageArray) {
        _moreMessageArray = [NSMutableArray array];
    }
    return _moreMessageArray;
}

- (NSMutableDictionary *)productDic
{
    if (!_productDic) {
        _productDic = [NSMutableDictionary dictionary];
    }
    return _productDic;
}

- (NSMutableDictionary *)addMoreDic
{
    if (!_addMoreDic) {
        _addMoreDic = [NSMutableDictionary dictionary];
    }
    return _addMoreDic;
}

#pragma mark - delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.moreMessageArray.count > 0) {
        return 1+self.productDic.allKeys.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    }else{
        RowsModel *rowModel = self.moreMessageArray[0];
        //房产抵押，机动车抵押，合同纠纷
        if ([rowModel.statusLabel containsString:@"发布"] || [rowModel.statusLabel containsString:@"面谈"]) {
            if (!self.productDic[@"house"]) {//房产抵押
                if (!self.productDic[@"car"]) {//机动车抵押
                    if (self.productDic[@"contract"]) {//合同纠纷
                        return 1+rowModel.productMortgages3.count;
                    }
                }else{
                    if (!self.productDic[@"contract"]) {
                        return 1+rowModel.productMortgages2.count;
                    }else{
                        if (section == 1) {
                            return 1+rowModel.productMortgages2.count;
                        }else{
                            return 1+rowModel.productMortgages3.count;
                        }
                    }
                }
            }else{
                if (!self.productDic[@"car"]) {
                    if (!self.productDic[@"contract"]) {
                        return 1+rowModel.productMortgages1.count;
                    }else{
                        if (section == 1) {
                            return 1+rowModel.productMortgages1.count;
                        }else{
                            return 1+rowModel.productMortgages3.count;
                        }
                    }
                }else{
                    if (!self.productDic[@"contract"]) {
                        if (section == 1) {
                            return 1+rowModel.productMortgages1.count;
                        }else{
                            return 1+rowModel.productMortgages2.count;
                        }
                    }else{
                        if (section == 1) {
                            return 1+rowModel.productMortgages1.count;
                        }else if(section == 2){
                            return 1+rowModel.productMortgages2.count;
                        }else{
                            return 1+rowModel.productMortgages3.count;
                        }
                    }
                }
            }
        }else{
            if (section == 1){
                return rowModel.productMortgages1.count;
            }else if (section == 2){
                return rowModel.productMortgages2.count;
            }else{
                return rowModel.productMortgages3.count;
            }
        }
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
    if (indexPath.section == 0) {
        identifier = @"moreMes0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        RowsModel *dataModel = self.moreMessageArray[0];
        
        NSArray *www;
        if ([dataModel.typeLabel isEqualToString:@"万"]) {
            www = @[@"基本信息",@"债权类型",@"委托事项",@"委托金额",@"固定费用",@"违约期限",@"合同履行地"];
        }else if([dataModel.typeLabel isEqualToString:@"%"]){
            www = @[@"基本信息",@"债权类型",@"委托事项",@"委托金额",@"风险费率",@"违约期限",@"合同履行地"];
        }
        [cell.userNameButton setTitle:www[indexPath.row] forState:0];
        
        if (indexPath.row == 0) {
            [cell.userNameButton setTitleColor:kBlackColor forState:0];
            cell.userNameButton.titleLabel.font = kBigFont;
            [cell.userActionButton setTitleColor:kTextColor forState:0];
            cell.userActionButton.titleLabel.font = kBigFont;
            
            if ([dataModel.statusLabel containsString:@"发布"] || [dataModel.statusLabel containsString:@"面谈"]) {
                [cell.userActionButton setTitle:@"编辑" forState:0];
                cell.userActionButton.userInteractionEnabled = YES;
                
                QDFWeakSelf;
                [cell.userActionButton addAction:^(UIButton *btn) {
                    ReportSuitViewController *reportSuitVC = [[ReportSuitViewController alloc] init];
                    reportSuitVC.tagString = @"3";
                    reportSuitVC.productid = dataModel.productid;
                    UINavigationController *nabb = [[UINavigationController alloc] initWithRootViewController:reportSuitVC];
                    [weakself presentViewController:nabb animated:YES completion:nil];
                }];
            }else{
                [cell.userActionButton setTitle:@"" forState:0];
            }
        }else {
            [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
            cell.userNameButton.titleLabel.font = kFirstFont;
            [cell.userActionButton setTitleColor:kGrayColor forState:0];
            cell.userActionButton.titleLabel.font = kBigFont;
            
            if (indexPath.row == 1){
                [cell.userActionButton setTitle:dataModel.categoryLabel forState:0];
            }else if (indexPath.row == 2){
                [cell.userActionButton setTitle:dataModel.entrustLabel forState:0];
            }else if (indexPath.row == 3){
                NSString *accc = [NSString stringWithFormat:@"%@万",dataModel.accountLabel];
                [cell.userActionButton setTitle:accc forState:0];
            }else if (indexPath.row == 4){
                NSString *tytenum = [NSString stringWithFormat:@"%@%@",dataModel.typenumLabel,dataModel.typeLabel];
                [cell.userActionButton setTitle:tytenum forState:0];
            }else if (indexPath.row == 5){
                NSString *overdue = [NSString stringWithFormat:@"%@个月",dataModel.overdue];
                [cell.userActionButton setTitle:overdue forState:0];
            }else if (indexPath.row == 6){
                [cell.userActionButton setTitle:dataModel.addressLabel forState:0];
            }
        }
        return cell;
    }else{
        //剩余section
        RowsModel *rowModel = self.moreMessageArray[0];
        
        if ([rowModel.statusLabel containsString:@"发布"] || [rowModel.statusLabel containsString:@"面谈"]) {//可以添加
            
            if (!self.productDic[@"house"]) {
                if (!self.productDic[@"car"]) {
                    if (self.productDic[@"contract"]) {//
                        
                    }
                }else{
                    if (!self.productDic[@"contract"]) {
                        
                    }else{
                        
                    }
                }
            }else{
                if (!self.productDic[@"car"]) {
                    if (!self.productDic[@"contract"]) {
                        
                    }else{
                        
                    }
                }else{
                    if (!self.productDic[@"contract"]) {
                        
                    }else{
                        
                    }
                }
            }
            
            /*
            if (self.productDic[@"house"]) {
                if (indexPath.row == rowModel.productMortgages1.count) {
                    //最后一行，显示添加按钮
                    identifier = @"house1";
                    BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell.oneButton setTitleColor:kLightGrayColor forState:0];
                    cell.oneButton.titleLabel.font = kSecondFont;
                    cell.oneButton.userInteractionEnabled = NO;
                    [cell.oneButton setTitle:@"添加抵押物地址信息" forState:0];

                    return cell;
                }else{//剩余行，显示添加的内容
                    identifier = @"house0";
                    AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.leftdAgentContraints.constant = 100;
                    cell.agentTextField.userInteractionEnabled = NO;
                    cell.agentLabel.text = @"抵押物地址";
                    cell.agentLabel.textColor = kLightGrayColor;
                    
                    MoreMessageModel *moreMeodel = [MoreMessageModel objectWithKeyValues:rowModel.productMortgages1[indexPath.row]];
                    cell.agentTextField.text = moreMeodel.addressLabel;
                    [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                    
                    return cell;
                }
            }
            
            if (self.productDic[@"car"]) {
                if (indexPath.row == rowModel.productMortgages2.count) {
                    identifier = @"car1";
                    BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell.oneButton setTitleColor:kLightGrayColor forState:0];
                    cell.oneButton.titleLabel.font = kSecondFont;
                    cell.oneButton.userInteractionEnabled = NO;
                    [cell.oneButton setTitle:@"添加机动车信息" forState:0];

                    return cell;
                }else{
                    identifier = @"car0";
                    AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.leftdAgentContraints.constant = 100;
                    cell.agentTextField.userInteractionEnabled = NO;
                    cell.agentLabel.text = @"机动车抵押";
                    cell.agentLabel.textColor = kLightGrayColor;
                    
                    MoreMessageModel *moreModel = [MoreMessageModel objectWithKeyValues:rowModel.productMortgages2[indexPath.row]];
                    cell.agentTextField.text = moreModel.brandLabel;
                    [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                    
                    return cell;
                }
            }
            
            if (self.productDic[@"contract"]) {
                if (indexPath.row == rowModel.productMortgages3.count) {
                    identifier = @"contract1";
                    BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell.oneButton setTitleColor:kLightGrayColor forState:0];
                    cell.oneButton.titleLabel.font = kSecondFont;
                    cell.oneButton.userInteractionEnabled = NO;
                    [cell.oneButton setTitle:@"添加合同纠纷类型" forState:0];

                    return cell;
                }else{
                    identifier = @"contract0";
                    AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.leftdAgentContraints.constant = 100;
                    cell.agentTextField.userInteractionEnabled = NO;
                    cell.agentLabel.text = @"合同纠纷";
                    cell.agentLabel.textColor = kLightGrayColor;
                    
                    MoreMessageModel *moreModel = [MoreMessageModel objectWithKeyValues:rowModel.productMortgages3[indexPath.row]];
                    cell.agentTextField.text = moreModel.contractLabel;
                    [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                    
                    return cell;
                }
            }
             */
            
//            if (indexPath.section == 1) {//房产抵押，机动车抵押，合同纠纷
//                if (indexPath.row == rowModel.productMortgages1.count) {
//                    //最后一行，显示添加按钮
//                    identifier = @"house1";
//                    BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//                    if (!cell) {
//                        cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//                    }
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    [cell.oneButton setTitleColor:kLightGrayColor forState:0];
//                    cell.oneButton.titleLabel.font = kSecondFont;
//                    cell.oneButton.userInteractionEnabled = NO;
//                    [cell.oneButton setTitle:@"添加抵押物地址信息" forState:0];
//                    
//                    return cell;
//                }else{//剩余行，显示添加的内容
//                    identifier = @"house0";
//                    AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//                    if (!cell) {
//                        cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//                    }
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    cell.leftdAgentContraints.constant = 100;
//                    cell.agentTextField.userInteractionEnabled = NO;
//                    cell.agentLabel.text = @"抵押物地址";
//                    cell.agentLabel.textColor = kLightGrayColor;
//                    
//                    MoreMessageModel *moreMeodel = [MoreMessageModel objectWithKeyValues:rowModel.productMortgages1[indexPath.row]];
//                    cell.agentTextField.text = moreMeodel.addressLabel;
//                    [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
//                    
//                    return cell;
//                }
//            }else if (indexPath.section == 2){
//                if (indexPath.row == rowModel.productMortgages2.count) {
//                    identifier = @"car1";
//                    BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//                    if (!cell) {
//                        cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//                    }
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    [cell.oneButton setTitleColor:kLightGrayColor forState:0];
//                    cell.oneButton.titleLabel.font = kSecondFont;
//                    cell.oneButton.userInteractionEnabled = NO;
//                    [cell.oneButton setTitle:@"添加机动车信息" forState:0];
//                    
//                    return cell;
//                }else{
//                    identifier = @"car0";
//                    AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//                    if (!cell) {
//                        cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//                    }
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    cell.leftdAgentContraints.constant = 100;
//                    cell.agentTextField.userInteractionEnabled = NO;
//                    cell.agentLabel.text = @"机动车抵押";
//                    cell.agentLabel.textColor = kLightGrayColor;
//                    
//                    MoreMessageModel *moreModel = [MoreMessageModel objectWithKeyValues:rowModel.productMortgages2[indexPath.row]];
//                    cell.agentTextField.text = moreModel.brandLabel;
//                    [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
//                    
//                    return cell;
//                }
//                
//            }else if (indexPath.section == 3){
//                if (indexPath.row == rowModel.productMortgages3.count) {
//                    identifier = @"contract1";
//                    BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//                    if (!cell) {
//                        cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//                    }
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    [cell.oneButton setTitleColor:kLightGrayColor forState:0];
//                    cell.oneButton.titleLabel.font = kSecondFont;
//                    cell.oneButton.userInteractionEnabled = NO;
//                    [cell.oneButton setTitle:@"添加合同纠纷类型" forState:0];
//                    
//                    return cell;
//                }else{
//                    identifier = @"contract0";
//                    AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//                    if (!cell) {
//                        cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//                    }
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    cell.leftdAgentContraints.constant = 100;
//                    cell.agentTextField.userInteractionEnabled = NO;
//                    cell.agentLabel.text = @"合同纠纷";
//                    cell.agentLabel.textColor = kLightGrayColor;
//                    
//                    MoreMessageModel *moreModel = [MoreMessageModel objectWithKeyValues:rowModel.productMortgages3[indexPath.row]];
//                    cell.agentTextField.text = moreModel.contractLabel;
//                    [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
//                    
//                    return cell;
//                }
//            }
            
        }else{//无添加功能(处理终止结案)
            if (rowModel.productMortgages1.count > 0) {
                if (indexPath.section == 1) {
                    identifier = @"moreMes1";
                    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    [cell.userNameButton setTitle:@"房产抵押" forState:0];
                    
                    return cell;
                }
                
            }
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kBigPadding;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RowsModel *rowModel = self.moreMessageArray[0];;
    if ([rowModel.statusLabel containsString:@"发布"] || [rowModel.statusLabel containsString:@"面谈"]){
        
    if (!self.productDic[@"house"]) {//房产抵押
        if (!self.productDic[@"car"]) {//机动车抵押
            if (self.productDic[@"contract"]) {//合同纠纷
//                return 1+rowModel.productMortgages3.count;
                if (indexPath.section == 1) {
                    if (indexPath.row == rowModel.productMortgages3.count) {
                        [self showHint:@"添加合同纠纷"];
                    }else{
                        [self showHint:@"编辑合同纠纷"];
                    }
                }
            }
        }else{
            if (!self.productDic[@"contract"]) {
//                return 1+rowModel.productMortgages2.count;
                if (indexPath.section == 1) {
                    if (indexPath.row == rowModel.productMortgages2.count) {
                        [self showHint:@"添加机动车抵押"];
                    }else{
                        [self showHint:@"编辑机动车抵押"];
                    }
                }
            }else{
                if (indexPath.section == 1) {
//                    return 1+rowModel.productMortgages2.count;
                    if (indexPath.row == rowModel.productMortgages2.count) {
                        [self showHint:@"添加机动车抵押"];
                    }else{
                        [self showHint:@"编辑机动车抵押"];
                    }
                }else if(indexPath.section == 2){
//                    return 1+rowModel.productMortgages3.count;
                    if (indexPath.row == rowModel.productMortgages3.count) {
                        [self showHint:@"添加合同纠纷"];
                    }else{
                        [self showHint:@"编辑合同纠纷"];
                    }
                }
            }
        }
    }else{
        if (!self.productDic[@"car"]) {
            if (!self.productDic[@"contract"]) {
//                return 1+rowModel.productMortgages1.count;
                if (indexPath.section == 1) {
                    if (indexPath.row == rowModel.productMortgages1.count) {
                        [self showHint:@"添加房产抵押"];
                    }else{
                        [self showHint:@"编辑房产抵押"];
                    }
                }
            }else{
                if (indexPath.section == 1) {
//                    return 1+rowModel.productMortgages1.count;
                    if (indexPath.row == rowModel.productMortgages1.count) {
                        [self showHint:@"添加房产抵押"];
                    }else{
                        [self showHint:@"编辑房产抵押"];
                    }
                }else if(indexPath.section == 2){
//                    return 1+rowModel.productMortgages3.count;
                    if (indexPath.row == rowModel.productMortgages3.count) {
                        [self showHint:@"添加合同纠纷"];
                    }else{
                        [self showHint:@"编辑合同纠纷"];
                    }
                }
            }
        }else{
            if (!self.productDic[@"contract"]) {
                if (indexPath.section == 1) {
//                    return 1+rowModel.productMortgages1.count;
                    if (indexPath.row == rowModel.productMortgages1.count) {
                        [self showHint:@"添加房产抵押"];
                    }else{
                        [self showHint:@"编辑房产抵押"];
                    }
                }else if(indexPath.section == 2){
//                    return 1+rowModel.productMortgages2.count;
                    if (indexPath.row == rowModel.productMortgages2.count) {
                        [self showHint:@"添加机动车抵押"];
                    }else{
                        [self showHint:@"编辑机动车抵押"];
                    }

                }
            }else{
                if (indexPath.section == 1) {
//                    return 1+rowModel.productMortgages1.count;
                    if (indexPath.row == rowModel.productMortgages1.count) {
                        [self showHint:@"添加房产抵押"];
                    }else{
                        [self showHint:@"编辑房产抵押"];
                    }
                }else if(indexPath.section == 2){
//                    return 1+rowModel.productMortgages2.count;
                    if (indexPath.row == rowModel.productMortgages2.count) {
                        [self showHint:@"添加机动车抵押"];
                    }else{
                        [self showHint:@"编辑机动车抵押"];
                    }
                }else if(indexPath.section == 3){
//                    return 1+rowModel.productMortgages3.count;
                    if (indexPath.row == rowModel.productMortgages3.count) {
                        [self showHint:@"添加合同纠纷"];
                    }else{
                        [self showHint:@"编辑合同纠纷"];
                    }

                }
            }
        }
    }
        
        /*
        QDFWeakSelf;
        if (indexPath.section == 1) {//房产抵押
            if (indexPath.row == rowModel.productMortgages1.count) {
                [self showBlurInView:self.view withType:@"添加" andCategory:@"房产抵押" andModel:nil finishBlock:^(NSInteger btnTag){
                    switch (btnTag) {
                        case 52:{//选择地区
                            HouseViewController *houseVC = [[HouseViewController alloc] init];
                            [weakself.navigationController pushViewController:houseVC animated:YES];
                        }
                            break;
                        case 53:{//保存
                            [weakself.addMoreDic setValue:@"310000" forKey:@"relation_1"];//省
                            [weakself.addMoreDic setValue:@"310100" forKey:@"relation_2"];//市
                            [weakself.addMoreDic setValue:@"310115" forKey:@"relation_3"];//区
                            [weakself.addMoreDic setValue:@"直向投资管理有限公司" forKey:@"relation_desc"];//详细地址
                            [weakself.addMoreDic setValue:@"1" forKey:@"type"];

                            [weakself addMoreMessages];
                        }
                            break;
                        default:
                            break;
                    }
                }];
            }else{
                MoreMessageModel *moreModel = [MoreMessageModel objectWithKeyValues:rowModel.productMortgages1[indexPath.row]];
                [self showBlurInView:self.view withType:@"编辑" andCategory:@"房产抵押" andModel:moreModel finishBlock:^(NSInteger btnTag){
                    switch (btnTag) {
                        case 52:{//选择地区
                            
                        }
                            break;
                        case 54:{//保存
                            [weakself.addMoreDic setValue:@"310000" forKey:@"relation_1"];//省
                            [weakself.addMoreDic setValue:@"310100" forKey:@"relation_2"];//市
                            [weakself.addMoreDic setValue:@"310115" forKey:@"relation_3"];//区
                            [weakself.addMoreDic setValue:@"清道夫" forKey:@"relation_desc"];//详细地址
                            [weakself.addMoreDic setValue:@"1" forKey:@"type"];
                            [weakself editMoremessagesWithModel:moreModel];
                        }
                            break;
                        case 55:{//删除
                            [weakself deleteMoreMessagesWithModel:moreModel];
                        }
                            break;
                        default:
                            break;
                    }
                }];
            }
        }else if(indexPath.section == 2){//机动车抵押
            if (indexPath.row == rowModel.productMortgages2.count) {
                //添加
                [self showBlurInView:nil withType:@"添加" andCategory:@"机动车抵押" andModel:nil finishBlock:^(NSInteger btnTag){
                    switch (btnTag) {
                        case 52:{//选择机动车抵押
                            BrandsViewController *brandsVC = [[BrandsViewController alloc] init];
                            [weakself.navigationController pushViewController:brandsVC animated:YES];
                            
                            [brandsVC setDidSelectedRow:^(NSString *provinceId, NSString *provinceName, NSString *cityId, NSString *cityName, NSString *areaId, NSString *areaName) {
                                
                                //params
                                [weakself.addMoreDic setValue:provinceId forKey:@"relation_1"];
                                [weakself.addMoreDic setValue:cityId forKey:@"relation_2"];
                                [weakself.addMoreDic setValue:areaId forKey:@"relation_3"];
                                [weakself.addMoreDic setValue:@"2" forKey:@"type"];
                                
                            }];
                        }
                            break;
                        case 53:{//保存
                            [weakself addMoreMessages];
                        }
                        default:
                            break;
                    }
                }];
            }else{//剩余行
                MoreMessageModel *moreModel2 = [MoreMessageModel objectWithKeyValues:rowModel.productMortgages2[indexPath.row]];

                [self showBlurInView:nil withType:@"编辑" andCategory:@"机动车抵押" andModel:moreModel2 finishBlock:^(NSInteger btnTag){
                    switch (btnTag) {
                        case 52:{//选择机动车抵押
                            BrandsViewController *brandsVC = [[BrandsViewController alloc] init];
                            [weakself.navigationController pushViewController:brandsVC animated:YES];
                            
                            [brandsVC setDidSelectedRow:^(NSString *provinceId, NSString *provinceName, NSString *cityId, NSString *cityName, NSString *areaId, NSString *areaName) {
                                
                                //params
                                [weakself.addMoreDic setValue:provinceId forKey:@"relation_1"];
                                [weakself.addMoreDic setValue:cityId forKey:@"relation_2"];
                                [weakself.addMoreDic setValue:areaId forKey:@"relation_3"];
                                [weakself.addMoreDic setValue:@"2" forKey:@"type"];
                                
                                //                                [weakself showBlurInView:nil withType:@"添加" andCategory:@"机动车抵押" andModel:nil finishBlock:nil];
                                
                            }];
                        }
                            break;
                        case 54:{
                            [weakself.addMoreDic setValue:@"2" forKey:@"type"];
                            [weakself editMoremessagesWithModel:moreModel2];
                        }
                            break;
                        case 55:{
                            [weakself deleteMoreMessagesWithModel:moreModel2];
                        }
                            break;
                        default:
                            break;
                    }
                }];
            }
        }else if (indexPath.section == 3){//合同纠纷
            if (indexPath.row == rowModel.productMortgages3.count) {
                
                [self showBlurInView:nil withType:@"添加" andCategory:@"合同纠纷" andModel:nil finishBlock:^(NSInteger btnTag){
                    switch (btnTag) {
                        case 52:{
                            
                        }
                            break;
                        case 53:{
                            [weakself.addMoreDic setValue:@"1" forKey:@"relation_1"];
                            [weakself.addMoreDic setValue:@"3" forKey:@"type"];
                            
                            [weakself addMoreMessages];
                        }
                            break;
                        default:
                            break;
                    }
                }];
                
            }else{
                MoreMessageModel *moreModel3 = [MoreMessageModel objectWithKeyValues:rowModel.productMortgages3[indexPath.row]];
                [self showBlurInView:nil withType:@"编辑" andCategory:@"合同纠纷" andModel:moreModel3 finishBlock:^(NSInteger btnTag){
                    switch (btnTag) {
                        case 52:{
                            
                        }
                            break;
                        case 54:{
                            [self.addMoreDic setValue:@"3" forKey:@"type"];
                            [self editMoremessagesWithModel:moreModel3];
                        }
                            break;
                        case 55:{
                            [self deleteMoreMessagesWithModel:moreModel3];
                        }
                            break;
                        default:
                            break;
                    }
                }];
            }
        }*/
    }
         
}

#pragma mark - method
- (void)getMoreMessagesOfProduct
{
    NSString *moreString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailOfMoreMessages];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"productid" : self.productid
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:moreString params:params successBlock:^(id responseObject) {
                
        [weakself.moreMessageArray removeAllObjects];
        
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        
        //navigation title
        weakself.title = response.data.number;
        
        RowsModel *rowModel = response.data;
        
        if ([rowModel.category containsString:@"1"]) {
            [weakself.productDic setValue:rowModel.productMortgages1 forKey:@"house"];
        }
        if ([rowModel.category containsString:@"2"]) {
            [weakself.productDic setValue:rowModel.productMortgages2 forKey:@"car"];
        }
        if ([rowModel.category containsString:@"3"]) {
            [weakself.productDic setValue:rowModel.productMortgages3 forKey:@"contract"];
        }
        
        [weakself.moreMessageArray addObject:rowModel];
        
        [weakself.moreMessageTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)showDetailBlurViewWithType:(NSString *)type andCategory:(NSString *)category  andModel:(RowsModel *)rowModel andIndexRow:(NSInteger)indexRow
{
    QDFWeakSelf;

    //添加房产抵押
    [self showBlurInView:self.view withType:@"添加" andCategory:@"房产抵押" andModel:nil finishBlock:^(NSInteger btnTag){
        switch (btnTag) {
            case 52:{//选择地区
                HouseViewController *houseVC = [[HouseViewController alloc] init];
                [weakself.navigationController pushViewController:houseVC animated:YES];
            }
                break;
            case 53:{//保存
                [weakself.addMoreDic setValue:@"310000" forKey:@"relation_1"];//省
                [weakself.addMoreDic setValue:@"310100" forKey:@"relation_2"];//市
                [weakself.addMoreDic setValue:@"310115" forKey:@"relation_3"];//区
                [weakself.addMoreDic setValue:@"直向投资管理有限公司" forKey:@"relation_desc"];//详细地址
                [weakself.addMoreDic setValue:@"1" forKey:@"type"];
                
                [weakself addMoreMessages];
            }
                break;
            default:
                break;
        }
    }];
    
    //编辑房产抵押
    MoreMessageModel *moreModel = [MoreMessageModel objectWithKeyValues:rowModel.productMortgages1[indexRow]];
    [self showBlurInView:self.view withType:@"编辑" andCategory:@"房产抵押" andModel:moreModel finishBlock:^(NSInteger btnTag){
        switch (btnTag) {
            case 52:{//选择地区
                
            }
                break;
            case 54:{//保存
                [weakself.addMoreDic setValue:@"310000" forKey:@"relation_1"];//省
                [weakself.addMoreDic setValue:@"310100" forKey:@"relation_2"];//市
                [weakself.addMoreDic setValue:@"310115" forKey:@"relation_3"];//区
                [weakself.addMoreDic setValue:@"清道夫" forKey:@"relation_desc"];//详细地址
                [weakself.addMoreDic setValue:@"1" forKey:@"type"];
                [weakself editMoremessagesWithModel:moreModel];
            }
                break;
            case 55:{//删除
                [weakself deleteMoreMessagesWithModel:moreModel];
            }
                break;
            default:
                break;
        }
    }];
    
    //添加机动车抵押
    [self showBlurInView:self.view withType:@"添加" andCategory:@"房产抵押" andModel:nil finishBlock:^(NSInteger btnTag){
        switch (btnTag) {
            case 52:{//选择地区
                HouseViewController *houseVC = [[HouseViewController alloc] init];
                [weakself.navigationController pushViewController:houseVC animated:YES];
            }
                break;
            case 53:{//保存
                [weakself.addMoreDic setValue:@"310000" forKey:@"relation_1"];//省
                [weakself.addMoreDic setValue:@"310100" forKey:@"relation_2"];//市
                [weakself.addMoreDic setValue:@"310115" forKey:@"relation_3"];//区
                [weakself.addMoreDic setValue:@"直向投资管理有限公司" forKey:@"relation_desc"];//详细地址
                [weakself.addMoreDic setValue:@"1" forKey:@"type"];
                
                [weakself addMoreMessages];
            }
                break;
            default:
                break;
        }
    }];
    
    //编辑机动车抵押
    MoreMessageModel *moreModel2 = [MoreMessageModel objectWithKeyValues:rowModel.productMortgages2[indexRow]];
    
    [self showBlurInView:nil withType:@"编辑" andCategory:@"机动车抵押" andModel:moreModel2 finishBlock:^(NSInteger btnTag){
        switch (btnTag) {
            case 52:{//选择机动车抵押
                BrandsViewController *brandsVC = [[BrandsViewController alloc] init];
                [weakself.navigationController pushViewController:brandsVC animated:YES];
                
                [brandsVC setDidSelectedRow:^(NSString *provinceId, NSString *provinceName, NSString *cityId, NSString *cityName, NSString *areaId, NSString *areaName) {
                    
                    //params
                    [weakself.addMoreDic setValue:provinceId forKey:@"relation_1"];
                    [weakself.addMoreDic setValue:cityId forKey:@"relation_2"];
                    [weakself.addMoreDic setValue:areaId forKey:@"relation_3"];
                    [weakself.addMoreDic setValue:@"2" forKey:@"type"];
                    
                    //                                [weakself showBlurInView:nil withType:@"添加" andCategory:@"机动车抵押" andModel:nil finishBlock:nil];
                    
                }];
            }
                break;
            case 54:{
                [weakself.addMoreDic setValue:@"2" forKey:@"type"];
                [weakself editMoremessagesWithModel:moreModel2];
            }
                break;
            case 55:{
                [weakself deleteMoreMessagesWithModel:moreModel2];
            }
                break;
            default:
                break;
        }
    }];
    
    //添加合同纠纷
    [self showBlurInView:nil withType:@"添加" andCategory:@"合同纠纷" andModel:nil finishBlock:^(NSInteger btnTag){
            switch (btnTag) {
                case 52:{

                }
                    break;
                case 53:{
                    [weakself.addMoreDic setValue:@"1" forKey:@"relation_1"];
                    [weakself.addMoreDic setValue:@"3" forKey:@"type"];

                    [weakself addMoreMessages];
                }
                    break;
                default:
                    break;
            }
        }];
    
    //编辑合同纠纷
    MoreMessageModel *moreModel3 = [MoreMessageModel objectWithKeyValues:rowModel.productMortgages3[indexRow]];
    [self showBlurInView:nil withType:@"编辑" andCategory:@"合同纠纷" andModel:moreModel3 finishBlock:^(NSInteger btnTag){
        switch (btnTag) {
            case 52:{
                
            }
                break;
            case 54:{
                [self.addMoreDic setValue:@"3" forKey:@"type"];
                [self editMoremessagesWithModel:moreModel3];
            }
                break;
            case 55:{
                [self deleteMoreMessagesWithModel:moreModel3];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)addMoreMessages
{
    NSString *addMoreString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMykMyReleaseDetailOfMoreMessagesToAdd];
    
    [self.addMoreDic setValue:self.productid forKey:@"productid"];
    [self.addMoreDic setValue:[self getValidateToken] forKey:@"token"];
    
    NSDictionary *params = self.addMoreDic;
    
    QDFWeakSelf;
    [self requestDataPostWithString:addMoreString params:params successBlock:^(id responseObject) {
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself getMoreMessagesOfProduct];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)deleteMoreMessagesWithModel:(MoreMessageModel *)moreModel
{
    NSString *deleteMoreString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMykMyReleaseDetailOfMoreMessagesToDelete];
    
    NSDictionary *params = @{@"mortgageid" : moreModel.mortgageid,
                             @"token" : [self getValidateToken]};
    
    QDFWeakSelf;
    [self requestDataPostWithString:deleteMoreString params:params successBlock:^(id responseObject) {
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself getMoreMessagesOfProduct];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)editMoremessagesWithModel:(MoreMessageModel *)moreModel
{
    NSString *editMoreString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMykMyReleaseDetailOfMoreMessagesToEdit];
    
    [self.addMoreDic setValue:moreModel.mortgageid forKey:@"mortgageid"];
    [self.addMoreDic setValue:moreModel.productid forKey:@"productid"];
    [self.addMoreDic setValue:[self getValidateToken] forKey:@"token"];
    
    NSDictionary *params = self.addMoreDic;
    
    QDFWeakSelf;
    [self requestDataPostWithString:editMoreString params:params successBlock:^(id responseObject) {
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself getMoreMessagesOfProduct];
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
