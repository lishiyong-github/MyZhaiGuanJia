//
//  UIButton+Block.m
//  qingdaofu
//
//  Created by zhixiang on 16/4/27.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>

@implementation UIButton (Block)

static char actionTag;

- (void)addAction:(ButtonBlock)block
{
    objc_setAssociatedObject(self, &actionTag, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)action:(id)sender
{
    ButtonBlock blockAction = objc_getAssociatedObject(self, &actionTag);
    if (blockAction) {
        blockAction(self);
    }
}

@end
