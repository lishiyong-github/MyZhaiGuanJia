//
//  MyScheduleViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/5.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyScheduleViewController.h"

#import "TextFieldCell.h"
#import "MineUserCell.h"
#import "CaseNoCell.h"
#import "AgentCell.h"
#import "EditDebtAddressCell.h"

#import "UIViewController+BlurView.h"

@interface MyScheduleViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *scheduleTableView;

@property (nonatomic,strong) NSMutableDictionary *scheduleDictionary;

@end

@implementation MyScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写进度";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.scheduleTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.scheduleTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)scheduleTableView
{
    if (!_scheduleTableView) {
        _scheduleTableView = [UITableView newAutoLayoutView];
        _scheduleTableView.backgroundColor = kBackColor;
        _scheduleTableView.separatorColor = kSeparateColor;
        _scheduleTableView.delegate = self;
        _scheduleTableView.dataSource = self;
        _scheduleTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _scheduleTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];

//        if ([_scheduleTableView respondsToSelector:@selector(setSeparatorInset:)]) {
//            [_scheduleTableView setSeparatorInset:UIEdgeInsetsZero];
//        }
//        if ([_scheduleTableView respondsToSelector:@selector(setLayoutMargins:)]) {
//            [_scheduleTableView setLayoutMargins:UIEdgeInsetsZero];
//        }

    }
    return _scheduleTableView;
}

- (NSMutableDictionary *)scheduleDictionary
{
    if (!_scheduleDictionary) {
        _scheduleDictionary = [NSMutableDictionary dictionary];
    }
    return _scheduleDictionary;
}

