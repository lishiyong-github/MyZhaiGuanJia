//
//  ApplicationSuccessViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/7/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "ApplicationSuccessViewController.h"

#import "ApplicationListViewController.h"//我的保函
#import "PowerProtectListViewController.h" //我的保权

#import "ApplicationSuccessCell.h"

@interface ApplicationSuccessViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *appSuccessTableView;
@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation ApplicationSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提交成功";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kNavColor} forState:0];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlueColor} forState:0];
    
    [self.view addSubview:self.appSuccessTableView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)finish
{
    UINavigationController *nav = self.navigationController;
    [nav popViewControllerAnimated:NO];
    [nav popViewControllerAnimated:NO];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.appSuccessTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)appSuccessTableView
{
    if (!_appSuccessTableView) {
        _appSuccessTableView = [UITableView newAutoLayoutView];
        _appSuccessTableView.delegate = self;
        _appSuccessTableView.dataSource = self;
        _appSuccessTableView.separatorColor = kSeparateColor;
        _appSuccessTableView.backgroundColor = kBackColor;
    }
    return _appSuccessTableView;
}

#pragma mark -tableview delegate and datasoyrce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"apps";
    ApplicationSuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ApplicationSuccessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *str1 = [NSString stringWithFormat:@"%@信息",self.successType];
    NSString *str2 = [NSString stringWithFormat:@"您可以在我的%@里查看%@的处理状态",self.successType,self.successType];
    NSString *str = [NSString stringWithFormat:@"%@\n%@",str1,str2];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributeStr addAttributes:@{NSFontAttributeName:kBigFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, str1.length)];
    [attributeStr addAttributes:@{NSFontAttributeName:kSecondFont,NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(str1.length+1, str2.length)];
    
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:6];
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];
    [cell.appLabel2 setAttributedText:attributeStr];
    
    NSString *appTitle = [NSString stringWithFormat:@"我的%@",self.successType];
    [cell.appButton2 setTitle:appTitle forState:0];
    
    QDFWeakSelf;
    [cell.appButton1 addAction:^(UIButton *btn) {
        NSLog(@"回首页");
        UINavigationController *nav = self.navigationController;
        [nav popViewControllerAnimated:NO];
        [nav popViewControllerAnimated:NO];
    }];
    
    [cell.appButton2 addAction:^(UIButton *btn) {
        NSLog(@"我的保函");
        if ([self.successType isEqualToString:@"保函"]) {
            ApplicationListViewController *applicationListVC = [[ApplicationListViewController alloc] init];
            [weakself.navigationController pushViewController:applicationListVC animated:YES];
        }else{
            NSLog(@"我的保权");
//            PowerProtectListViewController
            PowerProtectListViewController *powerListVC = [[PowerProtectListViewController alloc] init];
            [weakself.navigationController pushViewController:powerListVC animated:YES];
        }
    }];
    
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
