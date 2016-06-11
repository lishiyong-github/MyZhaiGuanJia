//
//  ResultModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/6.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Certification;

@interface ResultModel : NSObject

@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *user;
@property (nonatomic,strong) Certification *certification;
@end
