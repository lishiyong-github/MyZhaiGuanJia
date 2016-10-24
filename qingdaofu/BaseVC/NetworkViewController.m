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

- (void)tokenIsValid
{
    [self showHudInView:self.view hint:@"请稍候"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer= [AFHTTPResponseSerializer serializer];
    
    NSString *validString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kTokenOverdue];
    NSDictionary *params = @{@"token" : [self getValidateToken]?[self getValidateToken]:@""};
    
    [manager POST:validString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {        
        
        NSDictionary *aoaoao = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        TokenModel *model = [TokenModel objectWithKeyValues:responseObject];
        if (self.didTokenValid) {
            [self hideHud];
            self.didTokenValid(model);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideHud];
    }];
}

//- (void)requestDataPostWithString:(NSString *)string params:(NSDictionary *)params andImages:(NSDictionary *)images successBlock:(void (^)(id responseObject))successBlock andFailBlock:(void (^)(NSError *error))failBlock
//{
//    [self showHudInView:self.view hint:@"正在加载"];
//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    session.requestSerializer = [AFHTTPRequestSerializer serializer];
//    session.responseSerializer = [AFHTTPResponseSerializer serializer];
//    // 3.如果报接受类型不一致请替换一致text/html  或者 text/plain
//    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
//    
//    QDFWeakSelf;
//    [session POST:string parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        if (images) {
//            
//            for (NSString *key in [images allKeys]) {
//                NSArray *uploadImages = images[key];
//                
//                for (id obj in uploadImages) {
//                    if ([obj isKindOfClass:[NSString class]]) {
//                        
//                        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:obj] name:key fileName:KTimeStamp mimeType:@"image/png"];
//                        
//                    }else if ([obj isKindOfClass:[UIImage class]]){
//                        [formData appendPartWithFileData:UIImageJPEGRepresentation(obj, 0.7) name:key fileName:KTimeStamp mimeType:@"image/png"];
//                    }
//                }
//            }
//            
//        }
//
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (successBlock) {
//            [weakself hideHud];
//            successBlock(responseObject);
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failBlock) {
//            [weakself hideHud];
//            [self showHint:@"网络错误"];
//        }
//    }];
//}

- (void)requestDataPostWithString:(NSString *)string params:(NSDictionary *)params successBlock:(void (^)(id responseObject))successBlock andFailBlock:(void (^)(NSError *error))failBlock
{
    [self showHudInView:self.view hint:@"正在加载"];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    QDFWeakSelf;
    [session POST:string parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            [weakself hideHud];
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failBlock) {
            [weakself hideHud];
            [weakself showHint:@"网络错误"];
        }
    }];
}

- (void)uploadImages:(NSString *)imgData andType:(NSString *)imgType andFilePath:(NSString *)filePath
{
    NSString *uploadsString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kUploadImagesString];
    NSDictionary *params = @{@"filetype" : @"1",
                             @"extension" : @"jpg",
                             @"picture" : imgData
                             };
    
    QDFWeakSelf;
    [self requestDataPostWithString:uploadsString params:params successBlock:^(id responseObject) {
        ImageModel *imModel = [ImageModel objectWithKeyValues:responseObject];
        if (weakself.didGetValidImage) {
            [weakself hideHud];
            weakself.didGetValidImage(imModel);
        }
    } andFailBlock:^(NSError *error) {
        [weakself hideHud];
    }];
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
