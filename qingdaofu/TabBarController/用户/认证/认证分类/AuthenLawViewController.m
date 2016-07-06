//
//  AuthenLawViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/31.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AuthenLawViewController.h"

#import "CompleteViewController.h"   //认证成功

#import "TakePictureCell.h"
#import "EditDebtAddressCell.h"
#import "AgentCell.h"
#import "BaseCommitButton.h"

#import "UIViewController+MutipleImageChoice.h"

@interface AuthenLawViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *lawAuTableView;
@property (nonatomic,strong) BaseCommitButton *lawAuCommitButton;
@property (nonatomic,strong) UIAlertController *alertController;

@property (nonatomic,strong) NSString *pictureString;
@property (nonatomic,strong) UIImage *pictureImage1;
@property (nonatomic,strong) UIImage *pictureImage2;

@property (nonatomic,strong) NSMutableDictionary *lawDataDictionary;

@end

@implementation AuthenLawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"认证律所";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    self.pictureImage1 = [UIImage imageNamed:@"btn_camera"];
    self.pictureImage2  = [UIImage imageNamed:@"btn_camera"];
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.lawAuTableView];
    [self.view addSubview:self.lawAuCommitButton];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.lawAuTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.lawAuTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.lawAuCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.lawAuCommitButton autoSetDimension:ALDimensionHeight toSize:kTabBarHeight];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)lawAuTableView
{
    if (!_lawAuTableView) {
//        _lawAuTableView = [UITableView newAutoLayoutView];
        _lawAuTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _lawAuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _lawAuTableView.delegate = self;
        _lawAuTableView.dataSource = self;
        _lawAuTableView.tableFooterView = [[UIView alloc] init];
        _lawAuTableView.separatorColor = kSeparateColor;
    }
    return _lawAuTableView;
}

- (BaseCommitButton *)lawAuCommitButton
{
    if (!_lawAuCommitButton) {
        _lawAuCommitButton = [BaseCommitButton newAutoLayoutView];
        [_lawAuCommitButton setTitle:@"立即认证" forState:0];
        [_lawAuCommitButton addTarget:self action:@selector(goToAuthenLawMessages) forControlEvents:UIControlEventTouchUpInside];
        
//        QDFWeakSelf;
//        [_lawAuCommitButton addAction:^(UIButton *btn) {
//            
//            NSString *lawAuString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kAuthenString];
//            NSDictionary *params = @{@"category" : @"2",
//                                     @"name" : @"上海律所", //律所名称
//                                     @"cardno" : @"8888888888888",   //执业证号
//                                     @"contact" : @"律所律所",    //联系人
//                                     @"mobile" : @"13052358968",  //联系方式
//                                     @"email" : @"1234678@qq.com",    //邮箱
//                                     @"casedesc" : @"",  //案例
//                                     @"cardimg" : @"",  //证件图片
//                                     @"type" : @"update",  //add=>’添加认证’。update=>’修改认证’。
//                                     @"token" : [weakself getValidateToken]
//                                     };
//            
//            [weakself requestDataPostWithString:lawAuString params:params successBlock:^(id responseObject){
//                BaseModel *updateModel = [BaseModel objectWithKeyValues:responseObject];
//                [weakself showHint:updateModel.msg];
//                
//                if ([updateModel.code intValue] == 0000) {
//                    UINavigationController *lawNav = weakself.navigationController;
//                    [lawNav popViewControllerAnimated:NO];
//                    [lawNav popViewControllerAnimated:NO];
//                    
//                    CompleteViewController *completeVC = [[CompleteViewController alloc] init];
//                    completeVC.hidesBottomBarWhenPushed = YES;
//                    [lawNav pushViewController:completeVC animated:NO];
//                }
//                
//            } andFailBlock:^(NSError *error){
//                
//            }];
//        }];
    }
    return _lawAuCommitButton;
}

