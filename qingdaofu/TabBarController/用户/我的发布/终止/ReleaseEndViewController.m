//
//  ReleaseEndViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/31.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReleaseEndViewController.h"

#import "RequestEndViewController.h"  //申请终止
#import "CheckDetailPublishViewController.h"  //查看发布方

#import "MineUserCell.h"//信息
#import "NewPublishDetailsCell.h"//进度
#import "OrderPublishCell.h"//联系TA
#import "NewPublishStateCell.h"//状态

#import "PublishingModel.h"
#import "PublishingResponse.h"
#import "UserNameModel.h"  //申请方信息

//#import "CheckDetailPublishViewController.h"  //查看发布方
//#import "AdditionMessagesViewController.h" //查看更多
//#import "AgreementViewController.h"   //服务协议
//#import "PaceViewController.h"
//
//#import "MineUserCell.h"
//#import "OrderPublishCell.h"
//
//#import "BaseCommitButton.h"
//
//#import "PublishingResponse.h"
//#import "PublishingModel.h"
//#import "UserNameModel.h"
//
////查看进度
//#import "ScheduleResponse.h"
//#import "ScheduleModel.h"


@interface ReleaseEndViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *releaseEndTableView;
//json
@property (nonatomic,strong) NSMutableArray *releaseEndDataArray;


//<UITableViewDataSource,UITableViewDelegate>
//
//@property (nonatomic,assign) BOOL didSetupConstraints;
//@property (nonatomic,strong) UITableView *releaseEndTableView;
//@property (nonatomic,strong) BaseCommitButton *releaseEndCommitButton;
//
//@property (nonatomic,strong) NSMutableArray *endArray;
//@property (nonatomic,strong) NSMutableArray *scheduleReleaseEndArray;
//
//
//@property (nonatomic,strong) NSString *loanTypeString1;  //债权类型
//@property (nonatomic,strong) NSString *loanTypeString2;  //债权类型内容
//@property (nonatomic,strong) NSString *loanTypeImage;//债权类型图片

@end

@implementation ReleaseEndViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview: self.releaseEndTableView];
    
    [self.view setNeedsUpdateConstraints];
    
    [self getDetailMessages];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.releaseEndTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)releaseEndTableView
{
    if (!_releaseEndTableView) {
        _releaseEndTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _releaseEndTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _releaseEndTableView.backgroundColor = kBackColor;
        _releaseEndTableView.separatorColor = kSeparateColor;
        _releaseEndTableView.delegate = self;
        _releaseEndTableView.dataSource = self;
    }
    return _releaseEndTableView;
}

- (NSMutableArray *)releaseEndDataArray
{
    if (!_releaseEndDataArray) {
        _releaseEndDataArray = [NSMutableArray array];
    }
    return _releaseEndDataArray;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.releaseEndDataArray.count > 0) {
        return 4;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.releaseEndDataArray.count > 0) {
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
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.section == 0) {
        
        PublishingResponse *resModel = self.releaseEndDataArray[0];
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
            [cell.point3 setImage:[UIImage imageNamed:@"fail"] forState:0];
            cell.progress3.textColor = kRedColor;
            [cell.line3 setBackgroundColor:kLightGrayColor];
            
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
            NSString *checkStr = [NSString stringWithFormat:@"接单方：%@",nameStr];
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
//                    checkDetailPublishVC.idString = weakself.idString;
//                    checkDetailPublishVC.categoryString = weakself.categaryString;
//                    checkDetailPublishVC.pidString = weakself.pidString;
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
        [cell.userActionButton setTitle:@"查看详情" forState:0];
        
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
        [cell.userActionButton setTitle:@"查看" forState:0];
        
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
    }else if (indexPath.section == 2){
        [self showHint:@"居间协议"];
    }
}

#pragma mark - method
- (void)getDetailMessages
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProductDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"productid" : self.productid
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
        
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        if ([response.code isEqualToString:@"0000"]) {
            [weakself.releaseEndDataArray removeAllObjects];
            [weakself.releaseEndDataArray addObject:response];
            [weakself.releaseEndTableView reloadData];
        }
        
    } andFailBlock:^(NSError *error){
        
    }];
}

