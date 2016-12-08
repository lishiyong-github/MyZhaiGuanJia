//
//  MyReleaseDetailsViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/11/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyReleaseDetailsViewController.h"

#import "MoreMessagesViewController.h"  //更多信息
#import "CheckDetailPublishViewController.h"  //查看接单方信息

//面谈中，发布中
#import "ApplyRecordViewController.h"   //申请记录
//处理中，终止
#import "SignProtocolViewController.h" //签约协议
#import "AgreementViewController.h"  //居间协议
#import "RequestEndViewController.h" //申请终止
#import "DealingEndViewController.h"  //处理终止
#import "DealingCloseViewController.h" //处理结案
#import "PaceViewController.h"  //尽职调查
//结案
#import "AdditionalEvaluateViewController.h"  //去评价
#import "EvaluateListsViewController.h"//评价列表

#import "PublishCombineView.h"  //底部视图
#import "BaseRemindButton.h"//提示框
#import "DialogBoxView.h"//对话框
#import "BaseCommitButton.h" //评价

#import "MineUserCell.h"//完善信息
#import "NewPublishDetailsCell.h"//产品进度
#import "NewPublishStateCell.h"//等待面谈状态
#import "NewsTableViewCell.h"//选择申请方
#import "ProductCloseCell.h"  //结案
#import "ProgressCell.h" //尽职调查
#import "OrderPublishCell.h"//查看接单方

#import "PublishingResponse.h"
#import "RowsModel.h"//data
#import "OrdersModel.h" //接单人
#import "ApplyRecordModel.h"  //申请人
#import "ProductOrdersClosedOrEndApplyModel.h"  //处理终止或结案申请
#import "OrdersLogsModel.h" //日志

#import "UIButton+WebCache.h"

@interface MyReleaseDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) UITableView *releaseDetailTableView;
@property (nonatomic,strong) PublishCombineView *publishCheckView;
@property (nonatomic,strong) DialogBoxView *dialogBoxView;//对话框
@property (nonatomic,strong) BaseCommitButton *evaluateButton;  //评价

@property (nonatomic,strong) BaseRemindButton *EndOrloseRemindButton;  //新的申请记录提示信息
@property (nonatomic,strong) NSLayoutConstraint *heightCheckViewConstraints;  //publishCheckView的高度

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
    [self.view addSubview:self.evaluateButton];
    [self.evaluateButton setHidden:YES];
    [self.view addSubview:self.EndOrloseRemindButton];
    [self.EndOrloseRemindButton setHidden:YES];
    
    self.heightCheckViewConstraints = [self.publishCheckView autoSetDimension:ALDimensionHeight toSize:92];
    
    [self.view setNeedsUpdateConstraints];
    
    [self getDetailMessagesssss];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.releaseDetailTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        //处理中之前（发布中，面谈中）
        [self.publishCheckView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        
        //处理中的对话框
        [self.dialogBoxView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.dialogBoxView autoSetDimension:ALDimensionHeight toSize:kCellHeight1];
        
        //处理中的结案终止提醒
        [self.EndOrloseRemindButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, kCellHeight1, 0) excludingEdge:ALEdgeTop];
        [self.EndOrloseRemindButton autoSetDimension:ALDimensionHeight toSize:kRemindHeight];
        
        //结案的评价
        [self.evaluateButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.evaluateButton autoSetDimension:ALDimensionHeight toSize:kCellHeight1];
        
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
        _releaseDetailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
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
        [_dialogBoxView.dialogButton addAction:^(UIButton *btn) {
            if (weakself.dialogBoxView.dialogTextField.text.length > 0) {
                [weakself sendDialogWithText:weakself.dialogBoxView.dialogTextField.text];
            }
        }];
    }
    return _dialogBoxView;
}

