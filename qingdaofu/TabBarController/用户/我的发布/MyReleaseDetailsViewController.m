//
//  MyReleaseDetailsViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/11/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyReleaseDetailsViewController.h"

#import "MoreMessagesViewController.h"  //更多信息

//面谈中
#import "ApplyRecordViewController.h"   //申请记录
#import "DealingEndViewController.h"  //处理终止
#import "DealingCloseViewController.h" //处理结案
#import "RequestEndViewController.h" //申请终止
#import "RequestCloseViewController.h"
#import "SignProtocolViewController.h" //签约协议
#import "AgreementViewController.h"  //居间协议
#import "CheckDetailPublishViewController.h"  //查看接单方信息
#import "PaceViewController.h"  //尽职调查

#import "BaseRemindButton.h"
#import "DialogBoxView.h"//对话框

#import "MineUserCell.h"//完善信息
#import "NewPublishDetailsCell.h"//进度
#import "NewPublishStateCell.h"//状态
#import "NewsTableViewCell.h"//选择申请方
#import "ProductCloseCell.h"  //结案
#import "ProgressCell.h"

//面谈中
#import "OrderPublishCell.h"
#import "PublishCombineView.h"  //底部视图

#import "PublishingResponse.h"
#import "RowsModel.h"
#import "ApplyRecordModel.h"  //申请人
#import "ProductOrdersClosedOrEndApplyModel.h"  //处理终止或结案申请

#import "OrdersModel.h"
#import "OrdersLogsModel.h"

#import "UIView+UITextColor.h"

@interface MyReleaseDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) UITableView *releaseDetailTableView;
@property (nonatomic,strong) PublishCombineView *publishCheckView;
@property (nonatomic,strong) DialogBoxView *dialogBoxView;//对话框

@property (nonatomic,strong) BaseRemindButton *EndOrloseRemindButton;  //新的申请记录提示信息

//json
@property (nonatomic,strong) NSMutableArray *releaseDetailArray;
@property (nonatomic,strong) NSString *applyidString;//标记是否选择申请人

@end

@implementation MyReleaseDetailsViewController

