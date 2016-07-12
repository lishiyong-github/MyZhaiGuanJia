//
//  UploadViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/6/20.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "UploadViewController.h"

#import "TakePictureCell.h"
#import "BaseCommitButton.h"

#import "UIViewController+MutipleImageChoice.h"
#import "UIViewController+ImageBrowser.h"
#import "FSBasicImage.h"
#import "FSBasicImageSource.h"
#import "FSImageViewerViewController.h"

@interface UploadViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *upTableView;
@property (nonatomic,strong) BaseCommitButton *upCommitButton;

@property (nonatomic,strong) DebtModel *allImageModel;
@property (nonatomic,strong) NSArray *allImageArray;
@property (nonatomic,strong) NSString *allImageStrings;

@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"上传%@",self.typeString];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    self.allImageModel = [[DebtModel alloc] init];
    
    [self.view addSubview:self.upTableView];
    [self.view addSubview:self.upCommitButton];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.upTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.upTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kTabBarHeight];
        
        [self.upCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.upCommitButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.upTableView];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)upTableView
{
    if (!_upTableView) {
        _upTableView = [UITableView newAutoLayoutView];
        _upTableView.delegate = self;
        _upTableView.dataSource = self;
        _upTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBigPadding)];
        _upTableView.backgroundColor = kBackColor;
    }
    return _upTableView;
}

- (BaseCommitButton *)upCommitButton
{
    if (!_upCommitButton) {
        _upCommitButton = [BaseCommitButton newAutoLayoutView];
        [_upCommitButton setTitle:@"上传" forState:0];
        
        QDFWeakSelf;
        [_upCommitButton addAction:^(UIButton *btn) {
            [weakself addImageWithFinishBlock:^(NSArray *images) {

                if (images.count > 0) {
                    NSData *tData;
                    NSString *ttt = @"";
                    NSString *tStr = @"";
                    for (int i=0; i<images.count; i++) {
                        tData = [NSData dataWithContentsOfFile:images[i]];
                        ttt = [NSString stringWithFormat:@"%@",tData];
                        tStr = [NSString stringWithFormat:@"%@,%@",tStr,ttt];
                    }
                    weakself.allImageStrings = tStr;
                    weakself.allImageArray = images;
                    
                    //存储数据
                    if (self.typeUpInt == 0) {
                        weakself.allImageModel.imgnotarization = [NSMutableArray arrayWithArray:images];
                        weakself.allImageModel.imgnotarizations = tStr;
                    }else if (self.typeUpInt == 1){
                        weakself.allImageModel.imgcontract = [NSMutableArray arrayWithArray:images];
                        weakself.allImageModel.imgcontracts = tStr;
                    }else if (self.typeUpInt == 2){
                        weakself.allImageModel.imgcreditor = [NSMutableArray arrayWithArray:images];
                        weakself.allImageModel.imgcreditors = tStr;
                    }else if (self.typeUpInt == 3){
                        weakself.allImageModel.imgpick = [NSMutableArray arrayWithArray:images];
                        weakself.allImageModel.imgpicks = tStr;
                    }else if (self.typeUpInt == 4){
                        weakself.allImageModel.imgbenjin = [NSMutableArray arrayWithArray:images];
                        weakself.allImageModel.imgbenjins = tStr;
                    }else if (self.typeUpInt == 5){
                        weakself.allImageModel.imgshouju = [NSMutableArray arrayWithArray:images];
                        weakself.allImageModel.imgshoujus = tStr;
                    }
                    
                    TakePictureCell *cell = [weakself.upTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                    cell.pictureCollection.backgroundColor = kBackColor;
                    cell.collectionDataList = [NSMutableArray arrayWithArray:images];
                    [cell reloadData];
                }
            }];
        }];
    }
    return _upCommitButton;
}

#pragma mark - delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenHeight-kNavHeight-kTabBarHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"upImage";
    TakePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[TakePictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.typeUpInt == 0) {//公证书
        self.allImageArray = self.filesModel.imgnotarization;
    }else if (self.typeUpInt == 1){
        self.allImageArray = self.filesModel.imgcontract;
    }else if (self.typeUpInt == 2){
        self.allImageArray = self.filesModel.imgcreditor;
    }else if (self.typeUpInt == 3){
        self.allImageArray = self.filesModel.imgpick;
    }else if (self.typeUpInt == 4){
        self.allImageArray = self.filesModel.imgbenjin;
    }else{
        self.allImageArray = self.filesModel.imgshouju;
    }
    self.allImageModel  = self.filesModel;
    cell.collectionDataList = [NSMutableArray arrayWithArray:self.allImageArray];
    
    [cell reloadData];
    
    //展示图片
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
    
    return cell;
}

#pragma mark - editImages
- (void)back
{
    if (self.allImageArray.count > 0) {
        if (self.uploadImages) {
            self.uploadImages(self.allImageArray,self.allImageStrings,self.allImageModel);
        }
    }else{
        if (self.uploadImages) {
            self.uploadImages(self.allImageArray,self.allImageStrings,self.filesModel);
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
