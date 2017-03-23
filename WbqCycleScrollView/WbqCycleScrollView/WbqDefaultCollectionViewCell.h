//
//  WbqCollectionViewCell.h
//  WbqCycleScrollView
//
//  Created by wbq on 17/3/21.
//  Copyright © 2017年 汪炳权. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WbqDefaultCollectionViewCell : UICollectionViewCell




@property (weak, nonatomic) UIImageView *imageView;
@property (copy, nonatomic) NSString *title;

@property (nonatomic, strong) UIColor *titleLabelTextColor;
@property (nonatomic, strong) UIFont *titleLabelTextFont;
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;
@property (nonatomic, assign) CGFloat titleLabelHeight;
@property (nonatomic, assign) NSTextAlignment titleLabelTextAlignment;

@property (nonatomic, assign) BOOL hasConfigured;

/** 只展示文字轮播 */
@property (nonatomic, assign) BOOL onlyDisplayText;

@end
