//
//  PowerProtectPictureViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PowerProtectPictureViewController.h"

#import "BaseCommitView.h"

#import "UIViewController+MutipleImageChoice.h"
#import "TakePictureCell.h"
#import "MineUserCell.h"

@interface PowerProtectPictureViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *powerPictureTableView;
@property (nonatomic,strong) BaseCommitView *powerPictureButton;
@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation PowerProtectPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完善资料";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看示例" style:UIBarButtonItemStylePlain target:self action:@selector(sddd)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self.view addSubview:self.powerPictureTableView];
    [self.view addSubview:self.powerPictureButton];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)sddd
{
    
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.powerPictureTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.powerPictureTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.powerPictureButton];
        
        [self.powerPictureButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.powerPictureButton autoSetDimension:ALDimensionHeight toSize:kCellHeight1];
        
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)powerPictureTableView
{
    if (!_powerPictureTableView) {
        _powerPictureTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _powerPictureTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _powerPictureTableView.backgroundColor = kBackColor;
        _powerPictureTableView.delegate = self;
        _powerPictureTableView.dataSource = self;
    }
    return _powerPictureTableView;
}

- (BaseCommitView *)powerPictureButton
{
    if (!_powerPictureButton) {
        _powerPictureButton = [BaseCommitView newAutoLayoutView];
        [_powerPictureButton.button setTitle:@"保存" forState:0];
    }
    return _powerPictureButton;
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 50+kBigPadding*2;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    
    if (indexPath.row == 0) {
        identifier = @"upImage0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userActionButton setHidden:YES];
        
        NSArray *upArray = @[@"起诉书",@"财产保全申请书",@"相关证据材料",@"案件受理通知书"];
        [cell.userNameButton setTitle:upArray[indexPath.section] forState:0];
        
        return cell;
    }
    
    identifier = @"upImage1";
    TakePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[TakePictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.collectionDataList = [NSMutableArray arrayWithObject:@"upload_pictures"];
    [cell reloadData];
    
    QDFWeakSelf;
    QDFWeak(cell);
    [cell setDidSelectedItem:^(NSInteger items) {
         [weakself addImageWithMaxSelection:5 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
             if (images.count > 0) {
                 weakcell.collectionDataList = [NSMutableArray arrayWithArray:images];
                 [weakcell reloadData];
             }else{
                 weakcell.collectionDataList = [NSMutableArray arrayWithObject:@"upload_pictures"];
                 [weakcell reloadData];
             }
         }];
     }];
    
    //展示图片
    /*
    QDFWeakSelf;
    [cell setDidSelectedItem:^(NSInteger itemTag) {
        
        NSMutableArray *imgArray = [NSMutableArray array];
        for (NSString *filePath in weakself.allImageArray) {
            FSBasicImage *basicImage = [[FSBasicImage alloc] initWithImage:[UIImage imageWithContentsOfFile:filePath]];
            [imgArray addObject:basicImage];
        }
        
        FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:imgArray];
        FSImageViewerViewController *browser = [[FSImageViewerViewController alloc] initWithImageSource:photoSource];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:browser];
        [weakself presentViewController:nav animated:YES completion:nil];
    }];
    */
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBigPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 40;
    }
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        footerView.backgroundColor = kBackColor;
        
        UIButton *footerButton = [UIButton newAutoLayoutView];
        [footerButton setImage:[UIImage imageNamed:@"right"] forState:0];
        [footerButton setTitle:@"  请确保提供的材料真实性和完整性，同时我们会保护您的隐私" forState:0];
        [footerButton setTitleColor:kLightGrayColor forState:0];
        footerButton.titleLabel.font = kTabBarFont;
        [footerView addSubview:footerButton];
        
        [footerButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [footerButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        [footerButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        
        return footerView;
    }
    
    return nil;
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
