//
//  AgentCell.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "AgentCell.h"

@implementation AgentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.agentLabel];
        [self.contentView addSubview:self.agentTextField];
        [self.contentView addSubview:self.agentButton];
        
        self.leftdAgentContraints = [self.agentTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:90];
        
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.agentLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kBigPadding];
        [self.agentLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [self.agentTextField autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.agentLabel];
        [self.agentTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kBigPadding];
        
        [self.agentButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kSmallPadding];
        [self.agentButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.agentTextField];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UILabel *)agentLabel
{
    if (!_agentLabel) {
        _agentLabel = [UILabel newAutoLayoutView];
        _agentLabel.textColor = kBlackColor;
        _agentLabel.font = kBigFont;
    }
    return _agentLabel;
}

- (UITextField *)agentTextField
{
    if (!_agentTextField) {
        _agentTextField = [UITextField newAutoLayoutView];
        _agentTextField.textColor = kBlackColor;
        _agentTextField.font = kFirstFont;
    }
    return _agentTextField;
}

- (UIButton *)agentButton
{
    if (!_agentButton) {
        _agentButton = [UIButton newAutoLayoutView];
        [_agentButton setTitleColor:kBlueColor forState:0];
        _agentButton.titleLabel.font = kSecondFont;
        [_agentButton swapImage];
    }
    return _agentButton;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
