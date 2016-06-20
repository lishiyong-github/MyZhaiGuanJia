//
//  NetworkViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/1/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "NetworkViewController.h"
#import "MBProgressHUD.h"

@interface NetworkViewController ()

@end

@implementation NetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
/*
- (void)requestDataGetWithString:(NSString *)string params:(NSDictionary *)params successBlock:(void (^)())successBlock andFailBlock:(void (^)())failBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

   [manager GET:string parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
       if (successBlock) {
           successBlock(operation,responseObject);
       }
       
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       if (failBlock) {
           failBlock(operation,error);
       }
   }];

}
 */
- (void)requestDataPostWithString:(NSString *)string params:(NSDictionary *)params andImages:(NSDictionary *)images successBlock:(void (^)(id responseObject))successBlock andFailBlock:(void (^)(NSError *error))failBlock
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [session POST:string parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (images) {
            for (NSString *key in [images allKeys]) {
                NSArray *uploadImages = images[key];
                for (id obj in uploadImages) {
                    if ([obj isKindOfClass:[NSString class]]) {
                        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:obj] name:key fileName:KTimeStamp mimeType:@"image/png"];
                    }else if ([obj isKindOfClass:[UIImage class]]){
                        [formData appendPartWithFileData:UIImageJPEGRepresentation(obj, 0.7) name:key fileName:KTimeStamp mimeType:@"image/png"];
                    }
                }
            }
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failBlock) {
            failBlock(error);
        }
    }];
}
- (void)requestDataPostWithString:(NSString *)string params:(NSDictionary *)params successBlock:(void (^)(id responseObject))successBlock andFailBlock:(void (^)(NSError *error))failBlock
{
//    [self requestDataPostWithString:string params:params andImages:nil successBlock:successBlock andFailBlock:failBlock];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [session POST:string parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failBlock) {
            failBlock(error);
        }
    }];
    
    /*
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:string parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failBlock) {
            failBlock(error);
        }
    }];
*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
