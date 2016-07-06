//
//  AuthenPersonViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AuthenPersonViewController.h"
#import "CompleteViewController.h"   //认证成功

#import "TakePictureCell.h"
#import "EditDebtAddressCell.h"
#import "AgentCell.h"
#import "BaseCommitButton.h"

#import "UIViewController+MutipleImageChoice.h"

@interface AuthenPersonViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *personAuTableView;
@property (nonatomic,strong) BaseCommitButton *personAuCommitButton;

@property (nonatomic,strong) NSMutableDictionary *perDataDictionary;
@property (nonatomic,strong) NSMutableDictionary *perImageDictionary;
@property (nonatomic,strong) NSMutableArray *imageArray;

@end

@implementation AuthenPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"认证个人";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.personAuTableView];
    [self.view addSubview:self.personAuCommitButton];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.personAuTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.personAuTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.personAuCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.personAuCommitButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)personAuTableView
{
    if (!_personAuTableView) {
        _personAuTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _personAuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _personAuTableView.delegate = self;
        _personAuTableView.dataSource = self;
        _personAuTableView.tableFooterView = [[UIView alloc] init];
        _personAuTableView.separatorColor = kSeparateColor;
    }
    return _personAuTableView;
}

- (BaseCommitButton *)personAuCommitButton
{
    if (!_personAuCommitButton) {
        _personAuCommitButton = [BaseCommitButton newAutoLayoutView];
        [_personAuCommitButton setTitle:@"立即认证" forState:0];
        [_personAuCommitButton addTarget:self action:@selector(goToAuthenMessages) forControlEvents:UIControlEventTouchUpInside];

    }
    return _personAuCommitButton;
}

- (NSMutableDictionary *)perDataDictionary
{
    if (!_perDataDictionary) {
        _perDataDictionary = [NSMutableDictionary dictionary];
    }
    return _perDataDictionary;
}

