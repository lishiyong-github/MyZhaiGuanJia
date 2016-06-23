//
//  AuthenCompanyViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/31.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AuthenCompanyViewController.h"

#import "CompleteViewController.h"   //认证成功

#import "TakePictureCell.h"
#import "EditDebtAddressCell.h"
#import "AgentCell.h"
#import "BaseCommitButton.h"

#import "UIViewController+MutipleImageChoice.h"


@interface AuthenCompanyViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *companyAuTableView;
@property (nonatomic,strong) BaseCommitButton *companyAuCommitButton;

@property (nonatomic,strong) NSMutableDictionary *comDataDictionary;
@property (nonatomic,strong) NSMutableArray *imageArray;


@end

@implementation AuthenCompanyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"认证公司";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.companyAuTableView];
    [self.view addSubview:self.companyAuCommitButton];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.companyAuTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.companyAuTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.companyAuCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.companyAuCommitButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)companyAuTableView
{
    if (!_companyAuTableView) {
        _companyAuTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _companyAuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _companyAuTableView.delegate = self;
        _companyAuTableView.dataSource = self;
        _companyAuTableView.tableFooterView = [[UIView alloc] init];
        _companyAuTableView.separatorColor = kSeparateColor;
    }
    return _companyAuTableView;
}

- (BaseCommitButton *)companyAuCommitButton
{
    if (!_companyAuCommitButton) {
        _companyAuCommitButton = [BaseCommitButton newAutoLayoutView];
        [_companyAuCommitButton setTitle:@"立即认证" forState:0];
        [_companyAuCommitButton addTarget:self action:@selector(goToAuthenCompanyMessages) forControlEvents:UIControlEventTouchUpInside];
            
            /*
            UINavigationController *companyNav = weakself.navigationController;
            [companyNav popViewControllerAnimated:NO];
            [companyNav popViewControllerAnimated:NO];
            
            CompleteViewController *completeVC = [[CompleteViewController alloc] init];
            completeVC.hidesBottomBarWhenPushed = YES;
            [companyNav pushViewController:completeVC animated:NO];
             */
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
        return 80;
    }else if (indexPath.section == 2){
        if (indexPath.row == 4) {
            return 70;
        }
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    CertificationModel *certificationModel = self.responseModel.certification;
    if (indexPath.section == 0) {
        identifier = @"authenPer0";
        TakePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[TakePictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (certificationModel.cardimg) {
            NSString *subString = [certificationModel.cardimg substringWithRange:NSMakeRange(1, certificationModel.cardimg.length-2)];
            NSString *urlString = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,subString];
            NSURL *url = [NSURL URLWithString:urlString];
            cell.collectionDataList = [NSMutableArray arrayWithObject:url];
        }else{
            cell.collectionDataList = [NSMutableArray arrayWithObjects:@"btn_camera", nil];
        }

        QDFWeakSelf;
        QDFWeak(cell);
        [cell setDidSelectedItem:^(NSInteger itemTag) {
            
            [weakself addImageWithMaxSelection:1 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
                
                weakcell.collectionDataList = [NSMutableArray arrayWithArray:images];
                [weakcell reloadData];
//                [weakself.comDataDictionary setValue:images forKey:@"cardimg"];
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
        
        NSArray *perTextArray = @[@"|  基本信息",@"公司名称",@"营业执照号",@"联系人",@"联系方式"];
        NSArray *perPlacaTextArray = @[@"",@"请输入您的公司名称",@"请输入您的营业执照号",@"请输入您的姓名",@"请输入您常用的手机号码"];
        
        cell.leftdAgentContraints.constant = 110;
        cell.agentLabel.text = perTextArray[indexPath.row];
        cell.agentTextField.placeholder = perPlacaTextArray[indexPath.row];
        
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
            cell.agentTextField.text = certificationModel.mobile;
            QDFWeak(cell);
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [self.comDataDictionary setValue:text forKey:@"mobile"];
            }];
        }
        
        return cell;
    }else{
        
        if (indexPath.row < 4) {
            identifier = @"authenPer2";
            
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSArray *perTesArray = @[@"补充信息",@"企业邮箱",@"企业经营地址  ",@"公司网站"];
            NSArray *perHolderArray = @[@"",@"请输入您的企业邮箱",@"请输入您的企业经营地址",@"请输入您的公司网站"];
            
            cell.leftdAgentContraints.constant = 110;
            cell.agentLabel.text = perTesArray[indexPath.row];
            cell.agentTextField.placeholder = perHolderArray[indexPath.row];
            
            if (indexPath.row == 0) {
                cell.agentTextField.userInteractionEnabled = NO;
                NSMutableAttributedString *ttt = [cell.agentLabel setAttributeString:@"|  补充信息  " withColor:kBlueColor andSecond:@"(选填)" withColor:kLightGrayColor withFont:12];
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
            
            return cell;
        }
        
        identifier = @"authenPer3";
        
        EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.leftTextViewConstraints.constant = 105;
        cell.ediLabel.text = @"经典案例";
        cell.ediTextView.placeholder = @"关于公司在融资等方面的成功案例，有利于发布方更加青睐你";
        cell.ediTextView.font = kFirstFont;
        cell.ediTextView.text = certificationModel.casedesc;
        
        QDFWeak(cell);
        [cell setDidEndEditing:^(NSString *text) {
            weakcell.ediTextView.text = text;
            [self.comDataDictionary setValue:text forKey:@"casedesc"];
        }];
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 25;
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
        UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
        headerView.textAlignment = NSTextAlignmentCenter;
        
        NSString *str1 = @"上传验证身份证件照或名片图片";
        NSString *str2 = @"（选填）";
        NSString *str3 = [NSString stringWithFormat:@"%@%@",str1,str2];
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str3];
        
        [attributeStr setAttributes:@{NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(0, str1.length)];
        [attributeStr setAttributes:@{NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(str1.length, str2.length)];
        
        [headerView setAttributedText:attributeStr];
        headerView.font = kSecondFont;
        return headerView;
    }
    return nil;
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
    
    self.comDataDictionary[@"name"] = self.comDataDictionary[@"name"]?self.comDataDictionary[@"name"]:self.responseModel.certification.name;
    self.comDataDictionary[@"cardno"] = self.comDataDictionary[@"cardno"]?self.comDataDictionary[@"cardno"]:self.responseModel.certification.cardno;
    self.comDataDictionary[@"contact"] = self.comDataDictionary[@"contact"]?self.comDataDictionary[@"contact"]:self.responseModel.certification.contact;
    self.comDataDictionary[@"address"] = self.comDataDictionary[@"address"]?self.comDataDictionary[@"address"]:self.responseModel.certification.address;
    self.comDataDictionary[@"enterprisewebsite"] = self.comDataDictionary[@"enterprisewebsite"]?self.comDataDictionary[@"enterprisewebsite"]:self.responseModel.certification.enterprisewebsite;
    self.comDataDictionary[@"mobile"] = self.comDataDictionary[@"mobile"]?self.comDataDictionary[@"mobile"]:self.responseModel.certification.mobile;
    self.comDataDictionary[@"email"] = self.comDataDictionary[@"email"]?self.comDataDictionary[@"email"]:self.responseModel.certification.email;
    self.comDataDictionary[@"casedesc"] = self.comDataDictionary[@"casedesc"]?self.comDataDictionary[@"casedesc"]:self.responseModel.certification.casedesc;
    [self.comDataDictionary setValue:@"3" forKey:@"category"];
    [self.comDataDictionary setValue:[self getValidateToken] forKey:@"token"];
    
    if ([self.typeAuthen integerValue] == 1) {
        [self.comDataDictionary setValue:@"update" forKey:@"type"];  //update为修改
    }else{
        [self.comDataDictionary setValue:@"add" forKey:@"type"];  //update为修改
    }
    
    NSDictionary *params = self.comDataDictionary;
//    NSString *cardimg = self.comDataDictionary[@"cardimg"][0]?self.comDataDictionary[@"cardimg"][0]:self.responseModel.certification.cardimg;
//    NSDictionary *imageParams = @{@"cardimg" : cardimg};
    
    [self requestDataPostWithString:comAuString params:params andImages:nil successBlock:^(id responseObject) {
        BaseModel *personModel = [BaseModel objectWithKeyValues:responseObject];
        [self showHint:personModel.msg];
        
        if ([personModel.code isEqualToString:@"0000"]) {
            UINavigationController *personNav = self.navigationController;
            [personNav popViewControllerAnimated:NO];
            [personNav popViewControllerAnimated:NO];
            
            CompleteViewController *completeVC = [[CompleteViewController alloc] init];
            completeVC.hidesBottomBarWhenPushed = YES;
            completeVC.categoryString = @"1";
            [personNav pushViewController:completeVC animated:NO];
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
