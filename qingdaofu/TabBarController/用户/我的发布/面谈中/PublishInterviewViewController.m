//
//  PublishInterviewViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PublishInterviewViewController.h"
#import "ApplyRecordViewController.h"  //申请记录
#import "CheckDetailPublishViewController.h"  //查看发布方

#import "MineUserCell.h"//完善信息
#import "NewPublishDetailsCell.h"//进度
#import "OrderPublishCell.h"//联系TA
#import "NewPublishStateCell.h"//状态
#import "PublishCombineView.h"  //底部视图

#import "PublishingModel.h"
#import "PublishingResponse.h"
#import "UserNameModel.h"  //申请方信息

@interface PublishInterviewViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *publishInterviewTableView;
@property (nonatomic,strong) PublishCombineView *publishInterviewView;
@property (nonatomic,strong) NSMutableArray *publishInterviewArray;

@end

@implementation PublishInterviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview: self.publishInterviewTableView];
    [self.view addSubview:self.publishInterviewView];
    [self.view setNeedsUpdateConstraints];
    
    [self getDetailMessages];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.publishInterviewTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.publishInterviewTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.publishInterviewView];
        
        [self.publishInterviewView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.publishInterviewView autoSetDimension:ALDimensionHeight toSize:116];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)publishInterviewTableView
{
    if (!_publishInterviewTableView) {
        _publishInterviewTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _publishInterviewTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _publishInterviewTableView.backgroundColor = kBackColor;
        _publishInterviewTableView.separatorColor = kSeparateColor;
        _publishInterviewTableView.delegate = self;
        _publishInterviewTableView.dataSource = self;
    }
    return _publishInterviewTableView;
}

- (PublishCombineView *)publishInterviewView
{
    if (!_publishInterviewView) {
        _publishInterviewView = [PublishCombineView newAutoLayoutView];
        [_publishInterviewView.comButton1 setBackgroundColor:kButtonColor];
        [_publishInterviewView.comButton1 setTitle:@"同意TA作为接单方" forState:0];
        
        [_publishInterviewView.comButton2 setBackgroundColor:kWhiteColor];
        [_publishInterviewView.comButton2 setTitle:@"不合适，重新选择接单方" forState:0];
        [_publishInterviewView.comButton2 setTitleColor:kLightGrayColor forState:0];
        _publishInterviewView.comButton2.layer.borderColor = kBorderColor.CGColor;
        _publishInterviewView.comButton2.layer.borderWidth = kLineWidth;
    }
    return _publishInterviewView;
}