- (BaseCommitButton *)evaluateButton
{
    if (!_evaluateButton) {
        _evaluateButton = [BaseCommitButton newAutoLayoutView];
    }
    return _evaluateButton;
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
                    
                    [cell.userNameButton setImage:[UIImage imageNamed:@"product＿icon"] forState:0];
                    NSString *numberd = [NSString stringWithFormat:@" %@",dataModel.number];
                    [cell.userNameButton setTitle:numberd forState:0];
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
                    
                    NSString *nameStr = [NSString getValidStringFromString:dataModel.productApply.realname toString:dataModel.productApply.username];
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
                
                [cell.stateButton setImage:[UIImage imageNamed:@"image_interview"] forState:0];
                
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
                    
                    [cell.userNameButton setImage:[UIImage imageNamed:@"product＿icon"] forState:0];
                    NSString *numberd = [NSString stringWithFormat:@" %@",dataModel.number];
                    [cell.userNameButton setTitle:numberd forState:0];
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
                    
                    cell.stateLabel1.text = @"发布成功";
                    [cell.stateButton setImage:[UIImage imageNamed:@"release_image_success"] forState:0];
                    cell.stateLabel2.text = @"选择一个申请方作为意向接单方进行约见面谈";
                    
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
                    [cell.newsNameButton setImage:[UIImage imageNamed:@"product_application"] forState:0];
                    [cell.newsNameButton setTitle:@" 选择申请方" forState:0];
                    [cell.newsActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                    if ([dataModel.applyCount integerValue] == 0) {
                        [cell.newsCountButton setTitle:@"请选择申请方" forState:0];
                        cell.newsCountButton.backgroundColor = kWhiteColor;
                        [cell.newsCountButton setTitleColor:kBlackColor forState:0];
                    }else{
                        [cell.newsCountButton setTitle:dataModel.applyCount forState:0];
                        cell.newsCountButton.backgroundColor = kYellowColor;
//                        cell.newsCountButton.layer.cornerRadius = 12;
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
                
                [cell.userNameButton setImage:[UIImage imageNamed:@"product＿icon"] forState:0];
                NSString *numberd = [NSString stringWithFormat:@" %@",dataModel.number];
                [cell.userNameButton setTitle:numberd forState:0];
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
                    [cell.progress3 setText:@"已终止"];
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
                
                NSString *nameStr = [NSString getValidStringFromString:dataModel.productApply.realname toString:dataModel.productApply.username];
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
                    [cell.ppLabel setAttributedText:[self showPPLabelOfMyReleaseDetailWithModel:ordersLogsModel]];
                    
                    //image
                    [cell.ppTypeButton setTitle:ordersLogsModel.label forState:0];
                    if ([ordersLogsModel.label isEqualToString:@"我"]) {
                        [cell.ppTypeButton setBackgroundColor:kYellowColor1];
                    }else if ([ordersLogsModel.label isEqualToString:@"经"]){
                        [cell.ppTypeButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                    }else if ([ordersLogsModel.label isEqualToString:@"系"]){
                        [cell.ppTypeButton setBackgroundColor:kBlueColor1];
                    }else if ([ordersLogsModel.label isEqualToString:@"接"]){
                        [cell.ppTypeButton setBackgroundColor:kGreenColor];
                    }
                    
                    //content
                    [cell.ppTextButton setAttributedTitle:[self showPPTextButtonOfMyReleaseDetailWithModel:ordersLogsModel] forState:0];
                    
                    QDFWeakSelf;
                    [cell.ppTextButton addAction:^(UIButton *btn) {
                        [weakself actionOfEndOrCloseWithModel:ordersLogsModel];
                    }];
                    
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
                    [cell.ppLabel setAttributedText:[self showPPLabelOfMyReleaseDetailWithModel:ordersLogsModel]];
                    
                    //image
                    [cell.ppTypeButton setTitle:ordersLogsModel.label forState:0];
                    if ([ordersLogsModel.label isEqualToString:@"我"]) {
                        [cell.ppTypeButton setBackgroundColor:kYellowColor1];
                    }else if ([ordersLogsModel.label isEqualToString:@"经"]){
                        [cell.ppTypeButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                    }else if ([ordersLogsModel.label isEqualToString:@"系"]){
                        [cell.ppTypeButton setBackgroundColor:kBlueColor1];
                    }else if ([ordersLogsModel.label isEqualToString:@"接"]){
                        [cell.ppTypeButton setBackgroundColor:kGreenColor];
                    }
                    
                    //content
                    [cell.ppTextButton setAttributedTitle:[self showPPTextButtonOfMyReleaseDetailWithModel:ordersLogsModel] forState:0];
                    
                    QDFWeakSelf;
                    [cell.ppTextButton addAction:^(UIButton *btn) {
                        [weakself actionOfEndOrCloseWithModel:ordersLogsModel];
                    }];
                    
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
                [cell.ppLabel setAttributedText:[self showPPLabelOfMyReleaseDetailWithModel:ordersLogsModel]];
                
                //image
                [cell.ppTypeButton setTitle:ordersLogsModel.label forState:0];
                if ([ordersLogsModel.label isEqualToString:@"我"]) {
                    [cell.ppTypeButton setBackgroundColor:kYellowColor1];
                }else if ([ordersLogsModel.label isEqualToString:@"经"]){
                    [cell.ppTypeButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                }else if ([ordersLogsModel.label isEqualToString:@"系"]){
                    [cell.ppTypeButton setBackgroundColor:kBlueColor1];
                }else if ([ordersLogsModel.label isEqualToString:@"接"]){
                    [cell.ppTypeButton setBackgroundColor:kGreenColor];
                }
                
                //content
                [cell.ppTextButton setAttributedTitle:[self showPPTextButtonOfMyReleaseDetailWithModel:ordersLogsModel] forState:0];
                
                QDFWeakSelf;
                [cell.ppTextButton addAction:^(UIButton *btn) {
                    [weakself actionOfEndOrCloseWithModel:ordersLogsModel];
                }];
                
                return cell;
            }
        }
    }else if ([dataModel.statusLabel isEqualToString:@"已结案"]) {//已结案
        if (indexPath.section == 0) {
            if (indexPath.row == 0){
                identifier = @"close00";
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
                identifier = @"close01";
                OrderPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                
                if (!cell) {
                    cell = [[OrderPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                NSString *nameStr = [NSString getValidStringFromString:dataModel.productApply.realname toString:dataModel.productApply.username];
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
            identifier = @"close1";
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
            
            //签约协议图片
            ImageModel *imgModel = dataModel.SignPicture[0];
            NSString *imgString = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imgModel.file];
            [cell.signPictureButton1 sd_setImageWithURL:[NSURL URLWithString:imgString] forState:0 placeholderImage:nil];
            
            QDFWeakSelf;
            [cell setDidselectedBtn:^(NSInteger tag) {
                switch (tag) {
                    case 330:{//结清证明
                        DealingCloseViewController *dealingCloseVC = [[DealingCloseViewController alloc] init];
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
            if (indexPath.section == 1) {//材料清单
                [self showMaterialList];
            }
        }else{//发布中
            if (indexPath.section == 1) {//选择申请方
                ApplyRecordViewController *applyRecordsVC = [[ApplyRecordViewController alloc] init];
                applyRecordsVC.productid = self.productid;
                [self.navigationController pushViewController:applyRecordsVC animated:YES];
                
                QDFWeakSelf;
                [applyRecordsVC setDidChooseApplyUser:^(ApplyRecordModel *recordModel) {
                    NewsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    NSString *names = [NSString stringWithFormat:@" %@",[NSString getValidStringFromString:recordModel.realname toString:recordModel.username]];
                    [cell.newsNameButton setTitle:names forState:0];
                    [cell.newsCountButton setTitle:recordModel.mobile forState:0];
                    [cell.newsCountButton setBackgroundColor:kWhiteColor];
                    [cell.newsCountButton setTitleColor:kLightGrayColor forState:0];
                    
                    [weakself.publishCheckView.comButton2 setBackgroundColor:kButtonColor];
                    weakself.publishCheckView.comButton2.userInteractionEnabled = YES;
                    weakself.applyidString = recordModel.applyid;
                    
                    [weakself.publishCheckView setDidSelectedBtn:^(NSInteger tag)  {
                        if (tag == 111) {
                            [self showMaterialList];
                        }else if (tag == 112){
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
                    weakself.heightCheckViewConstraints.constant = 116;
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
                    weakself.heightCheckViewConstraints.constant = 92;
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
                            [self showMaterialList];
                        }else if (tag == 112){
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
                
                if (dataModel.productOrdersTerminationsApply || dataModel.productOrdersClosedsApply) {//有申请结案终止的消息
                    if (dataModel.productOrdersTerminationsApply) {
                        
                        if ([dataModel.productOrdersTerminationsApply.create_by isEqualToString:response.userid]) {//发布方
                            [weakself.EndOrloseRemindButton setHidden:YES];
                        }else{//接单方
                            [weakself.EndOrloseRemindButton setHidden:NO];;
                            [weakself.EndOrloseRemindButton setTitle:@"对方申请终止此单，点击处理  " forState:0];
                            [weakself.EndOrloseRemindButton setImage:[UIImage imageNamed:@"more_white"] forState:0];
                            [weakself.EndOrloseRemindButton addAction:^(UIButton *btn) {
                                DealingEndViewController *dealEndVC = [[DealingEndViewController alloc] init];
                                dealEndVC.terminationid = dataModel.productOrdersTerminationsApply.terminationid;
                                [weakself.navigationController pushViewController:dealEndVC animated:YES];
                            }];
                        }
                        
                    }else{
                        [weakself.EndOrloseRemindButton setHidden:NO];
                        [weakself.EndOrloseRemindButton setTitle:@"对方申请结案，点击处理  " forState:0];
                        [weakself.EndOrloseRemindButton setImage:[UIImage imageNamed:@"more_white"] forState:0];
                        
                        [weakself.EndOrloseRemindButton addAction:^(UIButton *btn) {
                            DealingCloseViewController *dealCloseVC = [[DealingCloseViewController alloc] init];
                            dealCloseVC.closedid = dataModel.productOrdersClosedsApply.closedid;
                            [weakself.navigationController pushViewController:dealCloseVC animated:YES];
                        }];
                    }
                }else{
                    [weakself.EndOrloseRemindButton setHidden:YES];
                }
            }else if ([dataModel.statusLabel isEqualToString:@"已终止"]){
                [weakself.publishCheckView setHidden:YES];
                [weakself.dialogBoxView setHidden:YES];
                [weakself.EndOrloseRemindButton setHidden:YES];
                
                [weakself.rightButton setHidden:YES];
                
                if (weakself.EndOrloseRemindButton) {
                    [weakself.EndOrloseRemindButton removeFromSuperview];
                }
                
            }else if ([dataModel.statusLabel isEqualToString:@"已结案"]){
                [weakself.rightButton setHidden:YES];
                
                [weakself.publishCheckView setHidden:YES];
                [weakself.dialogBoxView setHidden:YES];
                [weakself.EndOrloseRemindButton setHidden:YES];
                [weakself.evaluateButton setHidden:NO];
                
                if ([dataModel.commentTotal integerValue] == 0) {
                    [weakself.evaluateButton setTitle:@"评价" forState:0];
                    [weakself.evaluateButton addAction:^(UIButton *btn) {
                        [weakself showHint:@"评价"];
                        AdditionalEvaluateViewController *additionalEvaluateVC = [[AdditionalEvaluateViewController alloc] init];
                        additionalEvaluateVC.ordersid = dataModel.productApply.orders.ordersid;
                        additionalEvaluateVC.typeString = @"发布方";
                        additionalEvaluateVC.evaString = @"0";
                        UINavigationController *navv = [[UINavigationController alloc] initWithRootViewController:additionalEvaluateVC];
                        [weakself presentViewController:navv animated:YES completion:nil];
                    }];
                }else{
                    [weakself.evaluateButton setTitle:@"查看评价" forState:0];
                    [weakself.evaluateButton addAction:^(UIButton *btn) {
                        [weakself showHint:@"查看评价"];
                        EvaluateListsViewController *evaluateListsVC = [[EvaluateListsViewController alloc] init];
                        evaluateListsVC.ordersid = dataModel.productApply.orders.ordersid;
                        evaluateListsVC.typeString = @"发布方";
                        [weakself.navigationController pushViewController:evaluateListsVC animated:YES];
                    }];
                }
                
                if (weakself.EndOrloseRemindButton) {
                    [weakself.EndOrloseRemindButton removeFromSuperview];
                }
            }
            
            //特殊情况特殊处理
            if ([dataModel.validflag integerValue] == 0) {
                [weakself showHint:@"该订单已被删除"];
                [weakself back];
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
            [weakself.rightButton setHidden:YES];
            [weakself getDetailMessagesssss];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)showMaterialList
{
    [self showHint:@"材料清单"];
    UIButton *showButton1 = [UIButton newAutoLayoutView];
    showButton1.backgroundColor = UIColorFromRGB1(0x333333, 0.3);
    [[UIApplication sharedApplication].keyWindow addSubview:showButton1];
    [showButton1 autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [showButton1 setImage:[UIImage imageNamed:@"material_list"] forState:0];
    [showButton1 addAction:^(UIButton *btn) {
        [btn removeFromSuperview];
    }];
}

- (void)rightItemAction
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
            weakself.dialogBoxView.dialogTextField.text = nil;
            [weakself getDetailMessagesssss];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

#pragma mark - show content
- (NSMutableAttributedString *)showPPLabelOfMyReleaseDetailWithModel:(OrdersLogsModel *)logModel
{
    NSString *timess1 = [NSString stringWithFormat:@"%@\n",[NSDate getHMFormatterTime:logModel.action_at]];
    NSString *timess2 = [NSDate getYMDsFormatterTime:logModel.action_at];
    NSString *timess = [NSString stringWithFormat:@"%@%@",timess1,timess2];
    NSMutableAttributedString *attributeTime = [[NSMutableAttributedString alloc] initWithString:timess];
    [attributeTime setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(0, timess1.length)];
    [attributeTime setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(timess1.length, timess2.length)];
    NSMutableParagraphStyle *styleTime = [[NSMutableParagraphStyle alloc] init];
    [styleTime setParagraphSpacing:6];
    styleTime.alignment = 2;
    [attributeTime addAttribute:NSParagraphStyleAttributeName value:styleTime range:NSMakeRange(0, timess.length)];
    return attributeTime;
}

- (NSMutableAttributedString *)showPPTextButtonOfMyReleaseDetailWithModel:(OrdersLogsModel *)logModel
{
    if ([logModel.label isEqualToString:@"经"]) {
        if (logModel.memoTel.length > 0) {//有电话
            NSString *mm1 = [NSString stringWithFormat:@"[%@]",logModel.actionLabel];
            NSString *mm2 = [NSString stringWithFormat:@"%@%@",logModel.memoLabel,[logModel.memoTel substringWithRange:NSMakeRange(0, logModel.memoTel.length-11)]];
            NSString *mm3 = [logModel.memoTel substringWithRange:NSMakeRange(logModel.memoTel.length-11, 11)];
            NSString *mm = [NSString stringWithFormat:@"%@%@%@",mm1,mm2,mm3];
            NSMutableAttributedString *attributeMM = [[NSMutableAttributedString alloc] initWithString:mm];
            [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, mm1.length)];
            [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(mm1.length, mm2.length)];
            [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(mm2.length+mm1.length, mm3.length)];
            
            return attributeMM;
            
        }else{//无电话
            NSString *po1 = [NSString stringWithFormat:@"[%@]%@",logModel.actionLabel,logModel.memoLabel];
            NSString *po2 = logModel.triggerLabel;
            NSString *po = [NSString stringWithFormat:@"%@%@",po1,po2];
            NSMutableAttributedString *attributePo = [[NSMutableAttributedString alloc] initWithString:po];
            [attributePo setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, po1.length)];
            [attributePo setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(po1.length, po2.length)];
            return attributePo;
        }
    }else{//其他消息
        NSString *po1 = [NSString stringWithFormat:@"[%@]%@",logModel.actionLabel,logModel.memoLabel];
        NSString *po2;
        
        if ([logModel.label isEqualToString:@"我"] || [logModel.label isEqualToString:@"接"]) {
            if ([logModel.action integerValue] >= 40 && [logModel.action integerValue] <= 52) {
                if (logModel.triggerLabel.length > 0) {
                    po2 = logModel.triggerLabel;
                }else{
                    po2 = @"查看详情";
                }
            }else{
                po2 = logModel.triggerLabel;
            }
        }else{
            po2 = logModel.triggerLabel;
        }
        
        NSString *po = [NSString stringWithFormat:@"%@%@",po1,po2];
        NSMutableAttributedString *attributePo = [[NSMutableAttributedString alloc] initWithString:po];
        [attributePo setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, po1.length)];
        [attributePo setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(po1.length, po2.length)];
        return attributePo;
    }
    
    return nil;
}

- (void)actionOfEndOrCloseWithModel:(OrdersLogsModel *)logModel//40，41，42，50，51，52
{
    if ([logModel.action integerValue] >= 40 && [logModel.action integerValue] <= 42) {//结案详情
        DealingCloseViewController *dealCloseVC = [[DealingCloseViewController alloc] init];
        dealCloseVC.closedid = logModel.relaid;
        [self.navigationController pushViewController:dealCloseVC animated:YES];
    }else if ([logModel.action integerValue] >= 50 && [logModel.action integerValue] <= 52){//终止详情
        DealingEndViewController *dealEndVC = [[DealingEndViewController alloc] init];
        dealEndVC.terminationid = logModel.relaid;
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
