//
//  AuthenLawViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/31.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AuthenLawViewController.h"

#import "AuthentyWaitingViewController.h"   //认证成功

#import "TakePictureCell.h"
#import "EditDebtAddressCell.h"
#import "AgentCell.h"
#import "BaseCommitView.h"
#import "PersonCell.h"

#import "UIViewController+MutipleImageChoice.h"

@interface AuthenLawViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *lawAuTableView;
@property (nonatomic,strong) BaseCommitView *lawAuCommitButton;
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
    
    [self addKeyboardObserver];
}

- (void)dealloc
{
    [self removeKeyboardObserver];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.lawAuTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.lawAuTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.lawAuCommitButton];
        
        [self.lawAuCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.lawAuCommitButton autoSetDimension:ALDimensionHeight toSize:kCellHeight1];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)lawAuTableView
{
    if (!_lawAuTableView) {
        _lawAuTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _lawAuTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _lawAuTableView.delegate = self;
        _lawAuTableView.dataSource = self;
        _lawAuTableView.tableFooterView = [[UIView alloc] init];
        _lawAuTableView.separatorColor = kSeparateColor;
    }
    return _lawAuTableView;
}

- (BaseCommitView *)lawAuCommitButton
{
    if (!_lawAuCommitButton) {
        _lawAuCommitButton = [BaseCommitView newAutoLayoutView];
        [_lawAuCommitButton.button setTitle:@"提交资料" forState:0];
        [_lawAuCommitButton.button addTarget:self action:@selector(goToAuthenLawMessages) forControlEvents:UIControlEventTouchUpInside];
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
        return 105 + kBigPadding*2;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    CertificationModel *certificationModel = self.responseModel.certification;
    
    QDFWeakSelf;
    if (indexPath.section == 0) {
        identifier = @"authenLaw0";
        PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.pictureButton1 setImage:[UIImage imageNamed:@"upload_positive_image"] forState:0];
        [cell.pictureButton2 setImage:[UIImage imageNamed:@"upload_opposite_image"] forState:0];
        
        [cell.pictureButton1 addAction:^(UIButton *btn) {//正面照
            [weakself addImageWithMaxSelection:1 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
                NSData *imgData = [NSData dataWithContentsOfFile:images[0]];
                NSString *imgStr = [NSString stringWithFormat:@"%@",imgData];
                
                //                [self.perDataDictionary setValue:imgStr forKey:@"cardimgs"];
                
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
        identifier = @"authenLaw1";
        QDFWeakSelf;
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTouchBeginPoint:^(CGPoint point) {
            weakself.touchPoint = point;
        }];
        NSArray *perTextArray = @[@"|  基本信息",@"律所名称",@"执业证号",@"联系人",@"联系方式"];
        NSArray *perPlacaTextArray = @[@"",@"请输入您的律所名称",@"请输入17位执业证号",@"请输入联系人姓名",@"请输入您常用的手机号码"];
        
        cell.agentLabel.text = perTextArray[indexPath.row];
        cell.agentTextField.placeholder = perPlacaTextArray[indexPath.row];
        
        QDFWeak(cell);
        if (indexPath.row == 0) {
            cell.agentLabel.textColor = kBlueColor;
            cell.agentTextField.userInteractionEnabled = NO;
        }else if (indexPath.row == 1){//律所名称
            cell.agentTextField.text = certificationModel.name;
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [weakself.lawDataDictionary setValue:text forKey:@"name"];
            }];
        }else if (indexPath.row == 2){//执业证号
            cell.agentTextField.text = certificationModel.cardno;
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [weakself.lawDataDictionary setValue:text forKey:@"cardno"];
            }];
        }else if (indexPath.row == 3){//联系人
            cell.agentTextField.text = certificationModel.contact;
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [weakself.lawDataDictionary setValue:text forKey:@"contact"];
            }];
        }else{//联系方式
            cell.agentTextField.text = certificationModel.mobile?certificationModel.mobile:[self getValidateMobile];
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [weakself.lawDataDictionary setValue:text forKey:@"mobile"];
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
           
            QDFWeakSelf;
            [cell setTouchBeginPoint:^(CGPoint point) {
                weakself.touchPoint = point;
            }];
            NSArray *perTesArray = @[@"补充信息",@"邮箱"];
            NSArray *perHolderArray = @[@"",@"请输入您常用邮箱"];
            
            cell.agentLabel.text = perTesArray[indexPath.row];
            cell.agentTextField.placeholder = perHolderArray[indexPath.row];
            
            QDFWeak(cell);
            if (indexPath.row == 0) {
                cell.agentTextField.userInteractionEnabled = NO;
                NSMutableAttributedString *ttt = [cell.agentLabel setAttributeString:@"|  补充信息  " withColor:kBlueColor andSecond:@"(选填)" withColor:kGrayColor withFont:12];
                [cell.agentLabel setAttributedText:ttt];
            }else { //邮箱
                cell.agentTextField.text = certificationModel.email;
                [cell setDidEndEditing:^(NSString *text) {
                    weakcell.agentTextField.text = text;
                    [weakself.lawDataDictionary setValue:text forKey:@"email"];
                }];
            }
            return cell;
        }
        
        identifier = @"authenLaw3";
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.agentTextField.userInteractionEnabled = NO;
        cell.agentButton.userInteractionEnabled = NO;
        cell.agentLabel.text = @"经典案例";
        cell.agentTextField.placeholder = @"请输入诉讼、清收等成功案例";
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        
        return cell;
        
        /*
        identifier = @"authenLaw3";
        QDFWeakSelf;
        EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.leftTextViewConstraints.constant = 105;
        cell.ediLabel.text = @"经典案例";
        cell.ediTextView.placeholder = @"关于律所在清收等方面的成功案例，有利于发布方更加青睐你";
        cell.ediTextView.font = kFirstFont;
        cell.ediTextView.text = certificationModel.casedesc;
        [cell setTouchBeginPoint:^(CGPoint point) {
            weakself.touchPoint = point;
        }];
        QDFWeak(cell);
        [cell setDidEndEditing:^(NSString *text) {
            weakcell.ediTextView.text = text;
            [weakself.lawDataDictionary setValue:text forKey:@"casedesc"];
        }];

        return cell;
         */
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
    if (section == 2) {
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
        headerView.text = @"请上传律所执业图片";
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
    if (indexPath.section == 2 || indexPath.row == 2) {
        NSLog(@"经典案例");
        [self showHint:@"经典案例"];
    }
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
    self.lawDataDictionary[@"email"] = self.lawDataDictionary[@"email"]?self.lawDataDictionary[@"email"]:self.responseModel.certification.email;
    self.lawDataDictionary[@"casedesc"] = self.lawDataDictionary[@"casedesc"]?self.lawDataDictionary[@"casedesc"]:self.responseModel.certification.casedesc;
    
    self.lawDataDictionary[@"completionRate"] = self.responseModel.completionRate?self.responseModel.completionRate:@"";
    [self.lawDataDictionary setValue:@"2" forKey:@"category"];
    [self.lawDataDictionary setValue:[self getValidateToken] forKey:@"token"];
    
    if ([self.typeAuthen integerValue] == 1) {
        [self.lawDataDictionary setValue:@"update" forKey:@"type"];  //update为更新
    }else{
        [self.lawDataDictionary setValue:@"add" forKey:@"type"];  //add为修改
    }
    
    NSDictionary *params = self.lawDataDictionary;
    
    QDFWeakSelf;
     [self requestDataPostWithString:lawAuString params:params successBlock:^(id responseObject) {
        
        BaseModel *personModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:personModel.msg];
        
        if ([personModel.code isEqualToString:@"0000"]) {
            UINavigationController *lawNav = weakself.navigationController;
            [lawNav popViewControllerAnimated:NO];
            [lawNav popViewControllerAnimated:NO];
            [lawNav popViewControllerAnimated:NO];
            
            AuthentyWaitingViewController *waitingVC = [[AuthentyWaitingViewController alloc] init];
            waitingVC.categoryString = weakself.categoryString;
            waitingVC.hidesBottomBarWhenPushed = YES;
            [lawNav pushViewController:waitingVC animated:NO];
        }

    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)back
{
    if (!self.responseModel && !self.lawDataDictionary) {

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
