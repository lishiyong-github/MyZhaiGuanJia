//
//  MyDealingViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/6.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyDealingViewController.h"

#import "ApplyRecordViewController.h"  //申请记录
#import "CheckDetailPublishViewController.h"  //查看发布方

#import "MineUserCell.h"//完善信息
#import "NewPublishDetailsCell.h"//进度
#import "OrderPublishCell.h"//联系TA
#import "NewPublishStateCell.h"//状态
#import "PublishCombineView.h"  //底部视图
#import "BaseRemindButton.h"  //提示框

#import "PublishingModel.h"
#import "PublishingResponse.h"
#import "UserNameModel.h"  //申请方信息

//#import "CheckDetailPublishViewController.h"  //查看发布方
//#import "PaceViewController.h"    //查看进度
//#import "AdditionMessagesViewController.h"  //补充信息
//#import "AgreementViewController.h"  //协议
//#import "DelayHandleViewController.h"  //延期处理
//
//#import "EvaTopSwitchView.h"
//#import "BaseCommitButton.h"
//#import "BaseRemindButton.h"
//
//#import "MineUserCell.h"
//#import "OrderPublishCell.h"
//
//#import "PublishingModel.h"
//#import "PublishingResponse.h"
//#import "UserNameModel.h"
//
//#import "DelayResponse.h"
//#import "DelayModel.h"

@interface MyDealingViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIButton *dealRightNavButton;
@property (nonatomic,strong) UITableView *myDealingTableView;
@property (nonatomic,strong) BaseRemindButton *dealRemindButton;
@property (nonatomic,strong) UIView *chatView;
//json
@property (nonatomic,strong) NSMutableArray *myDealingDataArray;

//@property (nonatomic,strong) UITableView *dealingTableView;
//@property (nonatomic,assign) BOOL didSetupConstraints;
//@property (nonatomic,strong) EvaTopSwitchView *dealFootView;
//@property (nonatomic,strong) BaseCommitButton *dealCommitButton;
//@property (nonatomic,strong) BaseRemindButton *dealRemindButton;
//
//@property (nonatomic,strong) NSMutableArray *dealingDataList;


//@property (nonatomic,strong) NSString *loanTypeString1;  //债权类型
//@property (nonatomic,strong) NSString *loanTypeString2;  //债权类型内容
//@property (nonatomic,strong) NSString *loanTypeImage;//债权类型图片

@end

@implementation MyDealingViewController

- (void)viewWillAppear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delayRequestFromOrder) name:@"delay" object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.dealRightNavButton];
    
    [self.view addSubview: self.myDealingTableView];
    [self.view addSubview:self.chatView];
    [self.view addSubview:self.dealRemindButton];
//    [self.dealRemindButton setHidden:YES];
    [self.view setNeedsUpdateConstraints];
    
    [self getDetailMessages];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.myDealingTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.myDealingTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.chatView];
        
        [self.dealRemindButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.chatView];
        [self.dealRemindButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.dealRemindButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.dealRemindButton autoSetDimension:ALDimensionHeight toSize:kRemindHeight];
        
        [self.chatView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.chatView autoSetDimension:ALDimensionHeight toSize:kCellHeight1];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UIButton *)dealRightNavButton
{
    if (!_dealRightNavButton) {
        _dealRightNavButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        [_dealRightNavButton setTitleColor:kWhiteColor forState:0];
        [_dealRightNavButton setTitle:@"申请终止" forState:0];
        _dealRightNavButton.titleLabel.font = kFirstFont;
    }
    return _dealRightNavButton;
}

- (UITableView *)myDealingTableView
{
    if (!_myDealingTableView) {
        _myDealingTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _myDealingTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myDealingTableView.backgroundColor = kBackColor;
        _myDealingTableView.separatorColor = kSeparateColor;
        _myDealingTableView.delegate = self;
        _myDealingTableView.dataSource = self;
    }
    return _myDealingTableView;
}

- (BaseRemindButton *)dealRemindButton
{
    if (!_dealRemindButton) {
        _dealRemindButton = [BaseRemindButton newAutoLayoutView];
        [_dealRemindButton setTitle:@"对方申请终止此单，点击处理  " forState:0];
        [_dealRemindButton setImage:[UIImage imageNamed:@"more_white"] forState:0];
    }
    return _dealRemindButton;
}

- (UIView *)chatView
{
    if (!_chatView) {
        _chatView = [UIView newAutoLayoutView];
        [_chatView setBackgroundColor:kRedColor];
    }
    return _chatView;
}

