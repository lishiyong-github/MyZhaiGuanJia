//
//  UIViewController+MutipleImageChoice.m
//  testPickerImage
//
//  Created by shiyong_li on 16/6/11.
//  Copyright © 2016年 shiyong_li. All rights reserved.
//

#import "UIViewController+MutipleImageChoice.h"
#import "ZYQAssetPickerController.h"
#import "MBResourceManager.h"
#import "StandardPaths.h"
#import <Foundation/NSFileManager.h>
#import <objc/runtime.h>
#define MBTimeStamp [NSString stringWithFormat:@"%.0f",[[NSDate new] timeIntervalSince1970] * 1000]
@interface UIViewController (_MutipleImageChoice)<ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, copy) void (^finishBlock)(NSArray *array);
@end
@implementation UIViewController (MutipleImageChoice)
/**
 *
 * 参考UIWebView+AFNetworking
 *
 */
- (void (^)(NSArray *))finishBlock
{
    return objc_getAssociatedObject(self, @selector(finishBlock));
}

- (void)setFinishBlock:(void (^)(NSArray *))finishBlock
{
    objc_setAssociatedObject(self, @selector(finishBlock), finishBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addImageWithFinishBlock:(void (^)(NSArray *))finishBlock
{
    [self addImageWithMutipleChoise:NO andFinishBlock:finishBlock];
}
- (void)addImageWithMutipleChoise:(BOOL)mutipleChoice andFinishBlock:(void (^)(NSArray *))finishBlock
{
    [self addImageWithMaxSelection:0 andMutipleChoise:mutipleChoice andFinishBlock:finishBlock];
}

- (void)addImageWithMaxSelection:(NSInteger)maxSelection andFinishBlock:(void (^)(NSArray *))finishBlock
{
    [self addImageWithMaxSelection:maxSelection andMutipleChoise:NO andFinishBlock:finishBlock];
}
- (void)addImageWithMaxSelection:(NSInteger)maxSelection andMutipleChoise:(BOOL)mutipleChoice andFinishBlock:(void (^)(NSArray *))finishBlock
{
    self.finishBlock = finishBlock;
    UIAlertControllerStyle style = UIAlertControllerStyleActionSheet;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:style];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imageController = [[UIImagePickerController alloc]init];
            imageController.delegate = self;
            imageController.allowsEditing = YES;
            imageController.sourceType = UIImagePickerControllerSourceTypeCamera;            [weakSelf presentViewController:imageController animated:YES completion:nil];
        }else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"相机" message:@"相机不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
        if (maxSelection>0) {
            picker.maximumNumberOfSelection = maxSelection;
        }
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups=NO;
        picker.delegate=self;
        [weakSelf presentViewController:picker animated:YES completion:NULL];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:cancel];
    alertController.popoverPresentationController.sourceView = self.view;
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSMutableArray *fileNames = [NSMutableArray array];
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        if ([asset valueForProperty:ALAssetPropertyType]== ALAssetTypePhoto) {
            UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            NSString *filePath = [self getFilePathToSaveUnUpdatedImage];
            [[MBResourceManager sharedInstance]addUnusedResource:filePath];
            [UIImageJPEGRepresentation(image, 0.7) writeToFile:filePath atomically:YES];
            [fileNames addObject:filePath];
        }
    }
    if (self.finishBlock) {
        self.finishBlock(fileNames);
    }
}
- (NSString *)getFilePathToSaveUnUpdatedImage {
    NSString *filePath = [[NSFileManager defaultManager] pathForTemporaryFile:[NSString stringWithFormat:@"Image_%@.jpg", MBTimeStamp]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    return filePath;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    NSString *filePath = [self getFilePathToSaveUnUpdatedImage];
    [[MBResourceManager sharedInstance]addUnusedResource:filePath];
    [UIImageJPEGRepresentation(image, 0.7) writeToFile:filePath atomically:YES];
    if (self.finishBlock) {
        self.finishBlock(@[filePath]);
    }
}

@end
