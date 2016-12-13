//
//  CheckEvaluateResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/12/13.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckEvaluateResponse : NSObject

@property (nonatomic,strong) NSMutableArray *Comments1;  //评价集(评价)
@property (nonatomic,copy) NSString *commentsScore;  //综合评分

@end
