//
//  ReceiptAddressEditViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ReceiptAddressEditViewController.h"
#import "HouseChooseViewController.h"

#import "PowerCourtView.h"

#import "AgentCell.h"
#import "EditDebtAddressCell.h"
#import "LoginCell.h"
#import "BidOneCell.h"

@interface ReceiptAddressEditViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *receiptEditTableView;
@property (nonatomic,strong) PowerCourtView *receiptPickerView;

//传参
@property (nonatomic,strong) NSMutableDictionary *receiptDic;
@property (nonatomic,strong) NSMutableDictionary *receiptTestDic;


//省市区
@property (nonatomic,strong) NSDictionary *provinceDict;
@property (nonatomic,strong) NSDictionary *cityDcit;
@property (nonatomic,strong) NSDictionary *districtDict;


@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation ReceiptAddressEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.receiModel) {
        self.title = @"编辑地址";
    }else{
        self.title = @"新增地址";
    }
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveReceiptAddress)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self.view addSubview:self.receiptEditTableView];
    [self.view addSubview:self.receiptPickerView];
    [self.receiptPickerView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.receiptEditTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.receiptPickerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)receiptEditTableView
{
    if (!_receiptEditTableView) {
        _receiptEditTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _receiptEditTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _receiptEditTableView.delegate = self;
        _receiptEditTableView.dataSource = self;
        _receiptEditTableView.backgroundColor = kBackColor;
        _receiptEditTableView.separatorColor = kSeparateColor;
        _receiptEditTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _receiptEditTableView;
}

- (PowerCourtView *)receiptPickerView
{
    if (!_receiptPickerView) {
        _receiptPickerView = [PowerCourtView newAutoLayoutView];
        _receiptPickerView.publishStr = @"3";
        
        QDFWeakSelf;
        [_receiptPickerView setDidSelectedComponent:^(NSInteger component, NSInteger row, NSString *idString, NSString *nameString) {
            
            NSString *proID;
            NSString *proName;
            NSString *cityID;
            NSString *cityName;
            NSString *districtID;
            NSString *districtName;
            
            if (component == 0) {
                
                [weakself.receiptTestDic setObject:idString forKey:@"proID"];
                [weakself.receiptTestDic setObject:nameString forKey:@"proName"];
                [weakself getCityListsWithProvinceID:idString];
            }else if (component == 1){
                
                [weakself.receiptTestDic setObject:idString forKey:@"cityID"];
                [weakself.receiptTestDic setObject:nameString forKey:@"cityName"];
                [weakself getDistrictListsWithCityID:idString];
                
            }else if (component == 2){
                
                [weakself.receiptTestDic setObject:idString forKey:@"districtID"];
                [weakself.receiptTestDic setObject:nameString forKey:@"districtName"];
                
            }else if (component == 3){
                
                if (weakself.receiptTestDic[@"proName"] && weakself.receiptTestDic[@"cityName"] && weakself.receiptTestDic[@"districtName"]) {//都选择
                    
                    //显示
                    AgentCell *cell = [weakself.receiptEditTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                    cell.agentTextField.text = [NSString stringWithFormat:@"%@%@%@",weakself.receiptTestDic[@"proName"],weakself.receiptTestDic[@"cityName"],weakself.receiptTestDic[@"districtName"]];
                    
                    //保存参数
                    [weakself.receiptDic setObject:weakself.receiptTestDic[@"proID"] forKey:@"province"];
                    [weakself.receiptDic setObject:weakself.receiptTestDic[@"cityID"] forKey:@"city"];
                    [weakself.receiptDic setObject:weakself.receiptTestDic[@"districtID"] forKey:@"area"];
                }
            }
        }];
    }
    return _receiptPickerView;
}

- (NSMutableDictionary *)receiptDic
{
    if (!_receiptDic) {
        _receiptDic = [NSMutableDictionary dictionary];
    }
    return _receiptDic;
}

-(NSMutableDictionary *)receiptTestDic
{
    if (!_receiptTestDic) {
        _receiptTestDic = [NSMutableDictionary dictionary];
    }
    return _receiptTestDic;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.receiModel) {
        return 3;
    }else{
        return 2;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.section == 0) {
        if (indexPath.row < 2) {
            identifier = @"reiceptEd01";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *rere = @[@"收件人    ",@"电话号码"];
            NSArray *rtrt = @[@"请输入收件人姓名",@"请输入收件人电话号码"];
            cell.agentLabel.text = rere[indexPath.row];
            cell.agentTextField.placeholder = rtrt[indexPath.row];
            
            if (indexPath.row == 0) {//收件人
                cell.agentTextField.text = self.receiModel.nickname;
            }else{//电话
                cell.agentTextField.text = self.receiModel.tel;
            }
            
            QDFWeakSelf;
            [cell setDidEndEditing:^(NSString *text) {
                if (indexPath.row == 0) {
                    [weakself.receiptDic setObject:text forKey:@"nickname"];
                }else{
                    [weakself.receiptDic setObject:text forKey:@"tel"];
                }
            }];
            
            return cell;
            
        }else if (indexPath.row == 2){
            identifier = @"reiceptEd2";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.agentTextField.userInteractionEnabled = NO;
            cell.agentButton.userInteractionEnabled  = NO;
            
            cell.agentLabel.text = @"选择区域";
            cell.agentTextField.placeholder = @"请选择区域";
            [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            cell.agentTextField.text = [NSString stringWithFormat:@"%@%@%@",self.receiModel.province_name,self.receiModel.city_name,self.receiModel.area_name];
            
            return cell;
        }
        
        //详细地址
        identifier = @"reiceptEd3";
        EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.ediLabel.text = @"详细地址";
        cell.ediTextView.placeholder = @"请输入详细地址";
        cell.ediTextView.text = self.receiModel.address;
        
        QDFWeakSelf;
        [cell setDidEndEditing:^(NSString *text) {
            [weakself.receiptDic setObject:text forKey:@"address"];
        }];
        
        return cell;
        
    }else if (indexPath.section == 1){//LoginCell.h
        identifier = @"reiceptEd10";
        LoginCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[LoginCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.loginTextField.userInteractionEnabled = NO;
        [cell.getCodebutton setHidden:YES];
        cell.loginTextField.text = @"设为默认";
        if ([self.receiModel.isdefault integerValue] == 1) {
            [cell.loginSwitch setOn:YES];
        }else{
            [cell.loginSwitch setOn:NO];
        }
        
        QDFWeakSelf;
        [cell setDidEndSwitching:^(BOOL isOpen) {
            if (isOpen) {
                [weakself.receiptDic setObject:@"1" forKey:@"isdefault"];
            }else{
                [weakself.receiptDic setObject:@"0" forKey:@"isdefault"];
            }
        }];
        
        return cell;
        
    }else{
        identifier = @"reiceptEd20";
        BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.cancelButton setHidden:YES];
        cell.oneButton.userInteractionEnabled = NO;
        
        [cell.oneButton setTitle:@"删除地址" forState:0];
        [cell.oneButton setTitleColor:kRedColor forState:0];
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
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        [self getProvinceLists];
    }else if (indexPath.section == 2){
        [self DeleteReceiptAddressWithType:@"1"];
    }
}

#pragma mark - method
//new
- (void)saveReceiptAddress
{
    [self.view endEditing:YES];
    NSString *receiptString;
    if (self.receiModel) {
        receiptString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kReceiptCopyAddressString];
        [self.receiptDic setObject:self.receiModel.idString forKey:@"id"];
    }else{
        receiptString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kReceiptNewAddressString];
    }
    
    self.receiptDic[@"nickname"] = [NSString getValidStringFromString:self.receiptDic[@"nickname"] toString:self.receiModel.nickname];
    self.receiptDic[@"tel"] = [NSString getValidStringFromString:self.receiptDic[@"tel"] toString:self.receiModel.tel];
    self.receiptDic[@"province"] = [NSString getValidStringFromString:self.receiptDic[@"province"] toString:self.receiModel.province];
    self.receiptDic[@"city"] = [NSString getValidStringFromString:self.receiptDic[@"city"] toString:self.receiModel.city];
    self.receiptDic[@"area"] = [NSString getValidStringFromString:self.receiptDic[@"area"] toString:self.receiModel.area];
    self.receiptDic[@"address"] = [NSString getValidStringFromString:self.receiptDic[@"address"] toString:self.receiModel.address];
    self.receiptDic[@"isdefault"] = [NSString getValidStringFromString:self.receiptDic[@"isdefault"] toString:self.receiModel.isdefault];
    
    [self.receiptDic setObject:[self getValidateToken] forKey:@"token"];

    NSDictionary *params = self.receiptDic;
    
    QDFWeakSelf;
    [self requestDataPostWithString:receiptString params:params successBlock:^(id responseObject) {
        
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself.navigationController popViewControllerAnimated:YES];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

#pragma mark - get province city and dictrict
- (void)getProvinceLists
{
    NSString *provinceString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kProvinceString];
    QDFWeakSelf;
    [self requestDataPostWithString:provinceString params:nil successBlock:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        weakself.receiptPickerView.componentDic1 = dic;
        [weakself.receiptPickerView setHidden:NO];
        [weakself.receiptPickerView.pickerViews reloadAllComponents];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)getCityListsWithProvinceID:(NSString *)provinceId
{
    NSString *cityString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kCityString];
    NSDictionary *params = @{@"fatherID" : provinceId};
    
    QDFWeakSelf;
    [self requestDataPostWithString:cityString params:params successBlock:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        weakself.receiptPickerView.componentDic2 = dic[provinceId];
        if (weakself.receiptPickerView.componentDic3.allKeys.count > 0) {
            weakself.receiptPickerView.typeComponent = @"3";
        }else{
            weakself.receiptPickerView.typeComponent = @"2";
        }
        [weakself.receiptPickerView.pickerViews reloadAllComponents];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)getDistrictListsWithCityID:(NSString *)cityId
{
    NSString *districtString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kDistrictString];
    NSDictionary *params = @{@"fatherID" : cityId};
    
    QDFWeakSelf;
    [self requestDataPostWithString:districtString params:params successBlock:^(id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        weakself.receiptPickerView.componentDic3 = dic[cityId];
        weakself.receiptPickerView.typeComponent = @"3";
        [weakself.receiptPickerView.pickerViews reloadAllComponents];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

#pragma mark - delete
- (void)DeleteReceiptAddressWithType:(NSString *)typeString
{
    NSString *cancelString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kReceiptDefaultCancelString];
    NSDictionary *params = @{@"id" : self.receiModel.idString,
                             @"type" : typeString,
                             @"token" : [self getValidateToken]
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:cancelString params:params successBlock:^(id responseObject) {
        BaseModel *baModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baModel.msg];
        
        if ([baModel.code isEqualToString:@"0000"]) {
            [weakself.navigationController popViewControllerAnimated:YES];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
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
