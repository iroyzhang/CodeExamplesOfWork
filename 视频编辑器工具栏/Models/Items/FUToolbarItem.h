//
//  FUToolbarItem.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/1.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FUResourceItem.h"

@class FUToneGradientColorInfo;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FUToolbarItemStyle) {
    FUToolbarItemStyleNormal,
    FUToolbarItemStyleColor,
    FUToolbarItemStyleColorPalette,
    FUToolbarItemStyleFilter,
    FUToolbarItemStyleFormat,
    FUToolbarItemStyleResource,
    FUToolbarItemStyleGif,
    FUToolbarItemStyleSpeed,           // 速度弹出抽屉样式
};

@interface FUToolbarItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) id value;
@property (nullable, nonatomic, copy) NSString *iconName;
@property (nullable, nonatomic, copy) NSString *cornerName;
@property (nullable, nonatomic, copy) NSString *imageName;
@property (nonnull, nonatomic, copy) NSNumber *sliderValue;
@property (nonatomic, assign) FUToolbarItemStyle style;
@property (nonatomic, assign, getter=isAdjustable) BOOL adjustable;
@property (nonatomic, assign, getter=isHidden) BOOL hidden;
@property (nonatomic, assign, getter=isDisabled) BOOL disabled;
@property (nonatomic, assign, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, assign) BOOL canHighlighted;
@property (nonatomic, copy, nullable) NSString *displayFormat;
@property (nonatomic, assign) BOOL isArrangeable;
@property (nonatomic, weak, nullable) id<FUResourceItem> resource;
@property (nonatomic, nullable, copy) NSString *gradientBaseColorName;
@property (nonatomic, nullable) NSString *toneGradientColorName;
@property (nonatomic) CGFloat toneGradientColorScope;

//-(instancetype)initWithTitle:(NSString *)title value:(id)value iconName:(nullable NSString *)iconName style:(FUToolbarItemStyle)style;
-(instancetype)initWithTitle:(NSString *)title
                       value:(id)value
                    iconName:(nullable NSString *)iconName
                  cornerName:(nullable NSString *)cornerName
                       style:(FUToolbarItemStyle)style;
@end

NS_ASSUME_NONNULL_END

