//
//  NetworkViewController.h
//  qingdaofu
//
//  Created by zhixiang on 16/1/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ImageModel.h"

@interface NetworkViewController : BaseViewController

@property (nonatomic,strong) void (^didGetValidImage)(ImageModel *imageModel);

- (void)postOfRequestDataWithString:(NSString *)string params:(NSDictionary *)params successBlock:(void (^)(id responseObject))successBlock andFailBlock:(void (^)(NSError *error))failBlock;

-(void)requestDataPostWithString:(NSString *)string params:(NSDictionary *)params successBlock:(void(^)(id responseObject))successBlock andFailBlock:(void(^)(NSError *error))failBlock;

- (void)uploadImages:(NSString *)imgData andType:(NSString *)imgType andFilePath:(NSString *)filePath;

@end
