//
//  MyEndingViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyEndingViewController.h"
#import "CheckDetailPublishViewController.h"  //查看发布方
#import "MyScheduleViewController.h"    //填写进度
#import "AdditionMessagesViewController.h" //查看更多
#import "PaceViewController.h"
#import "AgreementViewController.h"

#import "MineUserCell.h"
#import "OrderPublishCell.h"

#import "EvaTopSwitchView.h"

#import "PublishingResponse.h"
#import "PublishingModel.h"
#import "UserNameModel.h"

#import "ScheduleResponse.h"
#import "ScheduleModel.h"

@interface MyEndingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *myEndingTableView;
@property (nonatomic,strong) EvaTopSwitchView *endingSwitchButton;

@property (nonatomic,strong) NSMutableArray *endArray;
@property (nonatomic,strong) NSMutableArray *scheduleOrderEndArray;


@property (nonatomic,strong) NSString *loanTypeString1;  //债权类型
@property (nonatomic,strong) NSString *loanTypeString2;  //债权类型内容
@property (nonatomic,strong) NSString *loanTypeImage;//债权类型图片

@end

@implementation MyEndingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.myEndingTableView];
    [self.view addSubview:self.endingSwitchButton];
    [self.view setNeedsUpdateConstraints];
    
    [self getDetailMessageOfEnding];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.myEndingTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.myEndingTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.endingSwitchButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.endingSwitchButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)myEndingTableView
{
    if (!_myEndingTableView) {
        _myEndingTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _myEndingTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myEndingTableView.delegate = self;
        _myEndingTableView.dataSource = self;
        _myEndingTableView.separatorColor = kSeparateColor;
        _myEndingTableView.backgroundColor = kBackColor;
    }
    return _myEndingTableView;
}

- (EvaTopSwitchView *)endingSwitchButton
{
    if (!_endingSwitchButton) {
        _endingSwitchButton = [EvaTopSwitchView newAutoLayoutView];
        _endingSwitchButton.backgroundColor = kNavColor;
        [_endingSwitchButton.blueLabel setHidden:YES];
        
        [_endingSwitchButton.getbutton setTitleColor:kBlackColor forState:0];
        [_endingSwitchButton.getbutton setTitle:@" 联系客服" forState:0];
        [_endingSwitchButton.getbutton setImage:[UIImage imageNamed:@"customer_service"] forState:0];
        [_endingSwitchButton.sendButton setTitle:@" 删除产品" forState:0];
        [_endingSwitchButton.sendButton setImage:[UIImage imageNamed:@"delete"] forState:0];
        
        [_endingSwitchButton.getbutton addAction:^(UIButton *btn) {
            NSMutableString *phoneStr = [NSMutableString stringWithFormat:@"telprompt://%@",@"400-855-7022"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
        }];
        
        [_endingSwitchButton.sendButton addTarget:self action:@selector(deleteTheProducOfOrderEnd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _endingSwitchButton;
}

- (NSMutableArray *)endArray
{
    if (!_endArray) {
        _endArray = [NSMutableArray array];
    }
    return _endArray;
}

- (NSMutableArray *)scheduleOrderEndArray
{
    if (!_scheduleOrderEndArray) {
        _scheduleOrderEndArray = [NSMutableArray array];
    }
    return _scheduleOrderEndArray;
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
    if (self.endArray.count > 0){
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
    PublishingResponse *responce ;
    PublishingModel *endModel;
    if (self.endArray.count > 0) {
        responce = self.endArray[0];
        endModel = responce.product;
    }
    
    static NSString *identifier;
    
    if (indexPath.section == 0) {
        identifier = @"processing0";
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
        identifier = @"processing1";
        OrderPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[OrderPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UserNameModel *userNameModel = responce.username;
        
        NSString *nameStr = [NSString getValidStringFromString:userNameModel.username toString:@"未认证"];
        NSString *checkStr = [NSString stringWithFormat:@"发布方：%@",nameStr];
        [cell.checkButton setTitle:checkStr forState:0];
        [cell.contactButton setTitle:@" 联系他" forState:0];
        [cell.contactButton setImage:[UIImage imageNamed:@"phone_blue"] forState:0];
        
        //接单方详情
        QDFWeakSelf;
        [cell.checkButton addAction:^(UIButton *btn) {
            if ([userNameModel.username isEqualToString:@""] || userNameModel.username == nil || !userNameModel.username) {
                [self showHint:@"发布方未认证，不能查看相关信息"];
            }else{
                CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
                checkDetailPublishVC.typeString = @"发布方";
                checkDetailPublishVC.idString = weakself.idString;
                checkDetailPublishVC.categoryString = weakself.categaryString;
                checkDetailPublishVC.pidString = weakself.pidString;
                [weakself.navigationController pushViewController:checkDetailPublishVC animated:YES];
            }
        }];
        
        //电话
        [cell.contactButton addAction:^(UIButton *btn) {
            if ([userNameModel.username isEqualToString:@""] || userNameModel.username == nil || !userNameModel.username) {
                [self showHint:@"发布方未认证，不能打电话"];
            }else{
                NSMutableString *phoneStr = [NSMutableString stringWithFormat:@"telprompt://%@",userNameModel.mobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
            }
        }];
        
        return cell;
        
    }else if(indexPath.section == 2){//详情
        if (indexPath.row == 0) {
            identifier = @"processing20";
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
        identifier = @"processing21";
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
            rowString55 = [NSString stringWithFormat:@"%@万",endModel.accountr];

        }else if ([endModel.loan_type integerValue] == 3) {
            rowString44 = @"机动车抵押";
            rowString5 = @"机动车抵押";
            rowString55 = responce.car;
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
        identifier = @"processing3";
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
        identifier = @"processing4";
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
- (void)getDetailMessageOfEnding
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        [weakself.endArray addObject:response];
        [weakself.myEndingTableView reloadData];
//        [weakself getScheduleDetails];
    } andFailBlock:^(NSError *error){
        
    }];
}

- (void)deleteTheProducOfOrderEnd
{
    NSString *deletePubString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kDeleteProductOfMyReleaseString];
    NSDictionary *params = @{@"id" : self.idString,
                             @"category" : self.categaryString,
                             @"token" : [self getValidateToken]
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

//- (void)getScheduleDetails
//{
//    NSString *scheduleString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kLookUpScheduleString];
//    NSDictionary *params = @{@"id" : self.idString,
//                             @"category" : self.categaryString,
//                             @"token" : [self getValidateToken]
//                             };
//    QDFWeakSelf;
//    [self requestDataPostWithString:scheduleString params:params successBlock:^(id responseObject) {
//        
//        ScheduleResponse *response = [ScheduleResponse objectWithKeyValues:responseObject];
//        for (ScheduleModel *model in response.disposing) {
//            [weakself.scheduleOrderEndArray addObject:model];
//        }
//        [weakself.myEndingTableView reloadData];
//        
//    } andFailBlock:^(NSError *error) {
//        
//    }];
//}

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
