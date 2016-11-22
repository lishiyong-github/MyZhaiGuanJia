//
//  PaceViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/5.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PaceViewController.h"

//#import "BaseCommitView.h"
//#import "EditDebtAddressCell.h"

#import "MineUserCell.h"
#import "ProgressCell.h"

#import "PaceResponse.h"
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
    if (self.orderLogsArray.count > 0) {
        return self.orderLogsArray.count;
    }
    return 0;
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
        NSString *timess1 = [NSString stringWithFormat:@"%@\n",[NSDate getHMFormatterTime:logsModel.action_at]];
        NSString *timess2 = [NSDate getYMDsFormatterTime:logsModel.action_at];
        NSString *timess = [NSString stringWithFormat:@"%@%@",timess1,timess2];
        NSMutableAttributedString *attributeTime = [[NSMutableAttributedString alloc] initWithString:timess];
        [attributeTime setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(0, timess1.length)];
        [attributeTime setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(timess1.length, timess2.length)];
        NSMutableParagraphStyle *styleTime = [[NSMutableParagraphStyle alloc] init];
        [styleTime setParagraphSpacing:6];
        styleTime.alignment = 2;
        [attributeTime addAttribute:NSParagraphStyleAttributeName value:styleTime range:NSMakeRange(0, timess.length)];
        [cell.ppLabel setAttributedText:attributeTime];
        
        //content
        [cell.ppTypeButton setTitle:logsModel.label forState:0];
        
        if ([logsModel.label isEqualToString:@"系"]) {
            [cell.ppTypeButton setBackgroundColor:kRedColor];
            
            NSString *tttt = [NSString stringWithFormat:@"[%@]%@",logsModel.actionLabel,logsModel.memoLabel];
            [cell.ppTextButton setTitle:tttt forState:0];
            
            //                        cell.ppTextButton.backgroundColor = kBackColor;
            //                        [cell.ppTextButton setContentEdgeInsets:UIEdgeInsetsMake(kSpacePadding, kSpacePadding, kSpacePadding, kSpacePadding)];
            //                        cell.leftTextConstraints.constant = kSpacePadding;
            
        }else if ([logsModel.label isEqualToString:@"我"]){
            [cell.ppTypeButton setBackgroundColor:kYellowColor];
            NSString *tttt = [NSString stringWithFormat:@"[%@]%@",logsModel.actionLabel,logsModel.memoLabel];
            [cell.ppTextButton setTitle:tttt forState:0];
        }else if ([logsModel.label isEqualToString:@"接"]){
            
            [cell.ppTypeButton setBackgroundColor:kButtonColor];
            NSString *tttt = [NSString stringWithFormat:@"[%@]%@",logsModel.actionLabel,logsModel.memoLabel];
            [cell.ppTextButton setTitle:tttt forState:0];
            
        }else if ([logsModel.label isEqualToString:@"经"]){
            [cell.ppTypeButton setBackgroundColor:kGrayColor];
            
            if (logsModel.memoTel) {//有电话
                NSString *mm1 = [NSString stringWithFormat:@"[%@]",logsModel.actionLabel];
                NSString *mm2 = [NSString stringWithFormat:@"%@%@",logsModel.memoLabel,[logsModel.memoTel substringWithRange:NSMakeRange(0, logsModel.memoTel.length-11)]];
                NSString *mm3 = [logsModel.memoTel substringWithRange:NSMakeRange(logsModel.memoTel.length-11, 11)];
                NSString *mm = [NSString stringWithFormat:@"%@%@%@",mm1,mm2,mm3];
                NSMutableAttributedString *attributeMM = [[NSMutableAttributedString alloc] initWithString:mm];
                [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, mm1.length)];
                [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(mm1.length, mm2.length)];
                [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(mm2.length+mm1.length, mm3.length)];
                [cell.ppTextButton setAttributedTitle:attributeMM forState:0];
                
                [cell.ppTextButton addAction:^(UIButton *btn) {
                    NSMutableString *phone = [NSMutableString stringWithFormat:@"telprompt://%@",mm3];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
                }];
                
            }else{//无电话
                NSString *tttt = [NSString stringWithFormat:@"[%@]%@",logsModel.actionLabel,logsModel.memoLabel];
                [cell.ppTextButton setTitle:tttt forState:0];
            }
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
        NSString *timess1 = [NSString stringWithFormat:@"%@\n",[NSDate getHMFormatterTime:logsModel.action_at]];
        NSString *timess2 = [NSDate getYMDsFormatterTime:logsModel.action_at];
        NSString *timess = [NSString stringWithFormat:@"%@%@",timess1,timess2];
        NSMutableAttributedString *attributeTime = [[NSMutableAttributedString alloc] initWithString:timess];
        [attributeTime setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(0, timess1.length)];
        [attributeTime setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(timess1.length, timess2.length)];
        NSMutableParagraphStyle *styleTime = [[NSMutableParagraphStyle alloc] init];
        [styleTime setParagraphSpacing:6];
        styleTime.alignment = 2;
        [attributeTime addAttribute:NSParagraphStyleAttributeName value:styleTime range:NSMakeRange(0, timess.length)];
        [cell.ppLabel setAttributedText:attributeTime];
        
        //image
        
        //content
        [cell.ppTypeButton setTitle:logsModel.label forState:0];
        if ([logsModel.label isEqualToString:@"系"]) {
            [cell.ppTypeButton setBackgroundColor:kRedColor];
            
            NSString *tttt = [NSString stringWithFormat:@"[%@]%@",logsModel.actionLabel,logsModel.memoLabel];
            [cell.ppTextButton setTitle:tttt forState:0];
            
            //                        cell.ppTextButton.backgroundColor = kBackColor;
            //                        [cell.ppTextButton setContentEdgeInsets:UIEdgeInsetsMake(kSpacePadding, kSpacePadding, kSpacePadding, kSpacePadding)];
            //                        cell.leftTextConstraints.constant = kSpacePadding;
            
        }else if ([logsModel.label isEqualToString:@"我"]){
            [cell.ppTypeButton setBackgroundColor:kYellowColor];
                NSString *tttt = [NSString stringWithFormat:@"[%@]%@",logsModel.actionLabel,logsModel.memoLabel];
                [cell.ppTextButton setTitle:tttt forState:0];
        }else if ([logsModel.label isEqualToString:@"接"]){
            [cell.ppTypeButton setBackgroundColor:kButtonColor];
            NSString *tttt = [NSString stringWithFormat:@"[%@]%@",logsModel.actionLabel,logsModel.memoLabel];
            [cell.ppTextButton setTitle:tttt forState:0];
        }else if ([logsModel.label isEqualToString:@"经"]){
            [cell.ppTypeButton setBackgroundColor:kGrayColor];
            
            if (logsModel.memoTel) {//有电话
                NSString *mm1 = [NSString stringWithFormat:@"[%@]",logsModel.actionLabel];
                NSString *mm2 = [NSString stringWithFormat:@"%@%@",logsModel.memoLabel,[logsModel.memoTel substringWithRange:NSMakeRange(0, logsModel.memoTel.length-11)]];
                NSString *mm3 = [logsModel.memoTel substringWithRange:NSMakeRange(logsModel.memoTel.length-11, 11)];
                NSString *mm = [NSString stringWithFormat:@"%@%@%@",mm1,mm2,mm3];
                NSMutableAttributedString *attributeMM = [[NSMutableAttributedString alloc] initWithString:mm];
                [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, mm1.length)];
                [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(mm1.length, mm2.length)];
                [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(mm2.length+mm1.length, mm3.length)];
                [cell.ppTextButton setAttributedTitle:attributeMM forState:0];
                
                [cell.ppTextButton addAction:^(UIButton *btn) {
                    NSMutableString *phone = [NSMutableString stringWithFormat:@"telprompt://%@",mm3];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
                }];
                
            }else{//无电话
                NSString *tttt = [NSString stringWithFormat:@"[%@]%@",logsModel.actionLabel,logsModel.memoLabel];
                [cell.ppTextButton setTitle:tttt forState:0];
            }
            
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
    NSString *timess1 = [NSString stringWithFormat:@"%@\n",[NSDate getHMFormatterTime:logsModel.action_at]];
    NSString *timess2 = [NSDate getYMDsFormatterTime:logsModel.action_at];
    NSString *timess = [NSString stringWithFormat:@"%@%@",timess1,timess2];
    NSMutableAttributedString *attributeTime = [[NSMutableAttributedString alloc] initWithString:timess];
    [attributeTime setAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(0, timess1.length)];
    [attributeTime setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(timess1.length, timess2.length)];
    NSMutableParagraphStyle *styleTime = [[NSMutableParagraphStyle alloc] init];
    [styleTime setParagraphSpacing:6];
    styleTime.alignment = 2;
    [attributeTime addAttribute:NSParagraphStyleAttributeName value:styleTime range:NSMakeRange(0, timess.length)];
    [cell.ppLabel setAttributedText:attributeTime];
    
    //content
    [cell.ppTypeButton setTitle:logsModel.label forState:0];
    if ([logsModel.label isEqualToString:@"系"]) {
        [cell.ppTypeButton setBackgroundColor:kRedColor];
        
        NSString *tttt = [NSString stringWithFormat:@"[%@]%@",logsModel.actionLabel,logsModel.memoLabel];
        [cell.ppTextButton setTitle:tttt forState:0];
        
        //                    cell.ppTextButton.backgroundColor = kBackColor;
        //                    [cell.ppTextButton setContentEdgeInsets:UIEdgeInsetsMake(kSpacePadding, kSpacePadding, kSpacePadding, kSpacePadding)];
        //                    cell.leftTextConstraints.constant = kSpacePadding;
        
    }else if ([logsModel.label isEqualToString:@"我"]){
        [cell.ppTypeButton setBackgroundColor:kYellowColor];
        NSString *tttt = [NSString stringWithFormat:@"[%@]%@",logsModel.actionLabel,logsModel.memoLabel];
        [cell.ppTextButton setTitle:tttt forState:0];
    }else if ([logsModel.label isEqualToString:@"接"]){
        [cell.ppTypeButton setBackgroundColor:kButtonColor];
        NSString *tttt = [NSString stringWithFormat:@"[%@]%@",logsModel.actionLabel,logsModel.memoLabel];
        [cell.ppTextButton setTitle:tttt forState:0];
    }else if ([logsModel.label isEqualToString:@"经"]){
        [cell.ppTypeButton setBackgroundColor:kGrayColor];
        
        if (logsModel.memoTel) {//有电话
            NSString *mm1 = [NSString stringWithFormat:@"[%@]",logsModel.actionLabel];
            NSString *mm2 = [NSString stringWithFormat:@"%@%@",logsModel.memoLabel,[logsModel.memoTel substringWithRange:NSMakeRange(0, logsModel.memoTel.length-11)]];
            NSString *mm3 = [logsModel.memoTel substringWithRange:NSMakeRange(logsModel.memoTel.length-11, 11)];
            NSString *mm = [NSString stringWithFormat:@"%@%@%@",mm1,mm2,mm3];
            NSMutableAttributedString *attributeMM = [[NSMutableAttributedString alloc] initWithString:mm];
            [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(0, mm1.length)];
            [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kLightGrayColor} range:NSMakeRange(mm1.length, mm2.length)];
            [attributeMM setAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(mm2.length+mm1.length, mm3.length)];
            [cell.ppTextButton setAttributedTitle:attributeMM forState:0];
            
            [cell.ppTextButton addAction:^(UIButton *btn) {
                NSMutableString *phone = [NSMutableString stringWithFormat:@"telprompt://%@",mm3];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
            }];
            
        }else{//无电话
            NSString *tttt = [NSString stringWithFormat:@"[%@]%@",logsModel.actionLabel,logsModel.memoLabel];
            [cell.ppTextButton setTitle:tttt forState:0];
        }
    }
    return cell;
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
