//
//  EvaluateModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/14.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;
@class ImageModel;

@interface EvaluateModel : NSObject  //收到的评价

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
@property (nonatomic,copy) NSString *action_by; //评价人
@property (nonatomic,copy) NSString *action_at; //评价时间
@property (nonatomic,copy) NSString *zuiping; //追评数量
@property (nonatomic,strong) NSString *userinfo; //被评人
@property (nonatomic,strong) NSArray *files;
@property (nonatomic,strong) NSArray *pictures;



///////评价人信息
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *picture;
@property (nonatomic,strong) ImageModel *headimg;  //图片


//@property (nonatomic,copy) NSString *creditor;  //评价方得评价平均分数
//@property (nonatomic,copy) NSString *buid;  //
//@property (nonatomic,copy) NSString *cuid;
//@property (nonatomic,copy) NSString *category;  //产品类型
//@property (nonatomic,copy) NSString *code;  //产品编号
//@property (nonatomic,copy) NSString *content; //评价内容
//@property (nonatomic,copy) NSString *contents; //追加评价内容
//@property (nonatomic,copy) NSString *create_time;// 评价时间
//@property (nonatomic,copy) NSString *create_times;// 追加评价时间
//@property (nonatomic,copy) NSString *gaoxiao;//
//@property (nonatomic,copy) NSString *idString;//
//@property (nonatomic,copy) NSString *isHide;//
//@property (nonatomic,copy) NSString *kuaijie;//
//@property (nonatomic,copy) NSString *mobile;  //手机号
//@property (nonatomic,copy) NSString *mobiles;  //手机号
//@property (nonatomic,copy) NSString *picture;//评价图片
//@property (nonatomic,strong) NSArray *pictures; //图片列表
//@property (nonatomic,copy) NSString *pid;//
//@property (nonatomic,copy) NSString *product_id;//
//@property (nonatomic,copy) NSString *professionalknowledge;//
//@property (nonatomic,copy) NSString *serviceattitude;//
//@property (nonatomic,copy) NSString *sid;//
//@property (nonatomic,copy) NSString *superaddition;//
//@property (nonatomic,copy) NSString *uidInner;//
//@property (nonatomic,copy) NSString *workefficiency;//
//@property (nonatomic,copy) NSString *youzhi;//
//@property (nonatomic,copy) NSString *zhuanye;//
//
//@property (nonatomic,copy) NSString *frequency; //评价次数

@end
