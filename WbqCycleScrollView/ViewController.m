//
//  ViewController.m
//  WbqCycleScrollView
//
//  Created by wbq on 17/3/21.
//  Copyright © 2017年 汪炳权. All rights reserved.
//

#import "ViewController.h"
#import "WbqCycleScrollView.h"

@interface ViewController ()<WbqCycleScrollViewDelegate,WbqCycleScrollViewDataSource>
@property(nonatomic,strong)WbqCycleScrollView * v;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.v = [[WbqCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, 375, 200)];
    self.v.pageControlStyle = WbqCycleCHIPageControlJalapenoStyle;
    self.v.delegate = self;
    self.v.dataSource = self;
    self.v.customNumofPage = 5;
    self.v.backgroundColor = [UIColor grayColor];
//    self.v.imageURLStringsGroup = @[@"http://cdn.dknb.nbtv.cn/attachment/app-image/1703/220930535d9c90e32554d81f20e6c5c9ba15603f.jpg@640w",@"http://cdn.dknb.nbtv.cn/attachment/app-image/1703/220934246829773744bf21b40b29aa3aebe9c2da.jpg@640w",@"http://cdn.dknb.nbtv.cn/attachment/app-image/1703/210425226bd0fa1f4d6e0aed4eb8da38b4b4b7f8.jpg@640w",@"http://cdn.dknb.nbtv.cn/attachment/app-image/1703/2011064201b719f0ce36b2eb0a3d17f115ef3570.jpg@640w"];
//    self.v.titlesGroup = @[@"清明节出行、扫墓必看！部分道路临时交通管制",@"安心！我国实现72小时内查明突发传染病原",@"986主播的日常，又双叕作幺蛾子啦！",@"绿色生活 低碳环保，让我们一起绿色出行"];
    [self.view addSubview:self.v];
    
    
}


-(void)cycleScrollView:(WbqCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
}

-(NSInteger)numberOfItemsInCycleScrollView:(WbqCycleScrollView *)cycleScrollView
{
    return 4;
}

-(UIView * )cellView:(WbqCycleScrollView *)cycleScrollView viewForItemAtIndex:(NSInteger)index
{
    UIView * view = [[UIView alloc]initWithFrame:self.v.bounds];
    view.backgroundColor = [UIColor colorWithRed:index * 0.1 green:0.5 blue:0.5 alpha:1];
    return view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
