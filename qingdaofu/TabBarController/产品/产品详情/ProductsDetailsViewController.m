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
#import "AllEvaluationViewController.h"  //全部评价
#import "CaseViewController.h"  //经典案例
//#import "DebtDocumnetsViewController.h"  //查看债权文件
#import "ProductsCheckDetailViewController.h"  //债权人信息
#import "ProductsCheckFilesViewController.h"  //债权文件


#import "UIImage+Color.h"
#import "BaseCommitButton.h"
#import "EvaTopSwitchView.h"  //切换
#import "ProdLeftView.h"  //产品基本信息
#import "UIButton+WebCache.h"

//cell
#import "MineUserCell.h"
#import "ProDetailCell.h"
#import "ProDetailNumberCell.h"  //浏览次数
#import "UserPublishCell.h"  //产品信息／发布方信息
#import "EvaluatePhotoCell.h"

//model
//产品信息
#import "NewProductResponse.h"
#import "PublishingModel.h"//产品详情
#import "CertificationModel.h" //发布人详情
#import "NumberModel.h" //申请次数
#import "CreditorFileModel.h"  //债权文件

//发布人信息
#import "CompleteResponse.h"

//收藏状态
#import "ApplicationStateModel.h"

//评价
#import "EvaluateResponse.h"
#import "EvaluateModel.h"

@interface ProductsDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIImage *shadowImage;
@property (nonatomic,strong) UIButton *leftItemButton;
@property (nonatomic,strong) UIButton *rightItemButton;
@property (nonatomic,strong) UITableView *productsDetailsTableView;
@property (nonatomic,strong) BaseCommitButton *proDetailsCommitButton;
@property (nonatomic,strong)  UIView *headerView;
@property (nonatomic,strong) ProdLeftView *leftTableView;

//json
@property (nonatomic,strong) NSString *typetString;//收藏状态
@property (nonatomic,strong) NSArray *messageArray1;
@property (nonatomic,strong) NSArray *messageArray11;
@property (nonatomic,strong) NSArray *messageArray2;
@property (nonatomic,strong) NSArray *messageArray22;
@property (nonatomic,strong) NSArray *certificationArray1;
@property (nonatomic,strong) NSArray *certificationArray11;
@property (nonatomic,strong) NSString *casedesc;

@property (nonatomic,strong) NSString *switchType; //切换产品详情or发布方信息

@property (nonatomic,strong) NSMutableArray *recommendDataArray; //产品信息
@property (nonatomic,strong) NSMutableArray *certifiDataArray;  //身份认证信息
@property (nonatomic,strong) NSMutableArray *numberDataArray; //浏览次数信息
@property (nonatomic,strong) NSMutableArray *fileDataArray;  //债权文件信息

@property (nonatomic,strong) NSMutableArray *allEvaResponse;
@property (nonatomic,strong) NSMutableArray *allEvaDataArray;

@end

