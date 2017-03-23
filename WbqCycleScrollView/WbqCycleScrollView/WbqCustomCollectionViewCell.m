//
//  WbqCustomCollectionViewCell.m
//  WbqCycleScrollView
//
//  Created by wbq on 17/3/23.
//  Copyright © 2017年 汪炳权. All rights reserved.
//

#import "WbqCustomCollectionViewCell.h"

@implementation WbqCustomCollectionViewCell

@synthesize itemView = _itemView;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.itemView.frame = self.bounds;
}

- (UIView *)itemView
{
    if (!_itemView) {
        _itemView = [[UIView alloc] init];
    }
    return _itemView;
}

- (void)setItemView:(UIView *)itemView
{
    if (_itemView) {
        [_itemView removeFromSuperview];
    }
    
    _itemView = itemView;
    
    [self addSubview:_itemView];
}


@end
