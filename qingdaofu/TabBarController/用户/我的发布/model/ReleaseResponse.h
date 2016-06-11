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

@property (nonatomic,strong) CreditorModel *creditor;
@property (nonatomic,copy) NSString *page;
@property (nonatomic,strong) NSMutableArray *rows;

@end
