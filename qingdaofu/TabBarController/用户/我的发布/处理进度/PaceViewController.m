//
//  PaceViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/5.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PaceViewController.h"

#import "ProgressCell.h"

#import "OrdersLogsModel.h"

#import "UIImageView+WebCache.h"

@interface PaceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstarits;
@property (nonatomic,strong) UITableView *paceTableView;

@end

@implementation PaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"处理进度";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.paceTableView];
    
    [self.view addSubview:self.baseRemindImageView];
    [self.baseRemindImageView setHidden:YES];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstarits) {
        
        [self.paceTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.baseRemindImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        self.didSetupConstarits = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)paceTableView
{
    if (!_paceTableView) {
        _paceTableView = [UITableView newAutoLayoutView];
        _paceTableView.backgroundColor = kBackColor;
        _paceTableView.separatorColor = [UIColor clearColor];
        _paceTableView.delegate = self;
        _paceTableView.dataSource = self;
        _paceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
    }
    return _paceTableView;
}

#pragma mark - delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderLogsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    return kCellHeight4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    OrdersLogsModel *logsModel = self.orderLogsArray[indexPath.row];
    
    if (indexPath.row == 0) {
        identifier = @"mypace31";
        ProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.ppLine1 setHidden:YES];
        
        //time
        [cell.ppLabel setAttributedText:[self showPPLabelOfPaceWithModel:logsModel]];
        
        //image
        if ([logsModel.label isEqualToString:@"经"]) {
            [cell.ppTypeButton setImage:[UIImage imageNamed:@"progress_managers"] forState:0];
        }else if([logsModel.label isEqualToString:@"系"]){
            [cell.ppTypeButton setImage:[UIImage imageNamed:@"progress_system"] forState:0];
        }else if ([logsModel.label isEqualToString:@"发"]){
            [cell.ppTypeButton setImage:[UIImage imageNamed:@"progress_publish"] forState:0];
        }else if ([logsModel.label isEqualToString:@"接"]){
            [cell.ppTypeButton setImage:[UIImage imageNamed:@"progress_orders"] forState:0];
        }else if ([logsModel.label isEqualToString:@"我"]){
            if ([self.personType integerValue] == 1) {//发布方
                [cell.ppTypeButton setImage:[UIImage imageNamed:@"progress_my_publish"] forState:0];
            }else if ([self.personType integerValue] == 2){//接单方
                [cell.ppTypeButton setImage:[UIImage imageNamed:@"progress_my_orders"] forState:0];
            }
        }
        
        //content
        [cell.ppTextButton setAttributedTitle:[self showPPTextOfPaceWithModel:logsModel] forState:0];
        
        //action
        if ([logsModel.label isEqualToString:@"经"] && logsModel.memoTel.length > 0) {
            QDFWeakSelf;
            [cell.ppTextButton addAction:^(UIButton *btn) {
                [weakself callPhoneWithTel:logsModel.memoTel];
            }];
        }
        
        return cell;
        
    }else if (indexPath.row == self.orderLogsArray.count-1){
        identifier = @"mypace38";
        ProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.ppLine2 setHidden:YES];
        
        //time
        [cell.ppLabel setAttributedText:[self showPPLabelOfPaceWithModel:logsModel]];
        
        //image
        if ([logsModel.label isEqualToString:@"经"]) {
            [cell.ppTypeButton setImage:[UIImage imageNamed:@"progress_managers"] forState:0];
        }else if([logsModel.label isEqualToString:@"系"]){
            [cell.ppTypeButton setImage:[UIImage imageNamed:@"progress_system"] forState:0];
        }else if ([logsModel.label isEqualToString:@"发"]){
            [cell.ppTypeButton setImage:[UIImage imageNamed:@"progress_publish"] forState:0];
        }else if ([logsModel.label isEqualToString:@"接"]){
            [cell.ppTypeButton setImage:[UIImage imageNamed:@"progress_orders"] forState:0];
        }else if ([logsModel.label isEqualToString:@"我"]){
            if ([self.personType integerValue] == 1) {//发布方
                [cell.ppTypeButton setImage:[UIImage imageNamed:@"progress_my_publish"] forState:0];
            }else if ([self.personType integerValue] == 2){//接单方
                [cell.ppTypeButton setImage:[UIImage imageNamed:@"progress_my_orders"] forState:0];
            }
        }
        
        //content
        [cell.ppTextButton setAttributedTitle:[self showPPTextOfPaceWithModel:logsModel] forState:0];
        
        //action
        if ([logsModel.label isEqualToString:@"经"] && logsModel.memoTel.length > 0) {
            QDFWeakSelf;
            [cell.ppTextButton addAction:^(UIButton *btn) {
                [weakself callPhoneWithTel:logsModel.memoTel];
            }];
        }
        
        return cell;
    }
    
    identifier = @"mypace33";
    ProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //time
    [cell.ppLabel setAttributedText:[self showPPLabelOfPaceWithModel:logsModel]];
    
    //image
    if ([logsModel.label isEqualToString:@"经"]) {
        [cell.ppTypeButton setImage:[UIImage imageNamed:@"progress_managers"] forState:0];
    }else if([logsModel.label isEqualToString:@"系"]){
        [cell.ppTypeButton setImage:[UIImage imageNamed:@"progress_system"] forState:0];
    }else if ([logsModel.label isEqualToString:@"发"]){
        [cell.ppTypeButton setImage:[UIImage imageNamed:@"progress_publish"] forState:0];
    }else if ([logsModel.label isEqualToString:@"接"]){
        [cell.ppTypeButton setImage:[UIImage imageNamed:@"progress_orders"] forState:0];
    }else if ([logsModel.label isEqualToString:@"我"]){
        if ([self.personType integerValue] == 1) {//发布方
            [cell.ppTypeButton setImage:[UIImage imageNamed:@"progress_my_publish"] forState:0];
        }else if ([self.personType integerValue] == 2){//接单方
            [cell.ppTypeButton setImage:[UIImage imageNamed:@"progress_my_orders"] forState:0];
        }
    }
    
    //content
    [cell.ppTextButton setAttributedTitle:[self showPPTextOfPaceWithModel:logsModel] forState:0];
    
    //action
    if ([logsModel.label isEqualToString:@"经"] && logsModel.memoTel.length > 0) {
        QDFWeakSelf;
        [cell.ppTextButton addAction:^(UIButton *btn) {
            [weakself callPhoneWithTel:logsModel.memoTel];
        }];
    }

    return cell;
}


