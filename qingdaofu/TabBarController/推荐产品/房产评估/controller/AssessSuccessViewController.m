//
//  AssessSuccessViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/7/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AssessSuccessViewController.h"
#import "HouseAssessViewController.h"

#import "BaseCommitButton.h"

#import "MineUserCell.h"
#import "BidOneCell.h"

@interface AssessSuccessViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *assessSuccessTableView;
@property (nonatomic,strong) BaseCommitButton *assessSucFooterButton;
@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation AssessSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评估结果";
    
    if ([self.fromType integerValue] == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:nil];
        [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor} forState:0];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    }else{
        self.navigationItem.leftBarButtonItem = self.leftItem;
    }
    
    [self.view addSubview:self.assessSuccessTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)finish
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.assessSuccessTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)assessSuccessTableView
{
    if (!_assessSuccessTableView) {
        _assessSuccessTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _assessSuccessTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _assessSuccessTableView.delegate = self;
        _assessSuccessTableView.dataSource = self;
        _assessSuccessTableView.separatorColor = kSeparateColor;
    }
    return _assessSuccessTableView;
}

- (BaseCommitButton *)assessSucFooterButton
{
    if (!_assessSucFooterButton) {
        _assessSucFooterButton = [BaseCommitButton newAutoLayoutView];
        [_assessSucFooterButton setTitle:@"继续评估" forState:0];
        
        QDFWeakSelf;
        [_assessSucFooterButton addAction:^(UIButton *btn) {
            [weakself dismissViewControllerAnimated:NO completion:nil];
            
//            HouseAssessViewController *houseAssessVC = [[HouseAssessViewController alloc] init];
//            houseAssessVC.hidesBottomBarWhenPushed = YES;
//            [weakself.navigationController pushViewController:houseAssessVC animated:NO];
        }];
    }
    return _assessSucFooterButton;
}

#pragma mark - delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 6;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 80;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//评估结果
            identifier = @"success00";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            
            cell.userNameButton.titleLabel.font = kBigFont;
            [cell.userNameButton setTitle:@"评估结果" forState:0];
            cell.userActionButton.titleLabel.font = kSecondFont;
            
            NSString *time = [NSDate getYMDhmFormatterTime:self.aModel.create_time];
            [cell.userActionButton setTitle:time forState:0];
            
            return cell;
        }
        
        //具体评估结果
        identifier = @"success01";
        BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        NSString *moneyString1 = [NSString stringWithFormat:@"%ld",[self.aModel.totalPrice integerValue]/10000];
        NSString *moneyString2 = @" 万";
        NSString *moneyString3 = @"房产初评结果";
        
        NSString *moneyStr = [NSString stringWithFormat:@"%@%@\n%@",moneyString1,moneyString2,moneyString3];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        
        [attributeStr setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:24],NSForegroundColorAttributeName:kRedColor,UIFontDescriptorFamilyAttribute:@"FZLanTingHeiS",UIFontDescriptorFamilyAttribute:@"FZLanTingHeiS-R-GB"} range:NSMakeRange(0, moneyString1.length)];//555
        [attributeStr setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kRedColor} range:NSMakeRange(moneyString1.length, moneyString2.length)];//万
        [attributeStr setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(moneyString1.length+moneyString2.length+1, moneyString3.length)];//万
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [moneyStr length])];

        [cell.oneButton setAttributedTitle:attributeStr forState:0];
        cell.oneButton.titleLabel.textAlignment = NSTextAlignmentCenter;

        return cell;
    }
    
    //section==1
    identifier = @"success10";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    [cell.userActionButton setHidden:YES];
    
    if (indexPath.row > 0) {
        cell.userNameButton.titleLabel.font = kFirstFont;
        [cell.userNameButton setTitleColor:kGrayColor forState:0];
    }else{
        cell.userNameButton.titleLabel.font = kBigFont;
    }
    
    NSString *str1 = @"房源信息";
    NSString *str2 = [NSString stringWithFormat:@"房源地址：%@",self.aModel.district];
    NSString *str3 = [NSString stringWithFormat:@"小区地址：%@",self.aModel.address];
    
    float total = [self.aModel.totalPrice floatValue] / [self.aModel.size floatValue];
    NSString *str4 = [NSString stringWithFormat:@"小区均价：%.2f元/m²",total];
    NSString *str5 = [NSString stringWithFormat:@"房源面积：%@m²",self.aModel.size];
    NSString *str6 = [NSString stringWithFormat:@"房源楼层：第%@层，共%@层",self.aModel.floor,self.aModel.maxFloor];
    NSArray *resultArray = [NSArray arrayWithObjects:str1,str2,str3,str4,str5,str6,nil];
    [cell.userNameButton setTitle:resultArray[indexPath.row] forState:0];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1f;
    }
    
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([self.fromType integerValue] == 1) {
        if (section == 1) {
            UIView *footerView = [[UIView alloc] init];
            [footerView addSubview:self.assessSucFooterButton];
            
            [self.assessSucFooterButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
            [self.assessSucFooterButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
            [self.assessSucFooterButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
            [self.assessSucFooterButton autoSetDimension:ALDimensionHeight toSize:40];
            
            return footerView;
        }
    }
    
    return nil;
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
