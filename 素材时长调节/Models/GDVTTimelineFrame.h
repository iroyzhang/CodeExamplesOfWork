//
//  GDVTTimelineFrame.h
//  GDMVideoEdit
//
//  Created by buze on 2021/11/25.
//

#import <Foundation/Foundation.h>

@class GDVTTimelineIdentifier;

NS_ASSUME_NONNULL_BEGIN

/// 时间轴帧模型
@interface GDVTTimelineFrame : NSObject <NSCopying>

/// 标识符
@property (nonatomic, copy) NSString *identifier;

/// 素材标识符，往往是素材路径
@property (nonatomic, copy) NSString *assetIdentifier;

/// 帧序号
@property (nonatomic, assign) NSUInteger frameIndex;

/// 帧宽度
@property (nonatomic, assign) CGFloat frameWidth;

/// 初始化方法
/// @param identifier 标识符
/// @param assetIdentifier 素材标识符
/// @param frameIndex 帧序号
/// @param frameWidth 帧宽度
- (instancetype)initWithIdentifier:(NSString *)identifier
                   assetIdentifier:(NSString *)assetIdentifier
                        frameIndex:(NSUInteger)frameIndex
                        frameWidth:(CGFloat)frameWidth;

@end

NS_ASSUME_NONNULL_END
