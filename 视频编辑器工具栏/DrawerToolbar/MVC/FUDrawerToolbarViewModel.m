//
//  FUDrawerToolbarViewModel.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/12.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUDrawerToolbarViewModel.h"
#import "FUToolbarTreeGenerator.h"
#import "FUFeatureState.h"
#import "FUDrawerToolbarModel.h"
#import "FUFeatureTreeNavigationState.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "FUFeatureNode.h"
#import "FUFeatureDrawerNode.h"
#import <Mantle/Mantle.h>
#import "FUCompositionProcessModel.h"
#import "FUComposition.h"
#import "FUTextProcessor.h"
#import "FUFrameModel.h"
#import "FUMediaProcessModel.h"
#import "FUImageProcessModel.h"
#import "FUSublayerProcessor.h"
#import "FUAudioRecordButton.h"
#import "FUVignettingProcessModel.h"
#import "FUBlurProcessModel.h"
#import "FUStickersManager.h"
#import "FUTrackSticker.h"
#import <Photos/Photos.h>

@implementation FUDrawerToolbarViewModel

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        _toolbarTreeGenerator = [[FUToolbarTreeGenerator alloc] init];
        _toolbarHidden = NO;
        _navigationBarHidden = YES;
        _startSurfaceTrack = [RACSubject subject];
        _stickersViewHidden = [RACSubject subject];
        _stickersOKButtonTapped = [RACSubject subject];
        _deleteCurrentSticker = [RACSubject subject];
        [self setupNodePressedSignals];
        [self setupNavigationStateSignals];
    }
    return self;
}

- (void)setupNodePressedSignals {
    RACSignal *selectedMainToolbarItemSignal = RACObserve(self, selectedMainToolbarItem);
    selectedMainToolbarItemSignal = [selectedMainToolbarItemSignal switchToLatest];
    selectedMainToolbarItemSignal = [selectedMainToolbarItemSignal map:^id _Nullable(id  _Nullable value) {
        return value;
    }];
    _mainNodePressed = selectedMainToolbarItemSignal;
    
    RACSignal *selectedSubToolbarItemSignal = RACObserve(self, selectedSubToolbarItem);
    selectedSubToolbarItemSignal = [selectedSubToolbarItemSignal switchToLatest];
    selectedSubToolbarItemSignal = [selectedSubToolbarItemSignal map:^id _Nullable(id  _Nullable value) {
        return value;
    }];
    _subNodePressed = selectedSubToolbarItemSignal;
    
    RACSignal *selectedSegmentToolbarItem = RACObserve(self, selectedSegmentToolbarItem);
    selectedSegmentToolbarItem = [selectedSegmentToolbarItem switchToLatest];
    selectedSegmentToolbarItem = [selectedSegmentToolbarItem map:^id _Nullable(id  _Nullable value) {
        return value;;
    }];
    _segmentNodePressed = selectedSegmentToolbarItem;
    
    RACSignal *selectedSegmentControlSignal = RACObserve(self, selectedSegmentControl);
    selectedSegmentControlSignal = [selectedSegmentControlSignal switchToLatest];
    selectedSegmentControlSignal = [selectedSegmentControlSignal map:^id _Nullable(id  _Nullable value) {
        RACTuple *tuple = (RACTuple *)value;
        return tuple.second;
    }];
    _segmentIndexChanged = selectedSegmentControlSignal;
    
    RACSignal *selectedAudioRecordButtonSiganl = RACObserve(self, selectedAudioRecordButton);
    selectedAudioRecordButtonSiganl = [selectedAudioRecordButtonSiganl switchToLatest];
    selectedAudioRecordButtonSiganl = [selectedAudioRecordButtonSiganl map:^id _Nullable(id  _Nullable value) {
        RACTuple *tuple = (RACTuple *)value;
        FUAudioRecordButton *audioRecordButton = tuple.second;
        if (audioRecordButton.recordStatus == FUAudioRecordStatusPlaying) {
            return @(YES);
        } else {
            return @(NO);
        }
    }];
    _audioRecordNodePressed = selectedAudioRecordButtonSiganl;
    
    RACSignal *reselectSurfaceTrackSignal = RACObserve(self, reselectSurfaceTrackButtonTapped);
    reselectSurfaceTrackSignal = [reselectSurfaceTrackSignal switchToLatest];
    reselectSurfaceTrackSignal = [reselectSurfaceTrackSignal map:^id _Nullable(id  _Nullable value) {
        return value;
    }];
    _reselectSurfaceTrack = reselectSurfaceTrackSignal;
    
    RACSignal *selectedStickerSignal = RACObserve(self, selectedStickerInfo);
    selectedStickerSignal = [selectedStickerSignal switchToLatest];
    selectedStickerSignal = [selectedStickerSignal map:^id _Nullable(id  _Nullable value) {
        return value;
    }];
    _selectedSticker = selectedStickerSignal;
    
    RACSignal *speedKeyframeButtonTappedSignal = RACObserve(self, speedKeyframeButtonTapped);
    speedKeyframeButtonTappedSignal = [speedKeyframeButtonTappedSignal switchToLatest];
    speedKeyframeButtonTappedSignal = [speedKeyframeButtonTappedSignal map:^id _Nullable(id  _Nullable value) {
        return value;
    }];
    _updateSpeedKeyframe = speedKeyframeButtonTappedSignal;
    
    RACSignal *speedResetButtonTappedSignal = RACObserve(self, speedResetButtonTapped);
    speedResetButtonTappedSignal = [speedResetButtonTappedSignal switchToLatest];
    speedResetButtonTappedSignal = [speedResetButtonTappedSignal map:^id _Nullable(id  _Nullable value) {
        return value;
    }];
    _resetSpeedKeyframes = speedResetButtonTappedSignal;
}