- (void)viewWillAppear:(BOOL)animated
{
    //当处理终止后刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDetailMessagesssss) name:@"refresh" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    [self.rightButton setHidden:YES];
    
    [self.view addSubview: self.releaseDetailTableView];
    [self.view addSubview:self.publishCheckView];
    [self.publishCheckView setHidden:YES];
    [self.view addSubview:self.dialogBoxView];
    [self.dialogBoxView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
    
    [self getDetailMessagesssss];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.releaseDetailTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
//        [self.releaseDetailTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.publishCheckView];
        
        [self.publishCheckView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
//        [self.publishCheckView autoSetDimension:ALDimensionHeight toSize:92];
        
        
        [self.dialogBoxView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.dialogBoxView autoSetDimension:ALDimensionHeight toSize:kCellHeight1];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)releaseDetailTableView
{
    if (!_releaseDetailTableView) {
        _releaseDetailTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _releaseDetailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _releaseDetailTableView.backgroundColor = kBackColor;
        _releaseDetailTableView.separatorColor = kSeparateColor;
        _releaseDetailTableView.delegate = self;
        _releaseDetailTableView.dataSource = self;
        _releaseDetailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    }
    return _releaseDetailTableView;
}

- (PublishCombineView *)publishCheckView
{
    if (!_publishCheckView) {
        _publishCheckView = [PublishCombineView newAutoLayoutView];
    }
    return _publishCheckView;
}

- (DialogBoxView *)dialogBoxView
{
    if (!_dialogBoxView) {
        _dialogBoxView = [DialogBoxView newAutoLayoutView];
        _dialogBoxView.backgroundColor = kWhiteColor;
        
        QDFWeakSelf;
        [_dialogBoxView setDidEndEditting:^(NSString *text) {
            if (text.length > 0) {
                [weakself sendDialogWithText:text];
            }
        }];
    }
    return _dialogBoxView;
}

- (BaseRemindButton *)EndOrloseRemindButton
{
    if (!_EndOrloseRemindButton) {
        _EndOrloseRemindButton = [BaseRemindButton newAutoLayoutView];
    }
    return _EndOrloseRemindButton;
}

- (NSMutableArray *)releaseDetailArray
{
    if (!_releaseDetailArray) {
        _releaseDetailArray = [NSMutableArray array];
    }
    return _releaseDetailArray;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.releaseDetailArray.count > 0) {
        RowsModel *dataModel = self.releaseDetailArray[0];
        
        if ([dataModel.statusLabel isEqualToString:@"发布中"]) {
            return 2;
        }else if ([dataModel.statusLabel isEqualToString:@"处理中"]) {
            return 4;
        }else if ([dataModel.statusLabel isEqualToString:@"已终止"]) {
            return 4;
        }else if ([dataModel.statusLabel isEqualToString:@"已结案"]) {
            return 2;
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.releaseDetailArray.count > 0) {
        RowsModel *dataModel = self.releaseDetailArray[0];
        if ([dataModel.statusLabel isEqualToString:@"已结案"]) {
            if (section == 0) {
                return 2;
            }
            return 1;

        }else{
            if (section == 0) {
                return 3;
            }else if (section == 3){
                return 1+dataModel.productApply.orders.productOrdersLogs.count;
            }
            return 1;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.releaseDetailArray.count > 0) {
        RowsModel *dataModel = self.releaseDetailArray[0];
        
        if ([dataModel.statusLabel isEqualToString:@"发布中"]) {
            if ([dataModel.productApply.status integerValue] == 20) {//面谈中
                if (indexPath.section == 0) {
                    if (indexPath.row == 0) {
                        return kCellHeight1;
                    }else if (indexPath.row == 1){
                        return 72;
                    }else if (indexPath.row == 2){
                        return kCellHeight3;
                    }
                }
                return 216;
            }else{//发布中
                if (indexPath.section == 0) {
                    if (indexPath.row == 0) {
                        return kCellHeight1;
                    }else if (indexPath.row == 1){
                        return 72;
                    }else if (indexPath.row == 2){
                        return 196;
                    }
                }
                return kCellHeight2;
            }
        }else if ([dataModel.statusLabel isEqualToString:@"处理中"] || [dataModel.statusLabel isEqualToString:@"已终止"]) {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    return kCellHeight1;
                }else if (indexPath.row == 1){
                    return 72;
                }else if (indexPath.row == 2){
                    return kCellHeight3;
                }
            }else if (indexPath.section == 3){
                if (indexPath.row > 0) {//尽职调查
                    return kCellHeight4;
                }
            }
            return kCellHeight;
        }else if ([dataModel.statusLabel isEqualToString:@"已结案"]) {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    return 72;
                }else if (indexPath.row == 1){
                    return kCellHeight3;
                }
            }
            return 395;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    RowsModel *dataModel = self.releaseDetailArray[0];
    
    if ([dataModel.statusLabel isEqualToString:@"发布中"]) {
        if ([dataModel.productApply.status integerValue] == 20) {//面谈中
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    identifier = @"publishing00";
                    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    [cell.userNameButton setTitle:dataModel.number forState:0];
                    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                    [cell.userActionButton setTitle:@"完善信息" forState:0];
                    
                    return cell;
                }else if (indexPath.row == 1){
                    identifier = @"publishing01";
                    NewPublishDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[NewPublishDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = kBackColor;
                    
                    [cell.point2 setImage:[UIImage imageNamed:@"succee"] forState:0];
                    cell.progress2.textColor = kTextColor;
                    [cell.line2 setBackgroundColor:kButtonColor];
                    
                    return cell;
                    
                }else if (indexPath.row == 2){
                    identifier = @"publishing02";
                    OrderPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    
                    if (!cell) {
                        cell = [[OrderPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    NSString *nameStr = [NSString getValidStringFromString:dataModel.productApply.mobile toString:@"未认证"];
                    NSString *checkStr = [NSString stringWithFormat:@"申请方：%@",nameStr];
                    [cell.checkButton setTitle:checkStr forState:0];
                    [cell.contactButton setTitle:@" 联系TA" forState:0];
                    [cell.contactButton setImage:[UIImage imageNamed:@"phone_blue"] forState:0];
                    
                    //接单方详情
                    QDFWeakSelf;
                    [cell.checkButton addAction:^(UIButton *btn) {
                        if ([nameStr isEqualToString:@"未认证"]) {
                            [weakself showHint:@"申请方未认证，不能查看相关信息"];
                        }else{
                            CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
                            checkDetailPublishVC.navTitle = @"申请方详情";
                            checkDetailPublishVC.productid = dataModel.productid;
                            checkDetailPublishVC.userid = dataModel.productApply.create_by;
                            [weakself.navigationController pushViewController:checkDetailPublishVC animated:YES];
                        }

                    }];
                    
                    //电话
                    [cell.contactButton addAction:^(UIButton *btn) {
                        if ([nameStr isEqualToString:@"未认证"]) {
                            [weakself showHint:@"接单方未认证，不能打电话"];
                        }else{
                            NSMutableString *phoneStr = [NSMutableString stringWithFormat:@"telprompt://%@",dataModel.productApply.mobile];
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
                        }
                    }];
                    return cell;
                }
            }else if (indexPath.section == 1){
                identifier = @"publishing10";
                NewPublishStateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[NewPublishStateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = kWhiteColor;
                
                cell.stateLabel1.text = @"等待面谈";
                
                cell.stateLabel2.numberOfLines = 0;
                [cell.stateLabel2 setTextAlignment:NSTextAlignmentCenter];
                NSString *sss1 = @"双方联系并约见面谈并确定是否由TA作为接单方";
                NSString *sss2 = @"面谈时可能需准备的";
                NSString *sss3 = @"《材料清单》";
                NSString *sss = [NSString stringWithFormat:@"%@\n%@%@",sss1,sss2,sss3];
                NSMutableAttributedString *attributeSS = [[NSMutableAttributedString alloc] initWithString:sss];
                [attributeSS addAttributes:@{NSFontAttributeName:kFourFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, sss1.length+1+sss2.length)];
                [attributeSS addAttributes:@{NSFontAttributeName:kFourFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(sss1.length+1+sss2.length, sss3.length)];
                
                NSMutableParagraphStyle *sisi = [[NSMutableParagraphStyle alloc] init];
                [sisi setLineSpacing:kSpacePadding];
                sisi.alignment = 1;
                [attributeSS addAttribute:NSParagraphStyleAttributeName value:sisi range:NSMakeRange(0, sss.length)];
                
                [cell.stateLabel2 setAttributedText:attributeSS];
                
                return cell;
            }
        }else{//发布中
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    identifier = @"publishing000";
                    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    [cell.userNameButton setTitle:dataModel.number forState:0];
                    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                    [cell.userActionButton setTitle:@"完善信息" forState:0];
                    
                    return cell;
                }else if (indexPath.row == 1){
                    identifier = @"publishing001";
                    NewPublishDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[NewPublishDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = kBackColor;
                    
                    return cell;
                    
                }else if (indexPath.row == 2){
                    identifier = @"publishing002";
                    NewPublishStateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[NewPublishStateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = kWhiteColor;
                    
                    return cell;
                }
                
            }else if (indexPath.section == 1){
                identifier = @"publishing010";
                NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (!self.applyidString) {
                    [cell.newsNameButton setTitle:@"选择申请方" forState:0];
                    [cell.newsActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                    if ([dataModel.applyCount integerValue] == 0) {
                        [cell.newsCountButton setTitle:@"请选择申请方" forState:0];
                        cell.newsCountButton.backgroundColor = kWhiteColor;
                        [cell.newsCountButton setTitleColor:kBlackColor forState:0];
                    }else{
                        [cell.newsCountButton setTitle:dataModel.applyCount forState:0];
                        cell.newsCountButton.backgroundColor = kYellowColor;
                    }
                }
                
                return cell;
            }
        }
    }else if ([dataModel.statusLabel isEqualToString:@"处理中"] || [dataModel.statusLabel isEqualToString:@"已终止"]) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                identifier = @"myDealing00";
                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell.userNameButton setTitle:dataModel.number forState:0];
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
                
                if ([dataModel.productApply.orders.status integerValue] == 30) {//终止
                    [cell.point3 setImage:[UIImage imageNamed:@"fail"] forState:0];
                    cell.progress3.textColor = kRedColor;
                    [cell.line3 setBackgroundColor:kRedColor];
                }else{//处理中
                    [cell.point3 setImage:[UIImage imageNamed:@"succee"] forState:0];
                    cell.progress3.textColor = kTextColor;
                    [cell.line3 setBackgroundColor:kButtonColor];
                }
                
                return cell;
                
            }else if (indexPath.row == 2){
                identifier = @"myDealing02";
                OrderPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                
                if (!cell) {
                    cell = [[OrderPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                NSString *nameStr = [NSString getValidStringFromString:dataModel.productApply.mobile toString:@"未认证"];
                NSString *checkStr = [NSString stringWithFormat:@"接单方：%@",nameStr];
                [cell.checkButton setTitle:checkStr forState:0];
                [cell.contactButton setTitle:@" 联系TA" forState:0];
                [cell.contactButton setImage:[UIImage imageNamed:@"phone_blue"] forState:0];
                
                //接单方详情
                QDFWeakSelf;
                [cell.checkButton addAction:^(UIButton *btn) {
                    if ([nameStr isEqualToString:@"未认证"]) {
                        [weakself showHint:@"接单方未认证，不能查看相关信息"];
                    }else{
                        CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
                        checkDetailPublishVC.navTitle = @"接单方详情";
                        checkDetailPublishVC.productid = dataModel.productid;
                        checkDetailPublishVC.userid = dataModel.productApply.create_by;
                        [weakself.navigationController pushViewController:checkDetailPublishVC animated:YES];
                    }
                    
                }];
                
                //电话
                [cell.contactButton addAction:^(UIButton *btn) {
                    if ([nameStr isEqualToString:@"未认证"]) {
                        [weakself showHint:@"接单方未认证，不能打电话"];
                    }else{
                        NSMutableString *phoneStr = [NSMutableString stringWithFormat:@"telprompt://%@",dataModel.productApply.mobile];
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
            
            [cell.userNameButton setTitle:@"居间协议" forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            if ([dataModel.productApply.orders.status integerValue] == 0) {
                [cell.userActionButton setTitle:@"等待接单方上传" forState:0];
            }else{
                [cell.userActionButton setTitle:@"查看" forState:0];
            }
            
            return cell;
        }else if (indexPath.section == 2){
            identifier = @"myDealing2";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.userNameButton setTitle:@"签约协议详情" forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            if ([dataModel.productApply.orders.status integerValue] <= 10) {
                [cell.userActionButton setTitle:@"等待接单方上传" forState:0];
            }else{
                [cell.userActionButton setTitle:@"查看" forState:0];
            }
            
            return cell;
        }else if (indexPath.section == 3){
            if (indexPath.row == 0) {
                identifier = @"myEnding30";
                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.userNameButton setTitle:@"尽职调查" forState:0];
                
                return cell;
            }else{//进度（将第一行和最后一行分开来写，去掉上下间隔线）
                if (indexPath.row == 1) {
                    identifier = @"myEnding31";
                    ProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[ProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell.ppLine1 setHidden:YES];
                    
                    OrdersLogsModel *ordersLogsModel = dataModel.productApply.orders.productOrdersLogs[indexPath.row-1];
                    
                    //time
                    NSString *timess1 = [NSString stringWithFormat:@"%@\n",[NSDate getHMFormatterTime:ordersLogsModel.action_at]];
                    NSString *timess2 = [NSDate getYMDsFormatterTime:ordersLogsModel.action_at];
                    NSString *timess = [NSString stringWithFormat:@"%@%@",timess1,timess2];
                    NSMutableAttributedString *attributeTime = [[NSMutableAttributedString alloc] initWithString:timess];
                    [attributeTime setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(0, timess1.length)];
                    [attributeTime setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(timess1.length, timess2.length)];
                    NSMutableParagraphStyle *styleTime = [[NSMutableParagraphStyle alloc] init];
                    [styleTime setParagraphSpacing:6];
                    styleTime.alignment = 2;
                    [attributeTime addAttribute:NSParagraphStyleAttributeName value:styleTime range:NSMakeRange(0, timess.length)];
                    [cell.ppLabel setAttributedText:attributeTime];
                    
                    //image
                    
                    //content
                    [cell.ppTypeButton setTitle:ordersLogsModel.label forState:0];
                    
                    if ([ordersLogsModel.label isEqualToString:@"系"]) {
                        [cell.ppTypeButton setBackgroundColor:kRedColor];
                        
                        NSString *tttt = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                        [cell.ppTextButton setTitle:tttt forState:0];
                        
//                        cell.ppTextButton.backgroundColor = kBackColor;
//                        [cell.ppTextButton setContentEdgeInsets:UIEdgeInsetsMake(kSpacePadding, kSpacePadding, kSpacePadding, kSpacePadding)];
//                        cell.leftTextConstraints.constant = kSpacePadding;
                        
                    }else if ([ordersLogsModel.label isEqualToString:@"我"]){
                        [cell.ppTypeButton setBackgroundColor:kYellowColor];
                        
                        //已终止不能在尽职调查里面操作
                        if ([dataModel.statusLabel isEqualToString:@"处理中"]) {
                            if ([ordersLogsModel.action integerValue] == 41 || [ordersLogsModel.action integerValue] == 50 || [ordersLogsModel.action integerValue] == 51) {
                                
                                NSString *po1 = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                                NSString *po2 = ordersLogsModel.triggerLabel;
                                NSString *po = [NSString stringWithFormat:@"%@%@",po1,po2];
                                NSMutableAttributedString *attributePo = [[NSMutableAttributedString alloc] initWithString:po];
                                [attributePo setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, po1.length)];
                                [attributePo setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(po1.length, po2.length)];
                                [cell.ppTextButton setAttributedTitle:attributePo forState:0];
                                
                                QDFWeakSelf;
                                [cell.ppTextButton addAction:^(UIButton *btn) {
                                    [weakself actionOfEndOrCloseWithModel:dataModel andActionType:ordersLogsModel.action andPerson:@"发布方"];
                                }];
                                
                            }else{
                                NSString *tttt = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                                [cell.ppTextButton setTitle:tttt forState:0];
                            }
                        }else{//已终止
                            NSString *tttt = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                            [cell.ppTextButton setTitle:tttt forState:0];
                        }
                    }else if ([ordersLogsModel.label isEqualToString:@"接"]){
                        
                        [cell.ppTypeButton setBackgroundColor:kButtonColor];
                        
                        if ([dataModel.statusLabel isEqualToString:@"处理中"]) {
                            if ([ordersLogsModel.action integerValue] == 40 || [ordersLogsModel.action integerValue] == 50 || [ordersLogsModel.action integerValue] == 51) {
                                
                                NSString *qo1 = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                                NSString *qo2 = ordersLogsModel.triggerLabel;
                                NSString *qo = [NSString stringWithFormat:@"%@%@",qo1,qo2];
                                NSMutableAttributedString *attributeQo = [[NSMutableAttributedString alloc] initWithString:qo];
                                [attributeQo setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, qo1.length)];
                                [attributeQo setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kTextColor   } range:NSMakeRange(qo1.length, qo2.length)];
                                [cell.ppTextButton setAttributedTitle:attributeQo forState:0];
                                
                                QDFWeakSelf;
                                [cell.ppTextButton addAction:^(UIButton *btn) {
                                    [weakself actionOfEndOrCloseWithModel:dataModel andActionType:ordersLogsModel.action andPerson:@"接单方"];
                                }];
                                
                            }else{
                                NSString *tttt = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                                [cell.ppTextButton setTitle:tttt forState:0];
                            }
                        }else{//已终止
                            NSString *tttt = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                            [cell.ppTextButton setTitle:tttt forState:0];

                        }
                    }else if ([ordersLogsModel.label isEqualToString:@"经"]){
                        [cell.ppTypeButton setBackgroundColor:kGrayColor];
                        
                        if (ordersLogsModel.memoTel.length > 0) {//有电话
                            NSString *mm1 = [NSString stringWithFormat:@"[%@]",ordersLogsModel.actionLabel];
                            NSString *mm2 = [NSString stringWithFormat:@"%@%@",ordersLogsModel.memoLabel,[ordersLogsModel.memoTel substringWithRange:NSMakeRange(0, ordersLogsModel.memoTel.length-11)]];
                            NSString *mm3 = [ordersLogsModel.memoTel substringWithRange:NSMakeRange(ordersLogsModel.memoTel.length-11, 11)];
                            NSString *mm = [NSString stringWithFormat:@"%@%@%@",mm1,mm2,mm3];
                            NSMutableAttributedString *attributeMM = [[NSMutableAttributedString alloc] initWithString:mm];
                            [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, mm1.length)];
                            [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(mm1.length, mm2.length)];
                            [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(mm2.length+mm1.length, mm3.length)];
                            [cell.ppTextButton setAttributedTitle:attributeMM forState:0];
                            
                            [cell.ppTextButton addAction:^(UIButton *btn) {
                                NSMutableString *phone = [NSMutableString stringWithFormat:@"telprompt://%@",mm3];
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
                            }];

                        }else{//无电话
                            NSString *tttt = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                            [cell.ppTextButton setTitle:tttt forState:0];
                        }
                    }
                    return cell;
                    
                }else if (indexPath.row == dataModel.productApply.orders.productOrdersLogs.count){
                    identifier = @"myEnding38";
                    ProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[ProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell.ppLine2 setHidden:YES];

                    OrdersLogsModel *ordersLogsModel = dataModel.productApply.orders.productOrdersLogs[indexPath.row-1];
                    
                    //time
                    NSString *timess1 = [NSString stringWithFormat:@"%@\n",[NSDate getHMFormatterTime:ordersLogsModel.action_at]];
                    NSString *timess2 = [NSDate getYMDsFormatterTime:ordersLogsModel.action_at];
                    NSString *timess = [NSString stringWithFormat:@"%@%@",timess1,timess2];
                    NSMutableAttributedString *attributeTime = [[NSMutableAttributedString alloc] initWithString:timess];
                    [attributeTime setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(0, timess1.length)];
                    [attributeTime setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(timess1.length, timess2.length)];
                    NSMutableParagraphStyle *styleTime = [[NSMutableParagraphStyle alloc] init];
                    [styleTime setParagraphSpacing:6];
                    styleTime.alignment = 2;
                    [attributeTime addAttribute:NSParagraphStyleAttributeName value:styleTime range:NSMakeRange(0, timess.length)];
                    [cell.ppLabel setAttributedText:attributeTime];
                    
                    //image
                    
                    //content
                    [cell.ppTypeButton setTitle:ordersLogsModel.label forState:0];
                    if ([ordersLogsModel.label isEqualToString:@"系"]) {
                        [cell.ppTypeButton setBackgroundColor:kRedColor];
                        
                        NSString *tttt = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                        [cell.ppTextButton setTitle:tttt forState:0];
                        
//                        cell.ppTextButton.backgroundColor = kBackColor;
//                        [cell.ppTextButton setContentEdgeInsets:UIEdgeInsetsMake(kSpacePadding, kSpacePadding, kSpacePadding, kSpacePadding)];
//                        cell.leftTextConstraints.constant = kSpacePadding;
                        
                    }else if ([ordersLogsModel.label isEqualToString:@"我"]){
                        [cell.ppTypeButton setBackgroundColor:kYellowColor];
                        
                        if ([dataModel.statusLabel isEqualToString:@"处理中"]) {
                            if ([ordersLogsModel.action integerValue] == 41 || [ordersLogsModel.action integerValue] == 50 || [ordersLogsModel.action integerValue] == 51) {
                                
                                NSString *po1 = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                                NSString *po2 = ordersLogsModel.triggerLabel;
                                NSString *po = [NSString stringWithFormat:@"%@%@",po1,po2];
                                NSMutableAttributedString *attributePo = [[NSMutableAttributedString alloc] initWithString:po];
                                [attributePo setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, po1.length)];
                                [attributePo setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(po1.length, po2.length)];
                                [cell.ppTextButton setAttributedTitle:attributePo forState:0];
                                
                                QDFWeakSelf;
                                [cell.ppTextButton addAction:^(UIButton *btn) {
                                    [weakself actionOfEndOrCloseWithModel:dataModel andActionType:ordersLogsModel.action andPerson:@"发布方"];
                                }];
                                
                            }else{
                                NSString *tttt = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                                [cell.ppTextButton setTitle:tttt forState:0];
                            }
                        }else{
                            NSString *tttt = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                            [cell.ppTextButton setTitle:tttt forState:0];
                        }
                    }else if ([ordersLogsModel.label isEqualToString:@"接"]){
                        [cell.ppTypeButton setBackgroundColor:kButtonColor];
                        
                        if ([dataModel.statusLabel isEqualToString:@"处理中"]) {
                            if ([ordersLogsModel.action integerValue] == 40 || [ordersLogsModel.action integerValue] == 50 || [ordersLogsModel.action integerValue] == 51) {
                                
                                NSString *qo1 = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                                NSString *qo2 = ordersLogsModel.triggerLabel;
                                NSString *qo = [NSString stringWithFormat:@"%@%@",qo1,qo2];
                                NSMutableAttributedString *attributeQo = [[NSMutableAttributedString alloc] initWithString:qo];
                                [attributeQo setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, qo1.length)];
                                [attributeQo setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kTextColor   } range:NSMakeRange(qo1.length, qo2.length)];
                                
                                [cell.ppTextButton setAttributedTitle:attributeQo forState:0];
                                
                                QDFWeakSelf;
                                [cell.ppTextButton addAction:^(UIButton *btn) {
                                    [weakself actionOfEndOrCloseWithModel:dataModel andActionType:ordersLogsModel.action andPerson:@"接单方"];
                                }];
                                
                            }else{
                                NSString *tttt = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                                [cell.ppTextButton setTitle:tttt forState:0];
                            }
                        }else{
                            NSString *tttt = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                            [cell.ppTextButton setTitle:tttt forState:0];
                        }
                    }else if ([ordersLogsModel.label isEqualToString:@"经"]){
                        [cell.ppTypeButton setBackgroundColor:kGrayColor];
                        if (ordersLogsModel.memoTel.length > 0) {//有电话
                            NSString *mm1 = [NSString stringWithFormat:@"[%@]",ordersLogsModel.actionLabel];
                            NSString *mm2 = [NSString stringWithFormat:@"%@%@",ordersLogsModel.memoLabel,[ordersLogsModel.memoTel substringWithRange:NSMakeRange(0, ordersLogsModel.memoTel.length-11)]];
                            NSString *mm3 = [ordersLogsModel.memoTel substringWithRange:NSMakeRange(ordersLogsModel.memoTel.length-11, 11)];
                            NSString *mm = [NSString stringWithFormat:@"%@%@%@",mm1,mm2,mm3];
                            NSMutableAttributedString *attributeMM = [[NSMutableAttributedString alloc] initWithString:mm];
                            [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, mm1.length)];
                            [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(mm1.length, mm2.length)];
                            [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(mm2.length+mm1.length, mm3.length)];
                            [cell.ppTextButton setAttributedTitle:attributeMM forState:0];
                            
                            [cell.ppTextButton addAction:^(UIButton *btn) {
                                NSMutableString *phone = [NSMutableString stringWithFormat:@"telprompt://%@",mm3];
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
                            }];
                            
                        }else{//无电话
                            NSString *tttt = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                            [cell.ppTextButton setTitle:tttt forState:0];
                        }
                    }
                    return cell;
                }
                
                identifier = @"myEnding33";
                ProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[ProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                OrdersLogsModel *ordersLogsModel = dataModel.productApply.orders.productOrdersLogs[indexPath.row-1];
                
                //time
                NSString *timess1 = [NSString stringWithFormat:@"%@\n",[NSDate getHMFormatterTime:ordersLogsModel.action_at]];
                NSString *timess2 = [NSDate getYMDsFormatterTime:ordersLogsModel.action_at];
                NSString *timess = [NSString stringWithFormat:@"%@%@",timess1,timess2];
                NSMutableAttributedString *attributeTime = [[NSMutableAttributedString alloc] initWithString:timess];
                [attributeTime setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(0, timess1.length)];
                [attributeTime setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(timess1.length, timess2.length)];
                NSMutableParagraphStyle *styleTime = [[NSMutableParagraphStyle alloc] init];
                [styleTime setParagraphSpacing:6];
                styleTime.alignment = 2;
                [attributeTime addAttribute:NSParagraphStyleAttributeName value:styleTime range:NSMakeRange(0, timess.length)];
                [cell.ppLabel setAttributedText:attributeTime];
                
                //image
                
                //content
                [cell.ppTypeButton setTitle:ordersLogsModel.label forState:0];
                if ([ordersLogsModel.label isEqualToString:@"系"]) {
                    [cell.ppTypeButton setBackgroundColor:kRedColor];
                    
                    NSString *tttt = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                    [cell.ppTextButton setTitle:tttt forState:0];
                    
//                    cell.ppTextButton.backgroundColor = kBackColor;
//                    [cell.ppTextButton setContentEdgeInsets:UIEdgeInsetsMake(kSpacePadding, kSpacePadding, kSpacePadding, kSpacePadding)];
//                    cell.leftTextConstraints.constant = kSpacePadding;
                    
                }else if ([ordersLogsModel.label isEqualToString:@"我"]){
                    [cell.ppTypeButton setBackgroundColor:kYellowColor];

                    if ([dataModel.statusLabel isEqualToString:@"处理中"]) {
                        if ([ordersLogsModel.action integerValue] == 41 || [ordersLogsModel.action integerValue] == 50 || [ordersLogsModel.action integerValue] == 51) {
                            
                            NSString *po1 = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                            NSString *po2 = ordersLogsModel.triggerLabel;
                            NSString *po = [NSString stringWithFormat:@"%@%@",po1,po2];
                            NSMutableAttributedString *attributePo = [[NSMutableAttributedString alloc] initWithString:po];
                            [attributePo setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, po1.length)];
                            [attributePo setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(po1.length, po2.length)];
                            [cell.ppTextButton setAttributedTitle:attributePo forState:0];
                            
                            QDFWeakSelf;
                            [cell.ppTextButton addAction:^(UIButton *btn) {
                                [weakself actionOfEndOrCloseWithModel:dataModel andActionType:ordersLogsModel.action andPerson:@"发布方"];
                            }];
                            
                        }else{
                            NSString *tttt = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                            [cell.ppTextButton setTitle:tttt forState:0];
                        }
                    }else{
                        NSString *tttt = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                        [cell.ppTextButton setTitle:tttt forState:0];
                    }
                }else if ([ordersLogsModel.label isEqualToString:@"接"]){
                    [cell.ppTypeButton setBackgroundColor:kButtonColor];
                    
                    if ([dataModel.statusLabel isEqualToString:@"处理中"]) {
                        if ([ordersLogsModel.action integerValue] == 40 || [ordersLogsModel.action integerValue] == 50 || [ordersLogsModel.action integerValue] == 51) {
                            
                            NSString *qo1 = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                            NSString *qo2 = ordersLogsModel.triggerLabel;
                            NSString *qo = [NSString stringWithFormat:@"%@%@",qo1,qo2];
                            NSMutableAttributedString *attributeQo = [[NSMutableAttributedString alloc] initWithString:qo];
                            [attributeQo setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, qo1.length)];
                            [attributeQo setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kTextColor   } range:NSMakeRange(qo1.length, qo2.length)];
                            
                            [cell.ppTextButton setAttributedTitle:attributeQo forState:0];
                            
                            QDFWeakSelf;
                            [cell.ppTextButton addAction:^(UIButton *btn) {
                                [weakself actionOfEndOrCloseWithModel:dataModel andActionType:ordersLogsModel.action andPerson:@"接单方"];
                            }];
                            
                        }else{
                            NSString *tttt = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                            [cell.ppTextButton setTitle:tttt forState:0];
                        }
                    }else{
                        NSString *tttt = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                        [cell.ppTextButton setTitle:tttt forState:0];
                    }
                }else if ([ordersLogsModel.label isEqualToString:@"经"]){
                    [cell.ppTypeButton setBackgroundColor:kGrayColor];
                    if (ordersLogsModel.memoTel.length > 0) {//有电话
                        NSString *mm1 = [NSString stringWithFormat:@"[%@]",ordersLogsModel.actionLabel];
                        NSString *mm2 = [NSString stringWithFormat:@"%@%@",ordersLogsModel.memoLabel,[ordersLogsModel.memoTel substringWithRange:NSMakeRange(0, ordersLogsModel.memoTel.length-11)]];
                        NSString *mm3 = [ordersLogsModel.memoTel substringWithRange:NSMakeRange(ordersLogsModel.memoTel.length-11, 11)];
                        NSString *mm = [NSString stringWithFormat:@"%@%@%@",mm1,mm2,mm3];
                        NSMutableAttributedString *attributeMM = [[NSMutableAttributedString alloc] initWithString:mm];
                        [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, mm1.length)];
                        [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(mm1.length, mm2.length)];
                        [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(mm2.length+mm1.length, mm3.length)];
                        [cell.ppTextButton setAttributedTitle:attributeMM forState:0];
                        
                        [cell.ppTextButton addAction:^(UIButton *btn) {
                            NSMutableString *phone = [NSMutableString stringWithFormat:@"telprompt://%@",mm3];
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
                        }];
                        
                    }else{//无电话
                        NSString *tttt = [NSString stringWithFormat:@"[%@]%@",ordersLogsModel.actionLabel,ordersLogsModel.memoLabel];
                        [cell.ppTextButton setTitle:tttt forState:0];
                    }
                }
                return cell;
            }
        }
    }
