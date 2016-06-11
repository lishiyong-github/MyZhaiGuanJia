//
//  AboutViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AboutViewController.h"
#import "CompanyWebSiteViewController.h"
#import <StoreKit/StoreKit.h>


#import "MineUserCell.h"
//#import "UIButton.h"

@interface AboutViewController ()<UITableViewDataSource,UITableViewDelegate,SKStoreProductViewControllerDelegate>

@property (nonatomic,assign) BOOL didSetupConstaints;
@property (nonatomic,strong) UITableView *aboutTableView;
@property (nonatomic,strong) UIButton *aboutHeaderView;
@property (nonatomic,strong) UIButton *aboutCommitButton;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于清道夫";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.aboutTableView];
    [self.view addSubview:self.aboutCommitButton];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstaints) {
        [self.aboutTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.aboutTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:115];
        
        [self.aboutCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.aboutCommitButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.aboutTableView];
        
        self.didSetupConstaints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)aboutTableView
{
    if (!_aboutTableView) {
        _aboutTableView = [UITableView newAutoLayoutView];
        _aboutTableView.delegate = self;
        _aboutTableView.dataSource = self;
        _aboutTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _aboutTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 142)];
        [_aboutTableView.tableHeaderView addSubview:self.aboutHeaderView];
        _aboutTableView.backgroundColor = kBackColor;
    }
    return _aboutTableView;
}

- (UIButton *)aboutHeaderView
{
    if (!_aboutHeaderView) {
        _aboutHeaderView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 142)];
        _aboutHeaderView.titleLabel.font = kSecondFont;
        [_aboutHeaderView setTitleColor:kLightGrayColor forState:0];
        
        [_aboutHeaderView setImage:[UIImage imageNamed:@"logo"] forState:0];
        
        //当前版本
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
        NSString *versionString = [NSString stringWithFormat:@"清道夫V%@",currentVersion];
        [_aboutHeaderView setTitle:versionString forState:0];
        
//        _aboutHeaderView.transform = CGAffineTransformRotate(_aboutHeaderView.transform, M_PI);
//        _aboutHeaderView.titleLabel.transform = CGAffineTransformRotate(_aboutHeaderView.titleLabel.transform, M_2_PI);
//        _aboutHeaderView.imageView.transform = CGAffineTransformRotate(_aboutHeaderView.imageView.transform, M_2_PI);
        
        
        //拿到title和image的大小：
//        CGSize titleSize = CGSizeMake(60, 15);
        //_aboutHeaderView.titleLabel.bounds.size;
        //CGSizeMake(60, 15);
//        _aboutHeaderView.titleLabel.bounds.size;
//        CGSize imageSize = _aboutHeaderView.imageView.bounds.size;
//        _aboutHeaderView.imageEdgeInsets = UIEdgeInsetsMake(-imageSize.height/2, titleSize.width/2, imageSize.height/2, -titleSize.width/2);
//        _aboutHeaderView.titleEdgeInsets = UIEdgeInsetsMake(titleSize.height/2, -imageSize.width/2, -titleSize.height/2, imageSize.width/2);
        
        /*
        //图片在上，文字在下
        btn.imageEdgeInsets = UIEdgeInsetsMake(-imageSize.height/2, imageSize.width, imageSize.height/2, -imageSize.width);
        btn.titleEdgeInsets = UIEdgeInsetsMake(imageSize.height, -imageSize.width/2, -imageSize.height/2, imageSize.width/2);
        杨丹  15:22:16
        //拿到title和image的大小：
        CGSize titleSize = btn.titleLabel.bounds.size;
        CGSize imageSize = btn.imageView.bounds.size;
        */
    }
    return _aboutHeaderView;
}

- (UIButton *)aboutCommitButton
{
    if (!_aboutCommitButton) {
        _aboutCommitButton = [UIButton newAutoLayoutView];
        _aboutCommitButton.backgroundColor = kBackColor;
        _aboutCommitButton.titleLabel.numberOfLines = 0;
        NSString *aString1  = @"官方网站";
        NSString *aString2 = @"Copyright©2015-2016 直向资产管理有限公司　沪ICP备15055061号-1";
        //@"Copyright©2015-2016 直向资产管理有限公司　沪ICP备15055061号-1";
        NSString *aString = [NSString stringWithFormat:@"%@\n%@",aString1,aString2];
        NSMutableAttributedString *aAttributeString = [[NSMutableAttributedString alloc] initWithString:aString];
        [aAttributeString addAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlueColor} range:NSMakeRange(0, aString1.length)];
        [aAttributeString addAttributes:@{NSFontAttributeName:kTabBarFont,NSForegroundColorAttributeName:kGrayColor} range:NSMakeRange(aString1.length+1, aString2.length)];
        [_aboutCommitButton setAttributedTitle:aAttributeString forState:0];
        
        QDFWeakSelf;
        [_aboutCommitButton addAction:^(UIButton *btn) {
            CompanyWebSiteViewController *companyWebSiteVc = [[CompanyWebSiteViewController alloc] init];
            [weakself.navigationController pushViewController:companyWebSiteVc animated:YES];
        }];
    }
    
    return _aboutCommitButton;
}

#pragma mark - tableView delegate and dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"about";
    MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.userNameButton setTitle:@"去评分" forState:0];
    [cell.userActionButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
    cell.userNameButton.userInteractionEnabled = NO;
    cell.userActionButton.userInteractionEnabled = NO;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SKStoreProductViewController *SKStoreProductsVC = [[SKStoreProductViewController alloc] init];
    SKStoreProductsVC.delegate = self;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"1065452286" forKey:SKStoreProductParameterITunesItemIdentifier];
    [SKStoreProductsVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error){
        if (result)
        {
            [self presentViewController:SKStoreProductsVC animated:YES completion:nil];
        }
    }];
}

#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 142)];
//    headerView.backgroundColor = kBackColor;
//    
//    //imageView
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-80)/2, 40, 80, 100)];
//    imageView.backgroundColor = kBlueColor;
//    [headerView addSubview:imageView];
//    
//    //version
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom+10, kScreenWidth, 20)];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = kLightGrayColor;
//    label.font = kFirstFont;
//    label.text = [NSString stringWithFormat:@"清道夫V%@",@"1.0.2"];
//    [headerView addSubview:label];
//    
//    return headerView;
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
