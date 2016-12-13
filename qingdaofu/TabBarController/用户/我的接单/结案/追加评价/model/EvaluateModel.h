//
//  EvaluateModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ImageModel;

@interface EvaluateModel : NSObject  //收到的评价

@property (nonatomic,copy) NSString *action_by; //评价人
@property (nonatomic,copy) NSString *action_at; //评价时间
@property (nonatomic,copy) NSString *commentid;  //评价id
@property (nonatomic,copy) NSString *productid;
@property (nonatomic,copy) NSString *ordersid;
@property (nonatomic,copy) NSString *type; //1-普通，2-追评
@property (nonatomic,copy) NSString *touid; //被评价人
@property (nonatomic,copy) NSString *tocommentid; //被评价评论ID
@property (nonatomic,copy) NSString *truth_score; //真实性
@property (nonatomic,copy) NSString *assort_score; // 配合度
@property (nonatomic,copy) NSString *response_score; //响应度
@property (nonatomic,copy) NSString *memo; //评价内容
@property (nonatomic,copy) NSString *zuiping; //追评数量
@property (nonatomic,copy) NSString *userinfo; //被评人
@property (nonatomic,strong) NSArray *filesImg;//图片


///////评价人信息
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *picture;
@property (nonatomic,strong) ImageModel *headimg;  //图片

@end