@implementation ProductsDetailsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kNavColor,NSFontAttributeName:kNavFont}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kBlueColor] forBarMetrics:UIBarMetricsDefault];
    
    self.shadowImage = self.navigationController.navigationBar.shadowImage;
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:kBlueColor]];
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
    
    self.switchType = @"33";
    
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
        [self.productsDetailsTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.proDetailsCommitButton];
        
        [self.proDetailsCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.proDetailsCommitButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)productsDetailsTableView
{
    if (!_productsDetailsTableView) {
        _productsDetailsTableView = [UITableView newAutoLayoutView];
        _productsDetailsTableView.backgroundColor = kBackColor;
        _leftTableView.separatorColor = kSeparateColor;
        _productsDetailsTableView.delegate = self;
        _productsDetailsTableView.dataSource = self;
        _productsDetailsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _productsDetailsTableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50+kBigPadding)];
        
        EvaTopSwitchView *productSwitchView = [[EvaTopSwitchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        productSwitchView.widthBlueConstraints.constant = kScreenWidth/2;
        productSwitchView.backgroundColor = kNavColor;
        [productSwitchView.getbutton  setTitle:@"产品信息" forState:0];//33
        [productSwitchView.sendButton  setTitle:@"发布方信息" forState:0];//34
        [productSwitchView.shortLineLabel setHidden:YES];
        [self.headerView addSubview:productSwitchView];
        
        if ([self.switchType isEqualToString:@"33"]) {
            [productSwitchView.getbutton setTitleColor:kBlueColor forState:0];
            [productSwitchView.sendButton setTitleColor:kBlackColor forState:0];
            productSwitchView.leftBlueConstraints.constant = 0;
            
        }else if ([self.switchType isEqualToString:@"34"]){
            [productSwitchView.sendButton setTitleColor:kBlueColor forState:0];
            [productSwitchView.getbutton setTitleColor:kBlackColor forState:0];
            productSwitchView.leftBlueConstraints.constant = kScreenWidth/2;
        }
        
        QDFWeak(productSwitchView);
        QDFWeakSelf;
        [productSwitchView setDidSelectedButton:^(NSInteger tag) {
            if (tag == 33) {//产品信息
                [weakproductSwitchView.getbutton setTitleColor:kBlueColor forState:0];
                [weakproductSwitchView.sendButton setTitleColor:kBlackColor forState:0];
                weakproductSwitchView.leftBlueConstraints.constant = 0;
                weakself.switchType = @"33";
                
                if (weakself.messageArray1.count == 0) {
                    [weakself getDetailMessage];
                }else{
                    [weakself.productsDetailsTableView reloadData];
                }
                
            }else{//发布人信息
                CertificationModel *certifiteModel;
                if (self.certificationArray1.count > 0) {
                    certifiteModel = self.certifiDataArray[0];
                }
                if ([certifiteModel.state isEqualToString:@"1"]){
                    [weakproductSwitchView.sendButton setTitleColor:kBlueColor forState:0];
                    [weakproductSwitchView.getbutton setTitleColor:kBlackColor forState:0];
                    weakproductSwitchView.leftBlueConstraints.constant = kScreenWidth/2;
                    weakself.switchType = @"34";
                    
                    if (weakself.certifiDataArray.count == 0) {
//                        [weakself getMessageOfPublishPerson];
                        [weakself getDetailMessage];
                    }else{
                        [weakself.productsDetailsTableView reloadData];
                    }
                }else{
                    [weakself showHint:@"发布方未认证，不能查看相关信息"];
                    [weakproductSwitchView.getbutton setTitleColor:kBlueColor forState:0];
                    [weakproductSwitchView.sendButton setTitleColor:kBlackColor forState:0];
                    weakproductSwitchView.leftBlueConstraints.constant = 0;
                }
            }
        }];
    }
    return _headerView;
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

- (NSMutableArray *)numberDataArray
{
    if (!_numberDataArray) {
        _numberDataArray = [NSMutableArray array];
    }
    return _numberDataArray;
}

- (NSMutableArray *)fileDataArray
{
    if (!_fileDataArray) {
        _fileDataArray = [NSMutableArray array];
    }
    return _fileDataArray;
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
                    return self.certificationArray1.count+1;
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
            return 190;
        }
        return 60;
    }
    
    //section==1
    if ([self.switchType isEqualToString:@"33"]) {
        if (indexPath.row == self.messageArray1.count+1) {
            return kBigPadding;
        }
        return kCellHeight;
    }else if ([self.switchType isEqualToString:@"34"]) {
        if (indexPath.row == self.certificationArray1.count) {//分割线
            return kBigPadding;
        }else if (indexPath.row == self.certificationArray1.count+2){//评价信息
            EvaluateModel *model = self.allEvaDataArray[0];
            if ([model.pictures isEqualToArray:@[]] || [model.pictures[0] isEqualToString:@""]) {
                return 105;
            }else{
                return 170;
            }
        }
        return kCellHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.section == 0) {
        
        PublishingModel *proModel = self.recommendDataArray[0];
        if (indexPath.row == 0) {//产品详情
            identifier = @"proDetais00";
            ProDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[ProDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kBlueColor;
            
            if ([proModel.category intValue] == 2){//清收
                //上边
                if ([proModel.agencycommissiontype isEqualToString:@"1"]) {
                    cell.deRateLabel.text = @"----  服务佣金  ----";
                    NSString *moneyStr1 = proModel.agencycommission;
                    NSString *moneyStr2 = @"%";
                    NSString *moneyStr = [NSString stringWithFormat:@"%@%@",moneyStr1,moneyStr2];
                    NSMutableAttributedString *attMoneyStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
                    [attMoneyStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:50],NSForegroundColorAttributeName:kNavColor} range:NSMakeRange(0, moneyStr1.length)];
                    [attMoneyStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],NSForegroundColorAttributeName:kNavColor} range:NSMakeRange(moneyStr1.length, moneyStr2.length)];
                    [cell.deRateLabel1 setAttributedText:attMoneyStr];
                }else{
                    cell.deRateLabel.text = @"----  固定费用  ----";
                    NSString *moneyStr1 = proModel.agencycommission;
                    NSString *moneyStr2 = @"万";
                    NSString *moneyStr = [NSString stringWithFormat:@"%@%@",moneyStr1,moneyStr2];
                    NSMutableAttributedString *attMoneyStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
                    [attMoneyStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:50],NSForegroundColorAttributeName:kNavColor} range:NSMakeRange(0, moneyStr1.length)];
                    [attMoneyStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],NSForegroundColorAttributeName:kNavColor} range:NSMakeRange(moneyStr1.length, moneyStr2.length)];
                    [cell.deRateLabel1 setAttributedText:attMoneyStr];
                }
                
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
                    cell.deRateLabel.text = @"----  固定费用  ----";
                    NSString *moneyStr1 = proModel.agencycommission;
                    NSString *moneyStr2 = @"万";
                    NSString *moneyStr = [NSString stringWithFormat:@"%@%@",moneyStr1,moneyStr2];
                    NSMutableAttributedString *attMoneyStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
                    [attMoneyStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:50],NSForegroundColorAttributeName:kNavColor} range:NSMakeRange(0, moneyStr1.length)];
                    [attMoneyStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],NSForegroundColorAttributeName:kNavColor} range:NSMakeRange(moneyStr1.length, moneyStr2.length)];
                    [cell.deRateLabel1 setAttributedText:attMoneyStr];
                }else{
                    cell.deRateLabel.text = @"----  代理费率  ----";
                    NSString *moneyStr1 = proModel.agencycommission;
                    NSString *moneyStr2 = @"%";
                    NSString *moneyStr = [NSString stringWithFormat:@"%@%@",moneyStr1,moneyStr2];
                    NSMutableAttributedString *attMoneyStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
                    [attMoneyStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:50],NSForegroundColorAttributeName:kNavColor} range:NSMakeRange(0, moneyStr1.length)];
                    [attMoneyStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],NSForegroundColorAttributeName:kNavColor} range:NSMakeRange(moneyStr1.length, moneyStr2.length)];
                    [cell.deRateLabel1 setAttributedText:attMoneyStr];
                }
                
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
            
            //左边－－－－通用（借款本金）
            cell.deMoneyView.fLabel1.text = @"借款本金";
            NSString *moneyStr1 = proModel.money;
            NSString *moneyStr2 = @"万";
            NSString *moneyStr = [NSString stringWithFormat:@"%@%@",moneyStr1,moneyStr2];
            NSMutableAttributedString *attMoneyStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
            [attMoneyStr addAttributes:@{NSFontAttributeName:kNavFont,NSForegroundColorAttributeName:kNavColor} range:NSMakeRange(0, moneyStr1.length)];
            [attMoneyStr addAttributes:@{NSFontAttributeName:kSmallFont,NSForegroundColorAttributeName:kNavColor} range:NSMakeRange(moneyStr1.length, moneyStr2.length)];
            [cell.deMoneyView.fLabel2 setAttributedText:attMoneyStr];
            
            return cell;
        }
        
        //row == 1  ProDetailNumberCell
        identifier = @"proDetais01";
        ProDetailNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ProDetailNumberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kNavColor;
        
        NumberModel *numberModel = self.numberDataArray[0];
        
        cell.numberButton1.fLabel1.text = @"浏览次数";
        cell.numberButton1.fLabel2.text = [NSString getValidStringFromString:proModel.browsenumber toString:@"0"];
        cell.numberButton2.fLabel1.text = @"申请次数";
        cell.numberButton2.fLabel2.text = [NSString getValidStringFromString:numberModel.shenqing toString:@"0"];
        cell.numberButton3.fLabel1.text = @"收藏次数";
        cell.numberButton3.fLabel2.text = [NSString getValidStringFromString:numberModel.shoucang toString:@"0"];

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
    }else{//发布方信息
        if (indexPath.row < self.certificationArray1.count) {
            identifier = @"proDetais20";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userNameButton.userInteractionEnabled = NO;
            cell.userActionButton.userInteractionEnabled = NO;

            [cell.userNameButton setTitle:self.certificationArray1[indexPath.row] forState:0];
            [cell.userActionButton setTitle:self.certificationArray11[indexPath.row] forState:0];
            
            if (indexPath.row == 0) {
                [cell.userActionButton setTitleColor:kYellowColor forState:0];
            }else if(indexPath.row > 0 && indexPath.row <self.certificationArray1.count-1){
                [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
                cell.userNameButton.titleLabel.font = kFirstFont;
                [cell.userActionButton setTitleColor:kGrayColor forState:0];
                cell.userActionButton.titleLabel.font = kFirstFont;
            }else if (indexPath.row == self.certificationArray1.count-1){
                [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
                cell.userNameButton.titleLabel.font = kFirstFont;
                [cell.userActionButton setTitleColor:kGrayColor forState:0];
                cell.userActionButton.titleLabel.font = kFirstFont;
                if ([self.casedesc isEqualToString:@"查看"]) {
                    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                }
            }
            
            return cell;
        }else if (indexPath.row == self.certificationArray1.count){
            identifier = @"proDetais21";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.userNameButton setHidden:YES];
            [cell.userActionButton setHidden:YES];
            cell.backgroundColor = kBackColor;
            return cell;
        }else if (indexPath.row == self.certificationArray1.count+1){
            identifier = @"proDetais22";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            [cell.userNameButton setTitle:@"收到的评价" forState:0];
            
            if (self.allEvaDataArray.count > 0) {
                [cell.userActionButton setTitle:@"查看全部" forState:0];
                [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            }else{
                [cell.userActionButton setTitle:@"暂无" forState:0];
            }
            
            return cell;
        }else{
            identifier = @"publish11";
            EvaluatePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[EvaluatePhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            EvaluateModel *evaModel;
            if (self.allEvaDataArray.count > 0 ) {
//                [cell.remindImageButton setHidden:YES];
                [cell.evaProductButton setHidden:YES];
                [cell.evaNameLabel setHidden:NO];
                [cell.evaTimeLabel setHidden:NO];
                [cell.evaTextLabel setHidden:NO];
                [cell.evaStarImage setHidden:NO];
                
                evaModel = self.allEvaDataArray[indexPath.row-1];
                //0为正常评价。1为匿名评价
                NSString *isHideStr;
                if ([evaModel.isHide integerValue] == 0) {
                    isHideStr = [NSString getValidStringFromString:evaModel.mobiles toString:@"匿名"];
                }else{
                    isHideStr = @"匿名";
                }
                cell.evaNameLabel.text = isHideStr;
                cell.evaTimeLabel.text = [NSDate getYMDFormatterTime:evaModel.create_time];
                cell.evaStarImage.currentIndex = [evaModel.creditor integerValue];
                cell.evaProImageView1.backgroundColor = kLightGrayColor;
                cell.evaProImageView2.backgroundColor = kLightGrayColor;
                cell.evaTextLabel.text = [NSString getValidStringFromString:evaModel.content toString:@"未填写评价内容"];
                
                // 图片
                if (evaModel.pictures.count == 1) {
                    if ([evaModel.pictures[0] isEqualToString:@""]) {//没有图片
                        [cell.evaProImageView1 setHidden:YES];
                        [cell.evaProImageView2 setHidden:YES];
                    }else{//有图片
                        [cell.evaProImageView1 setHidden:NO];
                        [cell.evaProImageView2 setHidden:YES];
                        
                        NSString *str1 = [evaModel.pictures[0] substringWithRange:NSMakeRange(1, [evaModel.pictures[0] length]-2)];
                        NSString *imageStr1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,str1];
                        NSURL *url1 = [NSURL URLWithString:imageStr1];
                        [cell.evaProImageView1 sd_setBackgroundImageWithURL:url1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
                    }
                }else if (evaModel.pictures.count >= 2){
                    [cell.evaProImageView1 setHidden:NO];
                    [cell.evaProImageView2 setHidden:NO];
                    NSString *str1 = [evaModel.pictures[0] substringWithRange:NSMakeRange(1, [evaModel.pictures[0] length]-2)];
                    NSString *imageStr1 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,str1];
                    NSURL *url1 = [NSURL URLWithString:imageStr1];
                    NSString *str2 = [evaModel.pictures[1] substringWithRange:NSMakeRange(1, [evaModel.pictures[1] length]-2)];
                    NSString *imageStr2 = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,str2];
                    NSURL *url2 = [NSURL URLWithString:imageStr2];
                    
                    [cell.evaProImageView1 sd_setBackgroundImageWithURL:url1 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
                    [cell.evaProImageView2 sd_setBackgroundImageWithURL:url2 forState:0 placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
                }
            }else{
//                [cell.remindImageButton setHidden:NO];
                [cell.evaProductButton setHidden:YES];
                [cell.evaNameLabel setHidden:YES];
                [cell.evaTimeLabel setHidden:YES];
                [cell.evaTextLabel setHidden:YES];
                [cell.evaStarImage setHidden:YES];
                [cell.evaProImageView1 setHidden:YES];
                [cell.evaProImageView2 setHidden:YES];
                [cell.evaProductButton setHidden:YES];
            }
            
            return cell;
        }
    }
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
        return self.headerView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return kBigPadding;
    }
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.switchType isEqualToString:@"33"]) {//产品信息
        if (indexPath.section == 1 && indexPath.row == 1+self.messageArray1.count+1+1+self.messageArray2.count-1-2) {//债权文件
            ProductsCheckFilesViewController *productsCheckFilesVC = [[ProductsCheckFilesViewController alloc] init];
            CreditorFileModel *crediFileModel = self.fileDataArray[0];
            productsCheckFilesVC.debtFileModel = crediFileModel.creditorfile;
            [self.navigationController pushViewController:productsCheckFilesVC animated:YES];
        }else if (indexPath.section == 1 && indexPath.row == 1+self.messageArray1.count+1+1+self.messageArray2.count-1-1){//债权人信息
            CreditorFileModel *filesModel = self.fileDataArray[0];
            if (filesModel.creditorinfo.count > 0) {
                ProductsCheckDetailViewController *productsCheckDetailVC = [[ProductsCheckDetailViewController alloc] init];
                productsCheckDetailVC.categoryString = @"1";
                CreditorFileModel *crediFileModel = self.fileDataArray[0];
                productsCheckDetailVC.listArray = crediFileModel.creditorinfo;
                [self.navigationController pushViewController:productsCheckDetailVC animated:YES];
            }
        }else if (indexPath.section == 1 && indexPath.row == 1+self.messageArray1.count+1+1+self.messageArray2.count-1){//债务人信息
            CreditorFileModel *filesModel = self.fileDataArray[0];
            if (filesModel.borrowinginfo.count > 0) {
                ProductsCheckDetailViewController *productsCheckDetailVC = [[ProductsCheckDetailViewController alloc] init];
                productsCheckDetailVC.categoryString = @"2";
                CreditorFileModel *crediFileModel = self.fileDataArray[0];
                productsCheckDetailVC.listArray = crediFileModel.borrowinginfo;
                [self.navigationController pushViewController:productsCheckDetailVC animated:YES];
            }
        }
    }else if ([self.switchType isEqualToString:@"34"]){//发布人信息
        if (indexPath.row == self.certificationArray1.count+1) {//所有评价
            if (self.allEvaDataArray.count > 0) {
                AllEvaluationViewController *allEvaluationVC = [[AllEvaluationViewController alloc] init];
                allEvaluationVC.idString = self.idString;
                allEvaluationVC.categoryString = self.categoryString;
                allEvaluationVC.pidString = self.pidString;
                allEvaluationVC.evaTypeString = @"evaluate";
                [self.navigationController pushViewController:allEvaluationVC animated:YES];
            }
        }else if (indexPath.row == self.certificationArray1.count-1){//经典案例
            if (self.casedesc) {
                CaseViewController *caseVC = [[CaseViewController alloc] init];
                caseVC.caseString = self.casedesc;
                [self.navigationController pushViewController:caseVC animated:YES];
            }
        }
    }
}

