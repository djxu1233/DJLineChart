//
//  DJCoordinateView.h
//  DJLineChart
//
//  Created by 广州凯笙 on 2017/10/18.
//  Copyright © 2017年 Keisun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJCoordinateView : UIView

- (instancetype)initWithFrame:(CGRect)frame xLineTitleArray:(NSArray *)xLineTitleArray yLineTitleArray:(NSArray *)yLineTitleArray valueArray:(NSArray *)valueArray;

- (void)refreshCurveWithNewPointViewsArray:(NSMutableArray *)newArray;

@end
