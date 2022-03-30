//
//  FUSurfaceTrackBar.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/8/12.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FUSurfaceTrackBar;

@protocol FUSurfaceTrackBarDelegate <NSObject>
- (void)surfaceTrackBar:(FUSurfaceTrackBar *)surfaceTrackBar reselectButtonTapped:(UIButton *)button;
- (void)surfaceTrackBar:(FUSurfaceTrackBar *)surfaceTrackBar addStickerButtonTapped:(UIButton *)button;
@end

@interface FUSurfaceTrackBar : UIView
@property (nonatomic, weak) id<FUSurfaceTrackBarDelegate> delegate;

@property (nonatomic, strong) UIButton *reselectButton;
@property (nonatomic, strong) UIButton *addStickerButton;
@end

NS_ASSUME_NONNULL_END