/*
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < 260+kBigPadding) {
        [scrollView setContentOffset:CGPointMake(0, 260+kBigPadding)];
    }
}
 */

#pragma mark - method
//产品详情
- (void)getDetailMessage
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProductDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categoryString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
        
        NSDictionary *qpwp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
        NewProductResponse *respModel = [NewProductResponse objectWithKeyValues:responseObject];
        
        if ([respModel.code isEqualToString:@"0000"]) {
            
            [weakself.numberDataArray addObject:respModel.number]; //申请次数
            [weakself.fileDataArray addObject:respModel.add];  //债权文件
            
            PublishingModel *dataModel = respModel.data;
            
            ////////////////*********产品详情*********/////////////////////////
            NSArray *categoryArr = @[@"清收",@"诉讼"];
            NSArray *cateStr = categoryArr[[weakself.categoryString integerValue] -2];
            weakself.navigationItem.title = [NSString stringWithFormat:@"%@%@",cateStr,dataModel.codeString];
            [weakself.recommendDataArray addObject:dataModel];
            
            //************产品信息*********///
            //金额
            NSString *moneyStr1 = [NSString stringWithFormat:@"%@万",dataModel.money];
            
            NSString *loan_typeStr = @"暂无";//债权类型
            if ([dataModel.loan_type intValue] == 1) {
                loan_typeStr = @"房产抵押";
            }else if ([dataModel.loan_type intValue] == 2){
                loan_typeStr = @"应收账款";
            }else if ([dataModel.loan_type intValue] == 3){
                loan_typeStr = @"机动车抵押";
            }else{
                loan_typeStr = @"无抵押";
            }
            
            //代理费用类型
            NSString *agencycommissiontypeStr = @"暂无";
            //代理费用
            NSString *agencycommissionStr1 = @"暂无";
            if ([dataModel.agencycommissiontype intValue] == 1) {//
                if ([dataModel.category integerValue] == 2) {
                    agencycommissiontypeStr = @"服务佣金";
                    agencycommissionStr1 = [NSString stringWithFormat:@"%@%@",[NSString getValidStringFromString:dataModel.agencycommission toString:@"0"],@"%"];
                }else{
                    agencycommissiontypeStr = @"固定费用";
                    agencycommissionStr1 = [NSString stringWithFormat:@"%@万",[NSString getValidStringFromString:dataModel.agencycommission toString:@"0"]];
                }
            }else if ([dataModel.agencycommissiontype intValue] ==2){
                if ([dataModel.category integerValue] == 2) {
                    agencycommissiontypeStr = @"固定费用";
                    agencycommissionStr1 = [NSString stringWithFormat:@"%@万",[NSString getValidStringFromString:dataModel.agencycommission toString:@"0"]];
                }else{
                    agencycommissiontypeStr = @"风险费率";
                    agencycommissionStr1 = [NSString stringWithFormat:@"%@%@",[NSString getValidStringFromString:dataModel.agencycommission toString:@"0"],@"%"];
                }
            }
            
            if ([dataModel.loan_type intValue] == 1) {//房产抵押
                NSString *mortorage_communityStr1 = [NSString getValidStringFromString:respModel.add.address];
                NSString *seatmortgageStr1 = [NSString getValidStringFromString:dataModel.seatmortgage];
                
                weakself.messageArray1 = @[@"借款本金",@"费用类型",@"代理费用",@"债权类型",@"抵押物地址",@"详细地址"];
                weakself.messageArray11 = @[moneyStr1,agencycommissiontypeStr,agencycommissionStr1,loan_typeStr,mortorage_communityStr1,seatmortgageStr1];
            }else if ([dataModel.loan_type intValue] == 3){//机动车抵押
                NSString *carStr1 = [NSString getValidStringFromString:dataModel.car];
                NSString *licenseStr1 = [NSString getValidStringFromString:dataModel.licenseplate];
                weakself.messageArray1 = @[@"借款本金",@"费用类型",@"代理费用",@"债权类型",@"机动车抵押",@"车牌类型"];
                weakself.messageArray11 = @[moneyStr1,agencycommissiontypeStr,agencycommissionStr1,loan_typeStr,carStr1,licenseStr1];
            }else if ([dataModel.loan_type intValue] == 2){//应收帐款
                NSString *accountrStr1 = [NSString getValidStringFromString:dataModel.accountr toString:@"0"];
                NSString *account11 = [NSString stringWithFormat:@"%@万",accountrStr1];
                
                weakself.messageArray1 = @[@"借款本金",@"费用类型",@"代理费用",@"债权类型",@"应收帐款"];
                weakself.messageArray11 = @[moneyStr1,agencycommissiontypeStr,agencycommissionStr1,loan_typeStr,account11];
            }else{
                
                weakself.messageArray1 = @[@"借款本金",@"费用类型",@"代理费用",@"债权类型"];
                weakself.messageArray11 = @[moneyStr1,agencycommissiontypeStr,agencycommissionStr1,loan_typeStr];
            }
            ///****** 补充信息 *******//////
            NSString *rate = [NSString getValidStringFromString:dataModel.rate]; //借款利率
            if (![rate isEqualToString:@"暂无"]) {
                rate = [NSString stringWithFormat:@"%@%@/月",rate,@"%"];
            }

            NSString *term = [NSString getValidStringFromString:dataModel.term];   //借款期限
            if (![term isEqualToString:@"暂无"]) {
                term = [NSString stringWithFormat:@"%@个月",term];
            }
            
            NSString *repaymethod = @"暂无";//还款方式
            if (dataModel.repaymethod) {//还款方式
                if ([dataModel.repaymethod intValue] == 1) {
                    repaymethod = @"一次性到期还本付息";
                }else if([dataModel.repaymethod intValue] == 2){
                    repaymethod = @"按月付息，到期还本";
                }else{
                    repaymethod = @"其他";
                }
            }
            
            NSString *obligor = @"暂无";  //债务人主体
            if (dataModel.obligor) {//债务人主体
                if ([dataModel.obligor intValue] == 1) {
                    obligor = @"自然人";
                }else if([dataModel.obligor intValue] == 2){
                    obligor = @"法人";
                }else{
                    obligor = @"其他";
                }
            }
            
            NSString *start = @"暂无";  //逾期日期
            if (dataModel.start) {
                start = [NSDate getYMDFormatterTime:dataModel.start];
                if ([start isEqualToString:@"1970-01-01"]) {
                    start = @"暂无";
                }
            }
            
            NSString *commissionperiod = [NSString getValidStringFromString:dataModel.commissionperiod]; //委托代理期限
            if (![commissionperiod isEqualToString:@"暂无"]) {
                commissionperiod = [NSString stringWithFormat:@"%@个月",commissionperiod];
            }
            
            NSString *paidmoney = [NSString getValidStringFromString:dataModel.paidmoney];//已付本金
            if (![paidmoney isEqualToString:@"暂无"]) {
                paidmoney = [NSString stringWithFormat:@"%@元",paidmoney];
            }
            
            NSString *interestpaid = [NSString getValidStringFromString:dataModel.interestpaid]; //已付利息
            if (![interestpaid isEqualToString:@"暂无"]) {
                interestpaid = [NSString stringWithFormat:@"%@元",interestpaid];
            }
            
            NSString *performancecontract = [NSString getValidStringFromString:dataModel.performancecontract];  //合同履行地
            
            NSString *creditorfile = @"查看";  //债权文件
            
            CreditorFileModel *fileModel = respModel.add;
            NSString *creditorinfo = @"暂无";  //债权人信息
            if (fileModel.creditorinfo.count > 0) {
                creditorinfo = @"查看";
            }
            
            NSString *borrowinginfo = @"暂无";  //债务人信息
            if (fileModel.borrowinginfo.count > 0) {
                creditorinfo = @"查看";
            }
            
            weakself.messageArray2 = @[@"借款利率",@"借款期限",@"还款方式",@"债务人主体",@"逾期日期",@"委托代理期限",@"已付本金",@"已付利息",@"合同履行地",@"债权文件",@"债权人信息",@"债务人信息"];
            weakself.messageArray22 = @[rate,term,repaymethod,obligor,start,commissionperiod,paidmoney,interestpaid,performancecontract,creditorfile,creditorinfo,borrowinginfo];
            
            [weakself.productsDetailsTableView reloadData];
            
            
            //////////////////////*********发布人详情*********/////////////////////////
            CertificationModel *certificationModel;
            if (respModel.certification) {
                certificationModel = respModel.certification;
                [weakself.certifiDataArray addObject:certificationModel];
            }
            
            NSString *definedStr = @"已认证";
            
            NSString *emailQ = [NSString getValidStringFromString:certificationModel.email];
            NSString *addressQ = [NSString getValidStringFromString:certificationModel.address];
            NSString *enterprisewebsiteQ = [NSString getValidStringFromString:certificationModel.enterprisewebsite];
            NSString *casedescQ = [NSString getValidStringFromString:certificationModel.casedesc];
            if (![casedescQ isEqualToString:@"暂无"]) {
                casedescQ = @"查看";
            }
            
            if ([certificationModel.category integerValue] == 1) {//个人
                weakself.certificationArray1 = @[@"基本信息",@"姓名",@"身份证号码",@"身份图片",@"联系电话",@"邮箱"];
                weakself.certificationArray11 = @[@"已认证个人",certificationModel.name,certificationModel.cardno,definedStr,certificationModel.mobile,emailQ];
            }else if ([certificationModel.category integerValue] == 2){//律所
                weakself.certificationArray1 = @[@"基本信息",@"律所名称",@"执业证号",@"图片",@"联系人",@"联系方式",@"邮箱",@"经典案例"];
                weakself.certificationArray11 = @[@"已认证律所",certificationModel.name,certificationModel.cardno,definedStr,certificationModel.contact,certificationModel.mobile,emailQ,casedescQ];
                weakself.casedesc = certificationModel.casedesc;
            }else if ([certificationModel.category integerValue] == 3){//公司
                weakself.certificationArray1 = @[@"基本信息",@"公司名称",@"营业执照号",@"图片",@"联系人",@"联系方式",@"企业邮箱",@"公司经营地址",@"公司网站",@"经典案例"];
                weakself.certificationArray11 = @[@"已认证公司",certificationModel.name,certificationModel.cardno,definedStr,certificationModel.contact,certificationModel.mobile,emailQ,addressQ,enterprisewebsiteQ,casedescQ];
                weakself.casedesc = certificationModel.casedesc;
            }
        }else{
            [weakself showHint:respModel.msg];
        }
        
        [weakself applicationForOrdersStates];
    } andFailBlock:^(NSError *error){
        [weakself applicationForOrdersStates];
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
        PublishingModel *rModel = weakself.recommendDataArray[0];
        
        if ((stateModel.app_id == nil || [stateModel.app_id intValue] == 2) && [rModel.progress_status integerValue] == 1) {
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
            
        }else if (([stateModel.app_id intValue] == 0) && ([rModel.progress_status intValue] == 1)) {//已申请
            [weakself.proDetailsCommitButton setTitleColor:kBlackColor forState:0];
            [weakself.proDetailsCommitButton setTitle:@"已申请" forState:0];
            [weakself.proDetailsCommitButton setBackgroundColor:kSelectedColor];
            weakself.proDetailsCommitButton.userInteractionEnabled = NO;
        }else if ([rModel.progress_status intValue] == 2){//申请成功
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
    
    PublishingModel *rightModel = self.recommendDataArray[0];
    
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

/*
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
            
            NSString *definedStr;
            if ([certificationModel.cardimg isEqualToString:@"undefined"]) {
                definedStr = @"未上传";
            }else{
                definedStr = @"已上传";
            }
            NSString *emailQ = [NSString getValidStringFromString:certificationModel.email];
            NSString *addressQ = [NSString getValidStringFromString:certificationModel.address];
            NSString *enterprisewebsiteQ = [NSString getValidStringFromString:certificationModel.enterprisewebsite];
            NSString *casedescQ = [NSString getValidStringFromString:certificationModel.casedesc];
            if (![casedescQ isEqualToString:@"暂无"]) {
                casedescQ = @"查看";
            }
            
            if ([certificationModel.category integerValue] == 1) {//个人
                weakself.certificationArray1 = @[@"基本信息",@"姓名",@"身份证号码",@"身份图片",@"联系电话",@"邮箱"];
                weakself.certificationArray11 = @[@"已认证个人",certificationModel.name,certificationModel.cardno,definedStr,certificationModel.mobile,emailQ];
            }else if ([certificationModel.category integerValue] == 2){//律所
                weakself.certificationArray1 = @[@"基本信息",@"律所名称",@"执业证号",@"图片",@"联系人",@"联系方式",@"邮箱",@"经典案例"];
                weakself.certificationArray11 = @[@"已认证律所",certificationModel.name,certificationModel.cardno,definedStr,certificationModel.contact,certificationModel.mobile,emailQ,casedescQ];
                weakself.casedesc = certificationModel.casedesc;
            }else if ([certificationModel.category integerValue] == 3){//公司
                weakself.certificationArray1 = @[@"基本信息",@"公司名称",@"营业执照号",@"图片",@"联系人",@"联系方式",@"企业邮箱",@"公司经营地址",@"公司网站",@"经典案例"];
                weakself.certificationArray11 = @[@"已认证公司",certificationModel.name,certificationModel.cardno,definedStr,certificationModel.contact,certificationModel.mobile,emailQ,addressQ,enterprisewebsiteQ,casedescQ];
                weakself.casedesc = certificationModel.casedesc;
            }
            [weakself getAllEvaluationListWithPage:@"1"];
            
        }else{
            [weakself showHint:response.msg];
        }
    } andFailBlock:^(NSError *error) {
        
    }];
}
 */


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
        [weakself.productsDetailsTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}


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
