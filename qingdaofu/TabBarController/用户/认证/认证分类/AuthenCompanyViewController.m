//
//  AuthenCompanyViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/31.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AuthenCompanyViewController.h"

#import "AuthentyWaitingViewController.h"   //认证成功
#import "CaseViewController.h" //经典案例

#import "TakePictureCell.h"
#import "EditDebtAddressCell.h"
#import "AgentCell.h"
#import "BaseCommitView.h"
#import "PersonCell.h"

#import "ImageModel.h"

#import "UIButton+WebCache.h"
#import "UIViewController+MutipleImageChoice.h"

@interface AuthenCompanyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *companyAuTableView;
@property (nonatomic,strong) BaseCommitView *companyAuCommitButton;

@property (nonatomic,strong) NSMutableDictionary *comDataDictionary;
@property (nonatomic,strong) NSString *imgFileIdString1;
@property (nonatomic,strong) NSString *imgFileIdString2;
@property (nonatomic,strong) NSString *imgFileUrlString1;
@property (nonatomic,strong) NSString *imgFileUrlString2;

@end

@implementation AuthenCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"认证公司";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.companyAuTableView];
    [self.view addSubview:self.companyAuCommitButton];
    [self.view setNeedsUpdateConstraints];
    
    [self addKeyboardObserver];
}

- (void)dealloc
{
    [self removeKeyboardObserver];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.companyAuTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.companyAuTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.companyAuCommitButton];
        
        [self.companyAuCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.companyAuCommitButton autoSetDimension:ALDimensionHeight toSize:kCellHeight4];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)companyAuTableView
{
    if (!_companyAuTableView) {
        _companyAuTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _companyAuTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _companyAuTableView.delegate = self;
        _companyAuTableView.dataSource = self;
        _companyAuTableView.tableFooterView = [[UIView alloc] init];
        _companyAuTableView.separatorColor = kSeparateColor;
    }
    return _companyAuTableView;
}

- (BaseCommitView *)companyAuCommitButton
{
    if (!_companyAuCommitButton) {
        _companyAuCommitButton = [BaseCommitView newAutoLayoutView];
        [_companyAuCommitButton.button setTitle:@"提交资料" forState:0];
        [_companyAuCommitButton addTarget:self action:@selector(goToAuthenCompanyMessages) forControlEvents:UIControlEventTouchUpInside];
    }
    return _companyAuCommitButton;
}

