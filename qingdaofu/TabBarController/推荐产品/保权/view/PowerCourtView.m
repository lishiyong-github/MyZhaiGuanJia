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
        
        self.backgroundColor = UIColorFromRGB1(0x333333, 0.3);
        self.tag = 1111;
        
        [self addSubview:self.finishButton];
        [self addSubview:self.pickerViews];
        [self addSubview:self.controllio];
        
        self.typeComponent = @"1";
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.finishButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.pickerViews];
        [self.finishButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.finishButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.finishButton autoSetDimension:ALDimensionHeight toSize:40];
        
        [self.pickerViews autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.pickerViews autoSetDimension:ALDimensionHeight toSize:160];
        
        [self.controllio autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [self.controllio autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.finishButton];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

- (UIButton *)finishButton
{
    if (!_finishButton) {
        _finishButton = [UIButton newAutoLayoutView];
        _finishButton.backgroundColor = kNavColor;
        [_finishButton setTitle:@"完成" forState:0];
        [_finishButton setTitleColor:kBlackColor forState:0];
        _finishButton.titleLabel.font = kFirstFont;
        _finishButton.layer.borderColor = kBorderColor.CGColor;
        _finishButton.layer.borderWidth = kLineWidth;
        _finishButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kBigPadding);
        _finishButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        QDFWeakSelf;
        
        [_finishButton addAction:^(UIButton *btn) {
            [weakself hiddenDateViewscc];
            
            if ([weakself.publishStr isEqualToString:@"3"]) {
                if (weakself.didSelectedComponent) {
                    weakself.didSelectedComponent(3,0,nil,nil);
                }
            }else{
                
                if (weakself.didSelectdRow) {
                    weakself.didSelectdRow(2,0,nil);
                }
            }
        }];
    }
    return _finishButton;
}

- (UIPickerView *)pickerViews
{
    if (!_pickerViews) {
        _pickerViews = [UIPickerView newAutoLayoutView];
        _pickerViews.backgroundColor = kNavColor;
        _pickerViews.delegate = self;
        _pickerViews.dataSource = self;
    }
    return _pickerViews;
}

- (UIControl *)controllio
{
    if (!_controllio) {
        _controllio = [UIControl newAutoLayoutView];
        [_controllio addTarget:self action:@selector(hiddenDateViewscc) forControlEvents:UIControlEventTouchUpInside];
    }
    return _controllio;
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

- (void)hiddenDateViewscc
{
    UIView *ioCView = [self viewWithTag:1111];
    [ioCView setHidden:YES];

}

#pragma mark - delegate and datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([self.publishStr isEqualToString:@"3"]) {
        if ([self.typeComponent integerValue] == 1) {
            return 1;
        }else if ([self.typeComponent integerValue] == 2){
            return 2;
        }
        return 3;
    }
    
    if ([self.typeComponent integerValue] == 1) {
        return 1;
    }else if ([self.typeComponent integerValue] == 2){
        return 2;
    }
    return 0;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([self.publishStr isEqualToString:@"3"]) {//3列
        if (component == 0) {
            return self.componentDic1.allKeys.count;
        }else if (component == 1){
            return self.componentDic2.allKeys.count;
        }
        return self.componentDic3.allKeys.count;
    }
    
    if (component == 0) {
        return self.component1.count;
    }else if (component == 1){
        return self.component2.count;
    }
    
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([self.publishStr isEqualToString:@"3"]) {
        if (component == 0) {
//            CourtProvinceModel *model = self.component1[row];
//            return model.name;
           return self.componentDic1.allValues[row];
        }else if (component == 1){
//            CourtProvinceModel *model = self.component2[row];
//            return model.name;
           return self.componentDic2.allValues[row];

        }
//        CourtProvinceModel *model = self.component2[row];
//        return model.name;
        return self.componentDic3.allValues[row];
    }
    
    if (component == 0) {
        CourtProvinceModel *model = self.component1[row];
        return model.name;
    }else if (component == 1){
        CourtProvinceModel *model = self.component2[row];
        return model.name;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.publishStr isEqualToString:@"3"]) {
        if (self.didSelectedComponent) {
            if (component == 0) {
                self.didSelectedComponent(component,row,self.componentDic1.allKeys[row],self.componentDic1.allValues[row]);
            }else if(component == 1){
                self.didSelectedComponent(component,row,self.componentDic2.allKeys[row],self.componentDic2.allValues[row]);
            }else{
                self.didSelectedComponent(component,row,self.componentDic3.allKeys[row],self.componentDic3.allValues[row]);
            }
        }
    }
    
    //保全页面
    if (self.didSelectdRow) {
        if (component == 0) {
            self.didSelectdRow(component,row,self.component1[row]);
        }else if(component == 1){
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
