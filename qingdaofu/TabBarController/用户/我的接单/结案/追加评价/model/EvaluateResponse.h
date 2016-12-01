//
//  EvaluateResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"

@interface EvaluateResponse : BaseModel

@property (nonatomic,strong) NSMutableArray *evaluate; //收到的评价（发布方）

@property (nonatomic,strong) NSMutableArray *Comments1;  //评价集(评价)
@property (nonatomic,strong) NSMutableArray *Comments2;  //追评
@property (nonatomic,copy) NSString *commentsScore;  //综合评分


@end
