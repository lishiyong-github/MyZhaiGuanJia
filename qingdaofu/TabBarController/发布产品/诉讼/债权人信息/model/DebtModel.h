//
//  DebtModel.h
//  qingdaofu
//
//  Created by zhixiang on 16/6/24.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DebtModel : NSObject

//债权人信息
@property (nonatomic,copy) NSString *creditorname;  //姓名
@property (nonatomic,copy) NSString *creditormobile; //电话
@property (nonatomic,copy) NSString *creditoraddress; //地址
@property (nonatomic,copy) NSString *creditorcardcode; //律所编号
@property (nonatomic,copy) NSString *creditorcardimages; //上传图片形式
@property (nonatomic,strong) NSMutableArray *creditorcardimage;//获取图片的形式

//债务人信息
@property (nonatomic,copy) NSString *borrowingname;//姓名
@property (nonatomic,copy) NSString *borrowingmobile;//电话
@property (nonatomic,copy) NSString *borrowingaddress;//地址
@property (nonatomic,copy) NSString *borrowingcardcode;//律所编号
@property (nonatomic,copy) NSString *borrowingcardimages;//上传图片的格式
@property (nonatomic,strong) NSMutableArray *borrowingcardimage;//获取图片的格式

//债权文件
@property (nonatomic,strong) NSArray *imgnotarization;  //公证书
@property (nonatomic,strong) NSArray *imgcontract;//借款合同
@property (nonatomic,strong) NSArray *imgcreditor;//他项权证
@property (nonatomic,strong) NSArray *imgpick;//收款凭证
@property (nonatomic,strong) NSArray *imgshouju;//收据
@property (nonatomic,strong) NSArray *imgbenjin;//还款凭证
@property (nonatomic,copy) NSString *imgnotarizations;
@property (nonatomic,copy) NSString *imgcontracts;
@property (nonatomic,copy) NSString *imgcreditors;
@property (nonatomic,copy) NSString *imgpicks;
@property (nonatomic,copy) NSString *imgshoujus;
@property (nonatomic,copy) NSString *imgbenjins;


@end
