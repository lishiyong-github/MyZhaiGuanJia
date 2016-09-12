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
#import "UIViewController+ImageBrowser.h"
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
@property (nonatomic,strong) NSDictionary *exampleDic;

@end

@implementation PowerProtectPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完善资料";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看示例" style:UIBarButtonItemStylePlain target:self action:@selector(viewExample)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self.view addSubview:self.powerPictureTableView];
    [self.view addSubview:self.powerPictureButton];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)viewExample
{
    if (self.exampleDic.allKeys.count == 0) {
        NSString *viewExampleString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kViewExampleString];
        NSDictionary *params = @{@"token" : [self getValidateToken]};
        
        QDFWeakSelf;
        [self requestDataPostWithString:viewExampleString params:params successBlock:^(id responseObject) {
            NSDictionary *sisis = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            weakself.exampleDic = sisis;
            
            NSArray *pArray = [NSArray arrayWithObjects:sisis[@"baodan1ios"],sisis[@"baodan2ios"],sisis[@"baodan3ios"], nil];
            NSArray *aArray = [NSArray arrayWithObjects:sisis[@"baohan1ios"], nil];
            
            if (weakself.pModel) {//保权
                [weakself showImages:pArray];
            }else if (weakself.aModel){//保函
                [weakself showImages:aArray];
            }
            
        } andFailBlock:^(NSError *error) {
            
        }];
    }else{
        NSArray *pArray = [NSArray arrayWithObjects:self.exampleDic[@"baodan1ios"],self.exampleDic[@"baodan2ios"],self.exampleDic[@"baodan3ios"], nil];
        NSArray *aArray = [NSArray arrayWithObjects:self.exampleDic[@"baohan1ios"], nil];
        
        if (self.pModel) {//保权
            [self showImages:pArray];
        }else if (self.aModel){//保函
            [self showImages:aArray];
        }
    }
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
        _powerPictureTableView.separatorColor = kSeparateColor;
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
        [_powerPictureButton addTarget:self action:@selector(saveAdditionalImages) forControlEvents:UIControlEventTouchUpInside];
    }
    return _powerPictureButton;
}

- (NSMutableArray *)qisuArray
{
    if (!_qisuArray) {
        _qisuArray = [NSMutableArray array];
        
        if ([self.navTitleString isEqualToString:@"保全"]) {
            if (self.pModel.qisus.count > 0) {
                NSMutableArray *aa = [NSMutableArray array];
                for (NSInteger i=0; i<self.pModel.qisus.count; i++) {
                    ImageModel *imaModel = self.pModel.qisus[i];
                    [aa addObject:imaModel.idString];
                }
                _qisuArray = [NSMutableArray arrayWithArray:aa];
            }
        }else if ([self.navTitleString isEqualToString:@"保函"]){
            if (self.aModel.qisus.count > 0) {
                NSMutableArray *aa = [NSMutableArray array];
                for (NSInteger i=0; i<self.aModel.qisus.count; i++) {
                    ImageModel *imaModel = self.aModel.qisus[i];
                    [aa addObject:imaModel.idString];
                }
                _qisuArray = [NSMutableArray arrayWithArray:aa];
            }
        }
    }
    return _qisuArray;
}

- (NSMutableArray *)caichanArray
{
    if (!_caichanArray) {
        _caichanArray = [NSMutableArray array];
        
        if ([self.navTitleString isEqualToString:@"保全"]) {
            if (self.pModel.caichans.count > 0) {
                NSMutableArray *bb = [NSMutableArray array];
                for (NSInteger i=0; i<self.pModel.caichans.count; i++) {
                    ImageModel *imaModel = self.pModel.caichans[i];
                    [bb addObject:imaModel.idString];
                }
                _caichanArray = [NSMutableArray arrayWithArray:bb];
            }
        }else if ([self.navTitleString isEqualToString:@"保函"]){
            if (self.aModel.caichans.count > 0) {
                NSMutableArray *bb = [NSMutableArray array];
                for (NSInteger i=0; i<self.aModel.caichans.count; i++) {
                    ImageModel *imaModel = self.aModel.caichans[i];
                    [bb addObject:imaModel.idString];
                }
                _caichanArray = [NSMutableArray arrayWithArray:bb];
            }
        }
    }
    return _caichanArray;
}

