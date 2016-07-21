//
//  MessageModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/7/4.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CategoryModel;

@interface MessageModel : NSObject

@property (nonatomic,copy) NSString *belonguid;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *idStr;
@property (nonatomic,copy) NSString *isRead;
//@property (nonatomic,copy) NSString *params;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *uidInner;
@property (nonatomic,copy) NSString *uri;
@property (nonatomic,strong) CategoryModel *category_id;
@property (nonatomic,copy) NSString *progress_status;  //状态
@property (nonatomic,copy) NSString *frequency;  //评价次数

@end