#pragma mark - delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.categoryString intValue] == 3) {//诉讼
        return 4;
    }
    
    return 2;//或者2
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.categoryString intValue] == 3) {//诉讼
        if (indexPath.row == 3) {
            return 200;
        }
        return kCellHeight;
    }
    
    if (indexPath.row == 1) {//清收
        return 200;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if ([self.categoryString integerValue] == 3) {//诉讼
        
        if (indexPath.row == 0) {//AgentCell.h
            identifier = @"schedule30";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.agentTextField.userInteractionEnabled = NO;
            
            cell.agentLabel.text = @"案号类型";
            cell.agentTextField.placeholder = @"请选择案号类型";
            [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            return cell;
            
        }else if (indexPath.row == 1){
            identifier = @"schedule31";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.agentButton setHidden:YES];
            
            cell.agentLabel.text = @"案号";
            cell.agentTextField.placeholder = @"请输入案号";
            
            return cell;

        }else if (indexPath.row == 2){
            identifier = @"schedule32";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.agentTextField.userInteractionEnabled = NO;
            
            cell.agentLabel.text = @"处置类型";
            cell.agentTextField.placeholder = @"请选择处置类型";
            [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            return cell;

        }else if (indexPath.row == 3){
            identifier = @"schedule33";
            EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.ediLabel.text = @"进度详情";
            cell.ediTextView.placeholder = @"请输入进度详情";
            
            [cell setDidEndEditing:^(NSString *text) {
                [self.scheduleDictionary setValue:text forKey:@"content"];
            }];
            
            return cell;
        }
    }
    
    //清收
    if (indexPath.row == 0){
        identifier = @"schedule20";
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.agentTextField.userInteractionEnabled = NO;
        cell.agentButton.userInteractionEnabled = NO;
        
        cell.agentLabel.text = @"处置类型";
        cell.agentTextField.placeholder = @"请选择处置类型";
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        return cell;
        
    }else if (indexPath.row == 1){
        identifier = @"schedule21";
        EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.ediLabel.text = @"进度详情";
        cell.ediTextView.placeholder = @"请输入进度详情";
        
        [cell setDidEndEditing:^(NSString *text) {
            [self.scheduleDictionary setValue:text forKey:@"content"];
        }];
        
        return cell;
    }
    
    return nil;
        /*
        if (indexPath.row < 2) {
            identifier = @"schedule30";
            CaseNoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[CaseNoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *arr1 = @[@"案号",@"选择处置类型"];
            NSArray *arr2 = @[@"请输入案号",@""];
            NSArray *arr3 = @[@"案号类型",@""];
            [cell.caseNoButton setTitle:arr1[indexPath.row] forState:0];
            [cell.caseNoTextField setPlaceholder:arr2[indexPath.row]];
            [cell.caseGoButton setTitle:arr3[indexPath.row] forState:0];
            [cell.caseGoButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
//            NSArray *suitArr = @[@"债权人上传处置资产",@"律师接单",@"双方洽谈",@"向法院起诉(财产保全)",@"整理诉讼材料",@"法院立案",@"向当事人发出开庭传票",@"开庭前调解",@"开庭",@"判决",@"二次开庭",@"二次判决",@"移交执行局申请执行",@"执行中提供借款人的财产线索",@"调查(公告)",@"拍卖",@"流拍",@"拍卖成功",@"付费"];
            NSArray *suitNoArr = @[@"一审",@"二审",@"再审",@"执行"];
            
            QDFWeakSelf;
            QDFWeak(cell);
            if (indexPath.row == 0) {//案号
                //案号
                [cell setDidEndEditting:^(NSString *text) {
                    [self.scheduleDictionary setValue:text forKey:@"case"];
                }];
                
                //案号类型
                [cell.caseGoButton addAction:^(UIButton *btn) {
                    [self.view endEditing:YES];
                    [weakself showBlurInView:self.view withArray:suitNoArr andTitle:@"选择案号类型" finishBlock:^(NSString *text,NSInteger row) {
                        [weakcell.caseGoButton setTitle:text forState:0];
                        NSString *auditStr = [NSString stringWithFormat:@"%ld",row-1];
                        [self.scheduleDictionary setValue:auditStr forKey:@"audit"];
                    }];
                }];
                
            }else{//处置类型
                cell.caseNoTextField.userInteractionEnabled = NO;
                cell.caseGoButton.userInteractionEnabled = NO;
//                [cell.caseGoButton addAction:^(UIButton *btn) {
//                    [self.view endEditing:YES];
//                    [weakself showBlurInView:self.view withArray:suitArr andTitle:@"选择处置类型" finishBlock:^(NSString *text,NSInteger row) {
//                        [weakcell.caseGoButton setTitle:text forState:0];
//                        
//                        NSString *statusStr = [NSString stringWithFormat:@"%ld",(long)row];
//                        [self.scheduleDictionary setValue:statusStr forKey:@"status"];
//                    }];
//                }];
            }
            return cell;
        }
        
        identifier = @"schedule32";
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.placeholder = @"请填写进度";
        [cell setDidEndEditing:^(NSString *text) {
            [self.scheduleDictionary setValue:text forKey:@"content"];
        }];
        

        return cell;
    }
    
    //融资或清收
    if (indexPath.row == 0) {
        identifier = @"schedule10";
        CaseNoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CaseNoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.caseNoButton setTitle:@"选择处置类型" forState:0];
        cell.caseNoTextField.userInteractionEnabled = NO;
        [cell.caseGoButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        cell.caseGoButton.userInteractionEnabled = NO;
        return cell;
    }
    
    identifier = @"schedule11";
    TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textField.placeholder = @"请填写进度";
    [cell setDidEndEditing:^(NSString *text) {
        [self.scheduleDictionary setValue:text forKey:@"content"];
    }];
    
    return cell;
         */
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QDFWeakSelf;
    if ([self.categoryString integerValue] == 3) {//诉讼
        if (indexPath.row == 0) {//案号类型
            NSArray *collectArr = @[@"一审",@"二审",@"再审",@"执行"];
            [self showBlurInView:self.view withArray:collectArr andTitle:@"选择案号类型" finishBlock:^(NSString *text,NSInteger row) {
                AgentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.agentTextField.text = text;
                
                NSString *auditStr = [NSString stringWithFormat:@"%ld",(long)row - 1];
                [weakself.scheduleDictionary setValue:auditStr forKey:@"udit"];
                
//                [weakself showBlurInView:self.view withArray:suitNoArr andTitle:@"选择案号类型" finishBlock:^(NSString *text,NSInteger row) {
//                    [weakcell.caseGoButton setTitle:text forState:0];
//                    NSString *auditStr = [NSString stringWithFormat:@"%ld",row-1];
//                    [self.scheduleDictionary setValue:auditStr forKey:@"audit"];
//                }];
            }];
        }else if (indexPath.row == 2) {
            NSArray *suitArr = @[@"债权人上传处置资产",@"律师接单",@"双方洽谈",@"向法院起诉(财产保全)",@"整理诉讼材料",@"法院立案",@"向当事人发出开庭传票",@"开庭前调解",@"开庭",@"判决",@"二次开庭",@"二次判决",@"移交执行局申请执行",@"执行中提供借款人的财产线索",@"调查(公告)",@"拍卖",@"流拍",@"拍卖成功",@"付费"];
            [self showBlurInView:self.view withArray:suitArr andTitle:@"选择处置类型" finishBlock:^(NSString *text,NSInteger row) {
                AgentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.agentTextField.text = text;
                
                NSString *statusStr = [NSString stringWithFormat:@"%ld",(long)row];
                [weakself.scheduleDictionary setValue:statusStr forKey:@"status"];
            }];
        }
    }else if ([self.categoryString integerValue] == 2){//清收
        if (indexPath.row == 0) {
            NSArray *collectArr = @[@"电话",@"上门",@"面谈"];
            [self showBlurInView:self.view withArray:collectArr andTitle:@"选择处置类型" finishBlock:^(NSString *text,NSInteger row) {
                AgentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.agentTextField.text = text;
                
                NSString *statusStr = [NSString stringWithFormat:@"%ld",(long)row];
                [weakself.scheduleDictionary setValue:statusStr forKey:@"status"];
            }];
        }
    }
}

#pragma mark - method
- (void)save
{
    [self writeMySchedule];
}

- (void)writeMySchedule
{
    [self.view endEditing:YES];
    NSString *myScheduleString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyscheduleString];
    /*
     status	状态
     
     清收：[
     1 => '电话',
     2 => '上门',
     3 => '面谈',
     ];
     
     诉讼：[
     1 => '债权人上传处置资产',
     2 => '律师接单',
     3 => '双方洽谈',
     4 => '向法院起诉(财产保全)',
     5 => '整理诉讼材料',
     6 => '法院立案',
     7 => '向当事人发出开庭传票',
     8 => '开庭前调解',
     9 => '开庭',
     10 => '判决',
     11 => '二次开庭',
     12 => '二次判决',
     13 => '移交执行局申请执行',
     14 => '执行中提供借款人的财产线索',
     15 => '调查(公告)',
     16 => '拍卖',
     17 => '流拍',
     18 => '拍卖成功',
     19 => '付费',
     ];
     */
    NSString *caseStr = self.scheduleDictionary[@"case"]?self.scheduleDictionary[@"case"]:@"";
    NSString *auditStr = self.scheduleDictionary[@"audit"]?self.scheduleDictionary[@"audit"]:@"";
    NSString *statusStr = self.scheduleDictionary[@"status"]?self.scheduleDictionary[@"status"]:@"";
    NSString *contentStr = self.scheduleDictionary[@"content"]?self.scheduleDictionary[@"content"]:@"";

    NSDictionary *params;
    if ([self.categoryString intValue] == 2){//清收
        params = @{@"token" : [self getValidateToken],
                   @"product_id" : self.idString,
                   @"category" : self.categoryString,
                   @"status" : statusStr,
                   @"content" : contentStr
                   };
    }else if ([self.categoryString intValue] == 3){//诉讼
        params = @{@"token" : [self getValidateToken],
                   @"product_id" : self.idString,
                   @"category" : self.categoryString,
                   @"status" : statusStr,
                   @"content" : contentStr,
                   @"audit" : auditStr,//诉讼的案号状态：0=>一审,1=>二审,2=>再审,3=>执行
                   @"case" : caseStr//诉讼里面的暗号
                   };
    }
    
    QDFWeakSelf;
    [self requestDataPostWithString:myScheduleString params:params successBlock:^( id responseObject){
        BaseModel *scheduleModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:scheduleModel.msg];
        
        if ([scheduleModel.code isEqualToString:@"0000"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"schedule" object:nil];
            [weakself.navigationController popViewControllerAnimated:YES];
        }
    } andFailBlock:^(NSError *error){
        
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
