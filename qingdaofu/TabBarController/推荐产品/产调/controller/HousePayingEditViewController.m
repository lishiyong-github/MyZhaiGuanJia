//
//  HousePayingEditViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/2.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "HousePayingEditViewController.h"
#import "HousePayingViewController.h"
#import "HouseChooseViewController.h"

#import "MineUserCell.h"
#import "EditDebtAddressCell.h"
#import "AgentCell.h"

#import "PropertyGenerateModel.h"

@interface HousePayingEditViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *housePropertyTableView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) NSMutableDictionary *payEditDic;

@end

@implementation HousePayingEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改信息";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveMessageOfPaying)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.housePropertyTableView];
    
    [self.view setNeedsUpdateConstraints];
    
    [self addKeyboardObserver];
}

-(void)dealloc
{
    [self removeKeyboardObserver];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.housePropertyTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - setter and getter
- (UITableView *)housePropertyTableView
{
    if (!_housePropertyTableView) {
        _housePropertyTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _housePropertyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _housePropertyTableView.delegate = self;
        _housePropertyTableView.dataSource = self;
        _housePropertyTableView.separatorColor = kSeparateColor;
    }
    return _housePropertyTableView;
}

- (NSMutableDictionary *)payEditDic
{
    if (!_payEditDic) {
        _payEditDic = [NSMutableDictionary dictionary];
    }
    return _payEditDic;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 60;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.row == 0) {//地址
        identifier = @"property0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userActionButton.userInteractionEnabled = NO;
        cell.userNameButton.userInteractionEnabled = NO;
        
        [cell.userNameButton setTitle:@"选择区域" forState:0];
        [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        NSString *areaS = [NSString stringWithFormat:@"%@  ",self.areaString];
        [cell.userActionButton setTitle:areaS forState:0];
        
        return cell;
    }else if (indexPath.row == 1){//详细地址
        identifier = @"property1";
        EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.ediLabel.text = @"详细地址";
        cell.ediTextView.placeholder = @"请输入详细地址";
        cell.ediTextView.text = self.addressString;
        
        QDFWeakSelf;
        [cell setDidEndEditing:^(NSString *text) {
            [weakself.payEditDic setObject:text forKey:@"address"];
        }];
        
        return cell;
    }
    
    //电话
    identifier = @"property2";
    AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.agentLabel.text = @"电话号码";
    cell.agentTextField.placeholder = @"请输入手机号码";
    cell.agentTextField.text = self.phoneString;
    
    QDFWeakSelf;
    [cell setDidEndEditing:^(NSString *text) {
        [weakself.payEditDic setObject:text forKey:@"phone"];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return kBigPadding;
    }
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        HouseChooseViewController *houseChooseVC = [[HouseChooseViewController alloc] init];
        houseChooseVC.cateString = @"2";
        [self.navigationController pushViewController:houseChooseVC animated:YES];
        
        QDFWeakSelf;
        [houseChooseVC setDidSelectedRow:^(NSString *name,NSString *idString,NSInteger row) {
            MineUserCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell.userActionButton setTitle:name forState:0];
            [weakself.payEditDic setObject:idString forKey:@"area"];
        }];
    }
}

#pragma mark - method
/*
- (void)back
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"未保存,是否保存？" preferredStyle:UIAlertControllerStyleAlert];
    
    QDFWeakSelf;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself saveMessageOfPaying];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
    [alertVC addAction:action1];
    [alertVC addAction:action2];

    [self presentViewController:alertVC animated:YES completion:nil];
}
 */

- (void)saveMessageOfPaying
{
    [self.view endEditing:YES];
    NSString *savePayString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kHousePorpertyEditString];
    
    self.payEditDic[@"area"] = [NSString getValidStringFromString:self.payEditDic[@"area"] toString:self.areaString];
    self.payEditDic[@"address"] = [NSString getValidStringFromString:self.payEditDic[@"address"] toString:self.addressString];
    self.payEditDic[@"phone"] = [NSString getValidStringFromString:self.payEditDic[@"phone"] toString:self.phoneString];
    [self.payEditDic setObject:self.idString forKey:@"id"];
    [self.payEditDic setObject:[self getValidateToken] forKey:@"token"];
    
    NSDictionary *params = self.payEditDic;
    
    QDFWeakSelf;
    [self requestDataPostWithString:savePayString params:params successBlock:^(id responseObject) {
        
        PropertyGenerateModel *oModel = [PropertyGenerateModel objectWithKeyValues:responseObject];
        
        if ([oModel.code isEqualToString:@"0000"]) {
            if ([weakself.actString integerValue] == 2) {
                
                HousePayingViewController *housePayingVC = [[HousePayingViewController alloc] init];
                housePayingVC.areaString = params[@"area"];
                housePayingVC.addressString = params[@"address"];
                housePayingVC.phoneString = params[@"phone"];
                housePayingVC.genarateMoney = oModel.money;
                housePayingVC.genarateId = oModel.idString;
                
                UINavigationController *naer = self.navigationController;
                [naer popViewControllerAnimated:NO];
                [naer pushViewController:housePayingVC animated:NO];
            }else{
                
                NSDictionary *uiui = @{@"area" : params[@"area"],
                                       @"address" : params[@"address"],
                                       @"phone" : params[@"phone"],
                                       @"money" : oModel.money,
                                       @"id" : oModel.idString
                                       };
                
                if (weakself.didEditMessage) {
                    weakself.didEditMessage(uiui);
                    [weakself.navigationController popViewControllerAnimated:YES];
                }
            }
        }else{
            [weakself showHint:oModel.msg];
        }
    } andFailBlock:^(NSError *error) {
        
    }];
//    [self.navigationController popViewControllerAnimated:YES];
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
