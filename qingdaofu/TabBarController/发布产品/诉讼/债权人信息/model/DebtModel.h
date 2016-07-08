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
@property (nonatomic,copy) NSString *creditorname;
@property (nonatomic,copy) NSString *creditormobile;
@property (nonatomic,copy) NSString *creditoraddress;
@property (nonatomic,copy) NSString *creditorcardcode;
@property (nonatomic,copy) NSString *creditorcardimages;
@property (nonatomic,strong) NSMutableArray *creditorcardimage;

//债务人信息
@property (nonatomic,copy) NSString *borrowingname;
@property (nonatomic,copy) NSString *borrowingmobile;
@property (nonatomic,copy) NSString *borrowingaddress;
@property (nonatomic,copy) NSString *borrowingcardcode;
@property (nonatomic,copy) NSString *borrowingcardimages;
@property (nonatomic,strong) NSMutableArray *borrowingcardimage;

//债权文件
@property (nonatomic,strong) NSArray *imgnotarization;  //公证书
@property (nonatomic,strong) NSArray *imgcontract;//借款合同
@property (nonatomic,strong) NSArray *imgcreditor;//他项权证
@property (nonatomic,strong) NSArray *imgpick;//收款凭证
@property (nonatomic,strong) NSArray *imgbenjin;//收据
@property (nonatomic,strong) NSArray *imgshouju;//还款凭证
@property (nonatomic,copy) NSString *imgnotarizations;


@end
