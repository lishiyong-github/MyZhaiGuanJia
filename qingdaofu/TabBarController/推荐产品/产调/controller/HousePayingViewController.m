//
//  HousePayingViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/2.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "HousePayingViewController.h"
#import "HousePayingEditViewController.h"
#import "HousePropertyListViewController.h" //产调列表

#import "WXApiObject.h"
#import "WXApiManager.h"
#import "WXApi.h"

#import "BaseCommitView.h"

#import "ReiceptCell.h"
#import "MineUserCell.h"

//pay
#import "PayResponse.h"
#import "PayModel.h"

@interface HousePayingViewController ()<UITableViewDelegate,UITableViewDataSource,WXApiManagerDelegate,WXApiDelegate>

@property (nonatomic,strong) UITableView *powerTableView;
@property (nonatomic,strong) BaseCommitView *powerCommitView;
@property (nonatomic,strong) NSString *idParam;
@property (nonatomic,strong) NSDictionary *editParms;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation HousePayingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ResponseResult) name:@"PaySuccess" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付中";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.powerTableView];
    [self.view addSubview:self.powerCommitView];
    
    [self.view setNeedsUpdateConstraints];
    
    [self shwoAlertViewWithType:@"1"];
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
        [_powerCommitView addTarget:self action:@selector(confirmToGenerateTheOrder) forControlEvents:UIControlEventTouchUpInside];
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
//        return 65;
        NSString *addressStr = [NSString stringWithFormat:@"%@%@",self.areaString,self.addressString];
        
        CGSize titleSize = CGSizeMake(kScreenWidth - kBigPadding*2, MAXFLOAT);
        CGSize actualSize = [addressStr boundingRectWithSize:titleSize options:NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:kSecondFont} context:nil].size;
        
        return 45+MAX(actualSize.height, 15.5);
        
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section == 0) {//基本信息
        identifier = @"pay0";
        ReiceptCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ReiceptCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.addressLabel.numberOfLines = 1;
        
        cell.nameLabel.text = self.phoneString;
        cell.phoneLabel.text = @"编辑";
        cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",self.areaString,self.addressString];
        
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
        cell.userNameButton.userInteractionEnabled = NO;
        cell.userActionButton.userInteractionEnabled = NO;
        
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
        housePayingEditVC.areaString = self.editParms[@"area"]?self.editParms[@"area"]:self.areaString;
        housePayingEditVC.addressString = self.editParms[@"address"]?self.editParms[@"address"]:self.addressString;
        housePayingEditVC.phoneString = self.editParms[@"phone"]?self.editParms[@"phone"]:self.phoneString;
        housePayingEditVC.idString = self.editParms[@"id"]?self.editParms[@"id"]:self.genarateId;
        [self.navigationController pushViewController:housePayingEditVC animated:YES];
        
        QDFWeakSelf;
        [housePayingEditVC setDidEditMessage:^(NSDictionary *parameters) {
            ReiceptCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.nameLabel.text = parameters[@"phone"];
            cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",parameters[@"area"],parameters[@"address"]];
            weakself.editParms = parameters;
        }];
    }else if (indexPath.section == 2){
        [self shwoAlertViewWithType:@"2"];
    }
}

#pragma mark - method
- (void)confirmToGenerateTheOrder
{    
    NSString *huhuString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,KhousePropertyConfirmOrderString];
    NSString *upIdString = self.editParms[@"id"]?self.editParms[@"id"]:self.genarateId;
    NSDictionary *params = @{@"id" : upIdString,
                             @"paytype" : @"APP",
                             @"token" : [self getValidateToken]
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:huhuString params:params successBlock:^(id responseObject) {
            
        PayResponse *payResponse = [PayResponse objectWithKeyValues:responseObject];
        
        if ([payResponse.code isEqualToString:@"0000"]) {
            
            PayModel *payModel = payResponse.paydata;
            // 调起微信支付
            PayReq *reqPay = [[PayReq alloc] init];
            reqPay.partnerId = payModel.partnerid;
            reqPay.prepayId = payModel.prepayid;
            reqPay.nonceStr = payModel.noncestr;
            reqPay.timeStamp = [payModel.timestamp intValue];
            reqPay.package = payModel.package;
            reqPay.sign = payModel.paySign;
            [WXApi sendReq:reqPay];
        }else{
            [weakself showHint:payResponse.msg];
        }
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)ResponseResult
{
    UIAlertController *alertFV = [UIAlertController alertControllerWithTitle:@"" message:@"支付成功" preferredStyle:UIAlertControllerStyleAlert];
    QDFWeakSelf;
    UIAlertAction *actr = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        HousePropertyListViewController *housePropertyListVC = [[HousePropertyListViewController alloc] init];
        UINavigationController *nagg = weakself.navigationController;
        [nagg popViewControllerAnimated:NO];
        [nagg popViewControllerAnimated:NO];
        [nagg pushViewController:housePropertyListVC animated:NO];
    }];
    [alertFV addAction:actr];
    [self presentViewController:alertFV animated:YES completion:nil];
}

- (void)shwoAlertViewWithType:(NSString *)type
{
    UIButton *showButton1 = [UIButton newAutoLayoutView];
    showButton1.backgroundColor = UIColorFromRGB1(0x333333, 0.3);
    [[UIApplication sharedApplication].keyWindow addSubview:showButton1];
    [showButton1 autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [showButton1 addAction:^(UIButton *btn) {
        [btn removeFromSuperview];
    }];
    if ([type integerValue] == 1) {
        [showButton1 setImage:[UIImage imageNamed:@"payimage"] forState:0];
    }else{
        [showButton1 setImage:[UIImage imageNamed:@"image_tip"] forState:0];
    }
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
