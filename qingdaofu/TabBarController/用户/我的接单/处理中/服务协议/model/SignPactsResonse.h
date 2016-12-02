//
//  SignPactsResonse.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/27.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"

@interface SignPactsResonse : BaseModel

@property (nonatomic,copy) NSString *OrdersStatus; //接单当前状态
@property (nonatomic,assign) BOOL accessOrdersORDERCOMFIRM; //可否协议确认权限
@property (nonatomic,strong) NSMutableArray *pacts;//图片内容集

@end
