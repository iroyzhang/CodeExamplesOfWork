//
//  FUDrawerToolbar.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/9.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FUToolbarDrawerNode;
@class FUSliderViewModel;
@class FUToolbarDrawerSliderNode;

@protocol FUDrawerToolbar <NSObject>
- (void)reloadData;
- (CGFloat)fullHeight;
- (CGFloat)defaultHeight;

@optional
@property (nonatomic, assign, getter=isFullScreen) BOOL isSliderHidden;
- (void)showSlider:(BOOL)animated;
- (void)hideSlider:(BOOL)animated;
- (void)setSliderValue:(float)value minimumValue:(float)minimumValue maximumValue:(float)maximumValue continuous:(BOOL)continuous displayFormat:(NSString *)displayFormat;
/// 隐藏/显示滑动条左右两侧按钮
- (void)isHideSliderButton:(BOOL)isHide;

@end

NS_ASSUME_NONNULL_END