- (NSMutableDictionary *)lawDataDictionary
{
    if (!_lawDataDictionary) {
        _lawDataDictionary = [NSMutableDictionary dictionary];
    }
    return _lawDataDictionary;
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
    
    CertificationModel *certificationModel = self.responseModel.certification;
    
    if (indexPath.section == 0) {
        identifier = @"authenLaw0";
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
               
        QDFWeak(cell);
        QDFWeakSelf;
        [cell setDidSelectedItem:^(NSInteger item) {
            [weakself addImageWithMaxSelection:1 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
                
                NSData *imgData = [NSData dataWithContentsOfFile:images[0]];
                NSString *imgStr = [NSString stringWithFormat:@"%@",imgData];
                [self.lawDataDictionary setValue:imgStr forKey:@"cardimgs"];
                
                weakcell.collectionDataList = [NSMutableArray arrayWithArray:images];
                [weakcell reloadData];
                
                
            }];
        }];
        
        return cell;
        
    }else if (indexPath.section == 1){
        identifier = @"authenLaw1";
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *perTextArray = @[@"|  基本信息",@"律所名称",@"执业证号",@"联系人",@"联系方式"];
        NSArray *perPlacaTextArray = @[@"",@"请输入您的律所名称",@"请输入17位执业证号",@"请输入联系人姓名",@"请输入您常用的手机号码"];
        
        cell.leftdAgentContraints.constant = 100;
        cell.agentLabel.text = perTextArray[indexPath.row];
        cell.agentTextField.placeholder = perPlacaTextArray[indexPath.row];
        
        if (indexPath.row == 0) {
            cell.agentLabel.textColor = kBlueColor;
            cell.agentTextField.userInteractionEnabled = NO;
        }else if (indexPath.row == 1){//律所名称
            cell.agentTextField.text = certificationModel.name;
            QDFWeak(cell);
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [self.lawDataDictionary setValue:text forKey:@"name"];
            }];
        }else if (indexPath.row == 2){//执业证号
            cell.agentTextField.text = certificationModel.cardno;
            QDFWeak(cell);
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [self.lawDataDictionary setValue:text forKey:@"cardno"];
            }];
        }else if (indexPath.row == 3){//联系人
            cell.agentTextField.text = certificationModel.contact;
            QDFWeak(cell);
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [self.lawDataDictionary setValue:text forKey:@"contact"];
            }];
        }else{//联系方式
            cell.agentTextField.text = certificationModel.mobile;
            QDFWeak(cell);
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [self.lawDataDictionary setValue:text forKey:@"mobile"];
            }];
        }
        
        return cell;
    }else{
        
        if (indexPath.row <2) {
            identifier = @"authenLaw2";
            
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
            }else { //邮箱
                cell.agentTextField.text = certificationModel.email;
                QDFWeak(cell);
                [cell setDidEndEditing:^(NSString *text) {
                    weakcell.agentTextField.text = text;
                    [self.lawDataDictionary setValue:text forKey:@"email"];
                }];
            }
            return cell;
        }
        
        identifier = @"authenLaw3";
        
        EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.leftTextViewConstraints.constant = 95;
        cell.ediLabel.text = @"经典案例";
        cell.ediTextView.placeholder = @"关于律所在融资等方面的成功案例，有利于发布方更加青睐你";
        cell.ediTextView.font = kFirstFont;
        cell.ediTextView.text = certificationModel.casedesc;
        
        QDFWeak(cell);
        [cell setDidEndEditing:^(NSString *text) {
            weakcell.ediTextView.text = text;
            [self.lawDataDictionary setValue:text forKey:@"casedesc"];
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
        NSString *str2 = @"（必填）";
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
- (void)goToAuthenLawMessages
{
    [self.view endEditing:YES];
    NSString *lawAuString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kAuthenString];
    /*
     @"category" : @"2",
     @"name" : @"上海律所", //律所名称
     @"cardno" : @"8888888888888",   //执业证号
     @"contact" : @"律所律所",    //联系人
     @"mobile" : @"13052358968",  //联系方式
     @"email" : @"1234678@qq.com",    //邮箱
     @"casedesc" : @"",  //案例
     @"cardimg" : @"",  //证件图片
     @"type" : @"update",  //add=>’添加认证’。update=>’修改认证’。
     @"token" : [weakself getValidateToken]
     */
    
    if (!self.lawDataDictionary[@"mobile"]) {
        self.lawDataDictionary[@"mobile"] = self.responseModel.certification.mobile?self.responseModel.certification.mobile:[self getValidateMobile];
    }
    if (!self.lawDataDictionary[@"cardimgs"]) {
        NSString *imgStr = self.responseModel.certification.cardimg?self.responseModel.certification.cardimg:@"";
        [self.lawDataDictionary setValue:imgStr forKey:@"cardimg"];
    }
    
    self.lawDataDictionary[@"name"] = self.lawDataDictionary[@"name"]?self.lawDataDictionary[@"name"]:self.responseModel.certification.name;
    self.lawDataDictionary[@"cardno"] = self.lawDataDictionary[@"cardno"]?self.lawDataDictionary[@"cardno"]:self.responseModel.certification.cardno;
    self.lawDataDictionary[@"contact"] = self.lawDataDictionary[@"contact"]?self.lawDataDictionary[@"contact"]:self.responseModel.certification.contact;
//    self.lawDataDictionary[@"mobile"] = self.lawDataDictionary[@"mobile"]?self.lawDataDictionary[@"mobile"]:self.responseModel.certification.mobile;
    self.lawDataDictionary[@"email"] = self.lawDataDictionary[@"email"]?self.lawDataDictionary[@"email"]:self.responseModel.certification.email;
    self.lawDataDictionary[@"casedesc"] = self.lawDataDictionary[@"casedesc"]?self.lawDataDictionary[@"casedesc"]:self.responseModel.certification.casedesc;
    [self.lawDataDictionary setValue:@"2" forKey:@"category"];
    [self.lawDataDictionary setValue:[self getValidateToken] forKey:@"token"];
    
    if ([self.typeAuthen integerValue] == 1) {
        [self.lawDataDictionary setValue:@"update" forKey:@"type"];  //update为更新
    }else{
        [self.lawDataDictionary setValue:@"add" forKey:@"type"];  //add为修改
    }
    
    NSDictionary *params = self.lawDataDictionary;
    
    [self requestDataPostWithString:lawAuString params:params andImages:nil successBlock:^(id responseObject) {
        
        BaseModel *personModel = [BaseModel objectWithKeyValues:responseObject];
        [self showHint:personModel.msg];
        
        if ([personModel.code isEqualToString:@"0000"]) {
            UINavigationController *personNav = self.navigationController;
            [personNav popViewControllerAnimated:NO];
            [personNav popViewControllerAnimated:NO];
            [personNav popViewControllerAnimated:NO];
            
            CompleteViewController *completeVC = [[CompleteViewController alloc] init];
            completeVC.hidesBottomBarWhenPushed = YES;
            completeVC.categoryString = self.categoryString;
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
