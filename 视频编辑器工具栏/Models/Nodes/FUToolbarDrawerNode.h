//
//  FUToolbarDrawerModel.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/2.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FUToolbarItem;
@class FUToolbarDrawerSliderNode;
@class FUToolbarDrawerSegmentedNode;

typedef NS_ENUM(NSUInteger, FUToolbarDrawerNodeStyle) {
    FUToolbarDrawerNodeStyleMainAndSub,
    FUToolbarDrawerNodeStyleMainAndSlider,
    FUToolbarDrawerNodeStyleMainAndSegmented,
    FUToolbarDrawerNodeStyleMain,
    FUToolbarDrawerNodeStyleSlider,
    FUToolbarDrawerNodeStyleSegmentedAndSlider,
    FUToolbarDrawerNodeStyleRecord,
    FUToolbarDrawerNodeStyleHueAdjust,
    FUToolbarDrawerNodeStyleMainAndSliderAndButton,
};

@interface FUToolbarDrawerNode : NSObject
@property (nonatomic, assign) FUToolbarDrawerNodeStyle style;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray<FUToolbarItem *> *mainItems;
@property (nonatomic, copy, nullable) NSArray<FUToolbarItem *> *subItems;
@property (nonatomic, copy, nullable) NSString *mainTitle;
@property (nonatomic, copy, nullable) NSString *subTitile;
@property (nonatomic, assign) double sliderValue;
@property (nonatomic, strong, nullable) FUToolbarDrawerSliderNode *sliderNode;
@property (nonatomic, strong, nullable) NSArray<FUToolbarDrawerSegmentedNode *> *segmentedNodes;
@end

NS_ASSUME_NONNULL_END
