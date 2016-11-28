//
//  EditMessageViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/11/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "EditMessageViewController.h"

#import "AgentCell.h"

#import "BaseCommitButton.h"//保存删除按钮
#import "PublishCombineView.h"

@interface EditMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL didSetupConstraints;
@property (nonatomic,strong) UITableView *editMessageTableView;
@property (nonatomic,strong) BaseCommitButton *saveCommitButton;//单纯的保存按钮
@property (nonatomic,strong) PublishCombineView *saveOrDeleteButton; //保存删除按钮

@end

@implementation EditMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@%@",self.type,self.category];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
    [self.view addSubview:self.editMessageTableView];
    [self.view addSubview:self.saveCommitButton];
    [self.view addSubview:self.saveOrDeleteButton];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.editMessageTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (UITableView *)editMessageTableView
{
    if (!_editMessageTableView) {
        _editMessageTableView = [UITableView newAutoLayoutView];
        _editMessageTableView.delegate = self;
        _editMessageTableView.dataSource = self;
        _editMessageTableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _editMessageTableView;
}

#pragma mark - delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.category isEqualToString:@"房产抵押"]) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if ([self.category isEqualToString:@"房产抵押"]) {
        if (indexPath.row == 0) {
            //选择省份
            identifier = @"house0";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.agentLabel.text = @"选择区域";
            cell.agentTextField.placeholder = @"请选择";
            cell.agentTextField.userInteractionEnabled = NO;
            [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
            cell.agentButton.userInteractionEnabled = NO;

            return cell;
            
        }else if (indexPath.row == 1){
            //填写详细地址
            identifier = @"house1";
            AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.agentLabel.text = @"详细地址";
            cell.agentTextField.placeholder = @"请输入";
            [cell.agentButton setHidden:YES];
            
            return cell;
        }
    }else{//合同纠纷，机动车抵押
        //选择省份
        identifier = @"car0";
        AgentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AgentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.agentTextField.userInteractionEnabled = NO;
        [cell.agentButton setImage:[UIImage imageNamed:@"list_more"] forState:0];
        cell.agentButton.userInteractionEnabled = NO;
        
        if ([self.category isEqualToString:@"机动车抵押"]) {
            cell.agentLabel.text = @"选择机动车品牌";
            cell.agentTextField.placeholder = @"请选择";
        }else if ([self.category isEqualToString:@"合同纠纷"]){
            cell.agentLabel.text = @"选择类型";
            cell.agentTextField.placeholder = @"请选择";
        }
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
