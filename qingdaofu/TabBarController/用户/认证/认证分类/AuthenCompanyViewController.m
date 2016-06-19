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
@property (nonatomic,strong) UIAlertController *alertController;

@property (nonatomic,strong) NSString *pictureString;
@property (nonatomic,strong) UIImage *pictureImage1;
@property (nonatomic,strong) UIImage *pictureImage2;

@property (nonatomic,strong) NSMutableDictionary *comDataDictionary;


@end

@implementation AuthenCompanyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"认证公司";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    self.pictureImage1 = [UIImage imageNamed:@"btn_camera"];
    self.pictureImage2  = [UIImage imageNamed:@"btn_camera"];
    
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
        
        QDFWeakSelf;
        [cell setDidSelectedItem:^(NSInteger itemTag) {
            
            if (itemTag == 0) {
                [weakself addImageWithMutipleChoise:YES andFinishBlock:^(NSArray *images) {
                    [weakself.comDataDictionary setValue:images forKey:@"cardimg"];
                }];
            }
        }];
        
        //        [cell.pictureButton1 setImage:self.pictureImage1 forState:0];
        //        [cell.pictureButton1 addTarget:self action:@selector(showAlertViewController) forControlEvents:UIControlEventTouchUpInside];
        //        QDFWeakSelf;
        //        [cell.pictureButton1 addAction:^(UIButton *btn) {
        //            self.pictureString = @"picture1";
        //            [weakself showAlertViewController];
        //        }];
        
        //        [cell.pictureButton2 setImage:self.pictureImage2 forState:0];
        //        [cell.pictureButton2 addAction:^(UIButton *btn) {
        //            self.pictureString = @"picture2";
        //            [weakself showAlertViewController];
        //        }];
        
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
    NSString *personAuString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kAuthenString];
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
    
    self.comDataDictionary[@"cardimg"] = self.comDataDictionary[@"cardimg"]?self.comDataDictionary[@"cardimg"]:self.responseModel.certification.cardimg;
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
    
    if (self.responseModel) {
        [self.comDataDictionary setValue:@"update" forKey:@"type"];  //update为修改
    }else{
        [self.comDataDictionary setValue:@"add" forKey:@"type"];  //update为修改
    }
    
    
    NSDictionary *params = self.comDataDictionary;
    
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
}


#pragma mark - alertView
- (UIAlertController *)alertController
{
    if (!_alertController) {
        _alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSUInteger sourceType = 0;
            sourceType = UIImagePickerControllerSourceTypeCamera;
            [self takePhotos:sourceType];
        }];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSUInteger sourceType = 0;
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self takePhotos:sourceType];
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [_alertController addAction:action0];
        [_alertController addAction:action1];
        [_alertController addAction:action2];
        
    }
    return _alertController;
}

- (void)showAlertViewController
{
    [self presentViewController:self.alertController animated:YES completion:nil];
}

- (void)takePhotos:(NSInteger)sourceType
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && sourceType == UIImagePickerControllerSourceTypeCamera) {
        NSLog(@"未发现照相机");
        return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    
    //保存图片至本地
    [self saveImage:image withName:@"user.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"user.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    if ([self.pictureString isEqualToString:@"picture1"]) {
        self.pictureImage1 = savedImage;
    }else{
        self.pictureImage2 = savedImage;
    }
    
    [self.companyAuTableView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    
    //获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    //将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    
    //保存到NSUserDefaults
    //    NSUserDefaults *userDefaults =
}


#pragma mark - method commit
- (void)commit
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"user.png"];
    
    if ([fileManager fileExistsAtPath:fullPath]) {
        
    }
}

/*
- (void)submit:(NSFileManager *)fileManager andPath:(NSString *)fullPath
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"text/html;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    UIImage *image = [UIImage imageWithContentsOfFile:fullPath];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    [manager POST:@"" parameters:[NSDictionary new] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if ([fileManager fileExistsAtPath:fullPath]) {
            [formData appendPartWithFileData:imageData name:@"userfiles[]" fileName:@"user.png" mimeType:@"image/x-png"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
*/

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