- (NSMutableArray *)myDealingDataArray
{
    if (!_myDealingDataArray) {
        _myDealingDataArray = [NSMutableArray array];
    }
    return _myDealingDataArray;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.myDealingDataArray.count > 0) {
        return 3;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.myDealingDataArray.count > 0) {
        if (section == 0) {
            return 3;
        }
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return kCellHeight1;
        }else if (indexPath.row == 1){
            return 72;
        }else if (indexPath.row == 2){
            return kCellHeight3;
        }
    }
    return kCellHeight3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.section == 0) {
        
        PublishingResponse *resModel = self.myDealingDataArray[0];
        PublishingModel *publishModel = resModel.product;
        
        if (indexPath.row == 0) {
            identifier = @"myDealing00";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.userNameButton setTitle:publishModel.codeString forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            [cell.userActionButton setTitle:@"查看详情" forState:0];
            
            return cell;
        }else if (indexPath.row == 1){
            identifier = @"myDealing01";
            NewPublishDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[NewPublishDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kBackColor;
            
            [cell.point2 setImage:[UIImage imageNamed:@"succee"] forState:0];
            cell.progress2.textColor = kTextColor;
            [cell.line2 setBackgroundColor:kButtonColor];
            [cell.point3 setImage:[UIImage imageNamed:@"succee"] forState:0];
            cell.progress3.textColor = kTextColor;
            [cell.line3 setBackgroundColor:kButtonColor];
            
            return cell;
            
        }else if (indexPath.row == 2){
            identifier = @"myDealing02";
            OrderPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[OrderPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UserNameModel *userNameModel = resModel.username;
            
            NSString *nameStr = [NSString getValidStringFromString:userNameModel.jusername toString:@"未认证"];
            NSString *checkStr = [NSString stringWithFormat:@"申请方：%@",nameStr];
            [cell.checkButton setTitle:checkStr forState:0];
            [cell.contactButton setTitle:@" 联系TA" forState:0];
            [cell.contactButton setImage:[UIImage imageNamed:@"phone_blue"] forState:0];
            
            //接单方详情
            QDFWeakSelf;
            [cell.checkButton addAction:^(UIButton *btn) {
                if ([userNameModel.jusername isEqualToString:@""] || userNameModel.jusername == nil || !userNameModel.jusername) {
                    [weakself showHint:@"申请方未认证，不能查看相关信息"];
                }else{
                    CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
                    checkDetailPublishVC.idString = weakself.idString;
                    checkDetailPublishVC.categoryString = weakself.categaryString;
                    checkDetailPublishVC.pidString = weakself.pidString;
                    checkDetailPublishVC.typeString = @"接单方";
                    //                checkDetailPublishVC.typeDegreeString = @"处理中";
                    [weakself.navigationController pushViewController:checkDetailPublishVC animated:YES];
                }
            }];
            
            //电话
            [cell.contactButton addAction:^(UIButton *btn) {
                if ([userNameModel.jusername isEqualToString:@""] || userNameModel.jusername == nil || !userNameModel.jusername) {
                    [self showHint:@"申请方未认证，不能打电话"];
                }else{
                    NSMutableString *phoneStr = [NSMutableString stringWithFormat:@"telprompt://%@",userNameModel.jmobile];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
                }
            }];
            return cell;
        }
        
    }else if (indexPath.section == 1){
        identifier = @"myDealing1";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.userNameButton setTitle:@"签约协议详情" forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        [cell.userActionButton setTitle:@"查看" forState:0];
        
        return cell;
    }else if (indexPath.section == 2){
        identifier = @"myDealing2";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userNameButton setTitle:@"尽职调查" forState:0];
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self showHint:@"查看详情"];
    }else if (indexPath.section == 1) {
        [self showHint:@"签约协议详情"];
    }
}

#pragma mark - method
- (void)getDetailMessages
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
        
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        if ([response.code isEqualToString:@"0000"]) {
            [weakself.myDealingDataArray removeAllObjects];
            [weakself.myDealingDataArray addObject:response];
            [weakself.myDealingTableView reloadData];
        }
        
    } andFailBlock:^(NSError *error){
        
    }];
}

- (void)showRecordList
{
    ApplyRecordViewController *applyRecordsVC = [[ApplyRecordViewController alloc] init];
    applyRecordsVC.idStr = self.idString;
    applyRecordsVC.categaryStr = self.categaryString;
    [self.navigationController pushViewController:applyRecordsVC animated:YES];
}

