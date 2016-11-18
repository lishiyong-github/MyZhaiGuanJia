//
//  PersonCerterViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PersonCerterViewController.h"
#import "NewMobileViewController.h"
#import "AuthentyViewController.h"  //认证
#import "CompleteViewController.h"  //显示认证信息

#import "MineUserCell.h"

#import "CompleteResponse.h"
#import "CertificationModel.h"

#import "UIButton+WebCache.h"
#import "UIViewController+MutipleImageChoice.h"

@interface PersonCerterViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *personCerterTableView;

//json
@property (nonatomic,strong) NSMutableArray *personCenterArray;
@property (nonatomic,strong) NSString *nicknameString;

@end

@implementation PersonCerterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.personCerterTableView];
    [self.view setNeedsUpdateConstraints];
    
    [self getMessageOfPerson];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.personCerterTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)personCerterTableView
{
    if (!_personCerterTableView) {
        _personCerterTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _personCerterTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _personCerterTableView.delegate = self;
        _personCerterTableView.dataSource = self;
        _personCerterTableView.tableFooterView = [[UIView alloc] init];
        _personCerterTableView.separatorColor = kSeparateColor;
        _personCerterTableView.backgroundColor = kBackColor;
    }
    return _personCerterTableView;
}

- (NSMutableArray *)personCenterArray
{
    if (!_personCenterArray) {
        _personCenterArray = [NSMutableArray array];
    }
    return _personCenterArray;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.personCenterArray.count > 0) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return kCellHeight3;//
    }
    return kCellHeight2;//
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    CompleteResponse *response = self.personCenterArray[0];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            identifier = @"person00";
            
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectedBackgroundView = [[UIView alloc] init];
            cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
            
            [cell.userNameButton setTitle:@"头像" forState:0];
            [cell.userActionButton sd_setImageWithURL:[NSURL URLWithString:response.pictureurl] forState:0 placeholderImage:nil];
            [cell.userActionButton autoSetDimensionsToSize:CGSizeMake(40, 40)];
            cell.userActionButton.layer.cornerRadius = 20;
            cell.userActionButton.layer.masksToBounds = YES;
            
            return cell;

        }else if (indexPath.row == 1){
            identifier = @"person01";
            
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectedBackgroundView = [[UIView alloc] init];
            cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
            cell.userNameButton.userInteractionEnabled = NO;
            cell.userActionButton.userInteractionEnabled = NO;
            
            [cell.userNameButton setTitle:@"昵称" forState:0];
            NSString *naam = [NSString getValidStringFromString:response.realname toString:response.username];
            [cell.userActionButton setTitle:naam forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            return cell;

        }else if (indexPath.row == 2){
            identifier = @"person0";
            
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectedBackgroundView = [[UIView alloc] init];
            cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
            cell.userNameButton.userInteractionEnabled = NO;
            cell.userActionButton.userInteractionEnabled = NO;
            
            [cell.userNameButton setTitle:@"手机号码" forState:0];
            [cell.userActionButton setTitle:response.mobile forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            
            return cell;
        }
    }
    identifier = @"person1";
    
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = kCellSelectedColor;
    cell.userNameButton.userInteractionEnabled = NO;
    cell.userActionButton.userInteractionEnabled = NO;
    
    [cell.userNameButton setTitle:@"实名认证" forState:0];
    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    if (response.certification) {
        if ([response.certification.category integerValue] == 1) {
            [cell.userActionButton setTitle:@"已认证个人" forState:0];
        }else if ([response.certification.category integerValue] == 2) {
            [cell.userActionButton setTitle:@"已认证律所" forState:0];
        }else if ([response.certification.category integerValue] == 3) {
            [cell.userActionButton setTitle:@"已认证公司" forState:0];
        }
    }else{
        [cell.userActionButton setTitle:@"未认证" forState:0];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger indexRow = 4*indexPath.section + indexPath.row;
    
    switch (indexRow) {
        case 0:{//头像
            QDFWeakSelf;
            [self addImageWithMaxSelection:1 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
                if (images.count > 0) {
                    [weakself changePicturesWithDataArray:images];
                }
            }];
        }
            break;
        case 1:{//昵称
            [self showNickAlert];
        }
            break;
        case 2:{//电话
            CompleteResponse *response = self.personCenterArray[0];
            NewMobileViewController *newMobileVC = [[NewMobileViewController alloc] init];
            newMobileVC.mobile = response.mobile;
            [self.navigationController pushViewController:newMobileVC animated:YES];
        }
            break;
        case 4:{//认证
            CompleteResponse *response = self.personCenterArray[0];
            if (response.certification) {
                CompleteViewController *completeVC = [[CompleteViewController alloc] init];
                [self.navigationController pushViewController:completeVC animated:YES];
            }else{
                AuthentyViewController *authentyVC = [[AuthentyViewController alloc] init];
                authentyVC.typeAuthty = @"1";
                [self.navigationController pushViewController:authentyVC animated:YES];
            }
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - method
- (void)getMessageOfPerson
{
    NSString *aoaoa = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPersonCenterMessagesString];
    NSDictionary *params = @{@"token" : [self getValidateToken]};
    
    QDFWeakSelf;
    [self requestDataPostWithString:aoaoa params:params successBlock:^(id responseObject) {
        
        [weakself.personCenterArray removeAllObjects];
        
        CompleteResponse *response = [CompleteResponse objectWithKeyValues:responseObject];
        [weakself.personCenterArray addObject:response];
        [weakself.personCerterTableView reloadData];
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)changeNickName//修改昵称
{
    [self.view endEditing:YES];
    
    NSString *changeNick = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPersonCerterOfChangeNickString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"nickname" : self.nicknameString
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:changeNick params:params successBlock:^(id responseObject) {
        
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself getMessageOfPerson];
        }
        
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)changePicturesWithDataArray:(NSArray *)dataArray
{
    NSString *changePicture = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPersonCenterMessagesStringOfChangePicture];
    
    NSData *imData = [NSData dataWithContentsOfFile:dataArray[0]];
    NSString *imString = [NSString stringWithFormat:@"%@",imData];
    
    NSDictionary *params = @{@"filetype" : @"1",
                             @"extension" : @"jpg",
                             @"picture" : imString,
                             @"token" : [self getValidateToken]
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:changePicture params:params successBlock:^(id responseObject) {
        ImageModel *imageModel = [ImageModel objectWithKeyValues:responseObject];
        [weakself showHint:imageModel.msg];
        
        if ([imageModel.code isEqualToString:@"0000"]) {
            [weakself getMessageOfPerson];
        }
        
    } andFailBlock:^(NSError *error) {
    }];
}

- (void)showNickAlert
{
    UIAlertController *nickAlert = [UIAlertController alertControllerWithTitle:@"修改昵称" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    QDFWeakSelf;
    [nickAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入新的昵称";
        textField.delegate = weakself;
    }];
    
    UIAlertAction *nickAct0 = [UIAlertAction actionWithTitle:@"取消" style:0 handler:nil];
    
    UIAlertAction *nickAct1 = [UIAlertAction actionWithTitle:@"确认" style:0 handler:^(UIAlertAction * _Nonnull action) {
        [weakself changeNickName];
    }];
    
    [nickAlert addAction:nickAct0];
    [nickAlert addAction:nickAct1];
    
    [self presentViewController:nickAlert animated:YES completion:nil];
}

#pragma mark - method
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.nicknameString = textField.text;
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