//    else if ([dataModel.statusLabel isEqualToString:@"已终止"]) {//已终止
//        if (indexPath.section == 0) {
//            if (indexPath.row == 0) {
//                identifier = @"myEnding00";
//                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//                if (!cell) {
//                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//                }
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                
//                [cell.userNameButton setTitle:dataModel.number forState:0];
//                [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
//                [cell.userActionButton setTitle:@"查看详情" forState:0];
//                
//                return cell;
//                
//            }else if (indexPath.row == 1){
//                identifier = @"myEnding01";
//                NewPublishDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//                if (!cell) {
//                    cell = [[NewPublishDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//                }
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                cell.backgroundColor = kBackColor;
//                
//                [cell.point2 setImage:[UIImage imageNamed:@"succee"] forState:0];
//                cell.progress2.textColor = kTextColor;
//                [cell.line2 setBackgroundColor:kButtonColor];
//                
//                
//                [cell.point3 setImage:[UIImage imageNamed:@"fail"] forState:0];
//                cell.progress3.textColor = kRedColor;
//                [cell.line3 setBackgroundColor:kRedColor];
//                cell.progress3.text = @"已终止";
//                return cell;
//                
//            }else if (indexPath.row == 2){
//                identifier = @"myEnding02";
//                OrderPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//                
//                if (!cell) {
//                    cell = [[OrderPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//                }
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                
//                NSString *nameStr = [NSString getValidStringFromString:dataModel.productApply.mobile toString:@"未认证"];
//                NSString *checkStr = [NSString stringWithFormat:@"申请方：%@",nameStr];
//                [cell.checkButton setTitle:checkStr forState:0];
//                [cell.contactButton setTitle:@" 联系TA" forState:0];
//                [cell.contactButton setImage:[UIImage imageNamed:@"phone_blue"] forState:0];
//                
//                //接单方详情
//                QDFWeakSelf;
//                [cell.checkButton addAction:^(UIButton *btn) {
//                    if ([nameStr isEqualToString:@"未认证"]) {
//                        [weakself showHint:@"接单方未认证，不能查看相关信息"];
//                    }else{
//                        CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
//                        checkDetailPublishVC.navTitle = @"接单方详情";
//                        checkDetailPublishVC.productid = dataModel.productid;
//                        checkDetailPublishVC.userid = dataModel.productApply.create_by;
//                        [weakself.navigationController pushViewController:checkDetailPublishVC animated:YES];
//                    }
//                    
//                }];
//                
//                //电话
//                [cell.contactButton addAction:^(UIButton *btn) {
//                    if ([nameStr isEqualToString:@"未认证"]) {
//                        [weakself showHint:@"接单方未认证，不能打电话"];
//                    }else{
//                        NSMutableString *phoneStr = [NSMutableString stringWithFormat:@"telprompt://%@",dataModel.productApply.mobile];
//                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
//                    }
//                }];
//                return cell;
//            }
//            
//        }else if (indexPath.section == 1){
//            identifier = @"myEnding1";
//            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//            if (!cell) {
//                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//            }
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            [cell.userNameButton setTitle:@"居间协议" forState:0];
//            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
//            
//            if ([dataModel.productApply.orders.status integerValue] == 0) {
//                [cell.userActionButton setTitle:@"等待接单方上传" forState:0];
//            }else{
//                [cell.userActionButton setTitle:@"查看" forState:0];
//            }
//
//            return cell;
//        }else if (indexPath.section == 2){
//            identifier = @"myEnding2";
//            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//            if (!cell) {
//                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//            }
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            [cell.userNameButton setTitle:@"签约协议详情" forState:0];
//            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
//            
//            if ([dataModel.productApply.orders.status integerValue] <= 10) {
//                [cell.userActionButton setTitle:@"等待接单方上传" forState:0];
//            }else{
//                [cell.userActionButton setTitle:@"查看" forState:0];
//            }
//            
//            return cell;
//        }else if (indexPath.section == 3){
//            if (indexPath.row == 0) {
//                identifier = @"myEnding30";
//                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//                if (!cell) {
//                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//                }
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                [cell.userNameButton setTitle:@"尽职调查" forState:0];
//                return cell;
//            }else{//ProgressCell.h
//                identifier = @"myEnding31";
//                ProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//                if (!cell) {
//                    cell = [[ProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//                }
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//                OrdersLogsModel *ordersLogsModel = dataModel.productApply.orders.productOrdersLogs[indexPath.row-1];
//                
//                cell.ppLabel.text = [NSDate getYMDhmsFormatterTime:ordersLogsModel.action_at];
//                NSString *textts = [NSString getValidStringFromString:ordersLogsModel.memoLabel toString:@"无内容"];
//                [cell.ppTextButton setTitle:textts forState:0];
//                
//                return cell;
//            }
//        }
//    }
    else if ([dataModel.statusLabel isEqualToString:@"已结案"]) {//已结案
        if (indexPath.section == 0) {
            identifier = @"close00";
            if (indexPath.row == 0){
                identifier = @"myDealing00";
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
                [cell.line3 setBackgroundColor:kLightGrayColor];
                [cell.point4 setImage:[UIImage imageNamed:@"succee"] forState:0];
                cell.progress4.textColor = kTextColor;
                
                return cell;
                
            }else if (indexPath.row == 1){
                identifier = @"myDealing01";
                OrderPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                
                if (!cell) {
                    cell = [[OrderPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                NSString *nameStr = [NSString getValidStringFromString:dataModel.productApply.mobile toString:@"未认证"];
                NSString *checkStr = [NSString stringWithFormat:@"接单方：%@",nameStr];
                [cell.checkButton setTitle:checkStr forState:0];
                [cell.contactButton setTitle:@" 联系TA" forState:0];
                [cell.contactButton setImage:[UIImage imageNamed:@"phone_blue"] forState:0];
                
                //接单方详情
                QDFWeakSelf;
                [cell.checkButton addAction:^(UIButton *btn) {
                    if ([nameStr isEqualToString:@"未认证"]) {
                        [weakself showHint:@"接单方未认证，不能查看相关信息"];
                    }else{
                        CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
                        checkDetailPublishVC.navTitle = @"接单方详情";
                        checkDetailPublishVC.productid = dataModel.productid;
                        checkDetailPublishVC.userid = dataModel.productApply.create_by;
                        [weakself.navigationController pushViewController:checkDetailPublishVC animated:YES];
                    }
                    
                }];
                
                //电话
                [cell.contactButton addAction:^(UIButton *btn) {
                    if ([nameStr isEqualToString:@"未认证"]) {
                        [weakself showHint:@"接单方未认证，不能打电话"];
                    }else{
                        NSMutableString *phoneStr = [NSMutableString stringWithFormat:@"telprompt://%@",dataModel.productApply.mobile];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
                    }
                }];
                return cell;
            }
        }else if (indexPath.section == 1){
            identifier = @"myDealing1";
            ProductCloseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[ProductCloseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kBackColor;
            
            NSString *code1 = [NSString stringWithFormat:@"%@\n",dataModel.number];
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
            NSString *proText2 = [NSString stringWithFormat:@"债权类型：%@\n",dataModel.categoryLabel];
            NSString *proText3;
            if ([dataModel.typeLabel isEqualToString:@"万"]) {
                proText3 = [NSString stringWithFormat:@"固定费用：%@%@\n",dataModel.typenumLabel,dataModel.typeLabel];
            }else if ([dataModel.typeLabel isEqualToString:@"%"]){
                proText3 = [NSString stringWithFormat:@"风险费率：%@%@\n",dataModel.typenumLabel,dataModel.typeLabel];
            }
            NSString *proText4 = [NSString stringWithFormat:@"委托金额：%@万",dataModel.accountLabel];
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
                        dealingCloseVC.closedid = dataModel.productOrdersClosed.closedid;
                        [weakself.navigationController pushViewController:dealingCloseVC animated:YES];
                    }
                        break;
                    case 331:{//查看全部产品信息
                        MoreMessagesViewController *moreMessagesVC = [[MoreMessagesViewController alloc] init];
                        moreMessagesVC.productid = dataModel.productid;
                        [weakself.navigationController pushViewController:moreMessagesVC animated:YES];
                    }
                        break;
                    case 332:{//查看签约协议
                        SignProtocolViewController *signProtocolVC = [[SignProtocolViewController alloc] init];
                        signProtocolVC.ordersid = dataModel.productApply.orders.ordersid;
                        signProtocolVC.isShowString = @"0";
                        [weakself.navigationController pushViewController:signProtocolVC animated:YES];
                    }
                        break;
                    case 333:{//查看尽职调查
                        PaceViewController *paceVC = [[PaceViewController alloc] init];
                        paceVC.orderLogsArray = dataModel.productApply.orders.productOrdersLogs;
                        [weakself.navigationController pushViewController:paceVC animated:YES];
                    }
                        break;
                    case 334:{//查看居间协议
                        AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
                        agreementVC.navTitleString = @"居间协议";
                        agreementVC.flagString = @"0";
                        agreementVC.productid = dataModel.productid;
                        
                        [weakself.navigationController pushViewController:agreementVC animated:YES];
                    }
                        break;
                    default:
                        break;
                }
            }];
            
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
    RowsModel *dataModel = self.releaseDetailArray[0];
    
    //通用，查看信息
    if (![dataModel.statusLabel isEqualToString:@"已结案"]) {
        if (indexPath.section == 0 && indexPath.row == 0) {//完善信息
            MoreMessagesViewController *moreMessageVC = [[MoreMessagesViewController alloc] init];
            moreMessageVC.productid = dataModel.productid;
            [self.navigationController pushViewController:moreMessageVC animated:YES];
        }
    }
    
    if ([dataModel.statusLabel isEqualToString:@"发布中"]) {
        if ([dataModel.productApply.status integerValue] == 20) {//面谈中
            
        }else{//发布中

            if (indexPath.section == 1) {
                ApplyRecordViewController *applyRecordsVC = [[ApplyRecordViewController alloc] init];
                applyRecordsVC.productid = self.productid;
                [self.navigationController pushViewController:applyRecordsVC animated:YES];
                
                QDFWeakSelf;
                [applyRecordsVC setDidChooseApplyUser:^(ApplyRecordModel *recordModel) {
                    NewsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    [cell.newsNameButton setTitle:@"申请方" forState:0];
                    [cell.newsCountButton setTitle:recordModel.mobile forState:0];
                    [cell.newsCountButton setBackgroundColor:kWhiteColor];
                    [cell.newsCountButton setTitleColor:kLightGrayColor forState:0];
                    
                    [weakself.publishCheckView.comButton2 setBackgroundColor:kButtonColor];
                    weakself.publishCheckView.comButton2.userInteractionEnabled = YES;
                    weakself.applyidString = recordModel.applyid;
                    
                    [weakself.publishCheckView setDidSelectedBtn:^(NSInteger tag)  {
                        if (tag == 111) {
                            [weakself showHint:@"材料清单"];
                        }else if (tag == 112){
                            [weakself showHint:@"发起面谈"];
                            [weakself choosePersonOfInterView];
                        }
                    }];
                }];
            }
        }
    }else if ([dataModel.statusLabel isEqualToString:@"处理中"] || [dataModel.statusLabel isEqualToString:@"已终止"]){
        if (indexPath.section == 1) {
            [self showHint:@"居间协议"];
            if ([dataModel.productApply.orders.status integerValue] > 0) {
                AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
                agreementVC.navTitleString = @"居间协议";
                agreementVC.flagString = @"0";
                agreementVC.productid = dataModel.productid;
                [self.navigationController pushViewController:agreementVC animated:YES];
            }
        }else if (indexPath.section == 2){
            if ([dataModel.productApply.orders.status integerValue] > 10) {
                SignProtocolViewController *signProtocalVC = [[SignProtocolViewController alloc] init];
                signProtocalVC.isShowString = @"0";
                signProtocalVC.ordersid = dataModel.productApply.orders.ordersid;
                [self.navigationController pushViewController:signProtocalVC animated:YES];
            }
        }else if (indexPath.section == 3){
//            if (indexPath.row == 0) {
//                
//            }
        }
    }else if ([dataModel.statusLabel isEqualToString:@"已结案"]){
        
    }
}

#pragma mark - method
- (void)getDetailMessagesssss
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailsString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"productid" : self.productid
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
        
        NSDictionary *apaap = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        [weakself.releaseDetailArray removeAllObjects];
        
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        
        if ([response.code isEqualToString:@"0000"]) {
            
            RowsModel *dataModel = response.data;
            if ([dataModel.statusLabel isEqualToString:@"发布中"]) {
                [weakself.publishCheckView setHidden:NO];
                [weakself.rightButton setHidden:NO];
                [weakself.rightButton setTitle:@"删除订单" forState:0];
                [weakself.rightButton addTarget:self action:@selector(deleteThePublishing) forControlEvents:UIControlEventTouchUpInside];
                
                if ([dataModel.productApply.status integerValue] == 20) {//面谈中
                    
                    [weakself.publishCheckView autoSetDimension:ALDimensionHeight toSize:116];
                    weakself.publishCheckView.topBtnConstraints.constant = kBigPadding;
                    [weakself.publishCheckView.comButton1 setBackgroundColor:kButtonColor];
                    weakself.publishCheckView.comButton2.userInteractionEnabled = YES;
                    
                    NSString *aaa = @"同意TA作为接单方";
                    NSMutableAttributedString *attrie = [[NSMutableAttributedString alloc] initWithString:aaa];
                    [attrie addAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kWhiteColor} range:NSMakeRange(0, aaa.length)];
                    [weakself.publishCheckView.comButton1 setAttributedTitle:attrie forState:0];
                    
                    [weakself.publishCheckView.comButton2 setBackgroundColor:kWhiteColor];
                    [weakself.publishCheckView.comButton2 setTitle:@"不合适，重新选择接单方" forState:0];
                    [weakself.publishCheckView.comButton2 setTitleColor:kLightGrayColor forState:0];
                    weakself.publishCheckView.comButton2.layer.borderColor = kBorderColor.CGColor;
                    weakself.publishCheckView.comButton2.layer.borderWidth = kLineWidth;
                    
                    QDFWeakSelf;
                    [weakself.publishCheckView setDidSelectedBtn:^(NSInteger tag) {
                        if (tag == 111) {
                            [weakself actionOfInterviewResultOfActStirng:@"agree"];
                        }else{
                            [weakself actionOfInterviewResultOfActStirng:@"cancel"];
                        }
                    }];
                }else{//发布中
                    [weakself.publishCheckView autoSetDimension:ALDimensionHeight toSize:92];
                    weakself.publishCheckView.topBtnConstraints.constant = 0;
                    [weakself.publishCheckView.comButton2 setBackgroundColor:kSeparateColor];
                    weakself.publishCheckView.comButton2.userInteractionEnabled = NO;
                    
                    NSString *ppp1 = @"需准备的";
                    NSString *ppp2 = @"《材料清单》";
                    NSString *ppp = [NSString stringWithFormat:@"%@%@",ppp1,ppp2];
                    NSMutableAttributedString *attributePP = [[NSMutableAttributedString alloc] initWithString:ppp];
                    [attributePP addAttributes:@{NSFontAttributeName:kSmallFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, ppp1.length)];
                    [attributePP addAttributes:@{NSFontAttributeName:kSmallFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(ppp1.length, ppp2.length)];
                    [weakself.publishCheckView.comButton1 setAttributedTitle:attributePP forState:0];
                    
                    QDFWeakSelf;
                    [weakself.publishCheckView setDidSelectedBtn:^(NSInteger tag)  {
                        if (tag == 111) {
                            [weakself showHint:@"材料清单"];
                        }else if (tag == 112){
                            [weakself showHint:@"发起面谈"];
                            [weakself choosePersonOfInterView];
                        }
                    }];
                }
            }else if ([dataModel.statusLabel isEqualToString:@"处理中"]){//处理中
                [weakself.publishCheckView setHidden:YES];
                [weakself.dialogBoxView setHidden:NO];
                
                if ([dataModel.productApply.orders.status integerValue] > 10) {
                    [weakself.rightButton setHidden:NO];
                    [weakself.rightButton setTitle:@"申请终止" forState:0];
                    [weakself.rightButton addAction:^(UIButton *btn) {
                        RequestEndViewController *requestEndVC = [[RequestEndViewController alloc] init];
                        requestEndVC.ordersid = dataModel.productApply.orders.ordersid;
                        [weakself.navigationController pushViewController:requestEndVC animated:YES];
                    }];
                }
                
                [weakself.view addSubview:weakself.EndOrloseRemindButton];
                [weakself.EndOrloseRemindButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, kCellHeight1, 0) excludingEdge:ALEdgeTop];
                [weakself.EndOrloseRemindButton autoSetDimension:ALDimensionHeight toSize:kRemindHeight];
                
                if (dataModel.productOrdersTerminationsApply || dataModel.productOrdersClosedsApply) {//有申请结案终止的消息
                    [weakself.EndOrloseRemindButton setHidden:NO];
                    if (dataModel.productOrdersTerminationsApply) {
                        [weakself.EndOrloseRemindButton setTitle:@"对方申请终止次单，点击处理  " forState:0];
                        [weakself.EndOrloseRemindButton setImage:[UIImage imageNamed:@"more_white"] forState:0];
                        [weakself.EndOrloseRemindButton addAction:^(UIButton *btn) {
                            DealingEndViewController *dealEndVC = [[DealingEndViewController alloc] init];
                            dealEndVC.terminationid = dataModel.productOrdersTerminationsApply.terminationid;
                            dealEndVC.isShowAct = @"1";
                            [weakself.navigationController pushViewController:dealEndVC animated:YES];
                        }];
                    }else{
                        [weakself.EndOrloseRemindButton setTitle:@"对方申请结案，点击处理  " forState:0];
                        [weakself.EndOrloseRemindButton setImage:[UIImage imageNamed:@"more_white"] forState:0];
                        
                        [weakself.EndOrloseRemindButton addAction:^(UIButton *btn) {
                            DealingCloseViewController *dealCloseVC = [[DealingCloseViewController alloc] init];
                            dealCloseVC.perTypeString = @"1";
                            dealCloseVC.closedid = dataModel.productOrdersClosed.closedid;
                            [weakself.navigationController pushViewController:dealCloseVC animated:YES];
                        }];
                    }
                }else{
                    [weakself.EndOrloseRemindButton setHidden:YES];
                }
            }else if ([dataModel.statusLabel isEqualToString:@"已终止"]){
                [weakself.publishCheckView setHidden:YES];
                [weakself.dialogBoxView setHidden:YES];
                
                [weakself.rightButton setHidden:YES];
                
                if (weakself.EndOrloseRemindButton) {
                    [weakself.EndOrloseRemindButton removeFromSuperview];
                }
                
            }else if ([dataModel.statusLabel isEqualToString:@"已结案"]){
                [weakself.publishCheckView setHidden:YES];
                [weakself.dialogBoxView setHidden:YES];
                
                [weakself.rightButton setHidden:YES];
                
                if (weakself.EndOrloseRemindButton) {
                    [weakself.EndOrloseRemindButton removeFromSuperview];
                }
            }
            
            [weakself.releaseDetailArray addObject:response.data];
            [weakself.releaseDetailTableView reloadData];
        }
        
    } andFailBlock:^(NSError *error){
        
    }];
}

