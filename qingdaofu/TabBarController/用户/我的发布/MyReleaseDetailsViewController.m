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

//#import "AdditionMessagesViewController.h"  //补充信息
//#import "AgreementViewController.h"//协议
//#import "ReportSuitViewController.h"  //发布催收，发布诉讼

#import "BaseRemindButton.h"

#import "MineUserCell.h"//完善信息
#import "NewPublishDetailsCell.h"//进度
#import "NewPublishStateCell.h"//状态
#import "NewsTableViewCell.h"//选择申请方
#import "ProductCloseCell.h"  //结案

//面谈中
#import "OrderPublishCell.h"


#import "PublishCombineView.h"  //底部视图

#import "PublishingResponse.h"
#import "RowsModel.h"
#import "ApplyRecordModel.h"  //申请人
#import "ProductOrdersClosedOrEndApplyModel.h"  //处理终止或结案申请

#import "OrdersModel.h"

@interface MyReleaseDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) UITableView *releaseDetailTableView;
@property (nonatomic,strong) PublishCombineView *publishCheckView;
@property (nonatomic,strong) BaseRemindButton *EndOrloseRemindButton;  //新的申请记录提示信息

//json
@property (nonatomic,strong) NSMutableArray *releaseDetailArray;
@property (nonatomic,strong) NSString *applyidString;//标记是否选择申请人

@end

@implementation MyReleaseDetailsViewController

