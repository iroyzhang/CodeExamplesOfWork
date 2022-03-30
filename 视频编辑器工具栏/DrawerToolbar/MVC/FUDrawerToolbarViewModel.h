//
//  FUDrawerToolbarViewModel.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/12.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RACSignal;
@class RACSubject;
@class FUToolbarModel;
@class FUFeatureState;
@class FUToolbarTreeGenerator;
@class FUDrawerToolbarModel;
@class FUFeatureDrawerNode;
@class FUToolbarDrawerNode;
@class FUSliderViewModel;
@class FUFeatureNavigationProperty;
@class FUFaceTrackViewModel;
@class FUSurfaceTrackViewModel;
@class FUAudiosViewModel;

@interface FUDrawerToolbarViewModel : NSObject
@property (nonatomic, strong) FUDrawerToolbarModel *presentationModel;
@property (nonatomic, strong) FUFeatureState *featureState;
@property (nonatomic, strong) FUToolbarTreeGenerator *toolbarTreeGenerator;
@property (nonatomic, strong) FUToolbarDrawerNode *activeDrawerNode;
@property (nonatomic, strong) FUSliderViewModel *activeSliderViewModel;
@property (nonatomic, strong) FUFeatureNavigationProperty *navigationProperty;
@property (nonatomic, strong) FUFaceTrackViewModel *faceTrackViewModel;
@property (nonatomic, strong) FUSurfaceTrackViewModel *surfaceTrackViewModel;
@property (nonatomic, strong) FUAudiosViewModel *audiosViewModel;
@property (nonatomic, strong) RACSignal *featureCompositionProcessModel;
@property (nonatomic, strong) RACSignal *sliderViewModelSignal;
@property (nonatomic, strong) RACSignal *hueAdjustSliderViewModelSignal;
@property (nonatomic, strong) RACSignal *mainNodePressed;
@property (nonatomic, strong) RACSignal *subNodePressed;
@property (nonatomic, strong) RACSignal *segmentNodePressed;
@property (nonatomic, strong) RACSignal *segmentIndexChanged;
@property (nonatomic, strong) RACSignal *audioRecordNodePressed;
@property (nonatomic, strong) RACSignal *reselectSurfaceTrack;
@property (nonatomic, strong) RACSignal *selectedSticker;
@property (nonatomic, strong) RACSignal *selectedStickerInfo;
@property (nonatomic, strong) RACSignal *selectedMainToolbarItem;
@property (nonatomic, strong) RACSignal *selectedSubToolbarItem;
@property (nonatomic, strong) RACSignal *selectedSegmentToolbarItem;
@property (nonatomic, strong) RACSignal *selectedSegmentControl;
@property (nonatomic, strong) RACSignal *selectedAudioRecordButton;
@property (nonatomic, strong) RACSignal *reselectSurfaceTrackButtonTapped;
@property (nonatomic, strong) RACSignal *sliderValueChanged;
@property (nonatomic, strong) RACSignal *hueAdjustSliderValueChanged;
@property (nonatomic, strong) RACSignal *navigateToBack;
@property (nonatomic, strong) RACSignal *navigateToClose;
@property (nonatomic, strong) RACSignal *navigateToNext;
@property (nonatomic, strong) RACSignal *surfaceTrackCompleted;
@property (nonatomic, strong) RACSignal *updateSpeedKeyframe;
@property (nonatomic, strong) RACSignal *resetSpeedKeyframes;
@property (nonatomic, strong) RACSignal *speedKeyframeButtonTapped;
@property (nonatomic, strong) RACSignal *speedResetButtonTapped;
@property (nonatomic, strong) RACSubject *startSurfaceTrack;
@property (nonatomic, strong) RACSubject *stickersViewHidden;
@property (nonatomic, strong) RACSubject *stickersOKButtonTapped;
@property (nonatomic, strong) RACSubject *deleteCurrentSticker;
@property (nonatomic, assign) BOOL navigationBarHidden;
@property (nonatomic, assign) BOOL toolbarHidden;

@property (nonatomic) RACSignal *speedKeyframeStatus;

@property (nonatomic, assign, getter=isAnimating) BOOL animating;
@end

NS_ASSUME_NONNULL_END
