//
//  NetworkViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/1/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TokenModel.h"
#import "ImageModel.h"

@interface NetworkViewController : BaseViewController

@property (nonatomic,strong) void (^didTokenValid)(TokenModel *tokenModel);
@property (nonatomic,strong) void (^didGetValidImage)(ImageModel *imageModel);

- (void)tokenIsValid;

-(void)requestDataPostWithString:(NSString *)string params:(NSDictionary *)params successBlock:(void(^)(id responseObject))successBlock andFailBlock:(void(^)(NSError *error))failBlock;

//- (void)requestDataPostWithString:(NSString *)string params:(NSDictionary *)params andImages:(NSDictionary *)images successBlock:(void (^)(id responseObject))successBlock andFailBlock:(void (^)(NSError *error))failBlock;//image ;{key:array};

- (void)uploadImages:(NSString *)imgData andType:(NSString *)imgType andFilePath:(NSString *)filePath;

@end
