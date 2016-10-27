//
//  MyDealingViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/6.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyDealingViewController.h"

#import "CheckDetailPublishViewController.h"  //查看发布方
#import "RequestEndViewController.h"  //申请终止
#import "DealingEndViewController.h"  //处理终止申请
#import "DealingCloseViewController.h" //处理结案申请


#import "MineUserCell.h"//完善信息
#import "NewPublishDetailsCell.h"//进度
#import "OrderPublishCell.h"//联系TA
#import "NewPublishStateCell.h"//状态
#import "PublishCombineView.h"  //底部视图
#import "BaseRemindButton.h"  //提示框

#import "PublishingResponse.h"
#import "RowsModel.h"
#import "ApplyRecordModel.h"
#import "OrdersModel.h"

#import "PublishingModel.h"
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDetailMessageso) name:@"endProduct" object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    if ([self.status isEqualToString:@"处理中"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
        [self.view addSubview: self.myDealingTableView];
        [self.view addSubview:self.chatView];
        [self.view addSubview:self.dealRemindButton];
        //    [self.dealRemindButton setHidden:YES];
        
        [self.rightButton setTitle:@"申请终止" forState:0];
    }else{//已终止
        [self.view addSubview: self.myDealingTableView];
    }
    
    [self.view setNeedsUpdateConstraints];
    
    [self getDetailMessageso];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        if ([self.status isEqualToString:@"处理中"]) {
            [self.myDealingTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
            [self.myDealingTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.chatView];
            
            [self.dealRemindButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.chatView];
            [self.dealRemindButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            [self.dealRemindButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
            [self.dealRemindButton autoSetDimension:ALDimensionHeight toSize:kRemindHeight];
            
            [self.chatView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
            [self.chatView autoSetDimension:ALDimensionHeight toSize:kCellHeight1];
        }else{
            [self.myDealingTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        }
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
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
        
        QDFWeakSelf;
        [_dealRemindButton addAction:^(UIButton *btn) {
            DealingEndViewController *dealingEndVC = [[DealingEndViewController alloc] init];
            [weakself.navigationController pushViewController:dealingEndVC animated:YES];
            
//            DealingCloseViewController *dealingCloseVC = [[DealingCloseViewController alloc] init];
//            dealingCloseVC.perTypeString = @"1";
//            [weakself.navigationController pushViewController:dealingCloseVC animated:YES];
        }];
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
        return 4;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 1;
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
    
    RowsModel *rowModel = self.myDealingDataArray[0];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            identifier = @"myDealing00";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.userNameButton setTitle:rowModel.number forState:0];
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
            
            if ([rowModel.productApply.orders.status integerValue] == 30) {//终止
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
            
            NSString *nameStr = [NSString getValidStringFromString:rowModel.productApply.mobile toString:@"未认证"];
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
        
        if ([rowModel.productApply.orders.status integerValue] <= 10) {
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
        
        if ([rowModel.productApply.orders.status integerValue] == 0) {
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
    RowsModel *rowModel = self.myDealingDataArray[0];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self showHint:@"查看详情"];
    }else if (indexPath.section == 1) {
        if ([rowModel.productApply.orders.status integerValue] <= 10) {
            [self showHint:@"签约协议详情"];
        }else{
            [self showHint:@"查看签约协议详情"];
        }
    }else if (indexPath.section == 2){
        if ([rowModel.productApply.orders.status integerValue] == 0) {
            [self showHint:@"居间协议"];
        }else{
            [self showHint:@"查看居间协议"];
        }
    }
}

#pragma mark - method
- (void)getDetailMessageso
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailsString];
    NSDictionary *params;
    
    if (!self.messageid) {
        params = @{@"token" : [self getValidateToken],
                   @"productid" : self.productid
                   };
    }else{
        params = @{@"token" : [self getValidateToken],
                   @"productid" : self.productid,
                   @"messageid" : self.messageid
                   };
        
    }
    
    QDFWeakSelf;
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
        
        NSDictionary *wpwp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        
        if ([response.code isEqualToString:@"0000"]) {
            [weakself.myDealingDataArray removeAllObjects];
            [weakself.myDealingDataArray addObject:response.data];
            [weakself.myDealingTableView reloadData];
        }
        
    } andFailBlock:^(NSError *error){
        
    }];
}

- (void)rightItemAction
{
    if (self.myDealingDataArray.count > 0) {
        RowsModel *rowModel = self.myDealingDataArray[0];
        
        if ([rowModel.productApply.orders.status integerValue] <= 10) {
            [self showHint:@"接单方未上传协议，不能申请终止"];
        }else{
            RequestEndViewController *requestEndVC = [[RequestEndViewController alloc] init];
            requestEndVC.ordersid = rowModel.productApply.orders.ordersid;
            [self.navigationController pushViewController:requestEndVC animated:YES];
        }
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
