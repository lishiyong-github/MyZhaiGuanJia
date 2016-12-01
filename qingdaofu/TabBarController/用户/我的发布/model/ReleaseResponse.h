//
//  ReleaseResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/6.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"
@class CreditorModel;

@interface ReleaseResponse : BaseModel

/////////
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,copy) NSString *sum;  //累计交易总量

@end