- (NSMutableDictionary *)comDataDictionary
{
    if (!_comDataDictionary) {
        _comDataDictionary = [NSMutableDictionary dictionary];
    }
    return _comDataDictionary;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 5;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 105 + kBigPadding*2;
    }else if (indexPath.section == 2 && indexPath.row == 4){
        return 60;
    }
    
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section == 0) {
        identifier = @"authenCom0";
        PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.pictureButton1 setImage:[UIImage imageNamed:@"upload_positive_image"] forState:0];
        [cell.pictureButton2 setImage:[UIImage imageNamed:@"upload_opposite_image"] forState:0];
        
        QDFWeakSelf;
        [cell.pictureButton1 addAction:^(UIButton *btn) {//正面照
            [weakself addImageWithMaxSelection:1 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
                if (images.count > 0) {
                    NSData *imgData = [NSData dataWithContentsOfFile:images[0]];
                    NSString *imgStr = [NSString stringWithFormat:@"%@",imgData];
                    [weakself uploadImages:imgStr andType:nil andFilePath:nil];
                    
                    [weakself setDidGetValidImage:^(ImageModel *imgModel) {
                        if ([imgModel.code isEqualToString:@"0000"]) {
                            [btn setImage:[UIImage imageWithContentsOfFile:images[0]] forState:0];
                            weakself.imgFileIdString1 = imgModel.fileid;
                            weakself.imgFileUrlString1 = imgModel.url;
                        }
                    }];
                }
            }];
        }];
        
        [cell.pictureButton2 addAction:^(UIButton *btn) {//反面照
            [weakself addImageWithMaxSelection:1 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
                if (images.count > 0) {
                    NSData *imgData = [NSData dataWithContentsOfFile:images[0]];
                    NSString *imgStr = [NSString stringWithFormat:@"%@",imgData];
                    [weakself uploadImages:imgStr andType:nil andFilePath:nil];
                    
                    [weakself setDidGetValidImage:^(ImageModel *imgModel) {
                        if ([imgModel.error isEqualToString:@"0"]) {
                            [btn setImage:[UIImage imageWithContentsOfFile:images[0]] forState:0];
                            weakself.imgFileIdString2 = imgModel.fileid;
                            weakself.imgFileUrlString2 = imgModel.url;
                        }
                    }];
                }
            }];
        }];
        
        return cell;
        
    }else if (indexPath.section == 1){
        identifier = @"authenCom1";
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftdAgentContraints.constant = 100;
        
        NSArray *perTextArray = @[@"|  基本信息",@"公司名称",@"营业执照号",@"联系人",@"联系方式"];
        NSArray *perPlacaTextArray = @[@"",@"请输入您的公司名称",@"请输入17位营业执照号",@"请输入您的姓名",@"请输入您常用的手机号码"];

        cell.agentLabel.text = perTextArray[indexPath.row];
        cell.agentTextField.placeholder = perPlacaTextArray[indexPath.row];
        
        QDFWeakSelf;
        if (indexPath.row == 0) {
            cell.agentLabel.textColor = kBlueColor;
            cell.agentTextField.userInteractionEnabled = NO;
        }else if (indexPath.row == 1){//公司名称
            QDFWeak(cell);
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [self.comDataDictionary setValue:text forKey:@"name"];
            }];
        }else if (indexPath.row == 2){//营业执照号
            QDFWeak(cell);
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [self.comDataDictionary setValue:text forKey:@"cardno"];
            }];
        }else if (indexPath.row == 3){//联系人
            QDFWeak(cell);
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [self.comDataDictionary setValue:text forKey:@"contact"];
            }];
        }else{//联系方式
            QDFWeak(cell);
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [self.comDataDictionary setValue:text forKey:@"mobile"];
            }];
        }
        
        [cell setTouchBeginPoint:^(CGPoint point) {
            weakself.touchPoint = point;
        }];
        
        return cell;
        
    }else{
        
        if (indexPath.row < 4) {
            identifier = @"authenCom2";
            
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftdAgentContraints.constant = 100;

            NSArray *perTesArray = @[@"补充信息",@"企业邮箱",@"企业地址  ",@"公司网站"];
            NSArray *perHolderArray = @[@"",@"请输入您的企业邮箱",@"请输入您的企业经营地址",@"请输入您的公司网站"];
            
            cell.agentLabel.text = perTesArray[indexPath.row];
            cell.agentTextField.placeholder = perHolderArray[indexPath.row];
            
            if (indexPath.row == 0) {
                cell.agentTextField.userInteractionEnabled = NO;
                NSMutableAttributedString *ttt = [cell.agentLabel setAttributeString:@"|  补充信息  " withColor:kBlueColor andSecond:@"(选填)" withColor:kGrayColor withFont:12];
                [cell.agentLabel setAttributedText:ttt];
            }else if (indexPath.row == 1){//企业邮箱
                QDFWeak(cell);
                [cell setDidEndEditing:^(NSString *text) {
                    weakcell.agentTextField.text = text;
                    [self.comDataDictionary setValue:text forKey:@"email"];
                }];
            }else if (indexPath.row == 2){//经营地址
                QDFWeak(cell);
                [cell setDidEndEditing:^(NSString *text) {
                    weakcell.agentTextField.text = text;
                    [self.comDataDictionary setValue:text forKey:@"address"];
                }];
            }else{//公司网站
                QDFWeak(cell);
                [cell setDidEndEditing:^(NSString *text) {
                    weakcell.agentTextField.text = text;
                    [self.comDataDictionary setValue:text forKey:@"enterprisewebsite"];
                }];
            }
            QDFWeakSelf;
            [cell setTouchBeginPoint:^(CGPoint point) {
                weakself.touchPoint = point;
            }];
            
            return cell;
        }
        
        identifier = @"authenCom3";
        EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.leftTextViewConstraints.constant = 98;
        cell.ediLabel.text = @"经典案例";
        cell.ediTextView.placeholder = @"请输入清收或诉讼成功案例";
        cell.ediTextView.font = kFirstFont;
        
        QDFWeakSelf;
        [cell setTouchBeginPoint:^(CGPoint point) {
            weakself.touchPoint = point;
        }];
        
        QDFWeak(cell);
        [cell setDidEndEditing:^(NSString *text) {
            weakcell.ediTextView.text = text;
            [weakself.comDataDictionary setValue:text forKey:@"casedesc"];
        }];
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 35;
    }
    
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section > 1) {
        return kBigPadding;
    }
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
        headerView.textAlignment = NSTextAlignmentCenter;
        headerView.font = kSecondFont;
        headerView.text = @"请上传公司营业执照图片";
        headerView.textColor = kGrayColor;
        return headerView;
    }
    return nil;
}

#pragma mark - commit messages
- (void)goToAuthenCompanyMessages
{
    [self.view endEditing:YES];
    
    NSString *imgFileIdStr = [NSString stringWithFormat:@"%@,%@",self.imgFileIdString1,self.imgFileIdString2];
    [self.comDataDictionary setObject:imgFileIdStr forKey:@"cardimgimg"];
    NSString *imgFileUrlStr = [NSString stringWithFormat:@"'%@','%@'",self.imgFileUrlString1,self.imgFileUrlString2];
    [self.comDataDictionary setObject:imgFileUrlStr forKey:@"cardimg"];
    NSString *comAuString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kAuthenString];
    
    [self.comDataDictionary setValue:@"3" forKey:@"category"];
    [self.comDataDictionary setValue:[self getValidateToken] forKey:@"token"];
    
    [self.comDataDictionary setValue:@"add" forKey:@"type"];
    
    NSDictionary *params = self.comDataDictionary;
    
    QDFWeakSelf;
    [self requestDataPostWithString:comAuString params:params successBlock:^(id responseObject) {
        BaseModel *companyModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:companyModel.msg];
        
        if ([companyModel.code isEqualToString:@"0000"]) {
            AuthentyWaitingViewController *waitingVC = [[AuthentyWaitingViewController alloc] init];
            waitingVC.backString = @"2";
            [self.navigationController pushViewController:waitingVC animated:YES];
        }
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)back
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"是否放弃保存？" preferredStyle:UIAlertControllerStyleAlert];
    
    QDFWeakSelf;
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:act1];
    [alertVC addAction:act2];
    
    [self presentViewController:alertVC animated:YES completion:nil];
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
