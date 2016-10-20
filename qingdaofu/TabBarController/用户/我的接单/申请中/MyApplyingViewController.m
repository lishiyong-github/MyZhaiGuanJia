//
//  MyApplyingViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "MyApplyingViewController.h"
#import "CheckDetailPublishViewController.h"  //查看发布方

#import "BaseRemindButton.h"

#import "NewPublishDetailsCell.h"//进度
#import "NewPublishStateCell.h"//状态
#import "MineUserCell.h"//完善信息
#import "OrderPublishCell.h"

#import "PublishingModel.h"
#import "PublishingResponse.h"
#import "UserNameModel.h"

@interface MyApplyingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UIButton *applyingRightButton;
@property (nonatomic,strong) UITableView *myApplyingTableView;
@property (nonatomic,strong) NSMutableArray *myApplyArray;

//@property (nonatomic,strong) NSString *loanTypeString1;  //债权类型
//@property (nonatomic,strong) NSString *loanTypeString2;  //债权类型内容
//@property (nonatomic,strong) NSString *loanTypeImage;//债权类型图片

@end

@implementation MyApplyingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品详情";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.applyingRightButton];
    
    [self.view addSubview:self.myApplyingTableView];
    
    [self.view setNeedsUpdateConstraints];
    
    [self getDetailMessageOfApplying];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.myApplyingTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

