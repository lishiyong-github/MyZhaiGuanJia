//
//  BaseViewController.m
//  qingdaofu
//
//  Created by zhixiang on 16/1/29.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import "BaseViewController.h"

#import "UIImage+Color.h"


@interface BaseViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,strong) UIButton *leftBackBtn;
@property (nonatomic,assign) BOOL didSetupConstraints;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBackColor;
    
    //设置导航条的字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor,NSFontAttributeName:kNavFont}];
    
    //去除系统效果
    self.navigationController.navigationBar.translucent = NO;
    
    //设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
        
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"=====%@=====",NSStringFromClass([self class]));
}

-(UIBarButtonItem *)leftItem
{
    if (!_leftItem) {
        
//        _leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBackBtn];
        
//        [self.leftBackBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
//        [self.leftBackBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        
//        [self.leftBackBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 10, 0, 0)];
        
        _leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"information_nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    }
    return _leftItem;
}

- (UIButton *)leftBackBtn
{
    if (!_leftBackBtn) {
        _leftBackBtn = [UIButton newAutoLayoutView];
        [_leftBackBtn setImage:[UIImage imageNamed:@"information_nav_back"] forState:0];
        _leftBackBtn.layer.borderColor = kRedColor.CGColor;
        _leftBackBtn.layer.borderWidth = kLineWidth;
        [_leftBackBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBackBtn;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSString *)getValidateToken
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    return token;
}

- (void)tokenIsValid
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *validString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kTokenOverdue];
    NSURL *URL = [NSURL URLWithString:validString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromData:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"token 错误");
        }else{
            TokenModel *model = [TokenModel objectWithKeyValues:responseObject];
            if (self.didTokenValid) {
                self.didTokenValid(model);
            }
        }
    }];
    [uploadTask resume];
    
    /*
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSString *validString = [NSString stringWithFormat:@"%@%@",kQDFTestUrlString,kTokenOverdue];
    NSDictionary *params = @{@"token" : [self getValidateToken]?[self getValidateToken]:@""};
    [manager POST:validString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        TokenModel *model = [TokenModel objectWithKeyValues:responseObject];
        if (self.didTokenValid) {
            self.didTokenValid(model);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
     */
}

/*
- (UIAlertController *)alertController
{
    if (!_alertController) {
        _alertController = [UIAlertController alertControllerWithTitle:self.alertTitle message:self.alertMessage preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSUInteger sourceType = 0;
            sourceType = UIImagePickerControllerSourceTypeCamera;
            [self takePhotos:sourceType];
        }];
        
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSUInteger sourceType = 0;
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self takePhotos:sourceType];
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [_alertController addAction:action0];
        [_alertController addAction:action1];
        [_alertController addAction:action2];

    }
    return _alertController;
}

- (void)showAlertViewController
{
    [self presentViewController:self.alertController animated:YES completion:nil];
}

- (void)takePhotos:(NSInteger)sourceType
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && sourceType == UIImagePickerControllerSourceTypeCamera) {
        NSLog(@"未发现照相机");
        return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    // 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
 
    
    //保存图片至本地
    [self saveImage:image withName:self.saveImageString];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:self.saveImageString];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    self.savedImage = savedImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    
    //获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];

    //将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

*/
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
