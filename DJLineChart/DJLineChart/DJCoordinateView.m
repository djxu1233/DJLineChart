//
//  DJCoordinateView.m
//  DJLineChart
//
//  Created by 广州凯笙 on 2017/10/18.
//  Copyright © 2017年 Keisun. All rights reserved.
//

#import "DJCoordinateView.h"
#import "DJPointView.h"
#import "UIBezierPath+DJPointsBezier.h"

#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@interface DJCoordinateView ()

@property (nonatomic, strong) UIBezierPath *curve;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, copy) NSArray *valueArray;                //保存初始化时传入的值数组
@property (nonatomic, strong) NSArray *xLineTitleArray;         //X轴坐标的title
@property (nonatomic, strong) NSArray *yLineTitleArray;         //Y轴坐标的title
@property (nonatomic, assign) CGFloat yLineMarginY;             //Y轴坐标的之间的间隔
@property (nonatomic, strong) NSMutableArray *pointViewArray;   //保存pointView的数组
@property (nonatomic, strong) NSMutableArray * pointValueArray;     //保存pointView的center value的数组
@property (nonatomic, assign) CGFloat minOriginY;       //虚线框Y轴的最小坐标值
@property (nonatomic, assign) CGFloat maxOriginY;       //虚线框Y轴的最大坐标值


@end

@implementation DJCoordinateView

- (instancetype)initWithFrame:(CGRect)frame xLineTitleArray:(NSArray *)xLineTitleArray yLineTitleArray:(NSArray *)yLineTitleArray valueArray:(NSArray *)valueArray {
    self = [super initWithFrame:frame];
    if (self) {
        _valueArray = valueArray;
        _xLineTitleArray = xLineTitleArray;
        _yLineTitleArray = yLineTitleArray;
        _pointViewArray = [NSMutableArray array];
        _pointValueArray = [NSMutableArray array];
        [self setupCoordinate];
    }
    return self;
}

- (void)setupCoordinate {
    //添加X轴
    CALayer *xLine = [[CALayer alloc] init];
    xLine.frame = CGRectMake(30, CGRectGetHeight(self.frame)/2, CGRectGetWidth(self.frame)-60, 2);
    xLine.backgroundColor = [UIColor grayColor].CGColor;
    [self.layer addSublayer:xLine];
    [self drawXLineTriangleAtPoint:CGPointMake(CGRectGetMaxX(xLine.frame), CGRectGetMidY(xLine.frame))];
    
    //添加Y轴
    CALayer *yLine = [[CALayer alloc] init];
    yLine.frame = CGRectMake(30, 30, 2, CGRectGetHeight(self.frame)-60);
    yLine.backgroundColor = [UIColor grayColor].CGColor;
    [self.layer addSublayer:yLine];
    [self drawYLineTriangleAtPoint:CGPointMake(CGRectGetMidX(yLine.frame), CGRectGetMinY(yLine.frame))];
    
    CGFloat xLineMarginX = (CGRectGetWidth(xLine.frame)-30)/_xLineTitleArray.count;
    CGFloat yLineMarginY = (CGRectGetHeight(yLine.frame)/2-15)/((_yLineTitleArray.count-1)/2);
    _yLineMarginY = yLineMarginY;

    //添加X轴的title
    for (int i = 0; i < _xLineTitleArray.count; i ++) {
        
        CGRect xLineRect = CGRectMake(30+xLineMarginX+xLineMarginX*i, 30, 1.0, CGRectGetHeight(yLine.frame));
        [self drawCoordinateXDashLineAtView:self lineFrame:xLineRect lineLength:6 lineSpacing:2 lineColor:[UIColor lightGrayColor]];
        
        UILabel *xLineTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(30+xLineMarginX/2+xLineMarginX*i, CGRectGetMaxY(xLine.frame)+3, xLineMarginX, 20)];
        xLineTitleLab.text = _xLineTitleArray[i];
        xLineTitleLab.textColor = [UIColor blueColor];
        xLineTitleLab.textAlignment = NSTextAlignmentCenter;
        xLineTitleLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:xLineTitleLab];
        
        [self setupPointsWithOriginX:xLineRect.origin.x originY:30+16+(10-[_valueArray[i] integerValue])*yLineMarginY/2 tag:i];
    }
    
    NSValue * firstPointValue = _pointValueArray.firstObject;
    
    _curve = [UIBezierPath bezierPath];
    [_curve moveToPoint:firstPointValue.CGPointValue];
    [_curve addBezierThroughPoints:_pointValueArray];
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.strokeColor = RGBA(0, 204, 255, 0.65).CGColor;
    _shapeLayer.fillColor = nil;
    _shapeLayer.lineWidth = 3.0;
    _shapeLayer.path = _curve.CGPath;
    _shapeLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_shapeLayer];
    

    _minOriginY = 30+16;
    
    //添加Y轴的title
    for (int i = 0; i < _yLineTitleArray.count; i ++) {
        UILabel *yLineTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _minOriginY-10+yLineMarginY*i, 30, 20)];
        yLineTitleLab.text = _yLineTitleArray[i];
        yLineTitleLab.textColor = [UIColor redColor];
        yLineTitleLab.textAlignment = NSTextAlignmentCenter;
        yLineTitleLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:yLineTitleLab];
        
        CGRect yLineRect = CGRectMake(CGRectGetMinX(xLine.frame), _minOriginY+yLineMarginY*i, CGRectGetWidth(xLine.frame), 1.0);
        if (i == (_yLineTitleArray.count-1)/2) {
            continue;
        }
        if (i == _yLineTitleArray.count-1) {
            _maxOriginY = _maxOriginY+yLineMarginY*i;
        }
        [self drawCoordinateYDashLineAtView:self lineFrame:yLineRect lineLength:6 lineSpacing:2 lineColor:[UIColor lightGrayColor]];
    }

}

