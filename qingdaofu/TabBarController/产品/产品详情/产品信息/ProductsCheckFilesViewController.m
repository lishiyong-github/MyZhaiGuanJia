//
//  ProductsCheckFilesViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/7/7.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ProductsCheckFilesViewController.h"
#import "ProductsCheckFileDetailsViewController.h"

#import "MineUserCell.h"

#import "DebtModel.h"
#import "UIViewController+ImageBrowser.h"

@interface ProductsCheckFilesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *fileTableView;

@property (nonatomic,strong) NSMutableArray *imaDataArray;

@end

@implementation ProductsCheckFilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"债权文件";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.fileTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.fileTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)fileTableView
{
    if (!_fileTableView) {
        _fileTableView = [UITableView newAutoLayoutView];
        _fileTableView.delegate = self;
        _fileTableView.dataSource = self;
        _fileTableView.tableFooterView = [[UIView alloc] init];
        _fileTableView.separatorColor = kSeparateColor;
        _fileTableView.backgroundColor = kBackColor;
        _fileTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _fileTableView.separatorInset = UIEdgeInsetsMake(0, kBigPadding, 0, 0);
    }
    return _fileTableView;
}

- (NSMutableArray *)imaDataArray
{
    if (!_imaDataArray) {
        _imaDataArray = [NSMutableArray array];
    }
    return _imaDataArray;
}

#pragma makr - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"upload";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *arr1 = @[@"bond_icon_certificate",@"bond_icon_contract",@"bond_icon_warrants",@"bond_icon_voucher",@"bond_icon_receipt",@"bond_icon_repayment"];
    NSArray *arr2 = @[@"  公证书",@"  借款合同",@"  他项权证",@"  收款凭证",@"  收据",@"  还款凭证"];
    [cell.userNameButton setImage:[UIImage imageNamed:arr1[indexPath.row]] forState:0];
    [cell.userNameButton setTitle:arr2[indexPath.row] forState:0];
    
    [cell.userActionButton setTitle:@"查看" forState:0];
    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    cell.userActionButton.titleLabel.font = kSecondFont;
    [cell.userActionButton setTitleColor:kBlueColor forState:0];
    cell.userActionButton.userInteractionEnabled = NO;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.imaDataArray removeAllObjects];
    
    
    DebtModel *zModel = [[DebtModel alloc] init];
    zModel = self.fileResponse.creditorfiles;

    switch (indexPath.row) {
        case 0:{
            if (zModel.imgnotarization == nil || [zModel.imgnotarization isEqualToArray:@[@""]]) {//未上传
                [self showHint:@"未上传公证书"];
            }else{
                for (NSInteger k=0; k<zModel.imgnotarization.count; k++) {
                    NSString *aaaaa = zModel.imgnotarization[k];
                    NSString *subStr = [aaaaa substringWithRange:NSMakeRange(1, aaaaa.length-2)];
                    NSString *str = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,subStr];
                    NSURL *subUrl = [NSURL URLWithString:str];
                    [self.imaDataArray addObject:subUrl];
                }
                [self showImages:self.imaDataArray];
            }
        }
            break;
        case 1:{
            if (zModel.imgcontract == nil || [zModel.imgcontract isEqualToArray:@[@""]]) {//未上传
                [self showHint:@"未上传借款合同"];
            }else{
                for (NSInteger k=0; k<zModel.imgcontract.count; k++) {
                    NSString *aaaaa = zModel.imgcontract[k];
                    NSString *subStr = [aaaaa substringWithRange:NSMakeRange(1, aaaaa.length-2)];
                    NSString *str = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,subStr];
                    NSURL *subUrl = [NSURL URLWithString:str];
                    [self.imaDataArray addObject:subUrl];
                }
                [self showImages:self.imaDataArray];
            }
        }
            break;
        case 2:{
            if (zModel.imgcreditor == nil || [zModel.imgcreditor isEqualToArray:@[@""]]) {//未上传
                [self showHint:@"未上传他项权证"];
            }else{
                for (NSInteger k=0; k<zModel.imgcreditor.count; k++) {
                    NSString *aaaaa = zModel.imgcreditor[k];
                    NSString *subStr = [aaaaa substringWithRange:NSMakeRange(1, aaaaa.length-2)];
                    NSString *str = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,subStr];
                    NSURL *subUrl = [NSURL URLWithString:str];
                    [self.imaDataArray addObject:subUrl];
                }
                [self showImages:self.imaDataArray];
            }
        }
            break;
        case 3:{
            if (zModel.imgpick == nil || [zModel.imgpick isEqualToArray:@[@""]]) {//未上传
                [self showHint:@"未上传收款凭证"];
            }else{
                for (NSInteger k=0; k<zModel.imgpick.count; k++) {
                    NSString *aaaaa = zModel.imgpick[k];
                    NSString *subStr = [aaaaa substringWithRange:NSMakeRange(1, aaaaa.length-2)];
                    NSString *str = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,subStr];
                    NSURL *subUrl = [NSURL URLWithString:str];
                    [self.imaDataArray addObject:subUrl];
                }
                [self showImages:self.imaDataArray];
            }
        }
            break;
        case 4:{
            if (zModel.imgshouju == nil || [zModel.imgshouju isEqualToArray:@[@""]]) {//未上传
                [self showHint:@"未上传收据"];
            }else{
                for (NSInteger k=0; k<zModel.imgshouju.count; k++) {
                    NSString *aaaaa = zModel.imgshouju[k];
                    NSString *subStr = [aaaaa substringWithRange:NSMakeRange(1, aaaaa.length-2)];
                    NSString *str = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,subStr];
                    NSURL *subUrl = [NSURL URLWithString:str];
                    [self.imaDataArray addObject:subUrl];
                }
                [self showImages:self.imaDataArray];
            }
        }
            break;
        case 5:{
            if (zModel.imgbenjin == nil || [zModel.imgbenjin isEqualToArray:@[@""]]) {//未上传
                [self showHint:@"未上传还款凭证"];
            }else{
                for (NSInteger k=0; k<zModel.imgbenjin.count; k++) {
                    NSString *aaaaa = zModel.imgbenjin[k];
                    NSString *subStr = [aaaaa substringWithRange:NSMakeRange(1, aaaaa.length-2)];
                    NSString *str = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,subStr];
                    NSURL *subUrl = [NSURL URLWithString:str];
                    [self.imaDataArray addObject:subUrl];
                }
                [self showImages:self.imaDataArray];
            }
        }
            break;
        default:
            break;
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
