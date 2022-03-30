//
//  GDVTTimelineViewConfiguration.h
//  GDMVideoEdit
//
//  Created by buze on 2021/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 时间轴视图配置
@interface GDVTTimelineViewConfiguration : NSObject

/// 内容高度
@property (nonatomic, assign) CGFloat contentHeight;

/// 时间轴视图内容间距
@property (nonatomic, assign) UIEdgeInsets contentInset;

/// 项目间距
@property (nonatomic, assign) CGFloat itemSpacing;

@end

NS_ASSUME_NONNULL_END
