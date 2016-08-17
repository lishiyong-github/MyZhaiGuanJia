//
//  PowerCourtView.m
//  qingdaofu
//
//  Created by zhixiang on 16/8/17.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PowerCourtView.h"
#import "CourtProvinceModel.h"

@interface PowerCourtView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@end

@implementation PowerCourtView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.finishButton];
        [self addSubview:self.pickerViews];
        
        self.typeComponent = @"1";
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.finishButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.finishButton autoSetDimension:ALDimensionHeight toSize:kCellHeight];
        
        [self.pickerViews autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.pickerViews autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.finishButton];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)finishButton
{
    if (!_finishButton) {
        _finishButton = [UIButton newAutoLayoutView];
        [_finishButton setTitle:@"完成" forState:0];
        [_finishButton setTitleColor:kBlackColor forState:0];
        _finishButton.titleLabel.font = kFirstFont;
        _finishButton.layer.borderColor = kBorderColor.CGColor;
        _finishButton.layer.borderWidth = kLineWidth;
        _finishButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kBigPadding);
        _finishButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        QDFWeakSelf;
        [_finishButton addAction:^(UIButton *btn) {
            if (weakself.didSelectdRow) {
                weakself.didSelectdRow(2,0,nil);
            }
        }];
    }
    return _finishButton;
}

- (UIPickerView *)pickerViews
{
    if (!_pickerViews) {
        _pickerViews = [UIPickerView newAutoLayoutView];
        _pickerViews.delegate = self;
        _pickerViews.dataSource = self;
    }
    return _pickerViews;
}

- (NSMutableArray *)component1
{
    if (!_component1) {
        _component1 = [NSMutableArray array];
    }
    return _component1;
}

- (NSMutableArray *)component2
{
    if (!_component2) {
        _component2 = [NSMutableArray array];
    }
    return _component2;
}

#pragma mark - delegate and datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([self.typeComponent integerValue] == 1) {
        return 1;
    }
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.component1.count;
    }
    
    return self.component2.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        CourtProvinceModel *model = self.component1[row];
        return model.name;
    }
    
    CourtProvinceModel *model = self.component2[row];
    return model.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (self.didSelectdRow) {
        if (component == 0) {
            self.didSelectdRow(component,row,self.component1[row]);
        }else{
            self.didSelectdRow(component,row,self.component2[row]);
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
