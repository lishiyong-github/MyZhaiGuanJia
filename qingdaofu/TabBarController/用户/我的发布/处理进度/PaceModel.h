//
//  PaceModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaceModel : NSObject

@property (nonatomic,copy) NSString *audit;   //案号类型
@property (nonatomic,copy) NSString *caseString;//案号
@property (nonatomic,copy) NSString *category;
@property (nonatomic,copy) NSString *content;  //详情
@property (nonatomic,copy) NSString *create_time;  //
@property (nonatomic,copy) NSString *product_id;
@property (nonatomic,copy) NSString *status;   //处置类型
@property (nonatomic,copy) NSString *idString;

@end
