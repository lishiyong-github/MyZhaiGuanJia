//
//  PowerDetailsViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PowerDetailsViewController.h"

#import "PowerProtectViewController.h"  //申请保全
#import "PowerProtectPictureViewController.h"
#import "UIViewController+ImageBrowser.h"

#import "MessageCell.h"
#import "MineUserCell.h"
#import "PowerDetailsCell.h"

#import "ImageModel.h"
#import "PowerDetailModel.h"

@interface PowerDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *powerDetailsTableView;
@property (nonatomic,strong) NSMutableArray *powerDetalArray;
@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation PowerDetailsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self getDetailsOfPower];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"保全详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.powerDetailsTableView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.powerDetailsTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - setter and getter
- (UITableView *)powerDetailsTableView
{
    if (!_powerDetailsTableView) {
        _powerDetailsTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _powerDetailsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _powerDetailsTableView.delegate = self;
        _powerDetailsTableView.dataSource = self;
        _powerDetailsTableView.separatorColor = kSeparateColor;
        _powerDetailsTableView.backgroundColor = kBackColor;
    }
    return _powerDetailsTableView;
}

- (NSMutableArray *)powerDetalArray
{
    if (!_powerDetalArray) {
        _powerDetalArray = [NSMutableArray array];
    }
    return _powerDetalArray;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 7;
    }else if (section == 2){
        return 5;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 140;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    PowerModel *powerModel;
    if (self.powerDetalArray.count > 0) {
        powerModel = self.powerDetalArray[0];
    }
    
    if (indexPath.section == 0) {//保权进度
        identifier = @"power00";
        PowerDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PowerDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kBlueColor;
        cell.progress3.text = @"保全已出";//my_preservation@2x
        
        [cell.button1 setImage:[UIImage imageNamed:@"my_preservation"] forState:0];
        NSString *str1 = @"保全进度";
        NSString *str2 = @"本平台承诺对您的案件资料和隐私严格保密！";
        NSString *str = [NSString stringWithFormat:@"%@\n%@",str1,str2];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeStr setAttributes:@{NSForegroundColorAttributeName:kBlackColor,NSFontAttributeName:kBigFont} range:NSMakeRange(0, str1.length)];
        [attributeStr setAttributes:@{NSForegroundColorAttributeName:kLightGrayColor,NSFontAttributeName:kSmallFont} range:NSMakeRange(str1.length+1, str2.length)];
        
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:3];
        [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];
        
        [cell.button1 setAttributedTitle:attributeStr forState:0];
        
        if ([powerModel.status integerValue] == 1) {//未审核
            
        }else if ([powerModel.status integerValue] == 10){//审核成功
            cell.progress1.textColor = kBlueColor;
            [cell.point1 setImage:[UIImage imageNamed:@"progress_point_s"] forState:0];
        }else if ([powerModel.status integerValue] == 20){//签订协议
            cell.progress1.textColor = kBlueColor;
            [cell.point1 setImage:[UIImage imageNamed:@"progress_point_s"] forState:0];
            [cell.line1 setBackgroundColor:kBlueColor];
            cell.progress2.textColor = kBlueColor;
            [cell.point2 setImage:[UIImage imageNamed:@"progress_point_s"] forState:0];
        }else if ([powerModel.status integerValue] == 30){//已出保函
            cell.progress1.textColor = kBlueColor;
            [cell.point1 setImage:[UIImage imageNamed:@"progress_point_s"] forState:0];
            [cell.line1 setBackgroundColor:kBlueColor];
            cell.progress2.textColor = kBlueColor;
            [cell.point2 setImage:[UIImage imageNamed:@"progress_point_s"] forState:0];
            [cell.line2 setBackgroundColor:kBlueColor];
            cell.progress3.textColor = kBlueColor;
            [cell.point3 setImage:[UIImage imageNamed:@"progress_point_s"] forState:0];
        }else if ([powerModel.status integerValue] == 40){//完成
            cell.progress1.textColor = kBlueColor;
            [cell.point1 setImage:[UIImage imageNamed:@"progress_point_s"] forState:0];
            [cell.line1 setBackgroundColor:kBlueColor];
            cell.progress2.textColor = kBlueColor;
            [cell.point2 setImage:[UIImage imageNamed:@"progress_point_s"] forState:0];
            [cell.line2 setBackgroundColor:kBlueColor];
            cell.progress3.textColor = kBlueColor;
            [cell.point3 setImage:[UIImage imageNamed:@"progress_point_s"] forState:0];
            [cell.line3 setBackgroundColor:kBlueColor];
            cell.progress4.textColor = kBlueColor;
            [cell.point4 setImage:[UIImage imageNamed:@"progress_point_s"] forState:0];
        }
        
        return cell;
        
    }else if (indexPath.section == 1){
        //补充材料
        if (indexPath.row == 0) {
            identifier = @"application10";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.userNameButton setTitle:@"保全详情" forState:0];
            return cell;
        }
        
        identifier = @"application11234";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userNameButton.titleLabel.font = kFirstFont;
        [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
        cell.userActionButton.titleLabel.font = kFirstFont;
        [cell.userActionButton setTitleColor:kGrayColor forState:0];

        NSArray *additionArray;
        if ([powerModel.type integerValue] == 1) {
            additionArray =  @[@"保全金额",@"管辖法院",@"案件类型",@"联系方式",@"取函方式",@"取函地址"];;
        }else if ([powerModel.type integerValue] == 2){
            additionArray =  @[@"保全金额",@"管辖法院",@"案件类型",@"联系方式",@"取函方式",@"收获地址"];
        }
        
        [cell.userNameButton setTitle:additionArray[indexPath.row-1] forState:0];
        
        if (indexPath.row == 1) {
            float account = [powerModel.account floatValue]/10000;
            NSString *accounts = [NSString stringWithFormat:@"%2.f万",account];
            [cell.userActionButton setTitle:accounts forState:0];
        }else if (indexPath.row == 2){
            [cell.userActionButton setTitle:powerModel.fayuan_name forState:0];
        }else if (indexPath.row == 3){
            [cell.userActionButton setTitle:powerModel.category forState:0];
        }else if (indexPath.row == 4){
            [cell.userActionButton setTitle:powerModel.phone forState:0];
        }else if (indexPath.row == 5){
            if ([powerModel.type integerValue] == 1) {
                [cell.userActionButton setTitle:@"自取" forState:0];
            }else if ([powerModel.type integerValue] == 2){
                [cell.userActionButton setTitle:@"快递" forState:0];
            }
        }else if (indexPath.row == 6){
            if ([powerModel.type integerValue] == 1) {
                [cell.userNameButton setTitle:@"取函地址" forState:0];
                [cell.userActionButton setTitle:powerModel.fayuan_address forState:0];
            }else if ([powerModel.type integerValue] == 2){
                [cell.userNameButton setTitle:@"收货地址" forState:0];
                [cell.userActionButton setTitle:powerModel.address forState:0];
            }
        }
        return cell;
    }
    
    //上传材料
    if (indexPath.row == 0) {
        identifier = @"application20";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userNameButton.userInteractionEnabled = NO;
        cell.userActionButton.userInteractionEnabled = NO;
        
        [cell.userNameButton setTitle:@"上传的资料" forState:0];
        
        if ([powerModel.status integerValue] < 2) {
            [cell.userActionButton setTitle:@"编辑" forState:0];
            [cell.userActionButton setTitleColor:kBlueColor forState:0];
        }else{
            [cell.userActionButton setTitle:@"" forState:0];
        }
        
        return cell;
        
    }else{
        identifier = @"application21";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userNameButton.userInteractionEnabled = NO;
        cell.userActionButton.userInteractionEnabled = NO;
        
        NSArray *userArr = @[@"起诉书",@"财产保全申请书",@"相关证据材料",@"案件受理通知书"];
        cell.userNameButton.titleLabel.font = kFirstFont;
        [cell.userNameButton setTitle:userArr[indexPath.row-1] forState:0];
        [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
        
        [cell.userActionButton setTitleColor:kGrayColor forState:0];
        cell.userActionButton.titleLabel.font = kFirstFont;

        if (indexPath.row == 1){
            NSString *qisuCount = [NSString stringWithFormat:@"x%lu",(unsigned long)powerModel.qisus.count];
            [cell.userActionButton setTitle:qisuCount forState:0];
        }else if (indexPath.row == 2){
            NSString *caichanCount = [NSString stringWithFormat:@"x%lu",(unsigned long)powerModel.caichans.count];
            [cell.userActionButton setTitle:caichanCount forState:0];
        }else if (indexPath.row == 3){
            NSString *zhengjuCount = [NSString stringWithFormat:@"x%lu",(unsigned long)powerModel.zhengjus.count];
            [cell.userActionButton setTitle:zhengjuCount forState:0];
        }else if (indexPath.row == 4){
            NSString *anjianCount = [NSString stringWithFormat:@"x%lu",(unsigned long)powerModel.anjians.count];
            [cell.userActionButton setTitle:anjianCount forState:0];
        }
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kBigPadding;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {//上传材料
        
        PowerModel *powerModel = self.powerDetalArray[0];
        if (indexPath.row == 0) {
            if ([powerModel.status integerValue] < 2) {
                PowerProtectPictureViewController *powerProtectPictureVC = [[PowerProtectPictureViewController alloc] init];
                powerProtectPictureVC.pModel = powerModel;
                powerProtectPictureVC.navTitleString = @"保全";
                [self.navigationController pushViewController:powerProtectPictureVC animated:YES];
            }
        }else if (indexPath.row == 1){
            NSMutableArray *fileArray1 = [NSMutableArray array];
            for (int i=0; i<powerModel.qisus.count; i++) {
                ImageModel *fileModel = powerModel.qisus[i];
                NSString *file = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,fileModel.file];
                [fileArray1 addObject:file];
            }
            [self showImages:fileArray1];
            
        }else if (indexPath.row == 2){
            NSMutableArray *fileArray2 = [NSMutableArray array];
            for (int i=0; i<powerModel.caichans.count; i++) {
                ImageModel *fileModel = powerModel.caichans[i];
                NSString *file = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,fileModel.file];
                [fileArray2 addObject:file];
            }
            [self showImages:fileArray2];
        }else if (indexPath.row == 3){
            NSMutableArray *fileArray3 = [NSMutableArray array];
            for (int i=0; i<powerModel.zhengjus.count; i++) {
                ImageModel *fileModel = powerModel.zhengjus[i];
                NSString *file = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,fileModel.file];
                [fileArray3 addObject:file];
            }
            [self showImages:fileArray3];
            
        }else if (indexPath.row == 4){
            NSMutableArray *fileArray4 = [NSMutableArray array];
            for (int i=0; i<powerModel.anjians.count; i++) {
                ImageModel *fileModel = powerModel.anjians[i];
                NSString *file = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,fileModel.file];
                [fileArray4 addObject:file];
            }
            [self showImages:fileArray4];
        }
    }
}

#pragma mark - method
- (void)getDetailsOfPower
{
    NSString *detailPowerString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPowerDetailString];
    NSDictionary *params = @{@"id" : self.pModel.idString,
                             @"token" : [self getValidateToken]
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:detailPowerString params:params successBlock:^(id responseObject) {
        
        NSDictionary *apapa = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        PowerDetailModel *pdModel = [PowerDetailModel objectWithKeyValues:responseObject];
        if ([pdModel.code isEqualToString:@"0000"]) {
            [weakself.powerDetalArray removeAllObjects];
            [weakself.powerDetalArray addObject:pdModel.result];
            [weakself.powerDetailsTableView reloadData];
            
        }else{
            [weakself showHint:pdModel.msg];
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
