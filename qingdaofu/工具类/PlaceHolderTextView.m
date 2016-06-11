//
//  PlaceHolderTextView.m
//  qingdaofu
//
//  Created by zhixiang on 16/5/19.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "PlaceHolderTextView.h"

static float topMargin = 8;
static float leftMargin = 6;

@implementation PlaceHolderTextView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configDefault];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configDefault];
    }
    return self;
}

- (void)configDefault {
    if (!self.font) {
        self.font = [UIFont systemFontOfSize:14.0];
    }
    self.displayPlaceHolder = YES;
    self.placeholderColor = [UIColor grayColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChaneNotification:) name:UITextViewTextDidChangeNotification object:self];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    if (self.text.length == 0 && self.displayPlaceHolder && self.placeholder && self.placeholderColor ) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = self.textAlignment;
        [self.placeholder drawInRect:CGRectMake(leftMargin, topMargin + self.contentInset.top, self.frame.size.width-self.contentInset.left - self.contentInset.right - leftMargin, self.frame.size.height - self.contentInset.bottom - topMargin) withAttributes:@{NSFontAttributeName:self.font, NSForegroundColorAttributeName:self.placeholderColor, NSParagraphStyleAttributeName:paragraphStyle}];
    }
}

- (void)textDidChaneNotification:(NSNotification *)notification {
    if (notification.object == self) {
        [self setNeedsDisplay];
    }
}

-(void)setText:(NSString *)text{
    [super setText:text];
    [self setNeedsDisplay];
}

-(void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

- (void)setDisplayPlaceHolder:(BOOL)displayPlaceHolder {
    _displayPlaceHolder = displayPlaceHolder;
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