#pragma mark
- (NSMutableAttributedString *)showPPLabelOfPaceWithModel:(OrdersLogsModel *)logModel
{
    NSString *timess1 = [NSString stringWithFormat:@"%@\n",[NSDate getHMFormatterTime:logModel.action_at]];
    NSString *timess2 = [NSDate getYMDsFormatterTime:logModel.action_at];
    NSString *timess = [NSString stringWithFormat:@"%@%@",timess1,timess2];
    NSMutableAttributedString *attributeTime = [[NSMutableAttributedString alloc] initWithString:timess];
    [attributeTime setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(0, timess1.length)];
    [attributeTime setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(timess1.length, timess2.length)];
    NSMutableParagraphStyle *styleTime = [[NSMutableParagraphStyle alloc] init];
    [styleTime setParagraphSpacing:6];
    styleTime.alignment = 2;
    [attributeTime addAttribute:NSParagraphStyleAttributeName value:styleTime range:NSMakeRange(0, timess.length)];
    
    return attributeTime;
}

- (NSMutableAttributedString *)showPPTextOfPaceWithModel:(OrdersLogsModel *)logModel
{
    if ([logModel.label isEqualToString:@"经"]) {
        
        NSMutableAttributedString *attributeMM;
        if (logModel.memoTel.length > 0) {//有电话
            NSString *mm1 = [NSString stringWithFormat:@"[%@]",logModel.actionLabel];
            NSString *mm2 = [NSString stringWithFormat:@"%@%@",logModel.memoLabel,[logModel.memoTel substringWithRange:NSMakeRange(0, logModel.memoTel.length-11)]];
            NSString *mm3 = [logModel.memoTel substringWithRange:NSMakeRange(logModel.memoTel.length-11, 11)];
            NSString *mm = [NSString stringWithFormat:@"%@%@%@",mm1,mm2,mm3];
            attributeMM = [[NSMutableAttributedString alloc] initWithString:mm];
            [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, mm1.length)];
            [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(mm1.length, mm2.length)];
            [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(mm2.length+mm1.length, mm3.length)];
        }else{//无电话
            NSString *tttt = [NSString stringWithFormat:@"[%@]%@",logModel.actionLabel,logModel.memoLabel];
            attributeMM = [[NSMutableAttributedString alloc] initWithString:tttt];
            [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, tttt.length)];
        }
        return attributeMM;
    }else{
        NSString *mm1 = [NSString stringWithFormat:@"[%@]%@",logModel.actionLabel,logModel.memoLabel];
        NSString *mm2 = [NSString stringWithFormat:@"%@",logModel.triggerLabel];
        NSString *mm = [NSString stringWithFormat:@"%@%@",mm1,mm2];
        NSMutableAttributedString *attributeMM = [[NSMutableAttributedString alloc] initWithString:mm];
        [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, mm1.length)];
        [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(mm1.length, mm2.length)];
        return attributeMM;
    }
    return nil;
}

- (void)callPhoneWithTel:(NSString *)tel
{
    NSMutableString *phone = [NSMutableString stringWithFormat:@"telprompt://%@",tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
}

- (void)didReceiveryWarning {
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
