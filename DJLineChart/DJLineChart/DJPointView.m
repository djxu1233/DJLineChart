//
//  DJPointView.m
//  DJLineChart
//
//  Created by 广州凯笙 on 2017/10/18.
//  Copyright © 2017年 Keisun. All rights reserved.
//

#import "DJPointView.h"

static CGFloat const RADIUS = 4;

@implementation DJPointView

+ (DJPointView *)aInstance
{
    DJPointView * aInstance = [[self alloc] initWithFrame:(CGRect){CGPointZero, CGSizeMake(RADIUS * 2, RADIUS * 2)}];
    aInstance.layer.cornerRadius = RADIUS;
    aInstance.layer.masksToBounds = YES;
    aInstance.backgroundColor = [UIColor orangeColor];
//    [aInstance addTarget:aInstance action:@selector(touchDragInside:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    
    return aInstance;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];

    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    [super continueTrackingWithTouch:touch withEvent:event];
    CGPoint point = [touch locationInView:self];
    
//    NSLog(@"point.x===%f point.y===%f",point.x,point.y);
    
    if (self.refreshPointViewOriginYBlock) {
        self.refreshPointViewOriginYBlock(point.y);
    }

    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

//- (void)touchDragInside:(DJPointView *)pointView withEvent:(UIEvent *)event
//{
//    pointView.center = [[[event allTouches]anyObject] locationInView:self.superview];
//    
//    if (self.dragCallBack) {
//        self.dragCallBack(self);
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
