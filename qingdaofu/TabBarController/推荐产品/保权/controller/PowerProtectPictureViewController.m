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

#import "ImageModel.h"

@interface PowerProtectPictureViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *powerPictureTableView;
@property (nonatomic,strong) BaseCommitView *powerPictureButton;
@property (nonatomic,assign) BOOL didSetupConstraints;

//参数
//传参
@property (nonatomic,strong) NSMutableArray *qisuArray;
@property (nonatomic,strong) NSMutableArray *caichanArray;
@property (nonatomic,strong) NSMutableArray *zhengjuArray;
@property (nonatomic,strong) NSMutableArray *anjianArray;

//显示
@property (nonatomic,strong) NSMutableArray *qisuArray1;
@property (nonatomic,strong) NSMutableArray *caichanArray1;
@property (nonatomic,strong) NSMutableArray *zhengjuArray1;
@property (nonatomic,strong) NSMutableArray *anjianArray1;

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
        [_powerPictureButton.button addTarget:self action:@selector(saveAdditionalImages) forControlEvents:UIControlEventTouchUpInside];
    }
    return _powerPictureButton;
}

- (NSMutableArray *)qisuArray
{
    if (!_qisuArray) {
        _qisuArray = [NSMutableArray array];
    }
    return _qisuArray;
}

- (NSMutableArray *)caichanArray
{
    if (!_caichanArray) {
        _caichanArray = [NSMutableArray array];
    }
    return _caichanArray;
}

- (NSMutableArray *)zhengjuArray
{
    if (!_zhengjuArray) {
        _zhengjuArray = [NSMutableArray array];
    }
    return _zhengjuArray;
}

- (NSMutableArray *)anjianArray
{
    if (!_anjianArray) {
        _anjianArray = [NSMutableArray array];
    }
    return _anjianArray;
}

- (NSMutableArray *)qisuArray1
{
    if (!_qisuArray1) {
        _qisuArray1 = [NSMutableArray arrayWithObject:@"upload_pictures"];
    }
    return _qisuArray1;
}
- (NSMutableArray *)caichanArray1
{
    if (!_caichanArray1) {
        _caichanArray1 = [NSMutableArray arrayWithObject:@"upload_pictures"];
    }
    return _caichanArray1;
}

- (NSMutableArray *)zhengjuArray1
{
    if (!_zhengjuArray1) {
        _zhengjuArray1 = [NSMutableArray arrayWithObject:@"upload_pictures"];
    }
    return _zhengjuArray1;
}

- (NSMutableArray *)anjianArray1
{
    if (!_anjianArray1) {
        _anjianArray1 = [NSMutableArray arrayWithObject:@"upload_pictures"];
    }
    return _anjianArray1;
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
    
    if (indexPath.section == 0) {
        cell.collectionDataList = [NSMutableArray arrayWithArray:self.qisuArray1];
    }else if (indexPath.section == 1){
        cell.collectionDataList = [NSMutableArray arrayWithArray:self.caichanArray1];
    }else if (indexPath.section == 2){
        cell.collectionDataList = [NSMutableArray arrayWithArray:self.zhengjuArray1];
    }else if (indexPath.section == 3){
        cell.collectionDataList = [NSMutableArray arrayWithArray:self.anjianArray1];
    }
    
    [cell reloadData];

    QDFWeakSelf;
    [cell setDidSelectedItem:^(NSInteger items) {
        if (indexPath.section == 0) {//起诉书
            if (items == self.qisuArray1.count-1) {
                if (self.qisuArray1.count < 5) {
                    [weakself addImageWithMaxSelection:1 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
                        NSData *iData = [[NSData alloc] initWithContentsOfFile:images[0]];
                        NSString *dataString = [NSString stringWithFormat:@"%@",iData];
                        [weakself uploadImages:dataString andType:@"qisu" andFilePath:images[0]];
                    }];
                }else{
                    [self showHint:@"最多添加4张"];
                }
            }
        }else if (indexPath.section == 1){//财产保全申请书
            if (items == self.caichanArray1.count-1) {
                if (self.caichanArray1.count < 5) {
                    [weakself addImageWithMaxSelection:1 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
                        NSData *iData = [[NSData alloc] initWithContentsOfFile:images[0]];
                        NSString *dataString = [NSString stringWithFormat:@"%@",iData];
                        [weakself uploadImages:dataString andType:@"caichan" andFilePath:images[0]];
                    }];
                }else{
                    [self showHint:@"最多添加4张"];
                }
            }
        }else if (indexPath.section == 2){//相关证据材料
            if (items == self.zhengjuArray1.count-1) {
                if (self.zhengjuArray1.count < 5) {
                    [weakself addImageWithMaxSelection:1 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
                        NSData *iData = [[NSData alloc] initWithContentsOfFile:images[0]];
                        NSString *dataString = [NSString stringWithFormat:@"%@",iData];
                        [weakself uploadImages:dataString andType:@"zhengju" andFilePath:images[0]];
                    }];
                }else{
                    [self showHint:@"最多添加4张"];
                }
            }
        }else if (indexPath.section == 3){//案件受理通知书
            if (items == self.anjianArray1.count-1) {
                if (self.anjianArray1.count < 5) {
                    [weakself addImageWithMaxSelection:1 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
                        NSData *iData = [[NSData alloc] initWithContentsOfFile:images[0]];
                        NSString *dataString = [NSString stringWithFormat:@"%@",iData];
                        [weakself uploadImages:dataString andType:@"anjian" andFilePath:images[0]];
                    }];
                }else{
                    [self showHint:@"最多添加4张"];
                }
            }
        }
     }];
    
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

