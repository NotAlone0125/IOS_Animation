//
//  BezierPathView.m
//  YYH_UIBezierPath
//
//  Created by 杨昱航 on 2017/6/6.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

#import "BezierPathView.h"

@implementation BezierPathView

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.frame=frame;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    //矩形贝塞尔曲线
    UIBezierPath* bezierPath_rect = [UIBezierPath bezierPathWithRect:CGRectMake(30, 50, 100, 100)];
    [bezierPath_rect moveToPoint:CGPointMake(60, 60)];//贝塞尔曲线开始的点
    [bezierPath_rect addLineToPoint:CGPointMake(80, 80)];//添加直线到该点
    [bezierPath_rect addLineToPoint:CGPointMake(60, 90)];
    //[bezierPath_rect closePath];//加上该句三角形会自动闭合
    //[bezierPath_rect removeAllPoints];//移除所有的点，绘制的图形消失
    
    bezierPath_rect.lineCapStyle = kCGLineCapRound;  //端点类型
    /*
     kCGLineCapButt,   无端点
     kCGLineCapRound,  圆形端点
     kCGLineCapSquare  方形端点
     */
    bezierPath_rect.lineJoinStyle = kCGLineJoinBevel;  //线条连接类型
    /*
     kCGLineJoinMiter, 尖角
     kCGLineJoinRound, 圆角
     kCGLineJoinBevel  缺角
     */
    bezierPath_rect.miterLimit = 1;//最大斜接长度（只有在使用kCGLineJoinMiter是才有效）， 边角的角度越小，斜接长度就会越大;为了避免斜接长度过长，使用lineLimit属性限制，如果斜接长度超过miterLimit，边角就会以KCALineJoinBevel类型来显示
    CGFloat dash[] = {20,1};
    [bezierPath_rect setLineDash:dash count:2 phase:0];
    bezierPath_rect.lineWidth = 10;
    //圆形 椭圆贝塞尔曲线
    UIBezierPath *bezierPath_oval = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(200, 50, 150, 100)];
    bezierPath_oval.lineWidth = 10;
    //还有圆角的贝塞尔曲线
    UIBezierPath *bezierPath_RoundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(30, 200, 100, 100) cornerRadius:20];
    bezierPath_RoundedRect.lineWidth = 10;
    //绘制可选择圆角方位的贝塞尔曲线
    UIBezierPath *bezierPath_RoundedCornerRect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(200, 200, 100, 100) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
    bezierPath_RoundedCornerRect.lineWidth = 10;
    //绘制圆弧曲线
    UIBezierPath *bezierPath_ArcCenter = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, 400) radius:50 startAngle:M_PI / 2 * 3 endAngle:M_PI / 3 clockwise:YES];//用于画圆弧，参数说明如下： center: 弧线中心点的坐标 radius: 弧线所在圆的半径 startAngle: 弧线开始的角度值 endAngle: 弧线结束的角度值 clockwise: 是否顺时针画弧线。
    bezierPath_ArcCenter.lineWidth = 10;
    //添加二次 三次贝塞尔曲线
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = 2;
    [bezierPath moveToPoint:CGPointMake(10, 520)];
    [bezierPath addLineToPoint:CGPointMake(50, 530)];
    [bezierPath addQuadCurveToPoint:CGPointMake(100, 510) controlPoint:CGPointMake(80, 650)];
    [bezierPath addCurveToPoint:CGPointMake(200, 530) controlPoint1:CGPointMake(130, 600) controlPoint2:CGPointMake(170, 400)];
    [bezierPath addArcWithCenter:CGPointMake(300, 400) radius:50 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    [bezierPath moveToPoint:CGPointMake(20, 520)];
    [bezierPath addLineToPoint:CGPointMake(40, 520)];
    //根据CGPathRef绘制贝塞尔曲线
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 10, 640);
    CGPathAddCurveToPoint(path, NULL, 100, 700, 250, 550, 350, 650);
    UIBezierPath *bezierPath_CGPath = [UIBezierPath bezierPathWithCGPath:path];
    bezierPath_CGPath.lineWidth = 4;
    //选择填充颜色
    [[UIColor redColor] set];
    [bezierPath_rect fill];
    [bezierPath_oval fill];
    [bezierPath_RoundedRect fill];
    [bezierPath_RoundedCornerRect fill];
    //[bezierPath_ArcCenter fill];
    //[bezierPath_CGPath fill];
    
    //选择线条颜色
    [[UIColor blackColor] set];
    [bezierPath_rect stroke];
    [bezierPath_oval stroke];
    [bezierPath_RoundedRect stroke];
    [bezierPath_RoundedCornerRect stroke];
    [bezierPath_ArcCenter stroke];
    [bezierPath stroke];
    [bezierPath_CGPath stroke];
    //
    CALayer* aniLayer = [CALayer layer];
    aniLayer.backgroundColor = [UIColor redColor].CGColor;
    aniLayer.position = CGPointMake(10, 520);
    aniLayer.bounds = CGRectMake(0, 0, 8, 8);
    aniLayer.cornerRadius = 4;
    [self.layer addSublayer:aniLayer];
    //
    CAKeyframeAnimation* keyFrameAni = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAni.repeatCount = NSIntegerMax;
    keyFrameAni.path = bezierPath.CGPath;
    keyFrameAni.duration = 15;
    keyFrameAni.beginTime = CACurrentMediaTime() + 1;
    [aniLayer addAnimation:keyFrameAni forKey:@"keyFrameAnimation"];
    
}


@end