- (void)setupNavigationStateSignals {
    RACSignal *featureStateSignal = RACObserve(self, featureState);
    featureStateSignal = [featureStateSignal ignore:nil];
    featureStateSignal = [featureStateSignal replayLast];
    RACSignal *newToolbarModelSignal = [featureStateSignal map:^id _Nullable(id  _Nullable value) {
        FUFeatureState *featureState = (FUFeatureState *)value;
        FUFeatureNode *featureTree = featureState.navigationState.featureTree;
        FUToolbarNode *toolbarTree = [self.toolbarTreeGenerator toolbarTreeForFeatureTree:featureTree featureObjects:[self featureObjects]];
        FUDrawerToolbarModel *toolbarModel = [[FUDrawerToolbarModel alloc] initWithRoot:toolbarTree];
        if (featureState.navigationState.activeDrawerNode) {
            toolbarModel.activeDrawerNode = [self.toolbarTreeGenerator toolbarDrawerNodeForFeatureDrawerNode:featureState.navigationState.activeDrawerNode featureObjects:[self featureObjects]];
            
        }
        return toolbarModel;
    }];
    RAC(self, presentationModel) = newToolbarModelSignal;
}

#pragma mark - Custom Accessors

- (FUToolbarDrawerNode *)activeDrawerNode {
    FUToolbarDrawerNode *node = [self.toolbarTreeGenerator toolbarDrawerNodeForFeatureDrawerNode:self.featureState.navigationState.activeDrawerNode featureObjects:[self featureObjects]];
    return node;
}

#pragma mark - Helpers

- (NSDictionary *)featureObjects {
    NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
    id processModel = self.featureState.processModel;
    if (self.featureState) {
        [tempDictionary setObject:self.featureState forKey:NSStringFromClass([self.featureState class])];
    }
    if (processModel) {
        [tempDictionary setObject:processModel forKey:NSStringFromClass([processModel class])];
        if ([processModel respondsToSelector:@selector(imageProcessModel)]) {
            FUImageProcessModel *imageProcessModel = [processModel performSelector:@selector(imageProcessModel)];
            [tempDictionary setObject:imageProcessModel.maskProcessModel forKey:NSStringFromClass([FUMaskProcessModel class])];
        }else if ([processModel respondsToSelector:@selector(maskProcessModel)]) {
            FUMaskProcessModel *maskProcessModel = [processModel performSelector:@selector(maskProcessModel)];
            [tempDictionary setObject:maskProcessModel forKey:NSStringFromClass([FUMaskProcessModel class])];
        }
    }
    FUCanvasInfo *canvas = self.featureState.compositionProcessModel.composition.canvasInfo;
    if (canvas) {
        [tempDictionary setObject:canvas forKey:NSStringFromClass([canvas class])];
    }
    
    NSUUID *selectedID = self.featureState.compositionProcessModel.selectedID;
    id<FUProcessSubLayer> object = [self.featureState.compositionProcessModel.composition objectByIdentifier:selectedID];
    if ([object isKindOfClass:[FUTextProcessor class]]) {
        FUTextProcessor *textProcessor = (FUTextProcessor *)object;
        FUFrameModel *frameModel = textProcessor.frameModel;
        if (frameModel) {
            [tempDictionary setObject:frameModel forKey:NSStringFromClass([FUFrameModel class])];
        }
    } else if ([object isKindOfClass:[FUSublayerProcessor class]]) {
        FUSublayerProcessor *sublayerProcessor = (FUSublayerProcessor *)object;
        FUFrameModel *frameModel = sublayerProcessor.frameModel;
        [tempDictionary setObject:frameModel forKey:NSStringFromClass([FUFrameModel class])];
    } else if ([object isKindOfClass:[FUTransition class]]) {
        FUTransition *transition = (FUTransition *)object;
        [tempDictionary setObject:transition forKey:NSStringFromClass([FUTransition class])];
    }else{
        FUFrameModel *frameModel = object.frameModel;
        if ([frameModel.processModel isKindOfClass:[FUVignettingProcessModel class]] || [frameModel.processModel isKindOfClass:[FUBlurProcessModel class]]) {
            [tempDictionary setObject:frameModel forKey:NSStringFromClass([FUFrameModel class])];
        }
        if ([object isKindOfClass:[FUMainTrack class]]) {
            [tempDictionary setObject:object forKey:NSStringFromClass([FUMainTrack class])];
        }
    }
    
    return [tempDictionary copy];
}

@end
