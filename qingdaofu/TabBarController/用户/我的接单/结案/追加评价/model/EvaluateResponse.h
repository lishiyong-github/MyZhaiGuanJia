//
//  EvaluateResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"

@interface EvaluateResponse : BaseModel

@property (nonatomic,copy) NSString *creditor;  //评价方得评价平均分数
@property (nonatomic,copy) NSString *creditors;  //被评人得到的评价平均分数
@property (nonatomic,copy) NSString *evalua;  //评价次数
@property (nonatomic,strong) NSMutableArray *evaluate; //收到的评价（发布方）
@property (nonatomic,strong) NSMutableArray *launchevaluation; //给出的评价(接单方)
@property (nonatomic,copy) NSString *uid;  //登陆人的UID


@property (nonatomic,strong) NSMutableArray *Comments1;  //评价集
@property (nonatomic,copy) NSString *commentsScore;  //综合评分


@end
