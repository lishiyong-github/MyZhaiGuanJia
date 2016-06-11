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

@interface AuthenPersonViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *personAuTableView;
@property (nonatomic,strong) BaseCommitButton *personAuCommitButton;
@property (nonatomic,strong) UIAlertController *alertController;

@property (nonatomic,assign) NSInteger *pictureInt;

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
        
        QDFWeakSelf;
        [_personAuCommitButton addAction:^(UIButton *btn) {
            
            NSString *personAuString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kAuthenString];
            NSDictionary *params = @{@"category" : @"1",
                                     @"name" : @"米月虹",
                                     @"cardno" : @"420621199109095462",   //证件号
                                     @"mobile" : @"13162521916",
                                     @"email" : @"",    //邮箱
                                     @"casedesc" : @"个人案例个人案例个人案例",  //案例
                                     @"type" : @"add",
                                     @"token" : [weakself getValidateToken]
                                     };
            
            [weakself requestDataPostWithString:personAuString params:params successBlock:^(id responseObject){

                BaseModel *personModel = [BaseModel objectWithKeyValues:responseObject];
                
                [weakself showHint:personModel.msg];
                
                if ([personModel.code isEqualToString:@"0000"]) {
                    UINavigationController *personNav = weakself.navigationController;
                    [personNav popViewControllerAnimated:NO];
                    [personNav popViewControllerAnimated:NO];
                    
                    CompleteViewController *completeVC = [[CompleteViewController alloc] init];
                    completeVC.hidesBottomBarWhenPushed = YES;
                    [personNav pushViewController:completeVC animated:NO];
                }
                
            } andFailBlock:^(NSError *error){
                
            }];
            
        }];
    }
    return _personAuCommitButton;
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
    
    if (indexPath.section == 0) {
        identifier = @"authenPer0";
        TakePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[TakePictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setDidSelectedItem:^(NSInteger itemTag) {
            [self presentViewController:self.alertController animated:YES completion:nil];
            _pictureInt = itemTag;
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
            cell.agentTextField.text = self.cerModel.name;
        }else if (indexPath.row == 2){
            cell.agentTextField.text = self.cerModel.cardno;
        }else if (indexPath.row == 3){
            cell.agentTextField.text = self.cerModel.mobile;
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
                cell.agentTextField.text = self.cerModel.email;
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
        cell.ediTextView.text = self.cerModel.casedesc;
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
    
    TakePictureCell *cell = [self.personAuTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    [cell.collectionDataList replaceObjectAtIndex:(NSUInteger)_pictureInt withObject:savedImage];
    [cell reloadData];
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
