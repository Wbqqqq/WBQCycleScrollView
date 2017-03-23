//
//  WbqCycleScrollView.m
//  WbqCycleScrollView
//
//  Created by wbq on 17/3/21.
//  Copyright © 2017年 汪炳权. All rights reserved.
//

#import "WbqCycleScrollView.h"
#import "WbqDefaultCollectionViewCell.h"
#import "WbqCustomCollectionViewCell.h"
#import "UIImageView+WebCache.h"

NSString * const ID = @"cycleCell";

@interface WbqCycleScrollView () <UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic, weak) UICollectionView *mainView; // 显示图片的collectionView
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *imagePathsGroup;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalItemsCount;


@property (nonatomic, strong) UIImageView *backgroundImageView; // 当imageURLs为空时的背景图

@end

@implementation WbqCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self setupMainView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialization];
    [self setupMainView];
}

- (void)initialization
{

    _autoScrollTimeInterval = 2.0;
    _titleLabelTextColor = [UIColor whiteColor];
    _titleLabelTextFont= [UIFont systemFontOfSize:14];
    _titleLabelBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _titleLabelHeight = 30;
    _titleLabelTextAlignment = NSTextAlignmentLeft;
    _autoScroll = YES;
    _infiniteLoop = YES;
    
    _pageControlStyle = WbqCycleCHIPageControlAjiStyle;
    _bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.backgroundColor = [UIColor lightGrayColor];

}

- (void)setupMainView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    [mainView registerClass:[WbqDefaultCollectionViewCell class] forCellWithReuseIdentifier:ID];
    [mainView registerClass:[WbqCustomCollectionViewCell class] forCellWithReuseIdentifier:ID];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    mainView.dataSource = self;
    mainView.delegate = self;
    mainView.scrollsToTop = NO;
    [self addSubview:mainView];
    _mainView = mainView;
}

#pragma mark - properties

- (void)setPlaceholderImage:(UIImage *)placeholderImage
{
    _placeholderImage = placeholderImage;
    
    if (!self.backgroundImageView) {
        UIImageView *bgImageView = [UIImageView new];
        bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self insertSubview:bgImageView belowSubview:self.mainView];
        self.backgroundImageView = bgImageView;
    }
    
    self.backgroundImageView.image = placeholderImage;
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop
{
    _infiniteLoop = infiniteLoop;
    
    if (self.imagePathsGroup.count) {
        self.imagePathsGroup = self.imagePathsGroup;
    }
}

-(void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    
    [self invalidateTimer];
    
    if (_autoScroll) {
        [self setupTimer];
    }
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;
    
    _flowLayout.scrollDirection = scrollDirection;
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval
{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [self setAutoScroll:self.autoScroll];
}

- (void)setPageControlStyle:(WbqCycleScrollViewPageContolStyle)pageControlStyle
{
    _pageControlStyle = pageControlStyle;
    
    [self setupPageControl];
}

- (void)setImagePathsGroup:(NSArray *)imagePathsGroup
{
    [self invalidateTimer];
    
    _imagePathsGroup = imagePathsGroup;
    
    _totalItemsCount = self.infiniteLoop ? self.imagePathsGroup.count * 100 : self.imagePathsGroup.count;
    
    if (imagePathsGroup.count != 1) {
        self.mainView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    } else {
        self.mainView.scrollEnabled = NO;
    }
    
    [self setupPageControl];
    [self.mainView reloadData];
}

- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup
{
    _imageURLStringsGroup = imageURLStringsGroup;
    
    NSMutableArray *temp = [NSMutableArray new];
    [_imageURLStringsGroup enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * stop) {
        NSString *urlString;
        if ([obj isKindOfClass:[NSString class]]) {
            urlString = obj;
        } else if ([obj isKindOfClass:[NSURL class]]) {
            NSURL *url = (NSURL *)obj;
            urlString = [url absoluteString];
        }
        if (urlString) {
            [temp addObject:urlString];
        }
    }];
    self.imagePathsGroup = [temp copy];
}

- (void)setLocalizationImageNamesGroup:(NSArray *)localizationImageNamesGroup
{
    _localizationImageNamesGroup = localizationImageNamesGroup;
    self.imagePathsGroup = [localizationImageNamesGroup copy];
}

- (void)setTitlesGroup:(NSArray *)titlesGroup
{
    _titlesGroup = titlesGroup;
    if (self.onlyDisplayText) {
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < _titlesGroup.count; i++) {
            [temp addObject:@""];
        }
        self.backgroundColor = [UIColor clearColor];
        self.imageURLStringsGroup = [temp copy];
    }
}

