//
//  ApplyRecordsViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplyRecordsViewController.h"
#import "ApplyRecordsDetailViewController.h"   //申请人信息

#import "ApplyRecordsCell.h"

@interface ApplyRecordsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *applyRecordsTableView;

@end

@implementation ApplyRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请记录";
    self.navigationItem.leftBarButtonItem = self.leftItem;

    [self.view addSubview:self.applyRecordsTableView];
    [self.view setNeedsUpdateConstraints];
    [self getApplyRecordsListWithPage:@"0"];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.applyRecordsTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];

        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)applyRecordsTableView
{
    if (!_applyRecordsTableView) {
        _applyRecordsTableView = [UITableView newAutoLayoutView];
        _applyRecordsTableView.delegate = self;
        _applyRecordsTableView.dataSource = self;
        _applyRecordsTableView.tableFooterView = [[UIView alloc] init];
        _applyRecordsTableView.backgroundColor = kBackColor;
        _applyRecordsTableView.separatorInset = UIEdgeInsetsZero;
        
        if ([_applyRecordsTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_applyRecordsTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_applyRecordsTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_applyRecordsTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
    }
    return _applyRecordsTableView;
}

#pragma mark - tableView deleagte and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
        identifier = @"aRecords0";
        
        ApplyRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ApplyRecordsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    
    if (indexPath.row == 0) {
        
        cell.personLabel.textColor = kBlackColor;
        cell.personLabel.font = kBigFont;
        cell.personLabel.text = @"申请人";
        
        cell.dateLabel.textColor = kBlackColor;
        cell.dateLabel.font = kBigFont;
        cell.dateLabel.text = @"申请时间";
        
        [cell.actButton setTitleColor:kBlackColor forState:0];
        cell.actButton.titleLabel.font = kBigFont;
        [cell.actButton setTitle:@"操作" forState:0];
    }else{
        
        [cell.lineLabel11 setHidden:YES];
        [cell.lineLabel12 setHidden:YES];
        
        cell.personLabel.text = @"123456744";
        cell.dateLabel.text = @"2016-05-16";
        [cell.actButton setTitle:@"查看" forState:0];
        cell.actButton.layer.borderWidth = kLineWidth;
        cell.actButton.layer.borderColor = kBlueColor.CGColor;
        cell.actButton.layer.cornerRadius = corner;
        QDFWeakSelf;
        [cell.actButton addAction:^(UIButton *btn) {
            ApplyRecordsDetailViewController *checkDetailPublishVC = [[ApplyRecordsDetailViewController alloc] init];
            [weakself.navigationController pushViewController:checkDetailPublishVC animated:YES];
        }];
    }
    
    return cell;
}

#pragma mark - method
- (void)getApplyRecordsListWithPage:(NSString *)page
{
    NSString *listString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kMyRecordsString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"id" : self.idStr,
                             @"categary" : self.categaryStr,
                             @"page" : page
                             };
    [self requestDataPostWithString:listString params:params successBlock:^(id responseObject){
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@">>>>>>>> %@",dic);
        
        
    } andFailBlock:^(id responseObject){
        
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
