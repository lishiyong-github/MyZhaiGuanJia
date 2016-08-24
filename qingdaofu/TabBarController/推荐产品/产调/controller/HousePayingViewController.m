//
//  HousePayingViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/2.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "HousePayingViewController.h"
#import "ApplicationSuccessViewController.h"
#import "HousePayingEditViewController.h"

#import "WXApiObject.h"
#import "WXApiManager.h"

#import "BaseCommitView.h"

#import "MessageCell.h"
#import "MineUserCell.h"

//pay
#import "PayResponse.h"
#import "PayModel.h"

@interface HousePayingViewController ()<UITableViewDelegate,UITableViewDataSource,WXApiManagerDelegate>

@property (nonatomic,strong) UITableView *powerTableView;
@property (nonatomic,strong) BaseCommitView *powerCommitView;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation HousePayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付中";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.powerTableView];
    [self.view addSubview:self.powerCommitView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.powerTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.powerTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.powerCommitView];
        
        [self.powerCommitView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.powerCommitView autoSetDimension:ALDimensionHeight toSize:60];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - setter and getter
- (UITableView *)powerTableView
{
    if (!_powerTableView) {
        _powerTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _powerTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _powerTableView.delegate = self;
        _powerTableView.dataSource = self;
        _powerTableView.separatorColor = kSeparateColor;
    }
    return _powerTableView;
}

- (UIView *)powerCommitView
{
    if (!_powerCommitView) {
        _powerCommitView = [BaseCommitView newAutoLayoutView];
        
        [_powerCommitView.button setTitle:@"确定支付" forState:0];
        
        [_powerCommitView.button addTarget:self action:@selector(confirmToGenerateTheOrder) forControlEvents:UIControlEventTouchUpInside];
        
//        QDFWeakSelf;
//        [_powerCommitView.button addAction:^(UIButton *btn) {
//            ApplicationSuccessViewController *applicationSuccessVC = [[ApplicationSuccessViewController alloc] init];
//            applicationSuccessVC.successType = @"3";
//            [weakself.navigationController pushViewController:applicationSuccessVC animated:YES];
//        }];
        
    }
    return _powerCommitView;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 65;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section == 0) {//基本信息
        identifier = @"pay0";
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.actButton setHidden:YES];
        [cell.countLabel setHidden:YES];
        cell.timeLabel.font = kBigFont;
        cell.timeLabel.textColor = kBlueColor;
        
        cell.userLabel.text = self.phoneString;
        cell.timeLabel.text = @"编辑";
        cell.newsLabel.text = [NSString stringWithFormat:@"%@%@",self.areaString,self.addressString];
        
        return cell;
        
    }else if (indexPath.section == 1){//订单金额
        identifier = @"pay1";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userActionButton setTitleColor:kRedColor forState:0];
        
        [cell.userNameButton setTitle:@"订单金额" forState:0];
        NSString *moneyS = [NSString stringWithFormat:@"¥%@",self.genarateMoney];
        [cell.userActionButton setTitle:moneyS forState:0];
        
        return cell;
        
    }else if (indexPath.section == 2){//服务时间
        identifier = @"pay2";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.userNameButton setTitle:@"服务时间" forState:0];
        [cell.userActionButton setTitle:@"工作日9:00-16:30  " forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"tipss"] forState:0];
        
        return cell;
    }else{//微信支付
        identifier = @"pay3";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableAttributedString *title = [cell.userNameButton setAttributeString:@"  微信支付" withColor:kBlackColor andSecond:@"（仅支持微信支付）" withColor:kLightGrayColor withFont:13];
        [cell.userNameButton setAttributedTitle:title forState:0];
        [cell.userNameButton setImage:[UIImage imageNamed:@"wechat"] forState:0];
        
        [cell.userActionButton setImage:[UIImage imageNamed:@"choosed"] forState:0];

        return cell;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return kBigPadding;
    }
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {//编辑
        HousePayingEditViewController *housePayingEditVC = [[HousePayingEditViewController alloc] init];
        [self.navigationController pushViewController:housePayingEditVC animated:YES];
    }
}

#pragma mark - method
- (void)confirmToGenerateTheOrder
{    
    NSString *huhuString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,KhousePropertyConfirmOrderString];
    NSDictionary *params = @{@"id" : self.genarateId,
                             @"paytype" : @"APP",
                             @"token" : [self getValidateToken]
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:huhuString params:params successBlock:^(id responseObject) {
        
        NSDictionary *uiuiu = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        PayResponse *payResponse = [PayResponse objectWithKeyValues:responseObject];
        
        if ([payResponse.code isEqualToString:@"0000"]) {
            NSLog(@"调起微信支付");
            
            PayModel *payModel = payResponse.paydata;
            // 调起微信支付
            PayReq *reqPay = [[PayReq alloc] init];
            reqPay.partnerId = @"1351216801";
            reqPay.prepayId = weakself.genarateId;
//            uiuiu[@"result"][@"paydata"][@"WXreturn"][@"prepay_id"];
//            weakself.genarateId;
            reqPay.nonceStr = payModel.nonceStr;
//            uiuiu[@"result"][@"paydata"][@"WXreturn"][@"nonce_str"];
//            payModel.nonceStr;
            reqPay.timeStamp = (UInt32)[payModel.timeStamp integerValue];
            reqPay.package = payModel.package;
            reqPay.sign = payModel.paySign;
//            uiuiu[@"result"][@"paydata"][@"WXreturn"][@"sign"];
//            payModel.paySign;
            [WXApi sendReq:reqPay];
            
        }else{
            [weakself showHint:payResponse.msg];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
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
