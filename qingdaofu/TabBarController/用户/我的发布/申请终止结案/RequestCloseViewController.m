//
//  RequestCloseViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/20.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "RequestCloseViewController.h"
#import "DealingCloseViewController.h"  //证明示例

#import "BaseCommitView.h"
#import "AgentCell.h"

@interface RequestCloseViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) UITableView *requestCloseTableView;
@property (nonatomic,strong) BaseCommitView *requestCloseCommitView;

@property (nonatomic,strong) NSMutableDictionary *closeApplyDic;

@end

@implementation RequestCloseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请结案";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    [self.rightButton setTitle:@"证明示例" forState:0];
    
    [self.view addSubview:self.requestCloseTableView];
    [self.view addSubview:self.requestCloseCommitView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.requestCloseTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.requestCloseTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.requestCloseCommitView];
        
        [self.requestCloseCommitView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.requestCloseCommitView autoSetDimension:ALDimensionHeight toSize:kCellHeight4];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - getter
- (UITableView *)requestCloseTableView
{
    if (!_requestCloseTableView) {
        _requestCloseTableView = [UITableView newAutoLayoutView];
        _requestCloseTableView.backgroundColor = kBackColor;
        _requestCloseTableView.separatorColor = kSeparateColor;
        _requestCloseTableView.delegate = self;
        _requestCloseTableView.dataSource = self;
        _requestCloseTableView.tableFooterView = [[UIView alloc] init];
    }
    return _requestCloseTableView;
}

- (BaseCommitView *)requestCloseCommitView
{
    if (!_requestCloseCommitView) {
        _requestCloseCommitView = [BaseCommitView newAutoLayoutView];
        [_requestCloseCommitView.button setTitle:@"立即申请" forState:0];
        
        QDFWeakSelf;
        [_requestCloseCommitView addAction:^(UIButton *btn) {
            [weakself showAlertOfCloseApply];
        }];
    }
    return _requestCloseCommitView;
}

- (NSMutableDictionary *)closeApplyDic
{
    if (!_closeApplyDic) {
        _closeApplyDic = [NSMutableDictionary dictionary];
    }
    return _closeApplyDic;
}

#pragma mark - tableview delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"requestClose";
    AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.leftdAgentContraints.constant = 120;
    cell.agentButton.titleLabel.font = kBigFont;
    [cell.agentButton setTitleColor:kBlackColor forState:0];
    
    NSArray *cll = @[@[@"实际结案金额",@"实收佣金"],@[@"请输入实际结案金额",@"请输入实收佣金"]];
    cell.agentLabel.text = cll[0][indexPath.row];
    cell.agentTextField.placeholder = cll[1][indexPath.row];
    [cell.agentButton setTitle:@"万" forState:0];
    
    QDFWeakSelf;
    [cell setDidEndEditing:^(NSString *text) {
        if (indexPath.row == 0) {
            [weakself.closeApplyDic setValue:text forKey:@"price"];
        }else{
            [weakself.closeApplyDic setValue:text forKey:@"price2"];
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 76;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *footerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 76)];
    footerButton.backgroundColor = kBackColor;
    [footerButton setContentEdgeInsets:UIEdgeInsetsMake(kBigPadding, 11, 0, 11)];
    footerButton.titleLabel.numberOfLines = 0;
    NSString *sssss1 = @"注：";
    NSString *sssss2 = @"点击申请结案后，系统会根据您填写的信息发送给发布方一份结清证明，等待发布方确认无误后确认结案。";
    NSString *ssss = [NSString stringWithFormat:@"%@%@",sssss1,sssss2];
    NSMutableAttributedString *attributeSSS = [[NSMutableAttributedString alloc] initWithString:ssss];
    [attributeSSS setAttributes:@{NSFontAttributeName:kSmallFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(0, sssss1.length)];
    [attributeSSS setAttributes:@{NSFontAttributeName:kSmallFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(sssss1.length, sssss2.length)];
    NSMutableParagraphStyle *styleed = [[NSMutableParagraphStyle alloc] init];
    [styleed setLineSpacing:kSpacePadding];
    styleed.alignment = NSTextAlignmentLeft;
    [attributeSSS addAttribute:NSParagraphStyleAttributeName value:styleed range:NSMakeRange(0, ssss.length)];
    [footerButton setAttributedTitle:attributeSSS forState:0];
    
    return footerButton;
}

#pragma mark - method
- (void)showAlertOfCloseApply
{
    UIAlertController *closeAlert = [UIAlertController alertControllerWithTitle:@"是否立即申请结案" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    QDFWeakSelf;
    [closeAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请说明申请结案原因";
        textField.delegate = weakself;
    }];
    
    UIAlertAction *closeAct1 = [UIAlertAction actionWithTitle:@"否" style:0 handler:nil];
    UIAlertAction *closeAct2 = [UIAlertAction actionWithTitle:@"是" style:0 handler:^(UIAlertAction * _Nonnull action) {
        [weakself gotoApplyClose];
    }];
    
    [closeAlert addAction:closeAct1];
    [closeAlert addAction:closeAct2];
    
    [self presentViewController:closeAlert animated:YES completion:nil];
}

- (void)gotoApplyClose
{
    [self.view endEditing:YES];
    
    NSString *applyCloseString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyOrderDetailOfDealClosedApply];
    
    self.closeApplyDic[@"price"] =  self.closeApplyDic[@"price"]?self.closeApplyDic[@"price"]:@"";
    self.closeApplyDic[@"price2"] =  self.closeApplyDic[@"price2"]?self.closeApplyDic[@"price2"]:@"";//applymemo

    [self.closeApplyDic setValue:self.orderModell.orders.ordersid forKey:@"ordersid"];
    [self.closeApplyDic setValue:[self getValidateToken] forKey:@"token"];
    
    NSDictionary *params = self.closeApplyDic;
    
    QDFWeakSelf;
    [self requestDataPostWithString:applyCloseString params:params successBlock:^(id responseObject) {
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself back];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)rightItemAction
{
    DealingCloseViewController *dealCloseVC = [[DealingCloseViewController alloc] init];
    dealCloseVC.perTypeString = @"2";
    dealCloseVC.orderModell = self.orderModell;
    [self.navigationController pushViewController:dealCloseVC animated:YES];
}

#pragma mark - textField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.closeApplyDic setValue:textField.text forKey:@"applymemo"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
