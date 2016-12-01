//
//  ImageResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/12/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"
@class ImageModel;

@interface ImageResponse : BaseModel

@property (nonatomic,strong) ImageModel *result;

@end