- (NSMutableArray *)zhengjuArray
{
    if (!_zhengjuArray) {
        _zhengjuArray = [NSMutableArray array];
        
        if ([self.navTitleString isEqualToString:@"保全"]) {
            if (self.pModel.zhengjus.count > 0) {
                NSMutableArray *cc = [NSMutableArray array];
                for (NSInteger i=0; i<self.pModel.zhengjus.count; i++) {
                    ImageModel *imaModel = self.pModel.zhengjus[i];
                    [cc addObject:imaModel.idString];
                }
                _zhengjuArray = [NSMutableArray arrayWithArray:cc];
            }
        }else if ([self.navTitleString isEqualToString:@"保函"]){
            if (self.aModel.zhengjus.count > 0) {
                NSMutableArray *cc = [NSMutableArray array];
                for (NSInteger i=0; i<self.aModel.zhengjus.count; i++) {
                    ImageModel *imaModel = self.aModel.zhengjus[i];
                    [cc addObject:imaModel.idString];
                }
                _zhengjuArray = [NSMutableArray arrayWithArray:cc];
            }
        }
    }
    return _zhengjuArray;
}

- (NSMutableArray *)anjianArray
{
    if (!_anjianArray) {
        _anjianArray = [NSMutableArray array];
        
        if ([self.navTitleString isEqualToString:@"保全"]) {
            if (self.pModel.anjians.count > 0) {
                NSMutableArray *dd = [NSMutableArray array];
                for (NSInteger i=0; i<self.pModel.anjians.count; i++) {
                    ImageModel *imaModel = self.pModel.anjians[i];
                    [dd addObject:imaModel.idString];
                }
                _anjianArray = [NSMutableArray arrayWithArray:dd];
            }
        }else if ([self.navTitleString isEqualToString:@"保函"]){
            if (self.aModel.anjians.count > 0) {
                NSMutableArray *dd = [NSMutableArray array];
                for (NSInteger i=0; i<self.aModel.anjians.count; i++) {
                    ImageModel *imaModel = self.aModel.anjians[i];
                    [dd addObject:imaModel.idString];
                }
                _anjianArray = [NSMutableArray arrayWithArray:dd];
            }
        }
    }
    return _anjianArray;
}

- (NSMutableArray *)qisuArray1
{
    if (!_qisuArray1) {
        
        if ([self.navTitleString isEqualToString:@"保全"]) {
            if (self.pModel.qisus.count > 0) {
                NSMutableArray *aaaa = [NSMutableArray array];
                for (NSInteger i=0; i<self.pModel.qisus.count; i++) {
                    ImageModel *imaModel = self.pModel.qisus[i];
                    NSString *files = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imaModel.file];
                    [aaaa addObject:files];
                }
                _qisuArray1 = [NSMutableArray arrayWithArray:aaaa];
                [_qisuArray1 addObject:@"upload_pictures"];
            }else{
                _qisuArray1 = [NSMutableArray arrayWithObject:@"upload_pictures"];
            }
        }else if ([self.navTitleString isEqualToString:@"保函"]){
            if (self.aModel.qisus.count > 0) {
                NSMutableArray *aaaa = [NSMutableArray array];
                for (NSInteger i=0; i<self.aModel.qisus.count; i++) {
                    ImageModel *imaModel = self.aModel.qisus[i];
                    NSString *files = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imaModel.file];
                    [aaaa addObject:files];
                }
                _qisuArray1 = [NSMutableArray arrayWithArray:aaaa];
                [_qisuArray1 addObject:@"upload_pictures"];
            }else{
                _qisuArray1 = [NSMutableArray arrayWithObject:@"upload_pictures"];
            }
        }
    }
    return _qisuArray1;
}
- (NSMutableArray *)caichanArray1
{
    if (!_caichanArray1) {
        
        if ([self.navTitleString isEqualToString:@"保全"]) {
            if (self.pModel.caichans.count > 0) {
                NSMutableArray *bbbb = [NSMutableArray array];
                for (NSInteger i=0; i<self.pModel.caichans.count; i++) {
                    ImageModel *imaModel = self.pModel.caichans[i];
                    NSString *files = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imaModel.file];
                    [bbbb addObject:files];
                }
                _caichanArray1 = [NSMutableArray arrayWithArray:bbbb];
                [_caichanArray1 addObject:@"upload_pictures"];
            }else{
                _caichanArray1 = [NSMutableArray arrayWithObject:@"upload_pictures"];
            }
        }else if ([self.navTitleString isEqualToString:@"保函"]){
            if (self.aModel.caichans.count > 0) {
                NSMutableArray *bbbb = [NSMutableArray array];
                for (NSInteger i=0; i<self.aModel.caichans.count; i++) {
                    ImageModel *imaModel = self.aModel.caichans[i];
                    NSString *files = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imaModel.file];
                    [bbbb addObject:files];
                }
                _caichanArray1 = [NSMutableArray arrayWithArray:bbbb];
                [_caichanArray1 addObject:@"upload_pictures"];
            }else{
                _caichanArray1 = [NSMutableArray arrayWithObject:@"upload_pictures"];
            }
        }
    }
    return _caichanArray1;
}

