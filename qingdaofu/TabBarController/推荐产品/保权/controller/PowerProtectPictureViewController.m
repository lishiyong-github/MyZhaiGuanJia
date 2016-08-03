//
//  PowerProtectPictureViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PowerProtectPictureViewController.h"

#import "UIViewController+MutipleImageChoice.h"
#import "TakePictureCell.h"

@interface PowerProtectPictureViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *powerPictureTableView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation PowerProtectPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.navTitleString;
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(sddd)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kFirstFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self.view addSubview:self.powerPictureTableView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)sddd
{
    
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.powerPictureTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
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

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenHeight-kNavHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"upImage";
    TakePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[TakePictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /*
    if (self.typeUpInt == 0) {//公证书
        self.allImageArray = self.filesModel.imgnotarization;
    }else if (self.typeUpInt == 1){
        self.allImageArray = self.filesModel.imgcontract;
    }else if (self.typeUpInt == 2){
        self.allImageArray = self.filesModel.imgcreditor;
    }else if (self.typeUpInt == 3){
        self.allImageArray = self.filesModel.imgpick;
    }else if (self.typeUpInt == 4){
        self.allImageArray = self.filesModel.imgshouju;
    }else{
        self.allImageArray = self.filesModel.imgbenjin;
    }
    self.allImageModel  = self.filesModel;
    
     
    if ([self.tagString integerValue] == 1) {//首次编辑
        cell.collectionDataList = [NSMutableArray arrayWithArray:self.allImageArray];
        
    }else{//再次编辑
        if (self.allImageArray.count == 0) {
            cell.collectionDataList = [NSMutableArray arrayWithArray:@[]];
        }else if ((self.allImageArray.count == 1) && [self.allImageArray[0] isEqualToString:@""]){
            cell.collectionDataList = [NSMutableArray arrayWithArray:@[]];
        }else{
            for (int i=0; i<self.allImageArray.count; i++) {
                NSString *huhStr = self.allImageArray[i];
                NSString *subStr = [huhStr substringWithRange:NSMakeRange(1, huhStr.length-2)];
                NSString *urlStr = [NSString stringWithFormat:@"%@%@",kQDFTestImageString,subStr];
                NSURL *Url = [NSURL URLWithString:urlStr];
                [cell.collectionDataList addObject:Url];
            }
        }
    }
    */
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
