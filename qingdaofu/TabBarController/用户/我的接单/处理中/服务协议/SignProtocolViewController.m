//
//  SignProtocolViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/10/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "SignProtocolViewController.h"
#import "PublishCombineView.h"

#import "MineUserCell.h"

@interface SignProtocolViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstarints;
@property (nonatomic,strong) UITableView *sighProtocolTableView;
@property (nonatomic,strong) PublishCombineView *signCommitButton;

@end

@implementation SignProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签约协议图片";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.sighProtocolTableView];
    [self.view addSubview:self.signCommitButton];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstarints) {
        
        [self.sighProtocolTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.sighProtocolTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.signCommitButton];
        
        [self.signCommitButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.signCommitButton autoSetDimension:ALDimensionHeight toSize:116];
        
        self.didSetupConstarints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)sighProtocolTableView
{
    if (!_sighProtocolTableView) {
        _sighProtocolTableView = [UITableView newAutoLayoutView];
        _sighProtocolTableView.backgroundColor = kBackColor;
        _sighProtocolTableView.separatorColor = kSeparateColor;
        _sighProtocolTableView.delegate = self;
        _sighProtocolTableView.dataSource = self;
        _sighProtocolTableView.tableFooterView = [[UIView alloc] init];
    }
    return _sighProtocolTableView;
}

- (PublishCombineView *)signCommitButton
{
    if (!_signCommitButton) {
        _signCommitButton = [PublishCombineView newAutoLayoutView];
        [_signCommitButton.comButton1 setBackgroundColor:kButtonColor];
        [_signCommitButton.comButton1 setTitleColor:kWhiteColor forState:0];
        [_signCommitButton.comButton1 setTitle:@"保存" forState:0];
        [_signCommitButton.comButton2 setTitle:@"确认上传并开始尽职调查" forState:0];
        _signCommitButton.comButton2.layer.borderColor = kBorderColor.CGColor;
        _signCommitButton.comButton2.layer.borderWidth = kLineWidth;
        [_signCommitButton.comButton2 setTitleColor:kLightGrayColor forState:0];
        
        QDFWeakSelf;
        [_signCommitButton.comButton1 addAction:^(UIButton *btn) {
            [weakself showHint:@"保存"];
            [weakself back];
        }];
        
        [_signCommitButton.comButton2 addAction:^(UIButton *btn) {
            [weakself showHint:@"确认上传并开始尽职调查"];
            UIAlertController *signAlert = [UIAlertController alertControllerWithTitle:@"确认协议无误并上传吗？" message:@"确认后协议不能修改，并开始尽职调查" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *signAct0 = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
                [weakself back];
            }];
            
            UIAlertAction *signAct1 = [UIAlertAction actionWithTitle:@"取消" style:0 handler:nil];
            [signAlert addAction:signAct0];
            [signAlert addAction:signAct1];
            [weakself presentViewController:signAlert animated:YES completion:nil];
        }];
    }
    return _signCommitButton;
}

#pragma mark - tableView delagate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return kCellHeight;
    }
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
//    = @"sign";
    if (indexPath.row == 0) {
        identifier = @"sign0";
        MineUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MineUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kBackColor;
        [cell.userActionButton setHidden:YES];
        [cell.userNameButton setTitle:@"协议照片" forState:0];

        return cell;
    }
    
    identifier = @"sign1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kWhiteColor;
    
    return cell;
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
