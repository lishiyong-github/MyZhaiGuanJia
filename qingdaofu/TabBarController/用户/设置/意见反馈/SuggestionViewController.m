//
//  SuggestionViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/3.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "SuggestionViewController.h"

#import "EditDebtAddressCell.h"
//#import "EditDebtCell.h"

#import "AgentCell.h"
#import "TakePictureCell.h"
#import "TextFieldCell.h"
#import "BaseCommitButton.h"

@interface SuggestionViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *suggestTableView;
@property (nonatomic,strong) BaseCommitButton *suggestCommitButton;

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
//        _suggestTableView = [UITableView newAutoLayoutView];
        _suggestTableView.translatesAutoresizingMaskIntoConstraints = NO;
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
        
        QDFWeakSelf;
        [_suggestCommitButton addAction:^(UIButton *btn) {
            NSLog(@"提交");
            
            NSString *suggestionString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kSuggestionString];
            NSDictionary *params = @{@"phone" : @"13162521916",
                                     @"opinion" : @"有事找有事找",
                                     @"token" : [weakself getValidateToken]
                                     };
            [weakself requestDataPostWithString:suggestionString params:params successBlock:^(id responseObject){
                BaseModel *suggestModel = [BaseModel objectWithKeyValues:responseObject];
                [weakself showHint:suggestModel.msg];
                if ([suggestModel.code isEqualToString:@"0000"]) {
                    [weakself.navigationController popViewControllerAnimated:YES];
                }
                
            } andFailBlock:^(NSError *error){
                
            }];
            
        }];
    }
    return _suggestCommitButton;
}

#pragma mark - tabelView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 70;
        }else{
            return 80;
        }
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
            
            return cell;
        }
        
        identifier = @"suggest01";
        TakePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[TakePictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell.editImageButton1.label setHidden:YES];
//        [cell.editImageButton2.label setHidden:YES];

        return cell;
    }
    identifier = @"suggest1";
    AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.leftdAgentContraints.constant = kBigPadding;
    cell.agentTextField.placeholder = @"手机号码/邮箱（选填，方便我们联系您）";
    cell.agentTextField.font = kSecondFont;
    
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
