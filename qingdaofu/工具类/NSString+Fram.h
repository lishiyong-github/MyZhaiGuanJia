//
//  NSString+Fram.h
//  qingdaofu
//
//  Created by zhixiang on 16/4/28.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Fram)

- (CGSize)re_sizeWithFont:(UIFont *)font;
- (CGSize)re_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end
