//
//  ProductsCheckDetailViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/27.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ProductsCheckDetailViewController.h"
#import "DebtCell.h"
#import "DebtModel.h"

#import "UIImageView+WebCache.h"

@interface ProductsCheckDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupconstraints;
@property (nonatomic,strong) UITableView *listTableView;

@end

@implementation ProductsCheckDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.categoryString integerValue] == 1) {
        self.title = @"债权人信息";
    }else{
        self.title = @"债务人信息";
    }
    
    self.navigationItem.leftBarButtonItem = self.leftItem;
    [self.view addSubview:self.listTableView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupconstraints) {
        [self.listTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupconstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)listTableView
{
    if (!_listTableView) {
        _listTableView.translatesAutoresizingMaskIntoConstraints = YES;
        _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _listTableView.backgroundColor = kBackColor;
    }
    return _listTableView;
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"debtCredit";
    DebtCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DebtCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.debtEditButton setHidden:YES];

    DebtModel *deModel = self.listArray[indexPath.section];
    
    NSString *name;
    if ([self.categoryString  integerValue] == 1) {//债权人信息
        name = deModel.creditorname?deModel.creditorname:@"未填写";
    }else{//债务人信息
        name = deModel.borrowingname?deModel.borrowingname:@"未填写";
    }
    NSMutableAttributedString *nameStr = [cell.debtNameLabel setAttributeString:@"姓        名    " withColor:kBlackColor andSecond:name withColor:kLightGrayColor withFont:12];
    [cell.debtNameLabel setAttributedText:nameStr];
    
    NSString *tel;
    if ([self.categoryString  integerValue] == 1) {
        tel = deModel.creditormobile?deModel.creditormobile:@"未填写";
    }else{
        tel = deModel.borrowingmobile?deModel.borrowingmobile:@"未填写";
    }
    NSMutableAttributedString *telStr = [cell.debtTelLabel setAttributeString:@"联系方式    " withColor:kBlackColor andSecond:tel withColor:kLightGrayColor withFont:12];
    [cell.debtTelLabel setAttributedText:telStr];
    
    cell.debtAddressLabel.text = @"联系地址";
    if ([self.categoryString integerValue] == 1) {
        cell.debtAddressLabel1.text = deModel.creditoraddress?deModel.creditoraddress:@"未填写";
    }else{
        cell.debtAddressLabel1.text = deModel.borrowingaddress?deModel.borrowingaddress:@"未填写";
    }
    
    NSString *ID;
    if ([self.categoryString  integerValue] == 1) {
        ID = deModel.creditorcardcode?deModel.creditorcardcode:@"未填写";
    }else{
        ID = deModel.borrowingcardcode?deModel.borrowingcardcode:@"未填写";
    }
    NSMutableAttributedString *IDStr = [cell.debtIDLabel setAttributeString:@"证件号        " withColor:kBlackColor andSecond:ID withColor:kLightGrayColor withFont:12];
    [cell.debtIDLabel setAttributedText:IDStr];
    
    [cell.debtImageView1 sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"account_bitmap"]];
    [cell.debtImageView2 sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"account_bitmap"]];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
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
