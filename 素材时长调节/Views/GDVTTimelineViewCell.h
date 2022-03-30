//
//  GDVTTimelineViewCell.h
//  GDMVideoEdit
//
//  Created by buze on 2021/11/25.
//

#import <UIKit/UIKit.h>

@class GDVTTimelineFrame;

NS_ASSUME_NONNULL_BEGIN

/// 时间轴视图Cell
@interface GDVTTimelineViewCell : UICollectionViewCell

/// 标识符
@property (nonatomic, strong) GDVTTimelineFrame *timelineFrame ;

/// 缩略图视图
@property (nonatomic, strong, readonly) UIImageView *thumbnailImageView;

/// 添加圆角
/// @param corners 圆角边选项
/// @param radii 圆角半径
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;

/// 移除圆角
- (void)removeRoundedCorners;

@end

NS_ASSUME_NONNULL_END
