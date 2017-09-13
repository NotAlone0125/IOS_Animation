//
//  YYHAnimationView.m
//  YYH_WaveAnimation
//
//  Created by 杨昱航 on 2017/6/12.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

#import "YYHAnimationView.h"

#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

// 起点 RGB
#define originRed 37
#define originGreen 191
#define originBlue 191
// 终点 RGB
#define endRed 10
#define endGreen 145
#define endBlue 171

#define lifeCycle 25

@interface YYHAnimationView ()
{
    
    CGFloat _waveAmplitude; // 振幅
    CGFloat _waveCycle;     // 周期
    CGFloat _waveSpeed;     // 速度
    CGFloat _waterWaveHeight;
    CGFloat _waterWaveWidth;
    CGFloat _wavePointY;
    CGFloat _waveOffseetX;   // 波浪x位移
    UIColor *_waveColor;     // 波浪颜色
    
    
}

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) CAShapeLayer *firstWaveLayer;
@property (nonatomic, strong) CAShapeLayer *secondWaveLayer;
@property (nonatomic, strong) CAShapeLayer *thirdWaveLayer;
@property (nonatomic, strong) CAGradientLayer *gradLayer;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger num;

@end

@implementation YYHAnimationView

#pragma mark 交错显示的3个水纹Layer
/*
 1、CAShapeLayer继承自CALayer，可以使用CALayer的所有属性值
 2、CAShapeLayer需要与贝塞尔曲线配合使用才有意义
 3、使用CAShapeLayer与贝塞尔曲线可以实现不在view的drawRect方法中画出有一些想要的图形
 4、CAShapeLayer属于CoreAnimation框架，其动画渲染直接提交到手机的GPU当中，相较于view的drawRect方法使用CPU渲染而言，其效率极高，能大大优化内存使用情况。
 */
-(CAShapeLayer *)firstWaveLayer
{
    if (!_firstWaveLayer) {
        _firstWaveLayer=[CAShapeLayer layer];
        _firstWaveLayer.fillColor=_waveColor.CGColor;
    }
    return _firstWaveLayer;
}
-(CAShapeLayer *)secondWaveLayer
{
    if (!_secondWaveLayer) {
        _secondWaveLayer=[CAShapeLayer layer];
        _secondWaveLayer.fillColor=_waveColor.CGColor;
    }
    return _secondWaveLayer;
}
-(CAShapeLayer *)thirdWaveLayer
{
    if (!_thirdWaveLayer) {
        _thirdWaveLayer=[CAShapeLayer layer];
        _thirdWaveLayer.fillColor=_waveColor.CGColor;
    }
    return _thirdWaveLayer;
}
//CADisplayLink是一个能让我们以和屏幕刷新率相同的频率将内容画到屏幕上的定时器。我们在应用中创建一个新的 CADisplayLink 对象，把它添加到一个runloop中，并给它提供一个 target 和selector 在屏幕刷新的时候调用。
- (CADisplayLink *)displayLink
{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave)];
    }
    return _displayLink;
}


#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self configParams];
        [self initBottomLayer];
        [self startWave];
        [self setupTimer];
        
    }
    return self;
}


#pragma mark 配置参数
- (void)configParams
{
    _waterWaveWidth = self.frame.size.width;
    _waterWaveHeight = self.frame.size.height;
    _waveColor = rgba(255, 255, 255, 0.15);
    _waveSpeed = 0.05/M_PI;
    
    _waveOffseetX = 0;
    
    _wavePointY = 0;
    _waveAmplitude = 15;
    _waveCycle = 1.3*M_PI / _waterWaveWidth;
}

#pragma mark 利用CAGradientLayer设置背景板的过渡颜色
- (void)initBottomLayer
{
    if (self.gradLayer == nil) {
        self.gradLayer = [CAGradientLayer layer];
        self.gradLayer.frame = self.bounds;
    }
    self.gradLayer.startPoint = CGPointMake(0, 1);
    self.gradLayer.endPoint = CGPointMake(1, 0);
    self.gradLayer.colors = @[(id)[rgba(originRed, originGreen, originBlue, 1.0) CGColor],
                              (id)[rgba(0.5*(originRed + endRed), 0.5*(originGreen + endGreen), 0.5*(originBlue + endBlue), 1.0) CGColor],
                              (id)[rgba(endRed, endGreen, endBlue, 1.0) CGColor]];
    
    
    //    self.gradLayer.colors = @[(id)[rgba(originRed, originGreen, originBlue, 1.0) CGColor],
    //                              (id)[rgba(endRed, endGreen, endBlue, 1.0) CGColor]];
    
    [self.layer addSublayer:self.gradLayer];
}


