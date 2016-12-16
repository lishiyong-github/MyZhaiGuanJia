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
#import "EditUpTableView.h"

#import "PublishingResponse.h"
#import "RowsModel.h"

#import "UIViewController+BlurView.h"

@interface MoreMessagesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *moreMessageTableView;//显示信息的tableview
@property (nonatomic,strong) EditUpTableView *editMessageTableView; //添加额外信息
@property (nonatomic,strong) UIView *editBackView;
@property (nonatomic,strong) NSLayoutConstraint *heightEditConstraints;

//json
@property (nonatomic,strong) NSMutableArray *moreMessageArray;
@property (nonatomic,strong) NSMutableDictionary *productDic;  //显示额外添加信息（添加抵押物地址，添加机动车抵押类型，添加合同纠纷类型）

//params
@property (nonatomic,strong) NSMutableDictionary *addMoreDic;

@end

@implementation MoreMessagesViewController

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMoreMessagesOfProduct) name:@"headerRefresh" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.moreMessageTableView];
    
    [self.view setNeedsUpdateConstraints];
    
    [self getMoreMessagesOfProduct];
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

- (UIView *)editBackView
{
    if (!_editBackView) {
        _editBackView = [UIView newAutoLayoutView];
        _editBackView.backgroundColor = UIColorFromRGB1(0x333333, 0.3);
    }
    return _editBackView;
}

