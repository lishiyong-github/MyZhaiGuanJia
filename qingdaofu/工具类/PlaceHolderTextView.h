//
//  PlaceHolderTextView.h
//  qingdaofu
//
//  Created by zhixiang on 16/5/19.
//  Copyright © 2016年 zhixiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceHolderTextView : UITextView

@property (nonatomic, strong) IBInspectable NSString *placeholder;       /**< 提示文字 */
@property (nonatomic, strong) IBInspectable UIColor  *placeholderColor;  /**< 提示文字颜色 */
@property (nonatomic, assign) IBInspectable BOOL      displayPlaceHolder;/**< 是否显示提示文字 */

@end