- (NSMutableArray *)zhengjuArray1
{
    if (!_zhengjuArray1) {
        
        if ([self.navTitleString isEqualToString:@"保全"]) {
            if (self.pModel.zhengjus.count > 0) {
                NSMutableArray *cccc = [NSMutableArray array];
                for (NSInteger i=0; i<self.pModel.zhengjus.count; i++) {
                    ImageModel *imaModel = self.pModel.zhengjus[i];
                    NSString *files = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imaModel.file];
                    [cccc addObject:files];
                }
                _zhengjuArray1 = [NSMutableArray arrayWithArray:cccc];
                [_zhengjuArray1 addObject:@"upload_pictures"];
            }else{
                _zhengjuArray1 = [NSMutableArray arrayWithObject:@"upload_pictures"];
            }
        }else if ([self.navTitleString isEqualToString:@"保函"]){
            if (self.aModel.zhengjus.count > 0) {
                NSMutableArray *cccc = [NSMutableArray array];
                for (NSInteger i=0; i<self.aModel.zhengjus.count; i++) {
                    ImageModel *imaModel = self.aModel.zhengjus[i];
                    NSString *files = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imaModel.file];
                    [cccc addObject:files];
                }
                _zhengjuArray1 = [NSMutableArray arrayWithArray:cccc];
                [_zhengjuArray1 addObject:@"upload_pictures"];
            }else{
                _zhengjuArray1 = [NSMutableArray arrayWithObject:@"upload_pictures"];
            }
        }
    }
    return _zhengjuArray1;
}

