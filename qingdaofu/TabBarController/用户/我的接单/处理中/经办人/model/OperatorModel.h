//
//  OperatorModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/21.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperatorModel : NSObject

@property (nonatomic,copy) NSString *level;//1-第一级，2-第二级
@property (nonatomic,copy) NSString *owner;  //从属标志

@end
