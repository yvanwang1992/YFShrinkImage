//
//  UIImage+YFShrink.h
//  YFImageButton
//
//  Created by admin on 17/5/16.
//  Copyright © 2017年 Yvan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YFImageCombineType) {
    YFImageCombineHorizental,
    YFImageCombineVertical
};

@interface UIImage (YFShrink)

//缩放图片
-(UIImage *)scaleImageToSize:(CGSize)size;

//裁剪图片
-(UIImage *)clipImageWithClipRect:(CGRect)clipRect;

//拼接图片
+(UIImage *)combineWithImages:(NSArray *)images orientation:(YFImageCombineType)orientation;

//局部收缩
- (UIImage *)shrinkImageWithCapInsets:(UIEdgeInsets)capInsets actualSize:(CGSize)actualSize;
@end
