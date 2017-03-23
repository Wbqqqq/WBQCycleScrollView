//
//  WbqCycleScrollView.h
//  WbqCycleScrollView
//
//  Created by wbq on 17/3/21.
//  Copyright © 2017年 汪炳权. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CHIPageControl/CHIPageControl-Swift.h>


typedef enum {
    WbqCycleCHIPageControlAjiStyle,        // 系统自带经典样式
    WbqCycleCHIPageControlJalapenoStyle,       // 各种动画效果pagecontrol
    WbqCycleCHIPageControlAleppoStyle,
    WbqCycleCHIPageControlChimayoStyle,
    WbqCycleCHIPageControlFresnoStyle,
    WbqCycleCHIPageControlJaloroStyle,
    WbqCycleCHIPageControlPaprikaStyle,
    WbqCycleCHIPageControlPuyaStyle,
    WbqCyclePageContolStyleNone            // 不显示pagecontrol
} WbqCycleScrollViewPageContolStyle;

@protocol WbqCycleScrollViewDataSource,WbqCycleScrollViewDelegate;

@interface WbqCycleScrollView : UIView

/** 分页控件,默认在右下角 */
@property (nonatomic, weak) CHIBasePageControl * pageControl;

/** 分页控件Frame */
@property (nonatomic, assign) CGPoint pageControlCenter;

//////////////////////  数据源接口  //////////////////////

/** 网络图片 url string 数组 */
@property (nonatomic, strong) NSArray *imageURLStringsGroup;

/** 每张图片对应要显示的文字数组 */
@property (nonatomic, strong) NSArray *titlesGroup;

/** 本地图片数组 */
@property (nonatomic, strong) NSArray *localizationImageNamesGroup;

/** 自定义视图数组 */
@property (nonatomic, assign) NSInteger customNumofPage;


/////////////////////  滚动控制接口 //////////////////////

/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL infiniteLoop;

/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;

/** 图片滚动方向，默认为水平滚动 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

/** block方式监听点击 */
@property (nonatomic, copy) void (^clickItemOperationBlock)(NSInteger currentIndex);

/** block方式监听滚动 */
@property (nonatomic, copy) void (^itemDidScrollOperationBlock)(NSInteger currentIndex);

/** 轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill */
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;

/** 占位图，用于网络未加载到图片时 */
@property (nonatomic, strong) UIImage *placeholderImage;

/** 只展示文字轮播 */
@property (nonatomic, assign) BOOL onlyDisplayText;

/** pagecontrol 样式，默认为动画样式 */
@property (nonatomic, assign) WbqCycleScrollViewPageContolStyle pageControlStyle;


/** 轮播文字label字体颜色 */
@property (nonatomic, strong) UIColor *titleLabelTextColor;

/** 轮播文字label字体大小 */
@property (nonatomic, strong) UIFont  *titleLabelTextFont;

/** 轮播文字label背景颜色 */
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;

/** 轮播文字label高度 */
@property (nonatomic, assign) CGFloat titleLabelHeight;

/** 轮播文字label对齐方式 */
@property (nonatomic, assign) NSTextAlignment titleLabelTextAlignment;


@property (nonatomic, weak) id<WbqCycleScrollViewDataSource> dataSource;


@property (nonatomic, weak) id<WbqCycleScrollViewDelegate> delegate;



@end


@protocol WbqCycleScrollViewDataSource <NSObject>
@required

/** 自定义视图数据源 */
- (UIView *)cellView:(WbqCycleScrollView *)cycleScrollView viewForItemAtIndex:(NSInteger)index;

@end

@protocol WbqCycleScrollViewDelegate <NSObject>

@optional

/** 点击图片回调 */
- (void)cycleScrollView:(WbqCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

/** 图片滚动回调 */
- (void)cycleScrollView:(WbqCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;

@end