#pragma mark - setter and getter
- (UIButton *)applyingRightButton
{
    if (!_applyingRightButton) {
        _applyingRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        [_applyingRightButton setTitleColor:kWhiteColor forState:0];
        [_applyingRightButton setTitle:@"取消申请" forState:0];
        _applyingRightButton.titleLabel.font = kFirstFont;
        
        [_applyingRightButton addTarget:self action:@selector(cancelTheProductApply) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyingRightButton;
}

- (UITableView *)myApplyingTableView
{
    if (!_myApplyingTableView) {
        _myApplyingTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _myApplyingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _myApplyingTableView.delegate = self;
        _myApplyingTableView.dataSource = self;
        _myApplyingTableView.separatorColor = kSeparateColor;
        _myApplyingTableView.backgroundColor = kBackColor;
    }
    return _myApplyingTableView;
}

- (NSMutableArray *)myApplyArray
{
    if (!_myApplyArray) {
        _myApplyArray = [NSMutableArray array];
    }
    return _myApplyArray;
}

#pragma mark - tableView delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.myApplyArray.count > 0) {
        return 3;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.myApplyArray.count > 0) {
        if (section == 0) {
            return 2;
        }else if (section == 2){
            return 7;
        }
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 72;
        }else if (indexPath.row == 1){
            kCellHeight3;
        }
    }else if (indexPath.section == 1){
        PublishingResponse *resongde = self.myApplyArray[0];
        if ([resongde.product.progress_status integerValue] == 2) {
            return 196;
        }else if ([resongde.product.progress_status integerValue] == 1){
            return 210;
        }
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    PublishingResponse *resongde = self.myApplyArray[0];
    PublishingModel *applyingModel = resongde.product;

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            identifier = @"applying00";
            NewPublishDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[NewPublishDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kBackColor;
            [cell.progress1 setText:@"申请中"];
            
            if ([applyingModel.progress_status integerValue] == 2) {
                [cell.line2 setBackgroundColor:kLightGrayColor];
                [cell.progress2 setTextColor:kLightGrayColor];
                [cell.point2 setImage:[UIImage imageNamed:@"normal2"] forState:0];
            }else if ([applyingModel.progress_status integerValue] == 1){
                [cell.line2 setBackgroundColor:kButtonColor];
                [cell.progress2 setTextColor:kTextColor];
                [cell.point2 setImage:[UIImage imageNamed:@"succee"] forState:0];
            }
            
            return cell;
        }else if (indexPath.row == 1){
            identifier = @"applying01";
            if ([applyingModel.progress_status integerValue] == 2) {
                MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                PublishingResponse *resModel = self.myApplyArray[0];
                
                UserNameModel *userNameModel = resModel.username;
                NSString *nameStr = [NSString getValidStringFromString:userNameModel.username toString:@"未认证"];
                NSString *checkStr = [NSString stringWithFormat:@"发布方：%@",nameStr];
                [cell.userNameButton setTitle:checkStr forState:0];
                [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
                [cell.userActionButton setTitle:@"发布方详情  " forState:0];
                return cell;
            }else if ([applyingModel.progress_status integerValue] == 1){
                OrderPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                
                if (!cell) {
                    cell = [[OrderPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UserNameModel *userNameModel = resongde.username;
                
                NSString *nameStr = [NSString getValidStringFromString:userNameModel.username toString:@"未认证"];
                NSString *checkStr = [NSString stringWithFormat:@"发布方：%@",nameStr];
                [cell.checkButton setTitle:checkStr forState:0];
                [cell.contactButton setTitle:@" 联系TA" forState:0];
                [cell.contactButton setImage:[UIImage imageNamed:@"phone_blue"] forState:0];
                
                //接单方详情
                QDFWeakSelf;
                [cell.checkButton addAction:^(UIButton *btn) {
                    if ([userNameModel.username isEqualToString:@""] || userNameModel.username == nil || !userNameModel.username) {
                        [weakself showHint:@"发布方未认证，不能查看相关信息"];
                    }else{
                        CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
                        checkDetailPublishVC.idString = weakself.idString;
                        checkDetailPublishVC.categoryString = weakself.categaryString;
                        checkDetailPublishVC.pidString = @"1";
//                        weakself.pidString;
                        checkDetailPublishVC.typeString = @"发布方";
                        //                checkDetailPublishVC.typeDegreeString = @"处理中";
                        [weakself.navigationController pushViewController:checkDetailPublishVC animated:YES];
                    }
                }];
                
                //电话
                [cell.contactButton addAction:^(UIButton *btn) {
                    if ([userNameModel.username isEqualToString:@""] || userNameModel.username == nil || !userNameModel.username) {
                        [self showHint:@"发布方未认证，不能打电话"];
                    }else{
                        NSMutableString *phoneStr = [NSMutableString stringWithFormat:@"telprompt://%@",userNameModel.mobile];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
                    }
                }];
                return cell;
            }
        }
    }else if (indexPath.section == 1){
        identifier = @"applying1";

        NewPublishStateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[NewPublishStateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kWhiteColor;
        
        if ([applyingModel.progress_status integerValue] == 2) {
            cell.stateLabel1.text = @"申请中";
            cell.stateLabel2.text = @"申请中，等待发布方同意";
            
        }else if ([applyingModel.progress_status integerValue] == 1){
            cell.stateLabel1.text = @"等待面谈";

            cell.stateLabel2.numberOfLines = 0;
            NSString *staetc = @"双方联系并约见面谈，面谈后由发布方确定\n是否由您来接单";
            NSMutableAttributedString *attributeSt = [[NSMutableAttributedString alloc]initWithString:staetc];
            NSMutableParagraphStyle *syudy = [[NSMutableParagraphStyle alloc] init];
            [syudy setLineSpacing:2];
            syudy.alignment = NSTextAlignmentCenter;
            [attributeSt addAttribute:NSParagraphStyleAttributeName value:syudy range:NSMakeRange(0, staetc.length)];
            [cell.stateLabel2 setAttributedText:attributeSt];
        }
        
        return cell;
    }else if (indexPath.section == 2){
        identifier = @"applying2";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userActionButton setTitleColor:kGrayColor forState:0];
        cell.userActionButton.titleLabel.font = kBigFont;
        
        NSArray *textArr = @[@"产品详情",@"债权类型",@"委托事项",@"委托金额",@"委托费用",@"违约期限",@"合同履行地"];
        [cell.userNameButton setTitle:textArr[indexPath.row] forState:0];
        
//        PublishingResponse *resModel = self.myApplyArray[0];
//        PublishingModel *publishModel = resModel.product;
        
        if (indexPath.row == 0) {
            [cell.userNameButton setTitleColor:kBlackColor forState:0];
            cell.userNameButton.titleLabel.font = kBigFont;
            [cell.userActionButton setTitle:@"" forState:0];
        }else if (indexPath.row == 1){
            [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
            cell.userNameButton.titleLabel.font = kFirstFont;
            [cell.userActionButton setTitle:@"债权类型" forState:0];
        }else if (indexPath.row == 2){
            [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
            cell.userNameButton.titleLabel.font = kFirstFont;
            [cell.userActionButton setTitle:@"委托事项" forState:0];
        }else if (indexPath.row == 3){
            [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
            cell.userNameButton.titleLabel.font = kFirstFont;
            [cell.userActionButton setTitle:@"委托金额" forState:0];
        }else if (indexPath.row == 4){
            [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
            cell.userNameButton.titleLabel.font = kFirstFont;
            [cell.userActionButton setTitle:@"委托费用" forState:0];
        }else if (indexPath.row == 5){
            [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
            cell.userNameButton.titleLabel.font = kFirstFont;
            [cell.userActionButton setTitle:@"违约期限" forState:0];
        }else if (indexPath.row == 6){
            [cell.userNameButton setTitleColor:kLightGrayColor forState:0];
            cell.userNameButton.titleLabel.font = kFirstFont;
            [cell.userActionButton setTitle:@"合同履行地" forState:0];
        }
        
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
    if (indexPath.section == 0 && indexPath.row == 1) {//查看发布方
        PublishingResponse *respongr = self.myApplyArray[0];
        
        if ([respongr.product.progress_status integerValue] == 1) {
            UserNameModel *usModel = respongr.username;
            
            if ([usModel.username isEqualToString:@""] || usModel.username == nil || !usModel.username) {
                [self showHint:@"发布方未认证，不能查看相关信息"];
            }else{
                CheckDetailPublishViewController *checkDetailPublishVC = [[CheckDetailPublishViewController alloc] init];
                checkDetailPublishVC.typeString = @"发布方";
                checkDetailPublishVC.typeDegreeString = @"1";
                checkDetailPublishVC.idString = self.idString;
                checkDetailPublishVC.categoryString = self.categaryString;
                checkDetailPublishVC.pidString = @"1";
                //            self.pidString;
                [self.navigationController pushViewController:checkDetailPublishVC animated:YES];
            }
        }
    }
}

#pragma mark - method
- (void)getDetailMessageOfApplying
{
    NSString *detailString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyReleaseDetailString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categaryString
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:detailString params:params successBlock:^(id responseObject){
                
        PublishingResponse *response = [PublishingResponse objectWithKeyValues:responseObject];
        [weakself.myApplyArray addObject:response];
        [weakself.myApplyingTableView reloadData];
        
    } andFailBlock:^(NSError *error){
        
    }];
}

- (void)cancelTheProductApply
{
    [self showHint:@"取消申请"];
    
    PublishingResponse *respofn;
    if (self.myApplyArray.count > 0) {
        respofn = self.myApplyArray[0];
    }
    
    NSString *cancelString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kCancelProductOfMyOrderString];
    NSDictionary *params = @{@"id" : respofn.username.deleteId,
                             @"token" : [self getValidateToken]
                             };
    QDFWeakSelf;
    [self requestDataPostWithString:cancelString params:params successBlock:^(id responseObject) {
        
        BaseModel *baseModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:baseModel.msg];
        
        if ([baseModel.code isEqualToString:@"0000"]) {
            [weakself.navigationController popViewControllerAnimated:YES];
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