-(void)setCustomNumofPage:(NSInteger)customNumofPage
{
    _customNumofPage = customNumofPage;
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < _customNumofPage; i++) {
        [temp addObject:@""];
    }
    self.backgroundColor = [UIColor clearColor];
    self.imageURLStringsGroup = [temp copy];

}


#pragma mark - actions

- (void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)setupPageControl
{
    if (_pageControl) [_pageControl removeFromSuperview]; // 重新加载数据时调整
    
    if (self.imagePathsGroup.count == 0 || self.onlyDisplayText) return;
    
    if ((self.imagePathsGroup.count == 1) && self.pageControl.hidesForSinglePage) return;
    
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:[self currentIndex]];
    
    switch (self.pageControlStyle) {
        case WbqCycleCHIPageControlAjiStyle:
        {
            CHIPageControlAji *pageControl = [[CHIPageControlAji alloc] init];
            pageControl.numberOfPages = self.imagePathsGroup.count;
            pageControl.tintColor = [UIColor whiteColor];
            pageControl.userInteractionEnabled = NO;
            pageControl.progress = indexOnPageControl;
            pageControl.radius = 4.0;
            pageControl.padding = 5.0;
            pageControl.borderWidth = 1;
            pageControl.inactiveTransparency = 0;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
            
        case WbqCycleCHIPageControlJalapenoStyle:
        {
            CHIPageControlJalapeno *pageControl = [[CHIPageControlJalapeno alloc] init];
            pageControl.numberOfPages = self.imagePathsGroup.count;
            pageControl.tintColor = [UIColor whiteColor];
            pageControl.userInteractionEnabled = NO;
            pageControl.progress = indexOnPageControl;
            pageControl.radius = 4.0;
            pageControl.padding = 5.0;
            pageControl.borderWidth = 1;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
            
        case WbqCycleCHIPageControlAleppoStyle:
        {
            CHIPageControlAleppo *pageControl = [[CHIPageControlAleppo alloc] init];
            pageControl.numberOfPages = self.imagePathsGroup.count;
            pageControl.tintColor = [UIColor whiteColor];
            pageControl.userInteractionEnabled = NO;
            pageControl.progress = indexOnPageControl;
            pageControl.radius = 4.0;
            pageControl.padding = 5.0;
            pageControl.borderWidth = 1;
            pageControl.inactiveTransparency = 0;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
            
        case WbqCycleCHIPageControlChimayoStyle:
        {
            CHIPageControlChimayo *pageControl = [[CHIPageControlChimayo alloc] init];
            pageControl.numberOfPages = self.imagePathsGroup.count;
            pageControl.tintColor = [UIColor whiteColor];
            pageControl.userInteractionEnabled = NO;
            pageControl.progress = indexOnPageControl;
            pageControl.radius = 4.0;
            pageControl.padding = 5.0;
            pageControl.borderWidth = 1;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
            
        case WbqCycleCHIPageControlFresnoStyle:
        {
            CHIPageControlFresno *pageControl = [[CHIPageControlFresno alloc] init];
            pageControl.numberOfPages = self.imagePathsGroup.count;
            pageControl.tintColor = [UIColor whiteColor];
            pageControl.userInteractionEnabled = NO;
            pageControl.progress = indexOnPageControl;
            pageControl.radius = 4.0;
            pageControl.padding = 5.0;
            pageControl.borderWidth = 1;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
            
        case WbqCycleCHIPageControlJaloroStyle:
        {
            CHIPageControlJaloro *pageControl = [[CHIPageControlJaloro alloc] init];
            pageControl.numberOfPages = self.imagePathsGroup.count;
            pageControl.tintColor = [UIColor whiteColor];
            pageControl.userInteractionEnabled = NO;
            pageControl.progress = indexOnPageControl;
            pageControl.radius = 1.0;
            pageControl.padding = 5.0;
            pageControl.elementWidth = 12.0;
            pageControl.elementHeight = 1.0;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
            
        case WbqCycleCHIPageControlPaprikaStyle:
        {
            CHIPageControlPaprika *pageControl = [[CHIPageControlPaprika alloc] init];
            pageControl.numberOfPages = self.imagePathsGroup.count;
            pageControl.tintColor = [UIColor whiteColor];
            pageControl.userInteractionEnabled = NO;
            pageControl.progress = indexOnPageControl;
            pageControl.radius = 4.0;
            pageControl.padding = 5.0;
            pageControl.borderWidth = 1;
            pageControl.inactiveTransparency = 0;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
        case WbqCycleCHIPageControlPuyaStyle:
        {
            CHIPageControlPuya *pageControl = [[CHIPageControlPuya alloc] init];
            pageControl.numberOfPages = self.imagePathsGroup.count;
            pageControl.tintColor = [UIColor whiteColor];
            pageControl.userInteractionEnabled = NO;
            pageControl.progress = indexOnPageControl;
            pageControl.radius = 4.0;
            pageControl.padding = 5.0;
            [self addSubview:pageControl];
            _pageControl = pageControl;
        }
            break;
            
        default:
            break;
    }
    
    
}

- (void)automaticScroll
{
    if (0 == _totalItemsCount) return;
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

- (void)scrollToIndex:(int)targetIndex
{
    if (targetIndex >= _totalItemsCount) {
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
            [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        return;
    }
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}


- (int)currentIndex
{
    if (_mainView.frame.size.width == 0 || _mainView.frame.size.height == 0) {
        return 0;
    }
    
    int index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (_mainView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    } else {
        index = (_mainView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height;
    }
    
    return MAX(0, index);
}


- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    return (int)index % self.imagePathsGroup.count;
    
   
}


#pragma mark - life circles

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _flowLayout.itemSize = self.frame.size;
    
    _mainView.frame = self.bounds;
    if (_mainView.contentOffset.x == 0 &&  _totalItemsCount) {
        int targetIndex = 0;
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
        }else{
            targetIndex = 0;
        }
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    CGSize size = CGSizeZero;
    
    size = _pageControl.intrinsicContentSize;
    
    CGFloat x = self.mainView.frame.size.width - size.width - 10;
    
    CGFloat y = self.mainView.frame.size.height - size.height - 10;
    
    CGRect DefaultpageControlFrame = CGRectMake(x, y, size.width, size.height);
  
    self.pageControl.frame = DefaultpageControlFrame;
    
    if(self.pageControlCenter.x)
    {
        self.pageControl.center = self.pageControlCenter;
    }
    
    if (self.backgroundImageView) {
        self.backgroundImageView.frame = self.bounds;
    }
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃

- (void)dealloc {
    _mainView.delegate = nil;
    _mainView.dataSource = nil;
}

#pragma mark - public actions

- (void)adjustWhenControllerViewWillAppera
{
    long targetIndex = [self currentIndex];
    if (targetIndex < _totalItemsCount) {
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    
    if ([self.dataSource respondsToSelector:@selector(cellView:viewForItemAtIndex:)]) {
        
        WbqCustomCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        
        cell.itemView = [self.dataSource cellView:self viewForItemAtIndex:itemIndex];
        
        return cell;
    }
    
    WbqDefaultCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    NSString *imagePath = self.imagePathsGroup[itemIndex];
    
    if (!self.onlyDisplayText && [imagePath isKindOfClass:[NSString class]]) {
        if ([imagePath hasPrefix:@"http"]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:self.placeholderImage];
        } else {
            UIImage *image = [UIImage imageNamed:imagePath];
            if (!image) {
                [UIImage imageWithContentsOfFile:imagePath];
            }
            cell.imageView.image = image;
        }
    } else if (!self.onlyDisplayText && [imagePath isKindOfClass:[UIImage class]]) {
        cell.imageView.image = (UIImage *)imagePath;
    }
    
    if (_titlesGroup.count && itemIndex < _titlesGroup.count) {
        cell.title = _titlesGroup[itemIndex];
    }
    
    if (!cell.hasConfigured) {
        cell.titleLabelBackgroundColor = self.titleLabelBackgroundColor;
        cell.titleLabelHeight = self.titleLabelHeight;
        cell.titleLabelTextAlignment = self.titleLabelTextAlignment;
        cell.titleLabelTextColor = self.titleLabelTextColor;
        cell.titleLabelTextFont = self.titleLabelTextFont;
        cell.hasConfigured = YES;
        cell.imageView.contentMode = self.bannerImageViewContentMode;
        cell.clipsToBounds = YES;
        cell.onlyDisplayText = self.onlyDisplayText;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:[self pageControlIndexWithCurrentCellIndex:indexPath.item]];
    }
    if (self.clickItemOperationBlock) {
        self.clickItemOperationBlock([self pageControlIndexWithCurrentCellIndex:indexPath.item]);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.imagePathsGroup.count) return; // 解决清除timer时偶尔会出现的问题
    
      double offset = (double)((double)_mainView.contentOffset.x) /(double) _flowLayout.itemSize.width;
      int temp = (int)offset;
      int result = temp % self.imageURLStringsGroup.count;
      double  progress = offset - temp  + result;
      self.pageControl.progress = progress;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:self.mainView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (!self.imagePathsGroup.count) return; // 解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
        [self.delegate cycleScrollView:self didScrollToIndex:indexOnPageControl];
    } else if (self.itemDidScrollOperationBlock) {
        self.itemDidScrollOperationBlock(indexOnPageControl);
    }
}


@end
