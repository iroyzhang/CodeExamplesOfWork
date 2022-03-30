//
//  GDVTPannelContainerView.h
//  GDMVideoEdit
//
//  Created by buze on 2021/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 面板容器视图
@interface GDVTPannelContainerView : UIView

/// 触碰非内容区域的回调
@property (nonatomic, copy, nullable) void(^tappedNonContentArea)(void);

/// 内容视图
@property (nonatomic, strong, readonly) UIView *contentView;

/// 内容视图高度
@property (nonatomic, assign) CGFloat contentViewHeight;

/// 初始化方法
/// @param frame 位置尺寸
/// @param contentViewHeight 内容视图高度
/// @param tappedNonContentArea 触碰非内容区域回调
- (instancetype)initWithFrame:(CGRect)frame
            contentViewHeight:(CGFloat)contentViewHeight
         tappedNonContentArea:(void(^ _Nullable)(void))tappedNonContentArea;

/// 设置主视图
/// @param mainView 主视图
- (void)setupMainView:(UIView *)mainView;

/// 设置次要视图
/// @param subview 次要视图
- (void)setupSubview:(UIView *)subview;

@end

NS_ASSUME_NONNULL_END