////编辑信息
//- (void)editAllMessages
//{
//    if (self.myDealingDataArray.count > 0) {
//        PublishingResponse *response = self.myDealingDataArray[0];
//        PublishingModel *rModel = response.product;
//
//        ReportSuitViewController *reportSuiVC = [[ReportSuitViewController alloc] init];
//        reportSuiVC.categoryString = rModel.category;
//        reportSuiVC.suResponse = response;
//        reportSuiVC.tagString = @"3";
//        UINavigationController *nsop = [[UINavigationController alloc] initWithRootViewController:reportSuiVC];
//        [self presentViewController:nsop animated:YES completion:nil];
//    }
//}

- (void)deleteThePublishing
{
    NSString *deletePubString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kDeleteProductOfMyReleaseString];
    NSDictionary *params = @{@"id" : self.idString,
                             @"category" : self.categaryString,
                             @"token" : [self getValidateToken],
                             @"type" : @"2"
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:deletePubString params:params successBlock:^(id responseObject) {
        
        BaseModel *baModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baModel.msg];
        if ([baModel.code isEqualToString:@"0000"]) {
            [weakself.navigationController popViewControllerAnimated:YES];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}


/*
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview: self.dealingTableView];
    [self.view addSubview:self.dealFootView];
    [self.view addSubview:self.dealCommitButton];
    [self.dealCommitButton setHidden:YES];
    [self.dealFootView setHidden:YES];
    [self.view addSubview:self.dealRemindButton];
    [self.dealRemindButton setHidden:YES];
    
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
        
        [self.dealRemindButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.dealRemindButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.dealRemindButton autoSetDimension:ALDimensionHeight toSize:kRemindHeight];
        [self.dealRemindButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];

        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)dealingTableView
{
    if (!_dealingTableView) {
        _dealingTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _dealingTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _dealingTableView.delegate = self;
        _dealingTableView.dataSource = self;
        _dealingTableView.backgroundColor = kBackColor;
        _dealingTableView.separatorColor = kSeparateColor;
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
        _dealFootView.layer.borderWidth = kLineWidth;
        _dealFootView.layer.borderColor = kBorderColor.CGColor;
        
        [_dealFootView.getbutton setTitleColor:kBlackColor forState:0];
        [_dealFootView.getbutton setTitle:@" 终止" forState:0];
        [_dealFootView.getbutton setImage:[UIImage imageNamed:@"stop"] forState:0];
        
        [_dealFootView.sendButton setTitleColor:kBlackColor forState:0];
        [_dealFootView.sendButton setTitle:@" 申请结案" forState:0];
        [_dealFootView.sendButton setImage:[UIImage imageNamed:@"end"] forState:0];
    }
    return _dealFootView;
}

- (BaseCommitButton *)dealCommitButton
{
    if (!_dealCommitButton) {
        _dealCommitButton = [BaseCommitButton newAutoLayoutView];
        [_dealCommitButton setTitleColor:kNavColor forState:0];
    }
    return _dealCommitButton;
}

- (BaseRemindButton *)dealRemindButton
{
    if (!_dealRemindButton) {
        _dealRemindButton = [BaseRemindButton newAutoLayoutView];
        [_dealRemindButton setTitle:@"收到申请延期，点击处理  " forState:0];
        [_dealRemindButton setImage:[UIImage imageNamed:@"more_white"] forState:0];
    }
    return _dealRemindButton;
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
        return 5;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dealingDataList.count > 0) {
        if (section == 2) {
            PublishingResponse *response = self.dealingDataList[0];
            if ([response.product.loan_type isEqualToString:@"4"]) {
                return 5;
            }
            return 6;
        }
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 40;
    }else if (indexPath.section == 1){//112
        return 56;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PublishingResponse *response;
    PublishingModel *processModel;
    if (self.dealingDataList.count > 0) {
        response = self.dealingDataList[0];
        processModel = response.product;
    }
    
    static NSString *identifier;
    
    if (indexPath.section == 0) {
        identifier = @"dealing0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0x42566d);
        
        NSString *nameStrss;
        if ([processModel.category integerValue] == 2) {
            nameStrss = @"清收";
        }else if ([processModel.category integerValue] == 3){
            nameStrss = @"诉讼";
        }
        
        NSString *nameStr = [NSString stringWithFormat:@"%@%@",nameStrss,processModel.codeString];
        [cell.userNameButton setTitle:nameStr forState:0];
        [cell.userNameButton setTitleColor:kLightWhiteColor forState:0];
        cell.userNameButton.titleLabel.font = kFourFont;
        
        [cell.userActionButton setTitle:@"处理中" forState:0];
        [cell.userActionButton setTitleColor:kNavColor forState:0];
        cell.userActionButton.titleLabel.font = kFirstFont;
        
        return cell;
        
    }else if (indexPath.section == 1){//联系接单方
        identifier = @"dealing1";
        OrderPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[OrderPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UserNameModel *userNameModel = response.username;
        
        NSString *nameStr = [NSString getValidStringFromString:userNameModel.jusername toString:@"未认证"];
        NSString *checkStr = [NSString stringWithFormat:@"接单方：%@",nameStr];
        [cell.checkButton setTitle:checkStr forState:0];
        [cell.contactButton setTitle:@" 联系他" forState:0];
        [cell.contactButton setImage:[UIImage imageNamed:@"phone_blue"] forState:0];
        
        //接单方详情
        QDFWeakSelf;
        [cell.checkButton addAction:^(UIButton *btn) {
            if ([userNameModel.jusername isEqualToString:@""] || userNameModel.jusername == nil || !userNameModel.jusername) {
                [weakself showHint:@"发布方未认证，不能查看相关信息"];
            }else{
                CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
                checkDetailPublishVC.idString = weakself.idString;
                checkDetailPublishVC.categoryString = weakself.categaryString;
                checkDetailPublishVC.pidString = weakself.pidString;
//                weakself.pidString;
//                weakself.pidString;
                checkDetailPublishVC.typeString = @"接单方";
//                checkDetailPublishVC.typeDegreeString = @"处理中";
                [weakself.navigationController pushViewController:checkDetailPublishVC animated:YES];
            }
        }];
        
        //电话
        [cell.contactButton addAction:^(UIButton *btn) {
            if ([userNameModel.jusername isEqualToString:@""] || userNameModel.jusername == nil || !userNameModel.jusername) {
                [self showHint:@"接单方未认证，不能打电话"];
            }else{
                NSMutableString *phoneStr = [NSMutableString stringWithFormat:@"telprompt://%@",userNameModel.jmobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
            }
        }];
        
        return cell;
        
    }else if(indexPath.section == 2){//详情
        if (indexPath.row == 0) {
            identifier = @"dealing20";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userNameButton.userInteractionEnabled = NO;
            cell.userActionButton.userInteractionEnabled = NO;
            
            [cell.userNameButton setTitle:@"产品信息" forState:0];
            [cell.userActionButton setTitle:@"查看全部  " forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            return cell;
        }
        //详情
        identifier = @"dealing21";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
        cell.userNameButton.titleLabel.font = kFirstFont;
        [cell.userActionButton setTitleColor:kGrayColor forState:0];
        cell.userActionButton.titleLabel.font = kFirstFont;
        
        NSString *rowString1 = @"借款本金";
        NSString *rowString11 = [NSString stringWithFormat:@"%@万",processModel.money];//具体借款本金
        NSString *rowString2 = @"费用类型";
        NSString *rowString3;//具体费用类型
        NSString *rowString33;//费用
        if ([processModel.category integerValue] == 2) {
            if ([processModel.agencycommissiontype integerValue] == 1) {
                rowString3 = @"服务佣金";
                rowString33 = [NSString stringWithFormat:@"%@%@",processModel.agencycommission,@"%"];
            }else{
                rowString3 = @"固定费用";
                rowString33 = [NSString stringWithFormat:@"%@万",processModel.agencycommission];
            }
        }else if ([processModel.category integerValue] == 3){
            if ([processModel.agencycommissiontype integerValue] == 1) {
                rowString3 = @"固定费用";
                rowString33 = [NSString stringWithFormat:@"%@万",processModel.agencycommission];
            }else{
                rowString3 = @"代理费率";
                rowString33 = [NSString stringWithFormat:@"%@%@",processModel.agencycommission,@"%"];
            }
        }
        
        NSString *rowString4 = @"债权类型";
        NSString *rowString44; //具体债权类型
        NSString *rowString5;
        NSString *rowString55;
        if ([processModel.loan_type integerValue] == 1) {
            rowString44 = @"房产抵押";
            rowString5 = @"抵押物地址";
            rowString55 = processModel.seatmortgage;
        }else if ([processModel.loan_type integerValue] == 2) {
            rowString44 = @"应收帐款";
            rowString5 = @"应收帐款";
            rowString55 = [NSString stringWithFormat:@"%@万",processModel.accountr];;
        }else if ([processModel.loan_type integerValue] == 3) {
            rowString44 = @"机动车抵押";
            rowString5 = @"机动车抵押";
            rowString55 = response.car;
        }else if ([processModel.loan_type integerValue] == 4) {
            rowString44 = @"无抵押";
            rowString5 = @"1";
            rowString55 = @"1";
        }
        
        NSArray *rowLeftArray = @[rowString1,rowString2,rowString3,rowString4,rowString5];
        NSArray *rowRightArray = @[rowString11,rowString3,rowString33,rowString44,rowString55];
        
        [cell.userNameButton setTitle:rowLeftArray[indexPath.row-1] forState:0];
        [cell.userActionButton setTitle:rowRightArray[indexPath.row-1] forState:0];
        
        return cell;
    }else if (indexPath.section == 3){//服务协议
        identifier = @"dealing3";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userNameButton.userInteractionEnabled = NO;
        cell.userActionButton.userInteractionEnabled = NO;
        
        [cell.userNameButton setTitle:@"服务协议" forState:0];
        [cell.userActionButton setTitle:@"点击查看  " forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        return cell;
        
    }else{//处理进度
        identifier = @"dealing4";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userNameButton.userInteractionEnabled = NO;
        cell.userActionButton.userInteractionEnabled = NO;
        
        [cell.userNameButton setTitle:@"处理进度" forState:0];
        [cell.userActionButton setTitle:@"查看进度  " forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
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
    if (indexPath.section == 2 && indexPath.row == 0) {
        AdditionMessagesViewController *additionMessageVC = [[AdditionMessagesViewController alloc] init];
        additionMessageVC.idString = self.idString;
        additionMessageVC.categoryString = self.categaryString;
        [self.navigationController pushViewController:additionMessageVC animated:YES];
    }else if (indexPath.section == 3) {//协议
        AgreementViewController *agreementVc = [[AgreementViewController alloc] init];
        agreementVc.idString = self.idString;
        agreementVc.categoryString = self.categaryString;
        [self.navigationController pushViewController:agreementVc animated:YES];
    }else if (indexPath.section == 4) {
        PaceViewController *paceVC = [[PaceViewController alloc] init];
        paceVC.idString = self.idString;
        paceVC.categoryString = self.categaryString;
        [self.navigationController pushViewController:paceVC animated:YES];
    }
}

#pragma mark - method
- (void)getDealingMessage
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailString];
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
                
                //接单方法起的延期申请状态
                [weakself delayRequestFromOrder];
                
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
                
                [weakself.dealCommitButton setBackgroundColor:kBlueColor];
                [weakself.dealCommitButton setTitle:@"同意结案" forState:0];
                [weakself.dealCommitButton addAction:^(UIButton *btn) {
                    [weakself endProductWithStatusString:@"4"];
                }];
            }else{
                [weakself.dealFootView setHidden:YES];
                [weakself.dealCommitButton setHidden:NO];
                
                [weakself.dealCommitButton setTitle:@"已申请结案，等待对方确认中" forState:0];
                [weakself.dealCommitButton setBackgroundColor:kBorderColor];
                weakself.dealCommitButton.userInteractionEnabled = NO;
            }
        }
        
    } andFailBlock:^(NSError *error){
        
    }];
}

//申请延期状态(接单方发起延期)
- (void)delayRequestFromOrder
{
    NSString *deString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kIsDelayRequestString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:deString params:params successBlock:^(id responseObject) {
                
        DelayResponse *response = [DelayResponse objectWithKeyValues:responseObject];
        
        DelayModel *delayModel = response.delay;
        PublishingModel *puModel = response.product;

        if ([delayModel.is_agree isEqualToString:@""] || !delayModel.is_agree) {
            [weakself.dealRemindButton setHidden:YES];
        }else if ([delayModel.is_agree integerValue] == 0 && [response.uid integerValue] == [puModel.uidInner integerValue]){
            [weakself.dealRemindButton setHidden:NO];
            QDFWeakSelf;
            [weakself.dealRemindButton addAction:^(UIButton *btn) {
                DelayHandleViewController *delayHandleVC = [[DelayHandleViewController alloc] init];
                delayHandleVC.delayIdStr = delayModel.id_delay;
                [weakself.navigationController pushViewController:delayHandleVC animated:YES];
            }];
        }else{
            [weakself.dealRemindButton setHidden:YES];
        }
        
    } andFailBlock:^(NSError *error) {
        
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
 */

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