- (void)choosePersonOfInterView//选择面谈
{
    NSString *interViewString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyreleaseDetailsOfStartInterview];
    NSDictionary *params = @{@"applyid" : self.applyidString,
                             @"token" : [self getValidateToken]
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:interViewString params:params successBlock:^(id responseObject) {
        
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself getDetailMessagesssss];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)deleteThePublishing
{
    NSString *deletePubString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseOfDeleteString];
    NSDictionary *params = @{@"productid" : self.productid,
                             @"token" : [self getValidateToken]
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:deletePubString params:params successBlock:^(id responseObject) {
        
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself.navigationController popViewControllerAnimated:YES];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

//面谈中操作
- (void)actionOfInterviewResultOfActStirng:(NSString *)resultString//是否选择该申请方为接单方
{
    NSString *interViewResultString;
    if ([resultString isEqualToString:@"agree"]) {
        interViewResultString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailOfInterviewResultAgree];
    }else if ([resultString isEqualToString:@"cancel"]){
        interViewResultString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailOfInterviewResultCancel];
    }
    
    RowsModel *rowModel;
    if (self.releaseDetailArray.count > 0) {
        rowModel = self.releaseDetailArray[0];
    }
    
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"applyid" : rowModel.productApply.applyid
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:interViewResultString params:params successBlock:^(id responseObject) {
        
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            
            [weakself getDetailMessagesssss];
            
            if ([resultString isEqualToString:@"agree"]) {//同意－处理中
//                MyDealingViewController *myDealingVC = [[MyDealingViewController alloc] init];
//                myDealingVC.productid = rowModel.productid;
//                UINavigationController *navv = weakself.navigationController;
//                [navv popViewControllerAnimated:NO];
//                [navv pushViewController:myDealingVC animated:NO];
            }else if ([resultString isEqualToString:@"cancel"]){//拒绝－发布中
//                MyPublishingViewController *myPublishingVC = [[MyPublishingViewController alloc] init];
//                myPublishingVC.productid = rowModel.productid;
//                UINavigationController *navv = weakself.navigationController;
//                [navv popViewControllerAnimated:NO];
//                [navv pushViewController:myPublishingVC animated:NO];
            }
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)rightItemAction//申请终止
{
}

