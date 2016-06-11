//
//  UIButton+Addition.m
//  qingdaofu
//
//  Created by shiyong_li on 16/5/10.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "UIButton+Addition.h"

@implementation UIButton (Addition)
- (void)swapImage
{
    self.transform = CGAffineTransformRotate(self.transform, M_PI);
    self.titleLabel.transform = CGAffineTransformRotate(self.titleLabel.transform, M_PI);
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI);
}
@end
