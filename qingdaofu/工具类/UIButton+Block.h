//
//  UIButton+Block.h
//  qingdaofu
//
//  Created by zhixiang on 16/4/27.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonBlock)(UIButton *btn);

@interface UIButton (Block)

- (void)addAction:(ButtonBlock)block;


@end
