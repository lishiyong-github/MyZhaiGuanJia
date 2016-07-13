//
//  SuggestionViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "SuggestionViewController.h"

#import "AgentCell.h"
#import "TakePictureCell.h"
#import "TextFieldCell.h"
#import "BaseCommitButton.h"

#import "UIViewController+MutipleImageChoice.h"

@interface SuggestionViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *suggestTableView;
@property (nonatomic,strong) BaseCommitButton *suggestCommitButton;

@property (nonatomic,strong) NSMutableDictionary *suggestsDictionary;
@property (nonatomic,strong) NSMutableDictionary *suggestImageDic;

@end

@implementation SuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"意见反馈";
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self setupForDismissKeyboard];
    
    [self.view addSubview:self.suggestTableView];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.suggestTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)suggestTableView
{
    if (!_suggestTableView) {
        _suggestTableView.translatesAutoresizingMaskIntoConstraints = YES;
        _suggestTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _suggestTableView.backgroundColor = kBackColor;
        _suggestTableView.delegate = self;
        _suggestTableView.dataSource = self;
        _suggestTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
        [_suggestTableView.tableFooterView addSubview:self.suggestCommitButton];
    }
    return _suggestTableView;
}

- (BaseCommitButton *)suggestCommitButton
{
    if (!_suggestCommitButton) {
        _suggestCommitButton = [[BaseCommitButton alloc] initWithFrame:CGRectMake(kBigPadding, kBigPadding, kScreenWidth-kBigPadding*2, 40)];
        [_suggestCommitButton setTitle:@"提交" forState:0];
        [_suggestCommitButton addTarget:self action:@selector(commitSuggests) forControlEvents:UIControlEventTouchUpInside];
    }
    return _suggestCommitButton;
}

- (NSMutableDictionary *)suggestsDictionary
{
    if (!_suggestsDictionary) {
        _suggestsDictionary = [NSMutableDictionary dictionary];
    }
    return _suggestsDictionary;
}

- (NSMutableDictionary *)suggestImageDic
{
    if (!_suggestImageDic) {
        _suggestImageDic = [NSMutableDictionary dictionary];
    }
    return _suggestImageDic;
}
#pragma mark - tabelView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 2;
//    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            return 70;
//        }else{
//            return 80;
//        }
        return 150;
    }
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            identifier = @"suggest00";
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textField.placeholder = @"请详细描述您的问题或建议，您的反馈是我们前进最大的动力";
            cell.textField.font = kSecondFont;
            
            QDFWeakSelf;
            [cell setDidEndEditing:^(NSString *text) {
                [weakself.suggestsDictionary setValue:text forKey:@"opinion"];
            }];
            
            return cell;
        }
        
//        identifier = @"suggest01";
//        TakePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        
//        if (!cell) {
//            cell = [[TakePictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.collectionDataList = [NSMutableArray arrayWithObject:@"btn_camera"];
//        
//        QDFWeakSelf;
//        QDFWeak(cell);
//        [cell setDidSelectedItem:^(NSInteger item) {
//            [weakself addImageWithMaxSelection:4 andMutipleChoise:YES andFinishBlock:^(NSArray *images) {
//                weakcell.collectionDataList = [NSMutableArray arrayWithArray:images];
//                [weakcell reloadData];
//                [weakself.suggestImageDic setValue:images forKey:@""];
//            }];
//        }];
//
//        return cell;
    }
    identifier = @"suggest1";
    AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.agentLabel setHidden:YES];
    [cell.agentButton setHidden:YES];
    cell.leftdAgentContraints.constant = kBigPadding;
    
    cell.agentTextField.placeholder = @"手机号码/邮箱（选填，方便我们联系您）";
    cell.agentTextField.font = kSecondFont;
    
    QDFWeakSelf;
    [cell setDidEndEditing:^(NSString *text) {
        [weakself.suggestsDictionary setValue:text forKey:@"phone"];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return kBigPadding;
    }
    return 0.1f;
}

#pragma mark - method
- (void)commitSuggests
{
    [self.view endEditing:YES];
    NSString *suggestionString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kSuggestionString];
    self.suggestsDictionary[@"opinion"] = self.suggestsDictionary[@"opinion"]?self.suggestsDictionary[@"opinion"]:@"";
    self.suggestsDictionary[@"phone"] = self.suggestsDictionary[@"phone"]?self.suggestsDictionary[@"phone"]:@"";

    NSDictionary *params = @{@"phone" : self.suggestsDictionary[@"phone"],
                             @"opinion" : self.suggestsDictionary[@"opinion"],
                             @"token" : [self getValidateToken],
                             @"picture" : @""
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:suggestionString params:params andImages:nil successBlock:^(id responseObject) {
        BaseModel *suggestModel = [BaseModel objectWithKeyValues:responseObject];
        [weakself showHint:suggestModel.msg];
        
        if ([suggestModel.code isEqualToString:@"0000"]) {
            [weakself.navigationController popViewControllerAnimated:YES];
        }
    } andFailBlock:^(NSError *error) {
        
    }];
    
    
    
    
    
    
    /*
    [self requestDataPostWithString:suggestionString params:params successBlock:^(id responseObject){
        BaseModel *suggestModel = [BaseModel objectWithKeyValues:responseObject];
        [self showHint:suggestModel.msg];
        
        if ([suggestModel.code isEqualToString:@"0000"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } andFailBlock:^(NSError *error){
        
    }];
     */
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
