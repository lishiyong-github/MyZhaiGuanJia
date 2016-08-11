//
//  ApplicationDetailsViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplicationDetailsViewController.h"
#import "PowerProtectViewController.h"  //申请保全
#import "PowerProtectPictureViewController.h"

#import "MessageCell.h"
#import "MineUserCell.h"
#import "PowerDetailsCell.h"

@interface ApplicationDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *powerDetailsTableView;

@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation ApplicationDetailsViewController


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

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 6;
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
    if (indexPath.section == 0) {//保函进度
        identifier = @"power00";
        PowerDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PowerDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kBlueColor;
        
        [cell.button1 setImage:[UIImage imageNamed:@"right"] forState:0];
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
        
        NSArray *additionArray = @[@"保函金额",@"管辖法院",@"案        号",@"取函方式",@"取函地址"];
        [cell.userNameButton setTitle:additionArray[indexPath.row-1] forState:0];
        
        if (indexPath.row == 1) {
            [cell.userActionButton setTitle:@"600万" forState:0];
        }else if (indexPath.row == 2){
            [cell.userActionButton setTitle:@"上海市高级人民法院" forState:0];
        }else if (indexPath.row == 3){
            [cell.userActionButton setTitle:@"沪执002001号" forState:0];
        }else if (indexPath.row == 4){
            [cell.userActionButton setTitle:@"快递" forState:0];
        }else if (indexPath.row == 5){
            [cell.userActionButton setTitle:@"上海市浦东新区浦东南路855号" forState:0];
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
        [cell.userActionButton setTitle:@"编辑" forState:0];
        [cell.userActionButton setTitleColor:kBlueColor forState:0];
        
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
        [cell.userActionButton setTitle:@"x0" forState:0];
        
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
    if (indexPath.section == 2) {//相关材料
        if (indexPath.row == 0) {
            PowerProtectPictureViewController *powerProtectPictureVC = [[PowerProtectPictureViewController alloc] init];
            [self.navigationController pushViewController:powerProtectPictureVC animated:YES];
        }
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
