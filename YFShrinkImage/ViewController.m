//
//  ViewController.m
//  YFShrinkImage
//
//  Created by admin on 17/5/18.
//  Copyright © 2017年 Yvan Wang. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+YFShrink.h"

@interface ViewController (){
    
    UIButton *originButton, *resizableButton, *shrinkButton;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    //源图大小 不能改 只是为了触摸之后查看相应的动态变化longxin
    UIImage *originImage = [UIImage imageNamed:@"wechat"]; //200 * 78
    originButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 200, 78)];
    [originButton setTitle:@"正常图片(200*78)" forState:UIControlStateNormal];
    originButton.userInteractionEnabled = NO;
    originButton.clipsToBounds = YES;
    [originButton setBackgroundImage:originImage forState:UIControlStateNormal];
    [self.view addSubview:originButton];
     
    
    //收缩后的图片  150 * 70   需要传入一个显示的实际大小
    //实际显示宽度须actualWidth <= left + right;
    //实际显示高度须actualHeight <= top + bottom;
    UIImage *shrinkImage = [originImage shrinkImageWithCapInsets:UIEdgeInsetsMake(30, 40, 30, 60) actualSize:CGSizeMake(150, 60)];
    shrinkButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, 150, 60)];
    shrinkButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [shrinkButton setTitle:@"局部收缩150*60" forState:UIControlStateNormal];
    [shrinkButton setBackgroundImage:shrinkImage forState:UIControlStateNormal];
    [self.view addSubview:shrinkButton];
    
    //拉伸后的图片 220 * 100
    CGFloat height = originImage.size.height / 2.0;
    CGFloat width = originImage.size.width / 2.0;
    UIImage *newImage = [originImage resizableImageWithCapInsets:UIEdgeInsetsMake(height,width,height,width) resizingMode:UIImageResizingModeStretch];//取正中间一个点  在比较小的时候 这个正中间的点取的有问题啊
    resizableButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 300, 220, 100)];
    [resizableButton setTitle:@"局部拉伸(200*100)" forState:UIControlStateNormal];
    [resizableButton setBackgroundImage:newImage forState:UIControlStateNormal];
    [self.view addSubview:resizableButton];
    
    
    
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    CGPoint actualPoint = [self.view convertPoint:point toView:originButton];
    if(actualPoint.x >= 0 && actualPoint.x <= originButton.frame.size.width &&
        actualPoint.y >= 0 && actualPoint.y <= originButton.frame.size.height){
        UIImage *image1 = [UIImage imageNamed:@"wechat"];
        //        UIEdgeInsets margin = UIEdgeInsetsMake(10, 10, 10, 10);
        CGFloat top = actualPoint.y;
        CGFloat left = actualPoint.x;// - margin.left;
        CGFloat bottom = originButton.frame.size.height - top;// - margin.bottom;
        CGFloat right = originButton.frame.size.width - left;// - margin.right;
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top,left,bottom,right);
        UIImage *newImage = [image1 resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
        [resizableButton setBackgroundImage:newImage forState:UIControlStateNormal];
        NSLog(@"--------%@---------",NSStringFromUIEdgeInsets(edgeInsets));
        
        //画点
        UIView *view = [originButton viewWithTag:1122];
        if(view){
            [view removeFromSuperview];
        }
        
        view = [[UIView alloc] init];
        view.frame = CGRectMake(actualPoint.x, actualPoint.y, 1,1);
        //        view.frame = CGRectMake(0, 0, margin.left + margin.right, margin.top + margin.bottom);
        view.center = actualPoint;
        view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        
        view.tag = 1122;
        [originButton addSubview:view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