//对话框
- (void)sendDialogWithText:(NSString *)text
{
    [self.view endEditing:YES];
    
    NSString *dialogString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrderDetailOfAddPace];
    
    RowsModel *rowModel = self.releaseDetailArray[0];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"ordersid" : rowModel.productApply.orders.ordersid,
                             @"memo" : text};
    
    QDFWeakSelf;
    [self requestDataPostWithString:dialogString params:params successBlock:^(id responseObject) {
        
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself getDetailMessagesssss];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)actionOfEndOrCloseWithModel:(RowsModel *)rowModel andActionType:(NSString *)actionType andPerson:(NSString *)person//person分接单方和发布方；；actionType分40，41，42，50，51，52
{
    if ([actionType integerValue] == 40) {//接单方申请结案
        DealingCloseViewController *dealCloseVC = [[DealingCloseViewController alloc] init];
        dealCloseVC.perTypeString = @"1";
        dealCloseVC.closedid = rowModel.productOrdersClosed.closedid;
        [self.navigationController pushViewController:dealCloseVC animated:YES];
    }else if ([actionType integerValue] == 41){//发布方同意结案
        DealingCloseViewController *dealCloseVC = [[DealingCloseViewController alloc] init];
        dealCloseVC.perTypeString = @"2";
        dealCloseVC.closedid = rowModel.productOrdersClosed.closedid;
        [self.navigationController pushViewController:dealCloseVC animated:YES];
    }else if ([actionType integerValue] == 50 && [person isEqualToString:@"发布方"]){
        //发布方申请终止
        DealingEndViewController *dealEndVC = [[DealingEndViewController alloc] init];
        dealEndVC.terminationid = rowModel.productOrdersTerminationsApply.terminationid;
        dealEndVC.isShowAct = @"2";
        [self.navigationController pushViewController:dealEndVC animated:YES];
    }else if ([actionType integerValue] == 51 && [person isEqualToString:@"发布方"]){
        //发布方同意终止
        DealingEndViewController *dealEndVC = [[DealingEndViewController alloc] init];
        dealEndVC.terminationid = rowModel.productOrdersTerminationsApply.terminationid;
        dealEndVC.isShowAct = @"2";
        [self.navigationController pushViewController:dealEndVC animated:YES];
    }else if ([actionType integerValue] == 50 && [person isEqualToString:@"接单方"]){
        //接单方申请终止
        DealingEndViewController *dealEndVC = [[DealingEndViewController alloc] init];
        dealEndVC.terminationid = rowModel.productOrdersTerminationsApply.terminationid;
        dealEndVC.isShowAct = @"1";
        [self.navigationController pushViewController:dealEndVC animated:YES];
    }else if ([actionType integerValue] == 50 && [person isEqualToString:@"接单方"]){
        //接单方同意终止
        DealingEndViewController *dealEndVC = [[DealingEndViewController alloc] init];
        dealEndVC.terminationid = rowModel.productOrdersTerminationsApply.terminationid;
        dealEndVC.isShowAct = @"2";
        [self.navigationController pushViewController:dealEndVC animated:YES];
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