- (NSMutableArray *)anjianArray1
{
    if (!_anjianArray1) {
        
        if ([self.navTitleString isEqualToString:@"保全"]) {
            if (self.pModel.anjians.count > 0) {
                NSMutableArray *dddd = [NSMutableArray array];
                for (NSInteger i=0; i<self.pModel.anjians.count; i++) {
                    ImageModel *imaModel = self.pModel.anjians[i];
                    NSString *files = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imaModel.file];
                    [dddd addObject:files];
                }
                _anjianArray1 = [NSMutableArray arrayWithArray:dddd];
                [_anjianArray1 addObject:@"upload_pictures"];
            }else{
                _anjianArray1 = [NSMutableArray arrayWithObject:@"upload_pictures"];
            }
        }else if ([self.navTitleString isEqualToString:@"保函"]){
            if (self.aModel.anjians.count > 0) {
                NSMutableArray *dddd = [NSMutableArray array];
                for (NSInteger i=0; i<self.aModel.anjians.count; i++) {
                    ImageModel *imaModel = self.aModel.anjians[i];
                    NSString *files = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,imaModel.file];
                    [dddd addObject:files];
                }
                _anjianArray1 = [NSMutableArray arrayWithArray:dddd];
                [_anjianArray1 addObject:@"upload_pictures"];
            }else{
                _anjianArray1 = [NSMutableArray arrayWithObject:@"upload_pictures"];
            }
        }
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
            if (items == weakself.qisuArray1.count-1) {
                if (weakself.qisuArray1.count < 5) {
                    [weakself addImageWithMaxSelection:1 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
                        
                        if (images.count > 0) {
                            NSData *iData = [[NSData alloc] initWithContentsOfFile:images[0]];
                            NSString *dataString = [NSString stringWithFormat:@"%@",iData];
                            [weakself uploadImages:dataString andType:@"qisu" andFilePath:images[0]];
                            
                        }
                    }];
                }else{
                    [weakself showHint:@"最多添加4张"];
                }
            }else{
                [weakself deleteOneImageWithType:@"qisu" andIndex:items];
            }
        }else if (indexPath.section == 1){//财产保全申请书
            if (items == weakself.caichanArray1.count-1) {
                if (weakself.caichanArray1.count < 5) {
                    [weakself addImageWithMaxSelection:1 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
                        
                        if (images.count > 0) {
                            NSData *iData = [[NSData alloc] initWithContentsOfFile:images[0]];
                            NSString *dataString = [NSString stringWithFormat:@"%@",iData];
                            [weakself uploadImages:dataString andType:@"caichan" andFilePath:images[0]];
                        }
                    }];
                }else{
                    [weakself showHint:@"最多添加4张"];
                }
            }else{
                [weakself deleteOneImageWithType:@"caichan" andIndex:items];
            }
        }else if (indexPath.section == 2){//相关证据材料
            if (items == weakself.zhengjuArray1.count-1) {
                if (weakself.zhengjuArray1.count < 5) {
                    [weakself addImageWithMaxSelection:1 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
                        
                        if (images.count > 0) {
                            NSData *iData = [[NSData alloc] initWithContentsOfFile:images[0]];
                            NSString *dataString = [NSString stringWithFormat:@"%@",iData];
                            [weakself uploadImages:dataString andType:@"zhengju" andFilePath:images[0]];
                            
                        }
                        
                    }];
                }else{
                    [weakself showHint:@"最多添加4张"];
                }
            }else{
                [weakself deleteOneImageWithType:@"zhengju" andIndex:items];
            }
        }else if (indexPath.section == 3){//案件受理通知书
            if (items == weakself.anjianArray1.count-1) {
                if (weakself.anjianArray1.count < 5) {
                    [weakself addImageWithMaxSelection:1 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
                        
                        if (images.count > 0) {
                            NSData *iData = [[NSData alloc] initWithContentsOfFile:images[0]];
                            NSString *dataString = [NSString stringWithFormat:@"%@",iData];
                            [weakself uploadImages:dataString andType:@"anjian" andFilePath:images[0]];
                            
                        }
                        
                    }];
                }else{
                    [weakself showHint:@"最多添加4张"];
                }
            }else{
                [weakself deleteOneImageWithType:@"anjian" andIndex:items];
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
        return 30;
    }
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        footerView.backgroundColor = kBackColor;
        
        UIButton *footerButton = [UIButton newAutoLayoutView];
        [footerButton setImage:[UIImage imageNamed:@"tip_message"] forState:0];
        [footerButton setTitle:@"  请确保提供的材料真实性和完整性，同时我们会保护您的隐私" forState:0];
        [footerButton setTitleColor:kLightGrayColor forState:0];
        footerButton.titleLabel.font = kTabBarFont;
        [footerButton setContentHorizontalAlignment:1];
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
    
    NSString *idSSS;
    NSString *saveImageString;
    if ([self.navTitleString isEqualToString:@"保全"]) {
        idSSS = self.pModel.idString;
        saveImageString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kPowerAdditionalMessageString];
    }else if ([self.navTitleString isEqualToString:@"保函"]){
        idSSS = self.aModel.idString;
        saveImageString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kApplicationAdditionalMessageString];
    }
    
    NSDictionary *params = @{@"token" : [self getValidateToken],
                             @"qisu" : qisuStr,
                             @"caichan" : caichanStr,
                             @"zhengju" : zhengjuStr,
                             @"anjian" : anjianStr,
                             @"id" : idSSS
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

- (void)deleteOneImageWithType:(NSString *)type andIndex:(NSInteger)index
{
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"" message:@"确认删除该图片?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    QDFWeakSelf;
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"是" style:0 handler:^(UIAlertAction * _Nonnull action) {
        if ([type isEqualToString:@"qisu"]) {//起诉
            [weakself.qisuArray removeObjectAtIndex:index];
            [weakself.qisuArray1 removeObjectAtIndex:index];
        }else if ([type isEqualToString:@"caichan"]){
            [weakself.caichanArray removeObjectAtIndex:index];
            [weakself.caichanArray1 removeObjectAtIndex:index];
        }else if ([type isEqualToString:@"zhengju"]){
            [weakself.zhengjuArray removeObjectAtIndex:index];
            [weakself.zhengjuArray1 removeObjectAtIndex:index];
        }else if ([type isEqualToString:@"anjian"]){
            [weakself.anjianArray removeObjectAtIndex:index];
            [weakself.anjianArray1 removeObjectAtIndex:index];
        }
        [weakself.powerPictureTableView reloadData];
    }];
    
    UIAlertAction *act0 = [UIAlertAction actionWithTitle:@"否" style:0 handler:nil];
    
    [alertCon addAction:act0];
    [alertCon addAction:act1];
    
    [self presentViewController:alertCon animated:YES completion:nil];
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