- (void)viewWillAppear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDetailMessagesssss) name:@"refresh" object:nil];
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
    [self.view setNeedsUpdateConstraints];
    
    [self getDetailMessagesssss];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.releaseDetailTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.releaseDetailTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.publishCheckView];
        
        [self.publishCheckView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
//        [self.publishCheckView autoSetDimension:ALDimensionHeight toSize:92];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

//- (UIButton *)rightNavButton
//{
//    if (!_rightNavButton) {
//        _rightNavButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
//        [_rightNavButton setContentHorizontalAlignment:2];
//        [_rightNavButton setTitle:@"删除订单" forState:0];
//        [_rightNavButton setTitleColor:kWhiteColor forState:0];
//        _rightNavButton.titleLabel.font = kFirstFont;
//        [_rightNavButton addTarget:self action:@selector(deleteThePublishing) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _rightNavButton;
//}

- (UITableView *)releaseDetailTableView
{
    if (!_releaseDetailTableView) {
        _releaseDetailTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _releaseDetailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _releaseDetailTableView.backgroundColor = kBackColor;
        _releaseDetailTableView.separatorColor = kSeparateColor;
        _releaseDetailTableView.delegate = self;
        _releaseDetailTableView.dataSource = self;
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
            }else{
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
        }else if ([dataModel.statusLabel isEqualToString:@"处理中"]) {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    return kCellHeight1;
                }else if (indexPath.row == 1){
                    return 72;
                }else if (indexPath.row == 2){
                    return kCellHeight3;
                }
            }
            return kCellHeight;
        }else if ([dataModel.statusLabel isEqualToString:@"已终止"]) {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    return kCellHeight1;
                }else if (indexPath.row == 1){
                    return 72;
                }else if (indexPath.row == 2){
                    return kCellHeight3;
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
                        //                if ([userNameModel.jusername isEqualToString:@""] || userNameModel.jusername == nil || !userNameModel.jusername) {
                        //                    [weakself showHint:@"申请方未认证，不能查看相关信息"];
                        //                }else{
                        //                    CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
                        //                    checkDetailPublishVC.idString = weakself.idString;
                        //                    checkDetailPublishVC.categoryString = weakself.categaryString;
                        //                    checkDetailPublishVC.pidString = weakself.pidString;
                        //                    checkDetailPublishVC.typeString = @"接单方";
                        //                    //                checkDetailPublishVC.typeDegreeString = @"处理中";
                        //                    [weakself.navigationController pushViewController:checkDetailPublishVC animated:YES];
                        //                }
                    }];
                    
                    //电话
                    [cell.contactButton addAction:^(UIButton *btn) {
                        //                if ([userNameModel.jusername isEqualToString:@""] || userNameModel.jusername == nil || !userNameModel.jusername) {
                        //                    [self showHint:@"申请方未认证，不能打电话"];
                        //                }else{
                        //                    NSMutableString *phoneStr = [NSMutableString stringWithFormat:@"telprompt://%@",userNameModel.jmobile];
                        //                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
                        //                }
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
    }else if ([dataModel.statusLabel isEqualToString:@"处理中"]) {
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
                    //                if ([userNameModel.jusername isEqualToString:@""] || userNameModel.jusername == nil || !userNameModel.jusername) {
                    //                    [weakself showHint:@"申请方未认证，不能查看相关信息"];
                    //                }else{
                    //                    CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
                    //                    checkDetailPublishVC.idString = weakself.idString;
                    //                    checkDetailPublishVC.categoryString = weakself.categaryString;
                    //                    checkDetailPublishVC.pidString = weakself.pidString;
                    //                    checkDetailPublishVC.typeString = @"接单方";
                    //                    //                checkDetailPublishVC.typeDegreeString = @"处理中";
                    //                    [weakself.navigationController pushViewController:checkDetailPublishVC animated:YES];
                    //                }
                }];
                
                //电话
                [cell.contactButton addAction:^(UIButton *btn) {
                    //                if ([userNameModel.jusername isEqualToString:@""] || userNameModel.jusername == nil || !userNameModel.jusername) {
                    //                    [self showHint:@"申请方未认证，不能打电话"];
                    //                }else{
                    //                    NSMutableString *phoneStr = [NSMutableString stringWithFormat:@"telprompt://%@",userNameModel.jmobile];
                    //                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
                    //                }
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
            
            if ([dataModel.productApply.orders.status integerValue] <= 10) {
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
            
            [cell.userNameButton setTitle:@"居间协议" forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            if ([dataModel.productApply.orders.status integerValue] == 0) {
                [cell.userActionButton setTitle:@"等待接单方上传" forState:0];
            }else{
                [cell.userActionButton setTitle:@"查看" forState:0];
            }
            return cell;
        }else if (indexPath.section == 3){
            identifier = @"myDealing3";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.userNameButton setTitle:@"尽职调查" forState:0];
            return cell;
        }
    }else if ([dataModel.statusLabel isEqualToString:@"已终止"]) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                identifier = @"myEnding00";
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
                identifier = @"myEnding01";
                NewPublishDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[NewPublishDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = kBackColor;
                
                [cell.point2 setImage:[UIImage imageNamed:@"succee"] forState:0];
                cell.progress2.textColor = kTextColor;
                [cell.line2 setBackgroundColor:kButtonColor];
                
                
                [cell.point3 setImage:[UIImage imageNamed:@"fail"] forState:0];
                cell.progress3.textColor = kRedColor;
                [cell.line3 setBackgroundColor:kRedColor];
                cell.progress3.text = @"已终止";
                return cell;
                
            }else if (indexPath.row == 2){
                identifier = @"myEnding02";
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
                }];
                
                //电话
                [cell.contactButton addAction:^(UIButton *btn) {
                }];
                return cell;
            }
            
        }else if (indexPath.section == 1){
            identifier = @"myEnding1";
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
        }else if (indexPath.section == 2){
            identifier = @"myEnding2";
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
        }else if (indexPath.section == 3){
            identifier = @"myEnding3";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.userNameButton setTitle:@"尽职调查" forState:0];
            return cell;
        }
    }else if ([dataModel.statusLabel isEqualToString:@"已结案"]) {
        if (indexPath.section == 0) {
            identifier = @"close00";
            PublishingResponse *resModel = self.releaseDetailArray[0];
            
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
                }];
                
                //电话
                [cell.contactButton addAction:^(UIButton *btn) {
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
            NSString *proText4 = [NSString stringWithFormat:@"委托金额：%@",dataModel.accountLabel];
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
                        dealingCloseVC.productDealModel = dataModel.productOrdersTerminationsApply;
                        [weakself.navigationController pushViewController:dealingCloseVC animated:YES];
                    }
                        break;
                    case 331:{//查看全部产品信息
                        
                    }
                        break;
                    case 332:{//查看签约协议
                        
                    }
                        break;
                    case 333:{//查看尽职调查
                        
                    }
                        break;
                    case 334:{//查看居间协议
                        
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
    
    if (indexPath.section == 0 && indexPath.row == 0) {//完善信息
        MoreMessagesViewController *moreMessageVC = [[MoreMessagesViewController alloc] init];
        moreMessageVC.productid = dataModel.productid;
        [self.navigationController pushViewController:moreMessageVC animated:YES];
    }
    
    if ([dataModel.statusLabel isEqualToString:@"发布中"]) {
        if ([dataModel.productApply.status integerValue] == 20) {//面谈中
        }else{
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
    }else if ([dataModel.statusLabel isEqualToString:@"处理中"]){
        
    }else if ([dataModel.statusLabel isEqualToString:@"已终止"]){
        
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
        
        NSDictionary *sososo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
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
            }else if ([dataModel.statusLabel isEqualToString:@"处理中"]){
                [weakself.publishCheckView setHidden:YES];
                [weakself.releaseDetailTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
                
                if ([dataModel.productApply.orders.status integerValue] > 10) {
                    [weakself.rightButton setHidden:NO];
                    [weakself.rightButton setTitle:@"申请终止" forState:0];
                }
                
                [weakself.view addSubview:weakself.EndOrloseRemindButton];
                [weakself.EndOrloseRemindButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
                [weakself.EndOrloseRemindButton autoSetDimension:ALDimensionHeight toSize:kRemindHeight];
                if (dataModel.productOrdersTerminationsApply || dataModel.productOrdersClosedsApply) {//有申请结案终止的消息
                    [weakself.EndOrloseRemindButton setHidden:NO];
                    if (dataModel.productOrdersTerminationsApply) {
                        [weakself.EndOrloseRemindButton setTitle:@"对方申请终止次单，点击处理  " forState:0];
                        [weakself.EndOrloseRemindButton setImage:[UIImage imageNamed:@"more_white"] forState:0];
                        [weakself.EndOrloseRemindButton addAction:^(UIButton *btn) {
                            DealingEndViewController *dealEndVC = [[DealingEndViewController alloc] init];
                            dealEndVC.terminationid = dataModel.productOrdersTerminationsApply.terminationid;
                            [weakself.navigationController pushViewController:dealEndVC animated:YES];
                        }];
                    }else{
                        [weakself.EndOrloseRemindButton setTitle:@"对方申请结案，点击处理  " forState:0];
                        [weakself.EndOrloseRemindButton setImage:[UIImage imageNamed:@"more_white"] forState:0];
                        
                        [weakself.EndOrloseRemindButton addAction:^(UIButton *btn) {
                            DealingCloseViewController *dealCloseVC = [[DealingCloseViewController alloc] init];
                            dealCloseVC.perTypeString = @"1";
                            dealCloseVC.productDealModel = dataModel.productOrdersClosedsApply;
                            [weakself.navigationController pushViewController:dealCloseVC animated:YES];
                        }];
                    }
                }else{
                    [weakself.EndOrloseRemindButton setHidden:YES];
                }
            }else if ([dataModel.statusLabel isEqualToString:@"已终止"]){
                [weakself.publishCheckView setHidden:YES];
                [weakself.releaseDetailTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
                
                [weakself.rightButton setHidden:YES];
                
            }else if ([dataModel.statusLabel isEqualToString:@"已结案"]){
                [weakself.publishCheckView setHidden:YES];
                [weakself.releaseDetailTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
                
                [weakself.rightButton setHidden:YES];
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
    [self showHint:@"申请终止"];
    RowsModel *dataModel = self.releaseDetailArray[0];
    RequestEndViewController *requestEndVC = [[RequestEndViewController alloc] init];
    requestEndVC.ordersid = dataModel.productApply.orders.ordersid;
    [self.navigationController pushViewController:requestEndVC animated:YES];
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
