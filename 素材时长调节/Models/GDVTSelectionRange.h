//
//  GDVTSelectionRange.h
//  GDMVideoEdit
//
//  Created by buze on 2021/11/29.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GDVTSelectionRangeUpdateReason) {
    GDVTSelectionRangeUpdateReasonNone,
    GDVTSelectionRangeUpdateReasonUpdateLocationOnly, ///< 只更新位置，不更新长度
    GDVTSelectionRangeUpdateReasonUpdateLengthOnly, ///< 更新长度
    GDVTSelectionRangeUpdateReasonUpdateLocationAndLength, ///< 更新位置也更新时长
};

NS_ASSUME_NONNULL_BEGIN

/// 选择范围类型
@interface GDVTSelectionRange : NSObject <NSCopying>

/// 起始点
@property (nonatomic, assign) CGFloat location;

/// 长度
@property (nonatomic, assign) CGFloat length;

/// 初始化方法
/// @param location 位置
/// @param length 长度
- (instancetype)initWithLocation:(CGFloat)location length:(CGFloat)length;

@end

NS_ASSUME_NONNULL_END
