//
//  AuthenCompanyViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/31.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AuthenCompanyViewController.h"

#import "AuthentyWaitingViewController.h"   //认证成功

#import "TakePictureCell.h"
#import "EditDebtAddressCell.h"
#import "AgentCell.h"
#import "BaseCommitView.h"
#import "PersonCell.h"

#import "UIViewController+MutipleImageChoice.h"

@interface AuthenCompanyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *companyAuTableView;
@property (nonatomic,strong) BaseCommitView *companyAuCommitButton;

@property (nonatomic,strong) NSMutableDictionary *comDataDictionary;
@property (nonatomic,strong) NSMutableArray *imageArray;

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
        [self.companyAuCommitButton autoSetDimension:ALDimensionHeight toSize:kCellHeight1];
        
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
        [_companyAuCommitButton.button addTarget:self action:@selector(goToAuthenCompanyMessages) forControlEvents:UIControlEventTouchUpInside];
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

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
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
    }
    
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    CertificationModel *certificationModel = self.responseModel.certification;
    if (indexPath.section == 0) {
        identifier = @"authenPer0";
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
                NSData *imgData = [NSData dataWithContentsOfFile:images[0]];
                NSString *imgStr = [NSString stringWithFormat:@"%@",imgData];
                [self.comDataDictionary setValue:imgStr forKey:@"cardimgs"];
                [btn setImage:[UIImage imageWithContentsOfFile:images[0]] forState:0];
            }];
        }];
        
        [cell.pictureButton2 addAction:^(UIButton *btn) {//反面照
            [weakself addImageWithMaxSelection:1 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
                NSData *imgData = [NSData dataWithContentsOfFile:images[0]];
                NSString *imgStr = [NSString stringWithFormat:@"%@",imgData];
                
                //                [self.perDataDictionary setValue:imgStr forKey:@"cardimgs"];
                
                [btn setImage:[UIImage imageWithContentsOfFile:images[0]] forState:0];
            }];
        }];
        
        return cell;
        
    }else if (indexPath.section == 1){
        identifier = @"authenPer1";
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
            cell.agentTextField.text = certificationModel.name;
            QDFWeak(cell);
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [self.comDataDictionary setValue:text forKey:@"name"];
            }];
        }else if (indexPath.row == 2){//营业执照号
            cell.agentTextField.text = certificationModel.cardno;
            QDFWeak(cell);
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [self.comDataDictionary setValue:text forKey:@"cardno"];
            }];
        }else if (indexPath.row == 3){//联系人
            cell.agentTextField.text  = certificationModel.contact;
            QDFWeak(cell);
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [self.comDataDictionary setValue:text forKey:@"contact"];
            }];
        }else{//联系方式
            cell.agentTextField.text = certificationModel.mobile?certificationModel.mobile:[self getValidateMobile];
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
            identifier = @"authenPer2";
            
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
                cell.agentTextField.text = certificationModel.email;
                QDFWeak(cell);
                [cell setDidEndEditing:^(NSString *text) {
                    weakcell.agentTextField.text = text;
                    [self.comDataDictionary setValue:text forKey:@"email"];
                }];
            }else if (indexPath.row == 2){//经营地址
                cell.agentTextField.text = certificationModel.address;
                QDFWeak(cell);
                [cell setDidEndEditing:^(NSString *text) {
                    weakcell.agentTextField.text = text;
                    [self.comDataDictionary setValue:text forKey:@"address"];
                }];
            }else{//公司网站
                cell.agentTextField.text = certificationModel.enterprisewebsite;
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
        
        identifier = @"authenPer3";
        
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.agentTextField.userInteractionEnabled = NO;
        cell.agentButton.userInteractionEnabled = NO;
        
        cell.agentLabel.text = @"经典案例";
        cell.agentTextField.placeholder = @"请输入诉讼、清收等成功案例";
        cell.agentTextField.text = certificationModel.casedesc;
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        QDFWeak(cell);
        [cell setDidEndEditing:^(NSString *text) {
            weakcell.agentTextField.text = text;
            [self.comDataDictionary setValue:text forKey:@"casedesc"];
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
        
//        NSString *str1 = @"上传验证身份证件照或名片图片";
//        NSString *str2 = @"（必填）";
//        NSString *str3 = [NSString stringWithFormat:@"%@%@",str1,str2];
//
//        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str3];
//
//        [attributeStr setAttributes:@{NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(0, str1.length)];
//        [attributeStr setAttributes:@{NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(str1.length, str2.length)];
//
//        [headerView setAttributedText:attributeStr];
        return headerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == 2) {
        [self showHint:@"经典案例"];
    }
}

#pragma mark - commit messages
- (void)goToAuthenCompanyMessages
{
    [self.view endEditing:YES];
    NSString *comAuString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kAuthenString];
    /*
     @"category" : @"3",
     @"name" : @"米mi", //用户名
     @"cardno" : @"8888888888888",   //证件号
     @"email" : @"1234678@qq.com",    //邮箱
     @"casedesc" : @"",  //案例
     @"mobile" : @"13052358968",  //电话
     @"contact" : @"",    //联系人
     @"address" : @"",   //联系地址
     @"enterprisewebsite" : @"",  //公司网址
     @"cardimg" : @"",  //证件图片
     @"type" : @"update",  //add=>’添加认证’。update=>’修改认证’。
     @"token" : [weakself getValidateToken]
     */
    
    if (!self.comDataDictionary[@"mobile"]) {
        self.comDataDictionary[@"mobile"] = self.responseModel.certification.mobile?self.responseModel.certification.mobile:[self getValidateMobile];
    }
    if (!self.comDataDictionary[@"cardimgs"]) {
        NSString *imgStr = self.responseModel.certification.cardimg?self.responseModel.certification.cardimg:@"";
        [self.comDataDictionary setValue:imgStr forKey:@"cardimg"];
    }

    self.comDataDictionary[@"name"] = self.comDataDictionary[@"name"]?self.comDataDictionary[@"name"]:self.responseModel.certification.name;
    self.comDataDictionary[@"cardno"] = self.comDataDictionary[@"cardno"]?self.comDataDictionary[@"cardno"]:self.responseModel.certification.cardno;
    self.comDataDictionary[@"contact"] = self.comDataDictionary[@"contact"]?self.comDataDictionary[@"contact"]:self.responseModel.certification.contact;
    self.comDataDictionary[@"address"] = self.comDataDictionary[@"address"]?self.comDataDictionary[@"address"]:self.responseModel.certification.address;
    self.comDataDictionary[@"enterprisewebsite"] = self.comDataDictionary[@"enterprisewebsite"]?self.comDataDictionary[@"enterprisewebsite"]:self.responseModel.certification.enterprisewebsite;
    self.comDataDictionary[@"email"] = self.comDataDictionary[@"email"]?self.comDataDictionary[@"email"]:self.responseModel.certification.email;
    self.comDataDictionary[@"casedesc"] = self.comDataDictionary[@"casedesc"]?self.comDataDictionary[@"casedesc"]:self.responseModel.certification.casedesc;
    self.comDataDictionary[@"completionRate"] = self.responseModel.completionRate?self.responseModel.completionRate:@"";
    
    [self.comDataDictionary setValue:@"3" forKey:@"category"];
    [self.comDataDictionary setValue:[self getValidateToken] forKey:@"token"];
    
    if ([self.typeAuthen integerValue] == 1) {
        [self.comDataDictionary setValue:@"update" forKey:@"type"];  //update为修改
    }else{
        [self.comDataDictionary setValue:@"add" forKey:@"type"];  //update为修改
    }
    
    NSDictionary *params = self.comDataDictionary;
    
    QDFWeakSelf;
    [self requestDataPostWithString:comAuString params:params andImages:nil successBlock:^(id responseObject) {
        BaseModel *personModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:personModel.msg];
        
        if ([personModel.code isEqualToString:@"0000"]) {
            UINavigationController *personNav = weakself.navigationController;
            [personNav popViewControllerAnimated:NO];
            [personNav popViewControllerAnimated:NO];
            [personNav popViewControllerAnimated:NO];
            
            AuthentyWaitingViewController *waitingVC = [[AuthentyWaitingViewController alloc] init];
            waitingVC.categoryString = weakself.categoryString;
            waitingVC.hidesBottomBarWhenPushed = YES;
            [personNav pushViewController:waitingVC animated:NO];
        }
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)back
{
    if (!self.responseModel && !self.comDataDictionary) {

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
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
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
