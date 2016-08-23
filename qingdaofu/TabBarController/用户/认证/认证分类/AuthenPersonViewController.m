//
//  AuthenPersonViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AuthenPersonViewController.h"
#import "AuthentyWaitingViewController.h"   //认证成功


#import "TakePictureCell.h"
#import "AgentCell.h"
#import "PersonCell.h"
#import "BaseCommitView.h"
#import "UIViewController+MutipleImageChoice.h"

@interface AuthenPersonViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *personAuTableView;
@property (nonatomic,strong) BaseCommitView *personAuCommitButton;

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
    
    [self addKeyboardObserver];
}

- (void)dealloc
{
    [self removeKeyboardObserver];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.personAuTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.personAuTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.personAuCommitButton];
        
        [self.personAuCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.personAuCommitButton autoSetDimension:ALDimensionHeight toSize:kCellHeight1];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)personAuTableView
{
    if (!_personAuTableView) {
        _personAuTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _personAuTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _personAuTableView.delegate = self;
        _personAuTableView.dataSource = self;
        _personAuTableView.tableFooterView = [[UIView alloc] init];
        _personAuTableView.separatorColor = kSeparateColor;
    }
    return _personAuTableView;
}

- (BaseCommitView *)personAuCommitButton
{
    if (!_personAuCommitButton) {
        _personAuCommitButton = [BaseCommitView newAutoLayoutView];
        [_personAuCommitButton.button setTitle:@"提交资料" forState:0];
        [_personAuCommitButton.button addTarget:self action:@selector(goToAuthenMessages) forControlEvents:UIControlEventTouchUpInside];
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
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 105 + kBigPadding*2;
        
    }
//    else if (indexPath.section == 2){
//        if (indexPath.row == 2) {
//            return 70;
//        }
//    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    CertificationModel *certificationModel = self.respnseModel.certification;
    QDFWeakSelf;
    if (indexPath.section == 0) {
        
        identifier = @"authenPer0";
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
        /*
        identifier = @"authenPer0";
        TakePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[TakePictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([certificationModel.cardimg isEqualToString:@""] || !certificationModel.cardimg) {
            cell.collectionDataList = [NSMutableArray arrayWithObjects:@"btn_camera", nil];
        }else{
            NSString *subString = [certificationModel.cardimg substringWithRange:NSMakeRange(1, certificationModel.cardimg.length-2)];
            NSString *urlString = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,subString];
            NSURL *url = [NSURL URLWithString:urlString];
            cell.collectionDataList = [NSMutableArray arrayWithObject:url];
        }
        
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
         */
        
    }else if (indexPath.section == 1){
        identifier = @"authenPer1";
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTouchBeginPoint:^(CGPoint point) {
            weakself.touchPoint = point;
        }];
        
        NSArray *perTextArray = @[@"|  基本信息",@"姓名",@"身份证",@"手机号码"];
        NSArray *perPlacaTextArray = @[@"",@"请输入您的姓名",@"请输入您的身份证号码",@"请输入您的手机号码"];
        
        cell.agentLabel.text = perTextArray[indexPath.row];
        cell.agentTextField.placeholder = perPlacaTextArray[indexPath.row];
        
        QDFWeak(cell);
        if (indexPath.row == 0) {
            cell.agentLabel.textColor = kBlueColor;
            cell.agentTextField.userInteractionEnabled = NO;
        }else if (indexPath.row == 1){
            cell.agentTextField.text = certificationModel.name;
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [weakself.perDataDictionary setValue:text forKey:@"name"];
            }];
        }else if (indexPath.row == 2){
            cell.agentTextField.text = certificationModel.cardno;
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [weakself.perDataDictionary setValue:text forKey:@"cardno"];
            }];
        }else if (indexPath.row == 3){
            cell.agentTextField.text = certificationModel.mobile?certificationModel.mobile:[weakself getValidateMobile];
            [cell setDidEndEditing:^(NSString *text) {
                weakcell.agentTextField.text = text;
                [weakself.perDataDictionary setValue:text forKey:@"mobile"];
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
            [cell setTouchBeginPoint:^(CGPoint point) {
                weakself.touchPoint = point;
            }];
            
            NSArray *perTesArray = @[@"补充信息",@"邮箱"];
            NSArray *perHolderArray = @[@"",@"请输入您常用邮箱"];
            
            cell.agentLabel.text = perTesArray[indexPath.row];
            cell.agentTextField.placeholder = perHolderArray[indexPath.row];
            
            if (indexPath.row == 0) {
                cell.agentTextField.userInteractionEnabled = NO;
                NSMutableAttributedString *ttt = [cell.agentLabel setAttributeString:@"|  补充信息  " withColor:kBlueColor andSecond:@"(选填)" withColor:kGrayColor withFont:12];
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
        
//        identifier = @"authenPer3";
//        
//        EditDebtAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        
//        if (!cell) {
//            cell = [[EditDebtAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.leftTextViewConstraints.constant = 105;
//        cell.ediLabel.text = @"经典案例";
//        cell.ediTextView.placeholder = @"关于个人在融资等方面的成功案例，有利于发布方更加青睐你";
//        cell.ediTextView.text = certificationModel.casedesc;
//        [cell setTouchBeginPoint:^(CGPoint point) {
//            weakself.touchPoint = point;
//        }];
//        
//        QDFWeak(cell);
//        [cell setDidEndEditing:^(NSString *text) {
//            weakcell.ediTextView.text = text;
//            [weakself.perDataDictionary setValue:text forKey:@"casedesc"];
//        }];
//        
//        return cell;
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
        headerView.text = @"请上传一张【工牌或名片或身份证】等证明身份的图片";
        headerView.font = kSecondFont;
        headerView.textColor = kGrayColor;
        
//        NSString *str1 = @"请上传一张[工牌或名片或身份证]等证明身份的图片";
//        NSString *str2 = @"（选填）";
//        NSString *str3 = [NSString stringWithFormat:@"%@%@",str1,str2];
//        
//        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str3];
//        
//        [attributeStr setAttributes:@{NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(0, str1.length)];
//        [attributeStr setAttributes:@{NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(str1.length, str2.length)];
//        
//        [headerView setAttributedText:attributeStr];
//        headerView.font = kSecondFont;
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
    
    self.perDataDictionary[@"completionRate"] = self.respnseModel.completionRate?self.respnseModel.completionRate:@"";
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
    
    QDFWeakSelf;
    [self requestDataPostWithString:personAuString params:params successBlock:^(id responseObject) {

        BaseModel *model = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:model.msg];
        
        if ([model.code isEqualToString:@"0000"]) {
            UINavigationController *nav = weakself.navigationController;
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
            [nav popViewControllerAnimated:NO];
            
            AuthentyWaitingViewController *waitingVC = [[AuthentyWaitingViewController alloc] init];
            waitingVC.categoryString = weakself.categoryString;
            waitingVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:waitingVC animated:NO];
        }
        
    } andFailBlock:^(NSError *error) {
    
    }];
}

- (void)back
{
    if (!self.respnseModel && !self.perDataDictionary) {
        
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
