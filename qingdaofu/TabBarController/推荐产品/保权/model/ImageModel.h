//
//  ImageModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/8/19.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseModel.h"

@interface ImageModel : BaseModel

@property (nonatomic,copy) NSString *fileid; //图片id
@property (nonatomic,copy) NSString *name;   //图片名字
@property (nonatomic,copy) NSString *size;  //图片大小
@property (nonatomic,copy) NSString *type;  // 图片类型
@property (nonatomic,copy) NSString *url;  //图片下载地址

//列表里的图片
@property (nonatomic,copy) NSString *file;
@property (nonatomic,copy) NSString *idString;

@end
