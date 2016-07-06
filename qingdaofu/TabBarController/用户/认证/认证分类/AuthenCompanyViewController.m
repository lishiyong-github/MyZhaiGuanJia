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
#import "ZYKeyboardUtil.h"

@interface AuthenCompanyViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *companyAuTableView;
@property (nonatomic,strong) BaseCommitButton *companyAuCommitButton;
@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;

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
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)configKeyBoardRespond {
    self.keyboardUtil = [[ZYKeyboardUtil alloc] init];
    
    #pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
    #pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
        QDFWeakSelf;
    [self.keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakself adaptiveView:weakself.companyAuTableView, nil];
    }];
    
#pragma explain - 自定义键盘弹出处理(如配置，全自动键盘处理则失效)
#pragma explain - use animateWhenKeyboardAppearAutomaticAnimBlock, animateWhenKeyboardAppearBlock must be nil.
    /*
     [_keyboardUtil setAnimateWhenKeyboardAppearBlock:^(int appearPostIndex, CGRect keyboardRect, CGFloat keyboardHeight, CGFloat keyboardHeightIncrement) {
     NSLog(@"\n\n键盘弹出来第 %d 次了~  高度比上一次增加了%0.f  当前高度是:%0.f"  , appearPostIndex, keyboardHeightIncrement, keyboardHeight);
     //do something
     }];
     */
    
#pragma explain - 自定义键盘收起处理(如不配置，则默认启动自动收起处理)
#pragma explain - if not configure this Block, automatically itself.
    /*
     [_keyboardUtil setAnimateWhenKeyboardDisappearBlock:^(CGFloat keyboardHeight) {
     NSLog(@"\n\n键盘在收起来~  上次高度为:+%f", keyboardHeight);
     //do something
     }];
     */
    
#pragma explain - 获取键盘信息
    [_keyboardUtil setPrintKeyboardInfoBlock:^(ZYKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo) {
        NSLog(@"\n\n拿到键盘信息 和 ZYKeyboardUtil对象");
    }];
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
                
                NSData *imgData = [NSData dataWithContentsOfFile:images[0]];
                NSString *imgStr = [NSString stringWithFormat:@"%@",imgData];
                [self.comDataDictionary setValue:imgStr forKey:@"cardimgs"];
                
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
        
        NSArray *perTextArray = @[@"|  基本信息",@"公司名称",@"营业执照号",@"联系人",@"联系方式"];
        NSArray *perPlacaTextArray = @[@"",@"请输入您的公司名称",@"请输入17位营业执照号",@"请输入您的姓名",@"请输入您常用的手机号码"];
        
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

//#pragma mark - 响应selector
/////键盘显示事件
//- (void) keyboardWillShow:(NSNotification *)notification {
//    //获取键盘高度，在不同设备上，以及中英文下是不同的
//    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    
//    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
//    CGFloat offset = (panelInputTextView.frame.origin.y+panelInputTextView.frame.size.height+INTERVAL_KEYBOARD) - (self.view.frame.size.height - kbHeight);
//    
//    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
//    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    
//    //将视图上移计算好的偏移
//    if(offset > 0) {
//        [UIView animateWithDuration:duration animations:^{
//            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
//        }];
//    }
//}
//
/////键盘消失事件
//- (void) keyboardWillHide:(NSNotification *)notify {
//    // 键盘动画时间
//    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    
//    //视图下沉恢复原状
//    [UIView animateWithDuration:duration animations:^{
//        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    }];
//}

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

    [self.comDataDictionary setValue:@"3" forKey:@"category"];
    [self.comDataDictionary setValue:[self getValidateToken] forKey:@"token"];
    
    if ([self.typeAuthen integerValue] == 1) {
        [self.comDataDictionary setValue:@"update" forKey:@"type"];  //update为修改
    }else{
        [self.comDataDictionary setValue:@"add" forKey:@"type"];  //update为修改
    }
    
    NSDictionary *params = self.comDataDictionary;
    
    [self requestDataPostWithString:comAuString params:params andImages:nil successBlock:^(id responseObject) {
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
