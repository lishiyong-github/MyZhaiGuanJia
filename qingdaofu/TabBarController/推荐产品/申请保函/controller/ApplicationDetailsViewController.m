//
//  ApplicationDetailsViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplicationDetailsViewController.h"
#import "PowerProtectViewController.h"  //申请保全
#import "PowerProtectPictureViewController.h"//修改图片
#import "UIViewController+ImageBrowser.h"

#import "MessageCell.h"
#import "MineUserCell.h"
#import "PowerDetailsCell.h"

#import "ApplicationDetailResponse.h"
#import "ApplicationModel.h"

@interface ApplicationDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *powerDetailsTableView;

@property (nonatomic,assign) BOOL didSetupConstraints;

//json
@property (nonatomic,strong) NSMutableArray *appDetailArray;

@end

@implementation ApplicationDetailsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self getDetailOfApplicationGuarantee];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"保函详情";
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
    }
    return _powerDetailsTableView;
}

- (NSMutableArray *)appDetailArray
{
    if (!_appDetailArray) {
        _appDetailArray = [NSMutableArray array];
    }
    return _appDetailArray;
}

#pragma mark - tableview delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.appDetailArray.count > 0) {
        if (section == 1) {
            return 8;
        }else if (section == 2){
            return 5;
        }
        return 1;
    }
    return 0;
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
    
    ApplicationModel *appliModel;
    if (self.appDetailArray.count > 0) {
        appliModel = self.appDetailArray[0];
    }
    
    if (indexPath.section == 0) {//保函进度
        identifier = @"power00";
        PowerDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PowerDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kBlueColor;
        cell.progress3.text = @"保函已出";
        
        [cell.button1 setImage:[UIImage imageNamed:@"my_guarantee"] forState:0];
        NSString *str1 = @"保函进度";
        NSString *str2 = @"本平台承诺对您的案件资料和隐私严格保密！";
        NSString *str = [NSString stringWithFormat:@"%@\n%@",str1,str2];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeStr setAttributes:@{NSForegroundColorAttributeName:kBlackColor,NSFontAttributeName:kBigFont} range:NSMakeRange(0, str1.length)];
        [attributeStr setAttributes:@{NSForegroundColorAttributeName:kLightGrayColor,NSFontAttributeName:kSmallFont} range:NSMakeRange(str1.length+1, str2.length)];
        
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:3];
        [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];
        
        [cell.button1 setAttributedTitle:attributeStr forState:0];
        
        if ([appliModel.status integerValue] == 1) {//未审核
            
        }else if ([appliModel.status integerValue] == 10){//审核成功
            cell.progress1.textColor = kBlueColor;
            [cell.point1 setImage:[UIImage imageNamed:@"progress_point_s"] forState:0];
        }else if ([appliModel.status integerValue] == 20){//签订协议
            cell.progress1.textColor = kBlueColor;
            [cell.point1 setImage:[UIImage imageNamed:@"progress_point_s"] forState:0];
            [cell.line1 setBackgroundColor:kBlueColor];
            cell.progress2.textColor = kBlueColor;
            [cell.point2 setImage:[UIImage imageNamed:@"progress_point_s"] forState:0];
        }else if ([appliModel.status integerValue] == 30){//已出保函
            cell.progress1.textColor = kBlueColor;
            [cell.point1 setImage:[UIImage imageNamed:@"progress_point_s"] forState:0];
            [cell.line1 setBackgroundColor:kBlueColor];
            cell.progress2.textColor = kBlueColor;
            [cell.point2 setImage:[UIImage imageNamed:@"progress_point_s"] forState:0];
            [cell.line2 setBackgroundColor:kBlueColor];
            cell.progress3.textColor = kBlueColor;
            [cell.point3 setImage:[UIImage imageNamed:@"progress_point_s"] forState:0];
        }else if ([appliModel.status integerValue] == 40){//完成
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
        //详情
        if (indexPath.row == 0) {
            identifier = @"application10";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.userNameButton setTitle:@"保函详情" forState:0];
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
        if ([appliModel.type integerValue] == 1) {
            additionArray = @[@"保函金额",@"管辖法院",@"案件类型",@"案        号",@"联系方式",@"取函方式",@"取函地址"];
        }else if ([appliModel.type integerValue] == 2){
            additionArray = @[@"保函金额",@"管辖法院",@"案件类型",@"案        号",@"联系方式",@"快递方式",@"收获地址"];
        }
        [cell.userNameButton setTitle:additionArray[indexPath.row-1] forState:0];
        
        if (indexPath.row == 1) {
            float moneyFloat = [appliModel.money floatValue]/10000;
            NSString *moneyStr = [NSString stringWithFormat:@"%2.f万",moneyFloat];
            [cell.userActionButton setTitle:moneyStr forState:0];
        }else if (indexPath.row == 2){
            [cell.userActionButton setTitle:appliModel.fayuan_name forState:0];
        }else if (indexPath.row == 3){
            NSArray *cateArray =  @[@"借贷纠纷",@"房产土地",@"劳动纠纷",@"婚姻家庭",@" 合同纠纷",@"公司治理",@"知识产权",@"其他民事纠纷"];
            [cell.userActionButton setTitle:cateArray[[appliModel.category integerValue]-1] forState:0];
        }else if (indexPath.row == 4){
            [cell.userActionButton setTitle:appliModel.anhao forState:0];
        }else if (indexPath.row == 5){
            [cell.userActionButton setTitle:appliModel.phone forState:0];
        }else if (indexPath.row == 6){
            NSArray *typeArr = @[@"取函",@"快递"];
            NSInteger typeInt = [appliModel.type integerValue];
            [cell.userActionButton setTitle:typeArr[typeInt-1] forState:0];
        }else if (indexPath.row == 7){
            if ([appliModel.type integerValue] == 1) {
                [cell.userActionButton setTitle:appliModel.fayuan_address forState:0];
            }else if ([appliModel.type integerValue] == 2){
                [cell.userActionButton setTitle:appliModel.address forState:0];
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
        [cell.userNameButton setTitle:@"相关材料" forState:0];
        [cell.userActionButton setTitleColor:kBlueColor forState:0];
        
        if ([appliModel.status integerValue] < 2) {
            [cell.userActionButton setHidden:NO];
            [cell.userActionButton setTitle:@"编辑" forState:0];
        }else{
            [cell.userActionButton setHidden:YES];
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
        
        if (indexPath.row == 1) {
            NSString *number1 = [NSString stringWithFormat:@"x%lu",(unsigned long)appliModel.qisus.count];
            [cell.userActionButton setTitle:number1 forState:0];
        }else if (indexPath.row == 2){
            NSString *number2 = [NSString stringWithFormat:@"x%lu",(unsigned long)appliModel.caichans.count];
            [cell.userActionButton setTitle:number2 forState:0];
        }else if (indexPath.row == 3){
            NSString *number3 = [NSString stringWithFormat:@"x%lu",(unsigned long)appliModel.zhengjus.count];
            [cell.userActionButton setTitle:number3 forState:0];
        }else if (indexPath.row == 4){
            NSString *number4 = [NSString stringWithFormat:@"x%lu",(unsigned long)appliModel.anjians.count];
            [cell.userActionButton setTitle:number4 forState:0];
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
        ApplicationModel *appliModel = self.appDetailArray[0];
        if (indexPath.row == 0) {//编辑
            if ([appliModel.status integerValue] < 2) {
                PowerProtectPictureViewController *powerProtectPictureVC = [[PowerProtectPictureViewController alloc] init];
                powerProtectPictureVC.aModel = appliModel;
                powerProtectPictureVC.navTitleString = @"保函";
                [self.navigationController pushViewController:powerProtectPictureVC animated:YES];
            }
        }else if (indexPath.row == 1){
            NSMutableArray *fileArray1 = [NSMutableArray array];
            for (int i=0; i<appliModel.qisus.count; i++) {
                ImageModel *fileModel = appliModel.qisus[i];
                [fileArray1 addObject:fileModel.file];
            }
            [self showImages:fileArray1];
            
        }else if (indexPath.row == 2){
            NSMutableArray *fileArray2 = [NSMutableArray array];
            for (int i=0; i<appliModel.caichans.count; i++) {
                ImageModel *fileModel = appliModel.caichans[i];
                [fileArray2 addObject:fileModel.file];
            }
            [self showImages:fileArray2];
        }else if (indexPath.row == 3){
            NSMutableArray *fileArray3 = [NSMutableArray array];
            for (int i=0; i<appliModel.zhengjus.count; i++) {
                ImageModel *fileModel = appliModel.zhengjus[i];
                [fileArray3 addObject:fileModel.file];
            }
            [self showImages:fileArray3];
            
        }else if (indexPath.row == 4){
            NSMutableArray *fileArray4 = [NSMutableArray array];
            for (int i=0; i<appliModel.anjians.count; i++) {
                ImageModel *fileModel = appliModel.anjians[i];
                [fileArray4 addObject:fileModel.file];
            }
            [self showImages:fileArray4];
        }
    }
}

#pragma mark - method
- (void)getDetailOfApplicationGuarantee
{
    NSString *detailAppString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kApplicationGuaranteeDetailString];
    NSDictionary *params = @{@"id" : self.idString,
                             @"token" : [self getValidateToken]
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:detailAppString params:params successBlock:^(id responseObject) {
                        
        [weakself.appDetailArray removeAllObjects];
        
        ApplicationDetailResponse *responde = [ApplicationDetailResponse objectWithKeyValues:responseObject];
        
        if ([responde.code isEqualToString:@"0000"]) {
            [weakself.appDetailArray addObject:responde.model];

            [weakself.powerDetailsTableView reloadData];
        }else{
            [weakself showHint:responde.msg];
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
