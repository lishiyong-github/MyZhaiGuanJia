//
//  ApplicationCourtViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/7/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplicationCourtViewController.h"
#import "MineUserCell.h"

#import "CourtProvinceResponse.h"
#import "CourtProvinceModel.h"

@interface ApplicationCourtViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *courtChooseTableView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@property (nonatomic,strong) NSMutableArray *courtListArray;

@end

@implementation ApplicationCourtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择法院";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.courtChooseTableView];
    [self.view setNeedsUpdateConstraints];
    
    [self getCourtList];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.courtChooseTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)courtChooseTableView
{
    if (!_courtChooseTableView) {
        _courtChooseTableView = [UITableView newAutoLayoutView];
        _courtChooseTableView.backgroundColor = kBackColor;
        _courtChooseTableView.delegate = self;
        _courtChooseTableView.dataSource = self;
        _courtChooseTableView.separatorColor = kSeparateColor;
        _courtChooseTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _courtChooseTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];

    }
    return _courtChooseTableView;
}

- (NSMutableArray *)courtListArray
{
    if (!_courtListArray) {
        _courtListArray = [NSMutableArray array];
    }
    return _courtListArray;
}

#pragma mark - delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courtListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    identifier = @"assess00";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell.userNameButton setTitle:self.courtListArray[indexPath.row] forState:0];
    CourtProvinceModel *model = self.courtListArray[indexPath.row];
    [cell.userNameButton setTitle:model.name forState:0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.didSelectedRow) {
        CourtProvinceModel *model = self.courtListArray[indexPath.row];
        self.didSelectedRow(model.name,model.idString);
        [self back];
    }
}

#pragma mark - method
- (void)getCourtList
{
    NSString *courtString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPowerCourtString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"area_pid" : self.area_pidString,
                             @"area_id" : self.area_idString
                             };
        QDFWeakSelf;
    [self requestDataPostWithString:courtString params:params successBlock:^(id responseObject) {
        
        CourtProvinceResponse *responsel = [CourtProvinceResponse objectWithKeyValues:responseObject];
        
        if ([responsel.code isEqualToString:@"0000"]) {
            for (CourtProvinceModel *model in responsel.data) {
                [weakself.courtListArray addObject:model];
            }
            [weakself.courtChooseTableView reloadData];
        }else{
            [weakself showHint:responsel.msg];
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