- (EditUpTableView *)editMessageTableView
{
    if (!_editMessageTableView) {
        _editMessageTableView = [EditUpTableView newAutoLayoutView];
    }
    return _editMessageTableView;
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
        }else{//不能编辑的
            if (!self.productDic[@"house"]) {//房产抵押
                if (!self.productDic[@"car"]) {//机动车抵押
                    if (self.productDic[@"contract"]) {//合同纠纷
                        return rowModel.productMortgages3.count;
                    }
                }else{
                    if (!self.productDic[@"contract"]) {
                        return rowModel.productMortgages2.count;
                    }else{
                        if (section == 1) {
                            return rowModel.productMortgages2.count;
                        }else{
                            return rowModel.productMortgages3.count;
                        }
                    }
                }
            }else{
                if (!self.productDic[@"car"]) {
                    if (!self.productDic[@"contract"]) {
                        return rowModel.productMortgages1.count;
                    }else{
                        if (section == 1) {
                            return rowModel.productMortgages1.count;
                        }else{
                            return rowModel.productMortgages3.count;
                        }
                    }
                }else{
                    if (!self.productDic[@"contract"]) {
                        if (section == 1) {
                            return rowModel.productMortgages1.count;
                        }else{
                            return rowModel.productMortgages2.count;
                        }
                    }else{
                        if (section == 1) {
                            return rowModel.productMortgages1.count;
                        }else if(section == 2){
                            return rowModel.productMortgages2.count;
                        }else{
                            return rowModel.productMortgages3.count;
                        }
                    }
                }
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
            
            if (self.productDic.allKeys.count == 1) {
                if (self.productDic[@"house"]) {//房产抵押
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
                }else if (self.productDic[@"car"]){//机动车抵押
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

                }else if (self.productDic[@"contract"]){//合同纠纷
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
            }else if (self.productDic.allKeys.count ==2){
                if (!self.productDic[@"house"]) {//机动车抵押＋合同纠纷
                    if (indexPath.section == 1){
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
                    }else if (indexPath.section == 2){
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
                }else{
                    if (self.productDic[@"car"]) {//房产抵押＋机动车抵押
                        if (indexPath.section == 1){
                            if (indexPath.row == rowModel.productMortgages1.count) {
                                identifier = @"house1";
                                BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                                if (!cell) {
                                    cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                                }
                                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                [cell.oneButton setTitleColor:kLightGrayColor forState:0];
                                cell.oneButton.titleLabel.font = kSecondFont;
                                cell.oneButton.userInteractionEnabled = NO;
                                [cell.oneButton setTitle:@"添加房产抵押信息" forState:0];
                                
                                return cell;
                            }else{
                                identifier = @"house0";
                                AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                                if (!cell) {
                                    cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                                }
                                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                cell.leftdAgentContraints.constant = 100;
                                cell.agentTextField.userInteractionEnabled = NO;
                                cell.agentLabel.text = @"房产抵押";
                                cell.agentLabel.textColor = kLightGrayColor;
                                
                                MoreMessageModel *moreModel = [MoreMessageModel objectWithKeyValues:rowModel.productMortgages1[indexPath.row]];
                                cell.agentTextField.text = moreModel.addressLabel;
                                [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                                
                                return cell;
                            }
                        }else if (indexPath.section == 2){
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
                                [cell.oneButton setTitle:@"添加机动车抵押类型" forState:0];
                                
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
                                cell.agentLabel.text = @"机动车抵押";
                                cell.agentLabel.textColor = kLightGrayColor;
                                
                                MoreMessageModel *moreModel = [MoreMessageModel objectWithKeyValues:rowModel.productMortgages2[indexPath.row]];
                                cell.agentTextField.text = moreModel.brandLabel;
                                [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                                
                                return cell;
                            }
                        }

                    }else if(self.productDic[@"contract"]){//房产抵押＋合同纠纷
                        if (indexPath.section == 1){
                            if (indexPath.row == rowModel.productMortgages1.count) {
                                identifier = @"house1";
                                BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                                if (!cell) {
                                    cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                                }
                                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                [cell.oneButton setTitleColor:kLightGrayColor forState:0];
                                cell.oneButton.titleLabel.font = kSecondFont;
                                cell.oneButton.userInteractionEnabled = NO;
                                [cell.oneButton setTitle:@"添加房产抵押信息" forState:0];
                                
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
                                cell.agentLabel.text = @"房产抵押";
                                cell.agentLabel.textColor = kLightGrayColor;
                                
                                MoreMessageModel *moreModel = [MoreMessageModel objectWithKeyValues:rowModel.productMortgages1[indexPath.row]];
                                cell.agentTextField.text = moreModel.addressLabel;
                                [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                                
                                return cell;
                            }
                        }else if (indexPath.section == 2){
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
                    }
                }
                
            }else if (self.productDic.allKeys.count == 3){
                if (indexPath.section == 1) {
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
                }else if (indexPath.section == 2){
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
                }else if (indexPath.section == 3){
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
            }
        }else{//无添加功能(处理终止结案)
//            if (rowModel.productMortgages1.count > 0) {
//                if (indexPath.section == 1) {
//                    identifier = @"moreMes1";
//                    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//                    if (!cell) {
//                        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//                    }
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    
//                    [cell.userNameButton setTitle:@"房产抵押" forState:0];
//                    
//                    return cell;
//                }
//            }
            
            if (self.productDic.allKeys.count == 1) {
                if (self.productDic[@"house"]) {
                    //显示添加的内容
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

                }else if (self.productDic[@"car"]){
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
                }else if (self.productDic[@"contract"]){
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
            }else if (self.productDic.allKeys.count == 2){
                if (self.productDic[@"house"]) {
                    if (self.productDic[@"car"]) {//房产抵押＋机动车抵押
                        if (indexPath.section == 1) {
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
                    }else{//房产抵押＋合同纠纷
                        if (indexPath.section == 1) {
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
                    
                }else{//机动车抵押＋合同纠纷
                    if (indexPath.section == 1) {
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
                
            }else if (self.productDic.allKeys.count == 3){//房产抵押＋机动车抵押＋合同纠纷
                if (indexPath.section == 1) {
                   //显示添加的内容
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
                }else if (indexPath.section == 2){
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
                }else if (indexPath.section == 3){
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
                if (indexPath.section == 1) {
                    if (indexPath.row == rowModel.productMortgages3.count) {
                        [self showContractBlurViewWithType:@"添加" andModel:rowModel andIndexRow:indexPath.row];
                    }else{
                        [self showContractBlurViewWithType:@"编辑" andModel:rowModel andIndexRow:indexPath.row];
                    }
                }
            }
        }else{
            if (!self.productDic[@"contract"]) {
                if (indexPath.section == 1) {
                    if (indexPath.row == rowModel.productMortgages2.count) {
                        [self showBlurChooseViewWithType:@"添加" andCategory:@"机动车抵押" andModel:rowModel andIndexRow:indexPath.row];
                    }else{
                        [self showBlurChooseViewWithType:@"编辑" andCategory:@"机动车抵押" andModel:rowModel andIndexRow:indexPath.row];
                    }
                }
            }else{
                if (indexPath.section == 1) {
                    if (indexPath.row == rowModel.productMortgages2.count) {
                        [self showBlurChooseViewWithType:@"添加" andCategory:@"机动车抵押" andModel:rowModel andIndexRow:indexPath.row];
                    }else{
                        [self showBlurChooseViewWithType:@"编辑" andCategory:@"机动车抵押" andModel:rowModel andIndexRow:indexPath.row];
                    }
                }else if(indexPath.section == 2){
                    if (indexPath.row == rowModel.productMortgages3.count) {
                        [self showContractBlurViewWithType:@"添加" andModel:rowModel andIndexRow:indexPath.row];
                    }else{
                        [self showContractBlurViewWithType:@"编辑" andModel:rowModel andIndexRow:indexPath.row];
                    }
                }
            }
        }
    }else{
        if (!self.productDic[@"car"]) {
            if (!self.productDic[@"contract"]) {
                if (indexPath.section == 1) {
                    if (indexPath.row == rowModel.productMortgages1.count) {
                        [self showBlurChooseViewWithType:@"添加" andCategory:@"房产抵押" andModel:rowModel andIndexRow:indexPath.row];
                    }else{
                        [self showBlurChooseViewWithType:@"编辑" andCategory:@"房产抵押" andModel:rowModel andIndexRow:indexPath.row];
                    }
                }
            }else{
                if (indexPath.section == 1) {
                    if (indexPath.row == rowModel.productMortgages1.count) {
                        [self showBlurChooseViewWithType:@"添加" andCategory:@"房产抵押" andModel:rowModel andIndexRow:indexPath.row];
                    }else{
                        [self showBlurChooseViewWithType:@"编辑" andCategory:@"房产抵押" andModel:rowModel andIndexRow:indexPath.row];
                    }
                }else if(indexPath.section == 2){
                    if (indexPath.row == rowModel.productMortgages3.count) {
                        [self showContractBlurViewWithType:@"添加" andModel:rowModel andIndexRow:indexPath.row];
                    }else{
                        [self showContractBlurViewWithType:@"编辑" andModel:rowModel andIndexRow:indexPath.row];
                    }
                }
            }
        }else{
            if (!self.productDic[@"contract"]) {
                if (indexPath.section == 1) {
                    if (indexPath.row == rowModel.productMortgages1.count) {
                        [self showBlurChooseViewWithType:@"添加" andCategory:@"房产抵押" andModel:rowModel andIndexRow:indexPath.row];
                    }else{
                        [self showBlurChooseViewWithType:@"编辑" andCategory:@"房产抵押" andModel:rowModel andIndexRow:indexPath.row];
                    }
                }else if(indexPath.section == 2){
                    if (indexPath.row == rowModel.productMortgages2.count) {
                        [self showBlurChooseViewWithType:@"添加" andCategory:@"机动车抵押" andModel:rowModel andIndexRow:indexPath.row];
                    }else{
                        [self showBlurChooseViewWithType:@"编辑" andCategory:@"机动车抵押" andModel:rowModel andIndexRow:indexPath.row];
                    }
                }
            }else{
                if (indexPath.section == 1) {
                    if (indexPath.row == rowModel.productMortgages1.count) {
                        [self showBlurChooseViewWithType:@"添加" andCategory:@"房产抵押" andModel:rowModel andIndexRow:indexPath.row];
                    }else{
                        [self showBlurChooseViewWithType:@"编辑" andCategory:@"机动车抵押" andModel:rowModel andIndexRow:indexPath.row];
                    }
                }else if(indexPath.section == 2){
                    if (indexPath.row == rowModel.productMortgages2.count) {
                        [self showBlurChooseViewWithType:@"添加" andCategory:@"机动车抵押" andModel:rowModel andIndexRow:indexPath.row];
                    }else{
                        [self showBlurChooseViewWithType:@"编辑" andCategory:@"机动车抵押" andModel:rowModel andIndexRow:indexPath.row];
                    }
                }else if(indexPath.section == 3){
                    if (indexPath.row == rowModel.productMortgages3.count) {
                        [self showContractBlurViewWithType:@"添加" andModel:rowModel andIndexRow:indexPath.row];
                    }else{
                        [self showContractBlurViewWithType:@"编辑" andModel:rowModel andIndexRow:indexPath.row];
                    }

                }
            }
        }
    }
    }
}

#pragma mark - method
- (void)showBlurChooseViewWithType:(NSString *)type andCategory:(NSString *)category  andModel:(RowsModel *)rowModel andIndexRow:(NSInteger)indexRow
{
    //添加4*kCellHeight+kCellHeight4     编辑3*kCellHeight+116
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.editBackView];
    
    [self.editBackView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    [self.editBackView addSubview:self.editMessageTableView];
    [self.editMessageTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    
    MoreMessageModel *moreModel;
    if ([type isEqualToString:@"添加"]) {
        [self.editMessageTableView autoSetDimension:ALDimensionHeight toSize:4*kCellHeight+kCellHeight4];
        moreModel = nil;
    }else if([type isEqualToString:@"编辑"]){
        [self.editMessageTableView autoSetDimension:ALDimensionHeight toSize:3*kCellHeight+116];
        
        if ([category isEqualToString:@"房产抵押"]) {
            moreModel = [MoreMessageModel objectWithKeyValues:rowModel.productMortgages1[indexRow]];
        }else if ([category isEqualToString:@"机动车抵押"]){
            moreModel = [MoreMessageModel objectWithKeyValues:rowModel.productMortgages2[indexRow]];
        }else if ([category isEqualToString:@"机动车抵押"]){
            moreModel = [MoreMessageModel objectWithKeyValues:rowModel.productMortgages3[indexRow]];
        }
    }
    
    //refresh
    self.editMessageTableView.moreModel = moreModel;
    self.editMessageTableView.type = type;
    self.editMessageTableView.category = category;
    [self.editMessageTableView reloadDatas];
    
    //show details and action
    QDFWeakSelf;
    [self.editMessageTableView setDidEndEditting:^(NSString *text) {
        [weakself.addMoreDic setValue:text forKey:@"relation_desc"];//省
    }];
    [self.editMessageTableView setDidSelectedBtn:^(NSInteger btnTag) {
        
        switch (btnTag) {
            case 51:{//取消
                [weakself hiddenBlurChooseView];
            }
                break;
            case 52:{
                if ([category isEqualToString:@"房产抵押"]) {
                    [weakself hiddenBlurChooseView];
                    HouseViewController *houseVC = [[HouseViewController alloc] init];
                    [weakself.navigationController pushViewController:houseVC animated:YES];
                    
                    [houseVC setDidSelectedRow:^(NSString *proId, NSString *proName, NSString *cityId, NSString *cityName, NSString *areaId, NSString *areaName) {
                        [weakself showBlurChooseViewWithType:type andCategory:category andModel:rowModel andIndexRow:indexRow];
                        
                        //show
                        AgentCell *cell = [weakself.editMessageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                        cell.agentTextField.text = [NSString stringWithFormat:@"%@%@%@",proName,cityName,areaName];
                        
                        //params
                        [weakself.addMoreDic setValue:proId forKey:@"relation_1"];//省
                        [weakself.addMoreDic setValue:cityId forKey:@"relation_2"];//市
                        [weakself.addMoreDic setValue:areaId forKey:@"relation_3"];//区
                        [weakself.addMoreDic setValue:@"1" forKey:@"type"];
                    }];
                }else if ([category isEqualToString:@"机动车抵押"]){
                    [weakself hiddenBlurChooseView];
                    BrandsViewController *brandsVC = [[BrandsViewController alloc] init];
                    [weakself.navigationController pushViewController:brandsVC animated:YES];
                    
                    [brandsVC setDidSelectedRow:^(NSString *brandId, NSString *brandName, NSString *carId, NSString *carName, NSString *licenseId, NSString *licenseName) {
                        
                        [weakself showBlurChooseViewWithType:type andCategory:category andModel:rowModel andIndexRow:indexRow];
                        
                        AgentCell *cell = [weakself.editMessageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                        cell.agentTextField.text = [NSString stringWithFormat:@"%@%@%@",brandName,carName,licenseName];
                        
                        [weakself.addMoreDic setValue:brandId forKey:@"relation_1"];
                        [weakself.addMoreDic setValue:carId forKey:@"relation_2"];
                        [weakself.addMoreDic setValue:licenseId forKey:@"relation_3"];
                        [weakself.addMoreDic setValue:@"2" forKey:@"type"];
                    }];
                }
            }
                break;
            case 53:{//保存
                [weakself addMoreMessages];
            }
                break;
            case 54:{//编辑
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

- (void)hiddenBlurChooseView
{
    [self.editBackView removeFromSuperview];
}

- (void)showContractBlurViewWithType:(NSString *)type andModel:(RowsModel *)rowModel andIndexRow:(NSInteger)indexRow
{
    NSArray *contractArray;
    if ([type isEqualToString:@"添加"]) {
        contractArray = @[@"合同纠纷",@"民事诉讼",@"房产纠纷",@"劳动合同",@"其他"];
        
    }else if ([type isEqualToString:@"编辑"]){
        contractArray = @[@"合同纠纷",@"民事诉讼",@"房产纠纷",@"劳动合同",@"其他",@"删除该合同纠纷类型"];
    }
    
    MoreMessageModel *moreModel;
    if (rowModel.productMortgages3.count > 0) {
        moreModel = [MoreMessageModel objectWithKeyValues:rowModel.productMortgages3[indexRow]];
    }
    
    QDFWeakSelf;
    NSString *riti = [NSString stringWithFormat:@"%@合同纠纷类型",type];
    [self showBlurInView:self.view withArray:contractArray andTitle:riti finishBlock:^(NSString *text, NSInteger row) {
        
        if (row == 6) {//删除
            [weakself deleteMoreMessagesWithModel:moreModel];
        }else{
            //show
            AgentCell *cell = [weakself.editMessageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.agentTextField.text = text;
            
            //params
            NSString *www = [NSString stringWithFormat:@"%ld",(long)row];
            [weakself.addMoreDic setValue:www forKey:@"relation_1"];
            [weakself.addMoreDic setValue:@"3" forKey:@"type"];
            if ([type isEqualToString:@"添加"]) {
                [weakself addMoreMessages];
            }else if ([type isEqualToString:@"编辑"]){
                [weakself editMoremessagesWithModel:moreModel];
            }
        }
    }];
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
        
        if ([rowModel.categoryLabel containsString:@"房产抵押"]) {
            [weakself.productDic setValue:rowModel.productMortgages1 forKey:@"house"];
        }
        if ([rowModel.categoryLabel containsString:@"机动车抵押"]) {
            [weakself.productDic setValue:rowModel.productMortgages2 forKey:@"car"];
        }
        if ([rowModel.categoryLabel containsString:@"合同纠纷"]) {
            [weakself.productDic setValue:rowModel.productMortgages3 forKey:@"contract"];
        }
        
        [weakself.moreMessageArray addObject:rowModel];
        
        [weakself.moreMessageTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)addMoreMessages
{
    [self.editMessageTableView endEditing:YES];
    
    NSString *addMoreString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMykMyReleaseDetailOfMoreMessagesToAdd];
    
    [self.addMoreDic setValue:self.productid forKey:@"productid"];
    [self.addMoreDic setValue:[self getValidateToken] forKey:@"token"];
    
    NSDictionary *params = self.addMoreDic;
    
    QDFWeakSelf;
    [self requestDataPostWithString:addMoreString params:params successBlock:^(id responseObject) {
        
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself hiddenBlurChooseView];
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
            [weakself hiddenBlurChooseView];
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
            [weakself hiddenBlurChooseView];
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
