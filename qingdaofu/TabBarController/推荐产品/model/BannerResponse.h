//
//  BannerResponse.h
//  qingdaofu
//
//  Created by zhixiang on 16/12/1.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"

@interface BannerResponse : BaseModel

@property (nonatomic,strong) NSMutableArray *banner;//banner图

@property (nonatomic,strong) NSMutableArray *ad; //启动页的图片
@property (nonatomic,copy) NSString *duration;  //启动图间隔时间

@end