#pragma mark 加载layer 绑定runloop 帧刷新
- (void)startWave
{
    [self.layer addSublayer:self.firstWaveLayer];
    [self.layer addSublayer:self.secondWaveLayer];
    [self.layer addSublayer:self.thirdWaveLayer];
    
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}

#pragma mark 帧刷新事件
- (void)getCurrentWave
{
    _waveOffseetX += _waveSpeed;
    
    [self setFirstWaveLayerPath];
    [self setSecondWaveLayerPath];
    [self setThirdWaveLayerPath];
}

#pragma mark 三个shapeLayer 动画
- (void)setFirstWaveLayerPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _wavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    
    for (float x = 0.0f; x<=_waterWaveWidth; x ++) {
        
        y = _waveAmplitude *sin(-_waveCycle *x + _waveOffseetX - 10) +_wavePointY +10;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, _wavePointY);
    CGPathAddLineToPoint(path, nil, 0, _wavePointY);
    CGPathCloseSubpath(path);
    
    self.firstWaveLayer.path = path;
    
    CGPathRelease(path);
}

- (void)setSecondWaveLayerPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _wavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    
    for (float x = 0.0f; x<=_waterWaveWidth; x ++) {
        
        y = _waveAmplitude *sin(-(1.0*M_PI / _waterWaveWidth)*x + _waveOffseetX - 5 ) +_wavePointY + 10 ;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, _wavePointY);
    CGPathAddLineToPoint(path, nil, 0, _wavePointY);
    CGPathCloseSubpath(path);
    
    self.secondWaveLayer.path = path;
    
    CGPathRelease(path);
}
- (void)setThirdWaveLayerPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _wavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    
    for (float x = 0.0f; x<=_waterWaveWidth; x ++) {
        
        y = 18*sin(-(0.6*M_PI / _waterWaveWidth)*x + _waveOffseetX ) +_wavePointY + 18;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, _wavePointY);
    CGPathAddLineToPoint(path, nil, 0, _wavePointY);
    CGPathCloseSubpath(path);
    
    self.thirdWaveLayer.path = path;
    
    CGPathRelease(path);
}

#pragma mark 根据定时器来进行背景的变化
- (void)setupTimer
{
    CGFloat interval = 0.5;
    if (self.timer == nil) {
        self.timer = [NSTimer timerWithTimeInterval:interval target:self
                                           selector:@selector(timerFunc)
                                           userInfo:nil repeats:YES];
    }
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)timerFunc
{
    
    NSInteger R_A = 0.5*(originRed - endRed);
    NSInteger R_B = 0.5*(originRed + endRed);
    
    NSInteger G_A = 0.5*(originGreen - endGreen);
    NSInteger G_B = 0.5*(originGreen + endGreen);
    
    NSInteger B_A = 0.5*(originBlue - endBlue);
    NSInteger B_B = 0.5*(originBlue + endBlue);
    
    
    if (self.num > lifeCycle) {
        self.num = 0;
    }
    // 计算起点 RGB
    CGFloat originR = R_A*sin(2*M_PI/lifeCycle * self.num + M_PI_2) + R_B;
    CGFloat originG = G_A*sin(2*M_PI/lifeCycle * self.num + M_PI_2) + G_B;
    CGFloat originB = B_A*sin(2*M_PI/lifeCycle * self.num + M_PI_2) + B_B;
    //    // 计算中点 RGB
    CGFloat centerR = R_A*sin(2*M_PI/lifeCycle * self.num + M_PI) + R_B;
    CGFloat centerG = G_A*sin(2*M_PI/lifeCycle * self.num + M_PI) + G_B;
    CGFloat centerB = B_A*sin(2*M_PI/lifeCycle * self.num + M_PI) + B_B;
    // 计算结束点 RGB
    CGFloat endR = R_A*sin(2*M_PI/lifeCycle * self.num + 3*M_PI_2) + R_B;
    CGFloat endG = G_A*sin(2*M_PI/lifeCycle * self.num + 3*M_PI_2) + G_B;
    CGFloat endB = B_A*sin(2*M_PI/lifeCycle * self.num + 3*M_PI_2) + B_B;
    
    
    self.num += 1;
    
    self.gradLayer.colors = @[(id)[rgba(originR, originG, originB, 1.0) CGColor],
                              (id)[rgba(centerR, centerG, centerB, 1.0) CGColor],
                              (id)[rgba(endR, endG, endB, 1.0) CGColor]];
    
    //    self.gradLayer.colors = @[(id)[rgba(originR, originG, originB, 1.0) CGColor],
    //                              (id)[rgba(endR, endG, endB, 1.0) CGColor]];
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
    [self.displayLink invalidate];
    self.displayLink = nil;
}




@end
