//
//  ViewController.m
//  DJLineChart
//
//  Created by 广州凯笙 on 2017/10/18.
//  Copyright © 2017年 Keisun. All rights reserved.
//

#import "ViewController.h"
#import "DJCoordinateView.h"
#import "DJPointView.h"
#import "UIBezierPath+DJPointsBezier.h"


@interface ViewController ()

@property (nonatomic, strong) DJCoordinateView *coordinateView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubView];
}

- (void)setupSubView {
    NSMutableArray *xLineTitleArray = [NSMutableArray array];
    NSMutableArray *yLineTitleArray = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        NSString *str = [NSString stringWithFormat:@"%d月份",i+1];
        [xLineTitleArray addObject:str];
    }
    for (int i = 10; i >= 0; i --) {
        NSString *str = [NSString stringWithFormat:@"%d",2*i-10];
        [yLineTitleArray addObject:str];
    }
    NSArray *valueArray = @[@(-10), @5, @7, @0, @(-3)];
    DJCoordinateView *coordinateView = [[DJCoordinateView alloc] initWithFrame:CGRectMake(10, 50, 300, 500) xLineTitleArray:xLineTitleArray yLineTitleArray:yLineTitleArray valueArray:valueArray];
    [self.view addSubview:coordinateView];
    _coordinateView = coordinateView;
    
    
    UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(coordinateView.frame)+50, 80, 50)];
    changeBtn.backgroundColor = [UIColor redColor];
    [changeBtn setTitle:@"Click" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(changeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
}

- (void)changeBtnClicked:(UIButton *)btn {
    
    NSMutableArray *arrv = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        int x = arc4random() % 20;
        NSNumber *num = [NSNumber numberWithInteger:(x-10)];
        [arrv addObject:num];
    }

    [self.coordinateView refreshCurveWithNewPointViewsArray:arrv];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
