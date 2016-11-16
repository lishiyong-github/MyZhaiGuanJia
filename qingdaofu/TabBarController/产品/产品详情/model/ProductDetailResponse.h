//
//  ProductDetailResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/11/16.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"
@class ProductDetailModel;

@interface ProductDetailResponse : BaseModel

@property (nonatomic,strong)  ProductDetailModel *data;

@end
