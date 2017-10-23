//
//  DJPointView.h
//  DJLineChart
//
//  Created by 广州凯笙 on 2017/10/18.
//  Copyright © 2017年 Keisun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJPointView : UIControl

+ (DJPointView *)aInstance;

@property (nonatomic,copy) void (^dragCallBack)(DJPointView * pointView);

@property (nonatomic, copy) void (^refreshPointViewOriginYBlock)(CGFloat newOriginY);

@end
