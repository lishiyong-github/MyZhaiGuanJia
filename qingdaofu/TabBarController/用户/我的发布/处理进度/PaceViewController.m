//
//  PaceViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/5.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PaceViewController.h"

//#import "PaceCell.h"
#import "BidMessageCell.h"

#import "PaceResponse.h"
#import "PaceModel.h"

@interface PaceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstarits;
@property (nonatomic,strong) UITableView *paceTableView;
@property (nonatomic,strong) NSMutableArray *paceDataArray;

@end

@implementation PaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"处理进度";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.view.backgroundColor = kBackColor;
    
    [self.view addSubview:self.paceTableView];
    [self.view setNeedsUpdateConstraints];
    [self getPaceMessagesList];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstarits) {
        
        [self.paceTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstarits = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)paceTableView
{
    if (!_paceTableView) {
        _paceTableView.translatesAutoresizingMaskIntoConstraints = YES;
        _paceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _paceTableView.delegate = self;
        _paceTableView.dataSource = self;
        _paceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _paceTableView.backgroundColor = kBackColor;
    }
    return _paceTableView;
}

- (NSMutableArray *)paceDataArray
{
    if (!_paceDataArray) {
        _paceDataArray = [NSMutableArray array];
    }
    return _paceDataArray;
}

#pragma mark - delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.paceDataArray.count > 0) {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.paceDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.categoryString intValue] == 3) {
        return 145;
    }
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"pace";
    
    BidMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[BidMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kNavColor;
    
    PaceModel *model = self.paceDataArray[indexPath.row];
    NSArray *financeArray = @[@[@"尽职调查",@"公证",@"抵押",@"放款",@"返点",@"其他"],@[@"电话",@"上门",@"面谈"]];
    
    cell.timeLabel.text = [NSDate getYMDFormatterTime:model.create_time];
    
    if ([self.categoryString intValue] == 3) {//诉讼，有案号及案号类型
        NSArray *array1 = @[@"债权人上传处置资产",@"律师接单",@"双方洽谈",@"向法院起诉(财产保全)",@"整理诉讼材料",@"法院立案",@"向当事人发出开庭传票",@"开庭前调解",@"开庭",@"判决",@"二次开庭",@"二次判决",@"移交执行局申请执行",@"执行中提供借款人的财产线索",@"调查(公告)",@"拍卖",@"流拍",@"拍卖成功",@"付费"];
        //诉讼的案号状态：0=>一审,1=>二审,2=>再审,3=>执行
        NSArray *array2 = @[@"一审",@"二审",@"再审",@"执行"];
        NSInteger a1 = [model.audit intValue];
        NSInteger a2 = [model.status intValue]-1;
        
        cell.deadlineLabel.text = [NSString stringWithFormat:@"案号类型：%@",array1[a1]];
        cell.dateLabel.text = [NSString stringWithFormat:@"案        号：%@",model.caseString];
        cell.areaLabel.text = [NSString stringWithFormat:@"处置类型：%@",array2[a2]];
        cell.addressLabel.text = [NSString stringWithFormat:@"详        情：%@",model.content];
    }else if([self.categoryString intValue] == 1){//融资
        
        NSArray *array3 = @[@"尽职调查",@"公证",@"抵押",@"放款",@"返点",@"其他"];
        NSInteger a3 = [model.status intValue]-1;
        
        cell.deadlineLabel.text = [NSString stringWithFormat:@"处置类型：%@",array3[a3]];
        cell.dateLabel.text = [NSString stringWithFormat:@"详        情：%@",model.content];
    }else{
        NSArray *array4 = @[@"电话",@"上门",@"面谈"];
        NSInteger a4 = [model.status intValue]-1;
        cell.deadlineLabel.text = [NSString stringWithFormat:@"处置类型：%@",array4[a4]];
        cell.dateLabel.text = [NSString stringWithFormat:@"详        情：%@",model.content];
    }
    
    return cell;
    /*
    if (indexPath.row == 0) {
        cell.dateLabel.font = kBigFont;
        cell.stateLabel.font = kBigFont;
        cell.messageLabel.font = kBigFont;
        cell.dateLabel.textColor = kBlackColor;
        cell.stateLabel.textColor = kBlackColor;
        cell.messageLabel.textColor = kBlackColor;

        cell.dateLabel.text = @"日期";
        cell.stateLabel.text = @"状态";
        cell.messageLabel.text = @"详情";
    }else{
        PaceModel *model = self.paceDataArray[indexPath.row-1];
        NSArray *financeArray = @[@[@"尽职调查",@"公证",@"抵押",@"放款",@"返点",@"其他"],@[@"电话",@"上门",@"面谈"],@[@"债权人上传处置资产",@"律师接单",@"双方洽谈",@"向法院起诉(财产保全)",@"整理诉讼材料",@"法院立案",@"向当事人发出开庭传票",@"开庭前调解",@"开庭",@"判决",@"二次开庭",@"二次判决",@"移交执行局申请执行",@"执行中提供借款人的财产线索",@"调查(公告)",@"拍卖",@"流拍",@"拍卖成功",@"付费"]];
        
        cell.dateLabel.text = [NSDate getYMDFormatterTime:model.create_time];
        cell.messageLabel.text = model.content;
        NSInteger number1 = [model.category intValue];
        NSInteger number2 = [model.status intValue];
        cell.stateLabel.text = financeArray[number1][number2];
    }
    
    return cell;
    */
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

#pragma mark - method
- (void)getPaceMessagesList
{
    NSString *paceString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kLookUpScheduleString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idString,
                             @"category" : self.categoryString
                             };
    [self requestDataPostWithString:paceString params:params successBlock:^(id responseObject) {
        PaceResponse *response = [PaceResponse objectWithKeyValues:responseObject];
        for (PaceModel *paceModel in response.disposing) {
            [self.paceDataArray addObject:paceModel];
        }
        [self.paceTableView reloadData];
        
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
