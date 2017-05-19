# YFShrinkImage
YFShrinkImage is a category of UIImage which shrink partial of image.


[博客园记录: 【IOS】详解图片局部拉伸 + 实现图片局部收缩](http://www.cnblogs.com/yffswyf/p/6841254.html) 

## How To Use It?

#import "UIImage+YFShrink.h"

UIImage *originImage = [UIImage imageNamed:@"wechat"]; //200 * 78
UIImage *shrinkImage = [originImage shrinkImageWithCapInsets:UIEdgeInsetsMake(30, 40, 30, 60) actualSize:CGSizeMake(150, 60)];
shrinkButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 320, 150, 60)];
[shrinkButton setBackgroundImage:shrinkImage forState:UIControlStateNormal];
[self.view addSubview:shrinkButton];
 
##Effection:  

 ![Shrink](https://github.com/yvanwang1992/YFShrinkImage/blob/master/shrink.png)
 ![Note](https://github.com/yvanwang1992/YFShrinkImage/blob/master/shrinknote.png)