#pragma mark - method
- (void)uploadImages:(NSString *)imgData andType:(NSString *)imgType andFilePath:(NSString *)filePath
{
    NSString *uploadsString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kUploadImagesString];
    NSDictionary *params = @{@"filetype" : @"1",
                             @"extension" : @"jpg",
                             @"picture" : imgData
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:uploadsString params:params successBlock:^(id responseObject) {
        
        ImageModel *imageModel = [ImageModel objectWithKeyValues:responseObject];
        
        if ([imageModel.code isEqualToString:@"0000"]) {
            if ([imgType isEqualToString:@"qisu"]) {//起诉书
                [weakself.qisuArray addObject:imageModel.fileid];
                [weakself.qisuArray1 insertObject:filePath atIndex:0];
            }else if ([imgType isEqualToString:@"caichan"]){//财产
                [weakself.caichanArray addObject:imageModel.fileid];
                [weakself.caichanArray1 insertObject:filePath atIndex:0];
            }else if ([imgType isEqualToString:@"zhengju"]){//证据
                [weakself.zhengjuArray addObject:imageModel.fileid];
                [weakself.zhengjuArray1 insertObject:filePath atIndex:0];
            }else if ([imgType isEqualToString:@"anjian"]){//案件
                [weakself.anjianArray addObject:imageModel.fileid];
                [weakself.anjianArray1 insertObject:filePath atIndex:0];
            }
            
            [weakself.powerPictureTableView reloadData];
            
        }else{
            [weakself showHint:imageModel.msg];
        }
    } andFailBlock:^(NSError *error) {
        
    }];
}

- (void)saveAdditionalImages
{
    NSString *qisuStr = @"";
    for (int i=0; i<self.qisuArray.count; i++) {//起诉书
        NSString *qisuStr1 = self.qisuArray[i];
        qisuStr = [NSString stringWithFormat:@"%@,%@",qisuStr1,qisuStr];
    }
    
    NSString *caichanStr = @"";
    for (int i=0; i<self.caichanArray.count; i++) {//财产
        NSString *caichanStr1 = self.caichanArray[i];
        caichanStr = [NSString stringWithFormat:@"%@,%@",caichanStr1,caichanStr];
    }
    
    NSString *zhengjuStr = @"";
    for (int i=0; i<self.zhengjuArray.count; i++) {//证据
        NSString *zhengjuStr1 = self.zhengjuArray[i];
        zhengjuStr = [NSString stringWithFormat:@"%@,%@",zhengjuStr1,zhengjuStr];
    }
    
    NSString *anjianStr = @"";
    for (int i=0; i<self.anjianArray.count; i++) {//案件
        NSString *anjianStr1 = self.anjianArray[i];
        anjianStr = [NSString stringWithFormat:@"%@,%@",anjianStr1,anjianStr];
    }
    
    NSString *saveImageString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPowerAdditionalMessageString];
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"qisu" : qisuStr,
                             @"caichan" : caichanStr,
                             @"zhengju" : zhengjuStr,
                             @"anjian" : anjianStr,
                             @"id" : self.pModel.idString
                             };
    [self requestDataPostWithString:saveImageString params:params successBlock:^(id responseObject) {
       
        BaseModel *model = [BaseModel objectWithKeyValues:responseObject];
        [self showHint:model.msg];
        if ([model.code isEqualToString:@"0000"]) {
            [self back];
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
