//
//  EditUpTableView.m
//  qingdaofu
//
//  Created by zhixiang on 16/11/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "EditUpTableView.h"
#import "AgentCell.h"
#import "BidOneCell.h"

#import "PublishCombineView.h"
#import "BaseCommitView.h"
#import "BaseCommitButton.h"

@implementation EditUpTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorColor = kSeparateColor;
        self.backgroundColor = kBackColor;
        self.tableFooterView = [[UIView alloc] init];
    }
    return self;
}

- (NSArray *)upwardDataList
{
    if (!_upwardDataList) {
        _upwardDataList = [NSArray array];
    }
    return _upwardDataList;
}

- (NSLayoutConstraint *)heightTableConstraints
{
    if (!_heightTableConstraints) {
        _heightTableConstraints = [self autoSetDimension:ALDimensionHeight toSize:0];
    }
    return _heightTableConstraints;
}

#pragma mark - delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.category isEqualToString:@"房产抵押"]) {
        return 3;
    }
    return 2;
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
            identifier = @"house0";
            BidOneCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[BidOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSString *titie = [NSString stringWithFormat:@"%@%@",self.type,self.category];
            [cell.oneButton setTitle:titie forState:0];
            
            [cell.sureButton setImage:[UIImage imageNamed:@"deletes"] forState:0];
            
            QDFWeakSelf;
            [cell.sureButton addAction:^(UIButton *btn) {
                if (weakself.didSelectedBtn) {
                    weakself.didSelectedBtn(51);
                }
            }];

            return cell;
        }else if (indexPath.row == 1) {
            //选择省份
            identifier = @"house1";
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
            
        }else if (indexPath.row == 2){
            //填写详细地址
            identifier = @"house2";
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([self.type isEqualToString:@"添加"]) {//BaseCommitButton
        UIView  *footerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        
        BaseCommitButton *addButton = [BaseCommitButton newAutoLayoutView];
        [addButton setTitle:@"保存" forState:0];
        [footerView1 addSubview:addButton];
        
        [addButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:footerView1 withOffset:kBigPadding];
        [addButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:footerView1 withOffset:-kBigPadding];
        [addButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:footerView1 withOffset:-kBigPadding];
        [addButton autoSetDimension:ALDimensionHeight toSize:kCellHeight];
        
        QDFWeakSelf;
        [addButton addAction:^(UIButton *btn) {
            if (weakself.didSelectedBtn) {
                weakself.didSelectedBtn(53);
            }
        }];
        
        return footerView1;
    }else if ([self.type isEqualToString:@"编辑"]){//,PublishCombineView
        UIView *footerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        
        PublishCombineView *combileView = [PublishCombineView newAutoLayoutView];
        [combileView.comButton1 setTitle:@"保存" forState:0];
        [combileView.comButton1 setBackgroundColor:kButtonColor];
        
        [combileView.comButton2 setTitle:@"删除" forState:0];
        [combileView.comButton2 setTitleColor:kRedColor forState:0];
        combileView.comButton2.layer.borderColor = kRedColor.CGColor;
        combileView.comButton2.layer.borderWidth = kLineWidth;
        [footerView2 addSubview:combileView];
        
        QDFWeakSelf;
        [combileView.comButton1 addAction:^(UIButton *btn) {
            if (weakself.didSelectedBtn) {
                weakself.didSelectedBtn(54);
            }
        }];
        
        [combileView.comButton2 addAction:^(UIButton *btn) {
            if (weakself.didSelectedBtn) {
                weakself.didSelectedBtn(55);
            }
        }];
        
        
        return footerView2;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        if (self.didSelectedBtn) {
            self.didSelectedBtn(52);
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
