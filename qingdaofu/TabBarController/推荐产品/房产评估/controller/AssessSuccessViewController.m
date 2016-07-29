//
//  AssessSuccessViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/7/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AssessSuccessViewController.h"

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
    self.title = @"房产评估";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kNavColor} forState:0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self.view addSubview:self.assessSuccessTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
            [weakself.navigationController popViewControllerAnimated:YES];
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
            [cell.userActionButton setHidden:YES];
            
            [cell.userNameButton setTitle:@"评估结果" forState:0];
            
            return cell;
        }
        //具体评估结果
        identifier = @"success01";
        BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 20;// 字体的行间距
        
        NSString *moneyString1 = @"555";
        NSString *moneyString2 = @"万";
        NSString *moneyString3 = @"房产评估结果";
        
        NSString *moneyStr = [NSString stringWithFormat:@"%@%@\n%@",moneyString1,moneyString2,moneyString3];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
//        [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, moneyStr.length)];
        
        [attributeStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],NSForegroundColorAttributeName:kRedColor,UIFontDescriptorFamilyAttribute:@"FZLanTingHeiS",UIFontDescriptorFamilyAttribute:@"FZLanTingHeiS-R-GB"} range:NSMakeRange(0, moneyString1.length)];//555
        [attributeStr setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kRedColor} range:NSMakeRange(moneyString1.length, moneyString2.length)];//万
        [attributeStr setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(moneyString1.length+moneyString2.length+1, moneyString3.length)];//万
        [cell.oneButton setAttributedTitle:attributeStr forState:0];
        
        return cell;
    }
    //section==1
    
    identifier = @"success00";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    [cell.userActionButton setHidden:YES];
    
    if (indexPath.row > 0) {
        cell.userNameButton.titleLabel.font = kSecondFont;
        [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
    }
    
    NSString *str1 = @"房源信息";
    NSString *str2 = [NSString stringWithFormat:@"房源地址：%@",@"浦东新区"];
    NSString *str3 = [NSString stringWithFormat:@"小区地址：%@",@"浦东南路"];
    NSString *str4 = [NSString stringWithFormat:@"小区均价：%@",@"99999元/m²"];
    NSString *str5 = [NSString stringWithFormat:@"房源面积：%@",@"100m²"];
    NSString *str6 = [NSString stringWithFormat:@"房源楼层：%@",@"第4层，共9层"];
    NSArray *resultArray = [NSArray arrayWithObjects:str1,str2,str3,str4,str5,str6,nil];
    [cell.userNameButton setTitle:resultArray[indexPath.row] forState:0];
    
    return cell;
    
    return nil;
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
    UIView *footerView = [[UIView alloc] init];
    [footerView addSubview:self.assessSucFooterButton];
    
    [self.assessSucFooterButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
    [self.assessSucFooterButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
    [self.assessSucFooterButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
    [self.assessSucFooterButton autoSetDimension:ALDimensionHeight toSize:40];
    
    return footerView;
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
