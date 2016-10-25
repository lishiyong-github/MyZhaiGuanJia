//
//  MessageResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/25.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"

@interface MessageResponse : BaseModel

@property (nonatomic,strong) NSMutableArray *data;  //数据集
@property (nonatomic,copy) NSString *systemCount;  //未读
@property (nonatomic,copy) NSString *totalCount; //总共
@property (nonatomic,copy) NSString *curCount;  //当前
@property (nonatomic,copy) NSString *pageSize;  //当前返回数据数目
@property (nonatomic,copy) NSString *curpage;  //当前页
@property (nonatomic,copy) NSString *userid;

@end