/*
- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.releaseEndTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.releaseEndTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.releaseEndCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.releaseEndCommitButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}


- (UITableView *)releaseEndTableView
{
    if (!_releaseEndTableView) {
        _releaseEndTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _releaseEndTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _releaseEndTableView.delegate = self;
        _releaseEndTableView.dataSource = self;
        _releaseEndTableView.backgroundColor = kBackColor;
        _releaseEndTableView.separatorColor = kSeparateColor;
    }
    return _releaseEndTableView;
}

- (BaseCommitButton *)releaseEndCommitButton
{
    if (!_releaseEndCommitButton) {
        _releaseEndCommitButton = [BaseCommitButton newAutoLayoutView];
        _releaseEndCommitButton.backgroundColor = kNavColor;
        [_releaseEndCommitButton setTitleColor:kBlackColor forState:0];
        [_releaseEndCommitButton setTitle:@"删除产品" forState:0];
        
        [_releaseEndCommitButton addTarget:self action:@selector(deleteTheProducOfReleaseEnd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _releaseEndCommitButton;
}

- (NSMutableArray *)endArray
{
    if (!_endArray) {
        _endArray = [NSMutableArray array];
    }
    return _endArray;
}

- (NSMutableArray *)scheduleReleaseEndArray
{
    if (!_scheduleReleaseEndArray) {
        _scheduleReleaseEndArray = [NSMutableArray array];
    }
    return _scheduleReleaseEndArray;
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.endArray.count > 0) {
        return 5;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.endArray.count > 0) {
        if (section == 2) {
            PublishingResponse *response = self.endArray[0];
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
    PublishingResponse *reModel;
    PublishingModel *endModel;
    if (self.endArray.count > 0) {
        reModel = self.endArray[0];
        endModel = reModel.product;
    }
    
    static NSString *identifier;
    
    if (indexPath.section == 0) {
        identifier = @"releaseEnding0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromRGB(0x42566d);
        
        NSString *nameStrss;
        if ([endModel.category integerValue] == 2) {
            nameStrss = @"清收";
        }else if ([endModel.category integerValue] == 3){
            nameStrss = @"诉讼";
        }
        NSString *nameStr = [NSString stringWithFormat:@"%@%@",nameStrss,endModel.codeString];
        [cell.userNameButton setTitle:nameStr forState:0];
        [cell.userNameButton setTitleColor:kLightWhiteColor forState:0];
        cell.userNameButton.titleLabel.font = kFourFont;
        [cell.userActionButton setTitle:@"已终止" forState:0];
        [cell.userActionButton setTitleColor:kNavColor forState:0];
        cell.userActionButton.titleLabel.font = kFirstFont;
        
        return cell;
        
    }else if (indexPath.section == 1){//联系发布方
        identifier = @"releaseEnding1";
        OrderPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[OrderPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UserNameModel *userNameModel = reModel.username;
        
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
                checkDetailPublishVC.typeString = @"接单方";
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
            identifier = @"releaseEnding20";
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
        identifier = @"releaseEnding21";
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
        NSString *rowString11 = [NSString stringWithFormat:@"%@万",endModel.money];//具体借款本金
        NSString *rowString2 = @"费用类型";
        NSString *rowString3;//具体费用类型
        NSString *rowString33;//费用
        if ([endModel.category integerValue] == 2) {
            if ([endModel.agencycommissiontype integerValue] == 1) {
                rowString3 = @"服务佣金";
                rowString33 = [NSString stringWithFormat:@"%@%@",endModel.agencycommission,@"%"];
            }else{
                rowString3 = @"固定费用";
                rowString33 = [NSString stringWithFormat:@"%@万",endModel.agencycommission];
            }
        }else if ([endModel.category integerValue] == 3){
            if ([endModel.agencycommissiontype integerValue] == 1) {
                rowString3 = @"固定费用";
                rowString33 = [NSString stringWithFormat:@"%@万",endModel.agencycommission];
            }else{
                rowString3 = @"代理费率";
                rowString33 = [NSString stringWithFormat:@"%@%@",endModel.agencycommission,@"%"];
            }
        }
        
        NSString *rowString4 = @"债权类型";
        NSString *rowString44; //具体债权类型
        NSString *rowString5;
        NSString *rowString55;
        if ([endModel.loan_type integerValue] == 1) {
            rowString44 = @"房产抵押";
            rowString5 = @"抵押物地址";
            rowString55 = endModel.seatmortgage;
        }else if ([endModel.loan_type integerValue] == 2) {
            rowString44 = @"应收帐款";
            rowString5 = @"应收帐款";
            rowString55 = [NSString stringWithFormat:@"%@万",endModel.accountr];;
        }else if ([endModel.loan_type integerValue] == 3) {
            rowString44 = @"机动车抵押";
            rowString5 = @"机动车抵押";
            rowString55 = reModel.car;
        }else if ([endModel.loan_type integerValue] == 4) {
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
        identifier = @"releaseEnding3";
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
        identifier = @"releaseEnding4";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userNameButton.userInteractionEnabled = NO;
        cell.userActionButton.userInteractionEnabled = NO;
        
        [cell.userNameButton setTitle:@"处理进度" forState:0];
        [cell.userActionButton setTitle:@"点击查看  " forState:0];
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
    }else if (indexPath.section == 3) {
        AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
        agreementVC.idString = self.idString;
        agreementVC.categoryString = self.categaryString;
        [self.navigationController pushViewController:agreementVC animated:YES];
    }else if (indexPath.section == 4) {
        PaceViewController *paceVC = [[PaceViewController alloc] init];
        paceVC.idString = self.idString;
        paceVC.categoryString = self.categaryString;
        [self.navigationController pushViewController:paceVC animated:YES];
    }
}

#pragma mark - method
- (void)getEndMessages
{
    NSString *releaseString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:releaseString params:params successBlock:^(id responseObject){
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        [weakself.endArray addObject:response];
        [weakself.releaseEndTableView reloadData];

    } andFailBlock:^(NSError *error){
        
    }];
}

- (void)deleteTheProducOfReleaseEnd
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
