//
//  MessagesModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/10/25.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ImageModel;

@interface MessagesModel : NSObject

@property (nonatomic,copy) NSString *belonguid;
@property (nonatomic,copy) NSString *content;  //恭喜您认证成功，你可以发布信息或者处置
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *idString;
@property (nonatomic,copy) NSString *isRead;

//关联id
@property (nonatomic,copy) NSString *relaid;
@property (nonatomic,copy) NSString *relatitle;
@property (nonatomic,copy) NSString *relatype;

@property (nonatomic,copy) NSString *timeLabel;  //11天前
@property (nonatomic,copy) NSString *title;  //认证成功
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *uri;
@property (nonatomic,copy) NSString *validflag;

@property (nonatomic,strong) ImageModel *headimg;  //显示图像

@end
