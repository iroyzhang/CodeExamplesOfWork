//
//  GDVTElementDurationAdjustViewController.h
//  GDMVideoEdit
//
//  Created by buze on 2021/11/23.
//

#import "GDVEFunctionBaseViewController.h"
#import "GDVEFunctionProtocol.h"

@class GDVEBaseCoat, GDVTElementDurationAdjustViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol GDVTElementDurationAdjustViewControllerDelegate <GDVEFunctionViewControllerDelegate>

@optional

/// 已更新元素时长
/// @param elementDurationAdjustViewController 元素时长调节控制器
/// @param coatUuid coat标识符
- (void)elementDurationAdjustViewController:(GDVTElementDurationAdjustViewController *)elementDurationAdjustViewController
           didUpdatedWithCoatUuid:(NSString *)coatUuid;

/// 已经Seek到某时刻
/// @param elementDurationAdjustViewController 元素时长调节控制器
/// @param time 时刻
- (void)elementDurationAdjustViewController:(GDVTElementDurationAdjustViewController *)elementDurationAdjustViewController
                             didSeekToTime:(long)time;

@end

/// 元素时长调节控制器
@interface GDVTElementDurationAdjustViewController : GDVEFunctionBaseViewController <GDVEFunctionProtocol>

@property (nonatomic, weak) id<GDVTElementDurationAdjustViewControllerDelegate> delegate;

/// 当前元素外衣
- (GDVEBaseCoat *)currentCoat;

/// 调整方法
/// @param coat 需要调整的元素Coat
- (void)adjustElementWithCoat:(GDVEBaseCoat *)coat;

/// 播放器当前进度
/// @param currentTime 当前时间，单位毫秒
- (void)videoPlayerWithTime:(long)currentTime;

@end

NS_ASSUME_NONNULL_END
