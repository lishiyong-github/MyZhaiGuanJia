//
//  UploadFilesViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/11.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "UploadFilesViewController.h"
#import "UploadViewController.h"

#import "UIButton+Addition.h"

#import "MineUserCell.h"

@interface UploadFilesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *uploadTableView;
@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) NSMutableDictionary *imagesDictionaty;

@end

@implementation UploadFilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"上传债权文件";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.uploadTableView];
    [self.view setNeedsUpdateConstraints];
}

- (NSMutableDictionary *)imagesDictionaty
{
    if (!_imagesDictionaty) {
        _imagesDictionaty = [NSMutableDictionary dictionary];
    }
    return _imagesDictionaty;
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.uploadTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)uploadTableView
{
    if (!_uploadTableView) {
        _uploadTableView = [UITableView newAutoLayoutView];
        _uploadTableView.delegate = self;
        _uploadTableView.dataSource = self;
        _uploadTableView.tableFooterView = [[UIView alloc] init];
        _uploadTableView.separatorColor = kSeparateColor;
        _uploadTableView.backgroundColor = kBackColor;
        _uploadTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _uploadTableView.separatorInset = UIEdgeInsetsMake(0, kBigPadding, 0, 0);
    }
    return _uploadTableView;
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
    
    [cell.userActionButton setTitle:@"上传" forState:0];
    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    cell.userActionButton.titleLabel.font = kSecondFont;
    [cell.userActionButton setTitleColor:kBlueColor forState:0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UploadViewController *uploadVC = [[UploadViewController alloc] init];
    uploadVC.typeUpInt = indexPath.row;
    uploadVC.filesModel = [[DebtModel alloc] init];
    uploadVC.tagString = self.tagString;
    
    if (indexPath.row == 0) {//公证书
        uploadVC.filesModel.imgnotarization = [self.imagesDictionaty[@"imgnotarization"] count]?self.imagesDictionaty[@"imgnotarization"]:self.filesDic[@"imgnotarization"];
        uploadVC.typeString = @"公证书";
    }else if (indexPath.row == 1){
        uploadVC.filesModel.imgcontract = [self.imagesDictionaty[@"imgcontract"] count]?self.imagesDictionaty[@"imgcontract"]:self.filesDic[@"imgcontract"];
        uploadVC.typeString = @"借款合同";
    }else if (indexPath.row == 2){
        uploadVC.filesModel.imgcreditor = [self.imagesDictionaty[@"imgcreditor"] count]?self.imagesDictionaty[@"imgcreditor"]:self.filesDic[@"imgcreditor"];
        uploadVC.typeString = @"他项权证";
    }else if (indexPath.row == 3){
        uploadVC.filesModel.imgpick = [self.imagesDictionaty[@"imgpick"] count]?self.imagesDictionaty[@"imgpick"]:self.filesDic[@"imgpick"];
        uploadVC.typeString = @"收款凭证";
    }else if (indexPath.row == 4){
        uploadVC.filesModel.imgshouju = [self.imagesDictionaty[@"imgshouju"] count]?self.imagesDictionaty[@"imgshouju"]:self.filesDic[@"imgshouju"];
        uploadVC.typeString = @"收据";
    }else if (indexPath.row == 5){
        uploadVC.filesModel.imgbenjin = [self.imagesDictionaty[@"imgbenjin"] count]?self.imagesDictionaty[@"imgbenjin"]:self.filesDic[@"imgbenjin"];
        uploadVC.typeString = @"还款凭证";
    }
    [self.navigationController pushViewController:uploadVC animated:YES];

    QDFWeakSelf;
    [uploadVC setUploadImages:^(NSArray *imageArr,NSString *imageString,DebtModel *imageModel) {
        if (indexPath.row == 0) {//公证书
            [weakself.imagesDictionaty setValue:imageModel.imgnotarization forKey:@"imgnotarization"];
            [weakself.imagesDictionaty setValue:imageModel.imgnotarizations forKey:@"imgnotarizations"];
        }else if (indexPath.row == 1){//借款合同
            [weakself.imagesDictionaty setValue:imageModel.imgcontract forKey:@"imgcontract"];
            [weakself.imagesDictionaty setValue:imageModel.imgcontracts forKey:@"imgcontracts"];
        }else if (indexPath.row == 2){//他项权证
            [weakself.imagesDictionaty setValue:imageModel.imgcreditor forKey:@"imgcreditor"];
            [weakself.imagesDictionaty setValue:imageModel.imgcreditors forKey:@"imgcreditors"];
        }else if (indexPath.row == 3){//收款凭证
            [weakself.imagesDictionaty setValue:imageModel.imgpick forKey:@"imgpick"];
            [weakself.imagesDictionaty setValue:imageModel.imgpicks forKey:@"imgpicks"];
        }else if (indexPath.row == 4){//收据
            [weakself.imagesDictionaty setValue:imageModel.imgbenjin forKey:@"imgshouju"];
            [weakself.imagesDictionaty setValue:imageModel.imgbenjins forKey:@"imgshoujus"];
        }else if (indexPath.row == 5){//还款凭证
            [weakself.imagesDictionaty setValue:imageModel.imgshouju forKey:@"imgbenjin"];
            [weakself.imagesDictionaty setValue:imageModel.imgshoujus forKey:@"imgbenjins"];
        }
    }];
}

#pragma mark - method
- (void)back
{
    [super back];
    if (self.chooseImages) {
        self.chooseImages(self.imagesDictionaty);
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
