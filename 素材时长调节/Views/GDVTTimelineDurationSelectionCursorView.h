//
//  GDVTTimelineDurationSelectionCursorView.h
//  GDMVideoEdit
//
//  Created by buze on 2021/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 时间轴时长选择游标视图
@interface GDVTTimelineDurationSelectionCursorView : UIView

/// 游标尺寸
@property (nonatomic, assign) CGSize cursorSize;

/// 连接线尺寸
@property (nonatomic, assign) CGSize jointLineSize;

/// 连接线间距
@property (nonatomic, assign) CGFloat jointLineSpacing;

/// 游标颜色
@property (nonatomic, strong) UIColor *cursorColor;

/// 连接线颜色
@property (nonatomic, strong) UIColor *jointLineColor;

/// 初始化方法
/// @param frame 位置尺寸
/// @param cursorSize 把手尺寸
/// @param jointLineSize 连接线尺寸
/// @param jointLineSpacing 连接线间距
- (instancetype)initWithFrame:(CGRect)frame
                   cursorSize:(CGSize)cursorSize
                jointLineSize:(CGSize)jointLineSize
             jointLineSpacing:(CGFloat)jointLineSpacing;

@end

NS_ASSUME_NONNULL_END