- (NSMutableDictionary *)perImageDictionary
{
    if (!_perImageDictionary) {
        _perImageDictionary = [NSMutableDictionary dictionary];
    }
    return _perImageDictionary;
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
        return 4;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }else if (indexPath.section == 2){
        if (indexPath.row == 2) {
            return 70;
        }
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    CertificationModel *certificationModel = self.respnseModel.certification;
    
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
                NSData *imgData = [NSData dataWithContentsOfFile:images[0]];
                NSString *imgStr = [NSString stringWithFormat:@"%@",imgData];
                [self.perDataDictionary setValue:imgStr forKey:@"cardimgs"];
                weakcell.collectionDataList = [NSMutableArray arrayWithArray:images];
                [weakcell reloadData];
                
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
        
        NSArray *perTextArray = @[@"|  基本信息",@"姓名",@"身份证",@"联系方式"];
        NSArray *perPlacaTextArray = @[@"",@"请输入您的姓名",@"请输入您的身份证号码",@"请输入您常用的手机号码"];
        
        cell.leftdAgentContraints.constant = 100;
        cell.agentLabel.text = perTextArray[indexPath.row];
        cell.agentTextField.placeholder = perPlacaTextArray[indexPath.row];
        
        if (indexPath.row == 0) {
            cell.agentLabel.textColor = kBlueColor;
            cell.agentTextField.userInteractionEnabled = NO;
        }else if (indexPath.row == 1){
            cell.agentTextField.text = certificationModel.name;
            QDFWeak(cell);
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [self.perDataDictionary setValue:text forKey:@"name"];
            }];
        }else if (indexPath.row == 2){
            cell.agentTextField.text = certificationModel.cardno;
            QDFWeak(cell);
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [self.perDataDictionary setValue:text forKey:@"cardno"];
            }];
        }else if (indexPath.row == 3){
            cell.agentTextField.text = certificationModel.mobile?certificationModel.mobile:[self getValidateMobile];
            QDFWeak(cell);
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [self.perDataDictionary setValue:text forKey:@"mobile"];
            }];
        }
        
        return cell;
    }else{
    
        if (indexPath.row <2) {
            identifier = @"authenPer2";
            
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSArray *perTesArray = @[@"补充信息",@"邮箱"];
            NSArray *perHolderArray = @[@"",@"请输入您常用邮箱"];
            
            cell.leftdAgentContraints.constant = 100;
            cell.agentLabel.text = perTesArray[indexPath.row];
            cell.agentTextField.placeholder = perHolderArray[indexPath.row];
            
            if (indexPath.row == 0) {
                cell.agentTextField.userInteractionEnabled = NO;
                NSMutableAttributedString *ttt = [cell.agentLabel setAttributeString:@"|  补充信息  " withColor:kBlueColor andSecond:@"(选填)" withColor:kLightGrayColor withFont:12];
                [cell.agentLabel setAttributedText:ttt];
            }else{
                cell.agentTextField.text = certificationModel.email;
                QDFWeak(cell);
                [cell setDidEndEditing:^(NSString *text) {
                    weakcell.agentTextField.text = text;
                    [self.perDataDictionary setValue:text forKey:@"email"];
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
        cell.leftTextViewConstraints.constant = 95;
        cell.ediLabel.text = @"经典案例";
        cell.ediTextView.placeholder = @"关于个人在融资等方面的成功案例，有利于发布方更加青睐你";
        cell.ediTextView.text = certificationModel.casedesc;
        
        QDFWeak(cell);
        [cell setDidEndEditing:^(NSString *text) {
            weakcell.ediTextView.text = text;
            [self.perDataDictionary setValue:text forKey:@"casedesc"];
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
- (void)goToAuthenMessages
{
    [self.view endEditing:YES];
    NSString *personAuString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kAuthenString];
    
    if (!self.perDataDictionary[@"mobile"]) {
        self.perDataDictionary[@"mobile"] = self.respnseModel.certification.mobile?self.respnseModel.certification.mobile:[self getValidateMobile];
    }
    if (!self.perDataDictionary[@"cardimgs"]) {
        NSString *imgStr = self.respnseModel.certification.cardimg?self.respnseModel.certification.cardimg:@"";
        [self.perDataDictionary setValue:imgStr forKey:@"cardimg"];
    }
    
    self.perDataDictionary[@"name"] = self.perDataDictionary[@"name"]?self.perDataDictionary[@"name"]:self.respnseModel.certification.name;
    self.perDataDictionary[@"cardno"] = self.perDataDictionary[@"cardno"]?self.perDataDictionary[@"cardno"]:self.respnseModel.certification.cardno;
    self.perDataDictionary[@"email"] = self.perDataDictionary[@"email"]?self.perDataDictionary[@"email"]:self.respnseModel.certification.email;
    self.perDataDictionary[@"casedesc"] = self.perDataDictionary[@"casedesc"]?self.perDataDictionary[@"casedesc"]:self.respnseModel.certification.casedesc;
    
    [self.perDataDictionary setValue:@"1" forKey:@"category"];//认证类型
    [self.perDataDictionary setValue:[self getValidateToken] forKey:@"token"];
    
    if ([self.typeAuthen integerValue] == 1) {
        [self.perDataDictionary setValue:@"update" forKey:@"type"];  //update为修改
    }else{
        [self.perDataDictionary setValue:@"add" forKey:@"type"];  //add为 首次添加
    }
    
    NSString *completionRate = self.respnseModel.completionRate?self.respnseModel.completionRate:@"0";
    [self.perDataDictionary setValue:completionRate forKey:@"completionRate"];
    
    NSDictionary *params = self.perDataDictionary;
    
    
    [self requestDataPostWithString:personAuString params:params andImages:nil successBlock:^(id responseObject) {

        BaseModel *model = [BaseModel objectWithKeyValues:responseObject];
        [self showHint:model.msg];
        
        if ([model.code isEqualToString:@"0000"]) {
            UINavigationController *nav = self.navigationController;
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
            [nav popToRootViewControllerAnimated:NO];
            CompleteViewController *completeVC = [[CompleteViewController alloc] init];
            completeVC.categoryString = self.categoryString;
            completeVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:completeVC animated:NO];
        }
        
    } andFailBlock:^(NSError *error) {
        NSLog(@"****** %@",error);
    }];
    
    /*
    [self requestDataPostWithString:personAuString params:params successBlock:^(id responseObject){
        
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
        
    } andFailBlock:^(NSError *error){
        
    }];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