- (NSMutableArray *)publishInterviewArray
{
    if (!_publishInterviewArray) {
        _publishInterviewArray = [NSMutableArray array];
    }
    return _publishInterviewArray;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.publishInterviewArray.count > 0) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.publishInterviewArray.count > 0) {
        if (section == 0) {
            return 3;
        }
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return kCellHeight1;
        }else if (indexPath.row == 1){
            return 72;
        }else if (indexPath.row == 2){
            return kCellHeight3;
        }
    }
    return 216;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.section == 0) {
        
        PublishingResponse *resModel = self.publishInterviewArray[0];
        PublishingModel *publishModel = resModel.product;
        
        if (indexPath.row == 0) {
            identifier = @"publishing00";
            MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.userNameButton setTitle:publishModel.codeString forState:0];
            [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            [cell.userActionButton setTitle:@"编辑信息" forState:0];
            
            return cell;
        }else if (indexPath.row == 1){
            identifier = @"publishing01";
            NewPublishDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[NewPublishDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kBackColor;
            
            [cell.point2 setImage:[UIImage imageNamed:@"succee"] forState:0];
            cell.progress2.textColor = kTextColor;
            [cell.line2 setBackgroundColor:kButtonColor];
            
            return cell;
            
        }else if (indexPath.row == 2){
            identifier = @"publishing02";
            OrderPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[OrderPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UserNameModel *userNameModel = resModel.username;
            
            NSString *nameStr = [NSString getValidStringFromString:userNameModel.jusername toString:@"未认证"];
            NSString *checkStr = [NSString stringWithFormat:@"申请方：%@",nameStr];
            [cell.checkButton setTitle:checkStr forState:0];
            [cell.contactButton setTitle:@" 联系TA" forState:0];
            [cell.contactButton setImage:[UIImage imageNamed:@"phone_blue"] forState:0];
            
            //接单方详情
            QDFWeakSelf;
            [cell.checkButton addAction:^(UIButton *btn) {
                if ([userNameModel.jusername isEqualToString:@""] || userNameModel.jusername == nil || !userNameModel.jusername) {
                    [weakself showHint:@"申请方未认证，不能查看相关信息"];
                }else{
                    CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
                    checkDetailPublishVC.idString = weakself.idString;
                    checkDetailPublishVC.categoryString = weakself.categaryString;
                    checkDetailPublishVC.pidString = weakself.pidString;
                    checkDetailPublishVC.typeString = @"接单方";
                    //                checkDetailPublishVC.typeDegreeString = @"处理中";
                    [weakself.navigationController pushViewController:checkDetailPublishVC animated:YES];
                }
            }];
            
            //电话
            [cell.contactButton addAction:^(UIButton *btn) {
                if ([userNameModel.jusername isEqualToString:@""] || userNameModel.jusername == nil || !userNameModel.jusername) {
                    [self showHint:@"申请方未认证，不能打电话"];
                }else{
                    NSMutableString *phoneStr = [NSMutableString stringWithFormat:@"telprompt://%@",userNameModel.jmobile];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
                }
            }];
            return cell;
        }
        
    }else if (indexPath.section == 1){
        identifier = @"publishing1";
        NewPublishStateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[NewPublishStateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kWhiteColor;
        
        cell.stateLabel1.text = @"等待面谈";
        
        cell.stateLabel2.numberOfLines = 0;
        [cell.stateLabel2 setTextAlignment:NSTextAlignmentCenter];
        NSString *sss1 = @"双方联系并约见面谈并确定是否由TA作为接单方";
        NSString *sss2 = @"面谈时可能需准备的";
        NSString *sss3 = @"《材料清单》";
        NSString *sss = [NSString stringWithFormat:@"%@\n%@%@",sss1,sss2,sss3];
        NSMutableAttributedString *attributeSS = [[NSMutableAttributedString alloc] initWithString:sss];
        [attributeSS addAttributes:@{NSFontAttributeName:kFourFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, sss1.length+1+sss2.length)];
        [attributeSS addAttributes:@{NSFontAttributeName:kFourFont,NSForegroundColorAttributeName:kTextColor} range:NSMakeRange(sss1.length+1+sss2.length, sss3.length)];
        
        NSMutableParagraphStyle *sisi = [[NSMutableParagraphStyle alloc] init];
        [sisi setLineSpacing:kSpacePadding];
        sisi.alignment = 1;
        [attributeSS addAttribute:NSParagraphStyleAttributeName value:sisi range:NSMakeRange(0, sss.length)];
        
        [cell.stateLabel2 setAttributedText:attributeSS];
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kBigPadding;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self showHint:@"编辑信息"];
    }else if (indexPath.section == 1) {
        [self showHint:@"查看材料清单"];
    }
}

#pragma mark - method
- (void)getDetailMessages
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
        
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        if ([response.code isEqualToString:@"0000"]) {
            [weakself.publishInterviewArray removeAllObjects];
            [weakself.publishInterviewArray addObject:response];
            [weakself.publishInterviewTableView reloadData];
        }
        
    } andFailBlock:^(NSError *error){
        
    }];
}

//申请人列表
- (void)showRecordList
{
    ApplyRecordViewController *applyRecordsVC = [[ApplyRecordViewController alloc] init];
    applyRecordsVC.idStr = self.idString;
    applyRecordsVC.categaryStr = self.categaryString;
    [self.navigationController pushViewController:applyRecordsVC animated:YES];
}

////编辑信息
//- (void)editAllMessages
//{
//    if (self.publishInterviewArray.count > 0) {
//        PublishingResponse *response = self.publishInterviewArray[0];
//        PublishingModel *rModel = response.product;
//
//        ReportSuitViewController *reportSuiVC = [[ReportSuitViewController alloc] init];
//        reportSuiVC.categoryString = rModel.category;
//        reportSuiVC.suResponse = response;
//        reportSuiVC.tagString = @"3";
//        UINavigationController *nsop = [[UINavigationController alloc] initWithRootViewController:reportSuiVC];
//        [self presentViewController:nsop animated:YES completion:nil];
//    }
//}


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
