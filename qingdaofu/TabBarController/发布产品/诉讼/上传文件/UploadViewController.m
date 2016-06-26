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

#import "FSBasicImage.h"
#import "FSBasicImageSource.h"
#import "FSImageViewerViewController.h"

@interface UploadViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *upTableView;
@property (nonatomic,strong) BaseCommitButton *upCommitButton;
@property (nonatomic,strong) UIButton *rightButton;

@property (nonatomic,strong) NSArray *allImage;

@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
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

                NSLog(@"选择图片");
                
                if (images.count > 0) {
                    weakself.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:weakself.rightButton];
                    
                    TakePictureCell *cell = [weakself.upTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                    cell.pictureCollection.backgroundColor = kBackColor;
                    cell.collectionDataList = [NSMutableArray arrayWithArray:images];
                    
//                    weakself.allImage = images;
                    NSString *str;
                    for (int i=0; i<[images count]; i++) {
                        str = [str stringByAppendingString:images[i]];
                    }
                    
                    NSLog(@"str is %@",str);
                    
                    weakself.allImage = images;
                    
                    [cell reloadData];
                }
                
            }];
        }];
    }
    return _upCommitButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
        [_rightButton setTitle:@"编辑" forState:0];
        [_rightButton setTitle:@"取消" forState:UIControlStateSelected];
        _rightButton.titleLabel.font = kBigFont;
        [_rightButton setTitleColor:kBlueColor forState:0];
        
        QDFWeakSelf;
        [_rightButton addAction:^(UIButton *btn) {
            btn.selected = !btn.selected;
            
            if (btn.selected) {
                [weakself.upCommitButton setBackgroundColor:kNavColor];
                [weakself.upCommitButton setTitle:@"删除" forState:0];
                [weakself.upCommitButton setTitleColor:kRedColor forState:0];
            }else{
                [weakself.upCommitButton setBackgroundColor:kBlueColor];
                [weakself.upCommitButton setTitle:@"上传" forState:0];
                [weakself.upCommitButton setTitleColor:kNavColor forState:0];
            }
        }];
    }
    return _rightButton;
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
    
    //展示图片
    QDFWeakSelf;
    [cell setDidSelectedItem:^(NSInteger itemTag) {
        FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:weakself.allImage];
        FSImageViewerViewController *browser = [[FSImageViewerViewController alloc] initWithImageSource:photoSource imageIndex:itemTag];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:browser];
        [weakself presentViewController:nav animated:YES completion:nil];
    }];
    
    return cell;
}

#pragma mark - editImages
- (void)editImages:(NSArray *)imageArray
{
    
}

- (void)back
{
    [super back];
    if (self.uploadImages) {
        self.uploadImages(self.allImage);
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
