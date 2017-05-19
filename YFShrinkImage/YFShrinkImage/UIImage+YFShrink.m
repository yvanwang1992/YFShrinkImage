//
//  UIImage+YFShrink.m
//  YFImageButton
//
//  Created by admin on 17/5/16.
//  Copyright © 2017年 Yvan Wang. All rights reserved.
//

#import "UIImage+YFShrink.h"

@implementation UIImage (YFShrink)
 

//按照一定大小缩放图片
-(UIImage *)scaleImageToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);//设定大小
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}

//裁剪图片
-(UIImage *)clipImageWithClipRect:(CGRect)clipRect{
    CGImageRef clipImageRef = CGImageCreateWithImageInRect(self.CGImage, clipRect);
    UIGraphicsBeginImageContext(clipRect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, clipRect, clipImageRef);
    UIImage *clipImage = [UIImage imageWithCGImage :clipImageRef];
    
    UIGraphicsEndImageContext();
    
    return clipImage;
}

//拼接
+(UIImage *)combineWithImages:(NSArray *)images orientation:(YFImageCombineType)orientation{
    NSMutableArray *sizeArray = [[NSMutableArray alloc] init];
    CGFloat maxHeight = 0, maxWidth = 0;
    for (id image in images) {
//        if([image isKindOfClass:[UIImage class]]){
            CGSize size = ((UIImage *)image).size;
            if(orientation == YFImageCombineHorizental){//横向
                maxWidth += size.width;
                maxHeight = (size.height > maxHeight) ? size.height : maxHeight;
            }
            else{
                maxHeight += size.height;
                maxWidth = (size.width > maxWidth) ? size.width : maxWidth;
            }
            [sizeArray addObject:[NSValue valueWithCGSize:size]];
//        }
    }
    
    CGFloat lastLength = 0;//记录上一次的最右或者最下边值
    UIGraphicsBeginImageContext(CGSizeMake(maxWidth, maxHeight));
    for (int i = 0; i < sizeArray.count; i++){
        CGSize size = [[sizeArray objectAtIndex:i] CGSizeValue];
        CGRect currentRect;
        if(orientation == YFImageCombineHorizental){//横向
            currentRect = CGRectMake(lastLength, (maxHeight - size.height) / 2.0, size.width, size.height);
            [[images objectAtIndex:i] drawInRect:currentRect];
            lastLength = CGRectGetMaxX(currentRect);
        }
        else{
            currentRect = CGRectMake((maxWidth - size.width) / 2.0, lastLength, size.width, size.height);
            [[images objectAtIndex:i] drawInRect:currentRect];
            lastLength = CGRectGetMaxY(currentRect);
        }
    }
    UIImage* combinedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return combinedImage;
}

//局部收缩
- (UIImage *)shrinkImageWithCapInsets:(UIEdgeInsets)capInsets actualSize:(CGSize)actualSize{//默认拉伸好了 暂时不处理平铺的情况
    //一块区域  分为三块  两边不变 中间收缩
    UIImage *newAllImage = self;
    //如果横向变短了  处理横向
    if(actualSize.width < self.size.width){
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        //左边:
        if(capInsets.left > 0){
            UIImage *leftImage = [newAllImage clipImageWithClipRect:CGRectMake(0, 0, capInsets.left, newAllImage.size.height)];
            [imageArray addObject:leftImage];
        }
        //中间: 缩短
        CGFloat shrinkWidth = actualSize.width - capInsets.left - capInsets.right;//需要缩到的距离
        if(shrinkWidth > 0){
            UIImage *centerImage = [newAllImage clipImageWithClipRect:CGRectMake(capInsets.left, 0, newAllImage.size.width - capInsets.left - capInsets.right, newAllImage.size.height)];
            centerImage = [centerImage scaleImageToSize:CGSizeMake(shrinkWidth, newAllImage.size.height)];
            [imageArray addObject:centerImage];
        }
        //右边:
        if(capInsets.right > 0){
            UIImage *rightImage = [newAllImage clipImageWithClipRect:CGRectMake(newAllImage.size.width - capInsets.right, 0, capInsets.right, newAllImage.size.height)];
            [imageArray addObject:rightImage];
        }

        //拼接
        if(imageArray.count > 0){
            newAllImage = [UIImage combineWithImages:imageArray orientation:YFImageCombineHorizental];
            if(actualSize.height >= self.size.height){
                return newAllImage;
            }//否则继续纵向处理
        }
    }
    
    //如果纵向变短了 处理纵向(在横向处理完的基础上)
    if(actualSize.height < self.size.height){
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        //上边:
        if(capInsets.top > 0){
            UIImage *topImage = [newAllImage clipImageWithClipRect:CGRectMake(0, 0, self.size.width,capInsets.top)];
            [imageArray addObject:topImage];
        }
        //中间: 缩短
        CGFloat shrinkHeight = actualSize.height - capInsets.top - capInsets.bottom;//需要缩到的距离
        if(shrinkHeight > 0){
            UIImage *centerImage = [newAllImage clipImageWithClipRect:CGRectMake(0, capInsets.top, newAllImage.size.width,newAllImage.size.height - capInsets.bottom - capInsets.top)];
            centerImage = [centerImage scaleImageToSize:CGSizeMake(newAllImage.size.width,shrinkHeight)];
            [imageArray addObject:centerImage];
        }
        //下边:
        if(capInsets.bottom > 0){
            UIImage *bottomImage = [newAllImage clipImageWithClipRect:CGRectMake(0, newAllImage.size.height - capInsets.bottom, newAllImage.size.width,capInsets.bottom)];
            [imageArray addObject:bottomImage];
        }
        
        //拼接
        if(imageArray.count > 0){
            newAllImage = [UIImage combineWithImages:imageArray orientation:YFImageCombineVertical];
            return newAllImage;
        }
    }
    
    return nil;
}





@end