//初始化时创建pointView
- (void)setupPointsWithOriginX:(CGFloat)originX originY:(CGFloat)originY tag:(NSInteger)tag {
    DJPointView * pointView = [DJPointView aInstance];
    pointView.center = CGPointMake(originX, originY);
    pointView.tag = 1000+tag;
    [self addSubview:pointView];
    [_pointViewArray addObject:pointView];
    [_pointValueArray addObject:[NSValue valueWithCGPoint:pointView.center]];
}

//传入新的数组，重绘curve
- (void)refreshCurveWithNewPointViewsArray:(NSMutableArray *)newArray {
    [_curve removeAllPoints];
    
    CGFloat yLineMarginY = ((CGRectGetHeight(self.frame)-60)/2-15)/((_yLineTitleArray.count-1)/2);

    NSMutableArray *pointViewsArrv = [NSMutableArray array];
    for (int i = 0; i < newArray.count; i ++) {
        DJPointView *point = _pointViewArray[i];
        point.center = CGPointMake(point.center.x, 30+16+(10-[newArray[i] integerValue])*yLineMarginY/2);
        [pointViewsArrv addObject:point];
    }

    DJPointView * firstPointView = pointViewsArrv.firstObject;
    [_curve moveToPoint:firstPointView.center];
    
    NSMutableArray * pointValueArray = [NSMutableArray array];
    for (DJPointView * pointView in pointViewsArrv) {
        
        [pointValueArray addObject:[NSValue valueWithCGPoint:pointView.center]];
    }
    [_curve addBezierThroughPoints:pointValueArray];
    _shapeLayer.path = _curve.CGPath;

}

#pragma mark -
#pragma mark 绘制三角形
- (void)drawXLineTriangleAtPoint:(CGPoint)point {
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    // 开始点 从上->下左->下右的点
    [trianglePath moveToPoint:CGPointMake(point.x+8, point.y)];
    // 划线点
    [trianglePath addLineToPoint:CGPointMake(point.x, point.y-4)];
    [trianglePath addLineToPoint:CGPointMake(point.x, point.y+4)];
    [trianglePath closePath];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor grayColor].CGColor;
    shapeLayer.fillColor = [UIColor grayColor].CGColor;
    shapeLayer.path = trianglePath.CGPath;
    [self.layer addSublayer:shapeLayer];
}

- (void)drawYLineTriangleAtPoint:(CGPoint)point {
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    // 开始点 从上->下左->下右的点
    [trianglePath moveToPoint:CGPointMake(point.x, point.y-8)];
    // 划线点
    [trianglePath addLineToPoint:CGPointMake(point.x-4, point.y)];
    [trianglePath addLineToPoint:CGPointMake(point.x+4, point.y)];
    [trianglePath closePath];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor grayColor].CGColor;
    shapeLayer.fillColor = [UIColor grayColor].CGColor;
    shapeLayer.path = trianglePath.CGPath;
    [self.layer addSublayer:shapeLayer];
}

/**
 ** lineView:       需要绘制成虚线的view
 ** lineFrame       虚线的bounds
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawCoordinateXDashLineAtView:(UIView *)view lineFrame:(CGRect)lineFrame lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineFrame];
    [shapeLayer setPosition:CGPointMake(lineFrame.origin.x, lineFrame.size.height/2+lineFrame.origin.y)];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //设置虚线颜色
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //设置虚线宽度
    [shapeLayer setLineWidth:1];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //设置虚线的线宽及间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //创建虚线绘制路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置虚线绘制路径起点
    CGPathMoveToPoint(path, NULL, lineFrame.origin.x, lineFrame.origin.y);
    //设置虚线绘制路径终点
    CGPathAddLineToPoint(path, NULL, lineFrame.origin.x, lineFrame.origin.y+lineFrame.size.height);
    //设置虚线绘制路径
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [view.layer addSublayer:shapeLayer];
}

/**
 ** lineView:       需要绘制成虚线的view
 ** lineFrame       虚线的bounds
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawCoordinateYDashLineAtView:(UIView *)view lineFrame:(CGRect)lineFrame lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineFrame];
    [shapeLayer setPosition:CGPointMake(lineFrame.size.width/2+lineFrame.origin.x, lineFrame.origin.y)];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //设置虚线颜色
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //设置虚线宽度
    [shapeLayer setLineWidth:lineFrame.size.height];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //设置虚线的线宽及间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //创建虚线绘制路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置虚线绘制路径起点
    CGPathMoveToPoint(path, NULL, lineFrame.origin.x, lineFrame.origin.y);
    //设置虚线绘制路径终点
    CGPathAddLineToPoint(path, NULL, lineFrame.origin.x+lineFrame.size.width, lineFrame.origin.y);
    //设置虚线绘制路径
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [view.layer addSublayer:shapeLayer];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
