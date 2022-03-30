//
//  FUToolbarViewModel.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/3.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RACSignal;
@class FUToolbarModel;
@class FUFeatureState;
@class FUToolbarTreeGenerator;
@class FUToolbarNode;
@class FUFeatureNavigationProperty;

@interface FUToolbarViewModel : NSObject
@property (nonatomic, strong, nullable) FUToolbarModel *presentationModel;
@property (nonatomic, strong, readonly) FUToolbarNode *currentNode;
@property (nonatomic, strong) FUFeatureState *featureState;
@property (nonatomic, assign) CMTime seekTime;
@property (nonatomic, strong) RACSignal *featureCompositionProcessModel;
@property (nonatomic, strong) RACSignal *toolbarItemSelected;
@property (nonatomic, strong) RACSignal *toolBarItemLongPressed;
@property (nonatomic, strong) RACSignal *toolbarSectionTapped;
@property (nonatomic, strong) RACSignal *backPressed;
@property (nonatomic, strong) RACSignal *selectedToolbarItem;
@property (nonatomic, strong) RACSignal *nodePressed;
@property (nonatomic, strong) RACSignal *nodeLongPressed;
@property (nonatomic, strong) RACSignal *toolbarBackButtonTapped;
@property (nonatomic, strong) RACSignal *navigateToClose;
@property (nonatomic, strong) RACSignal *navigateToNext;
@property (nonatomic, strong) RACSignal *navigationNextButtonTapped;
@property (nonatomic, strong) RACSignal *navigationCloseButtonTapped;
@property (nonatomic, strong) FUToolbarTreeGenerator *toolbarTreeGenerator;
@property (nonatomic, strong) FUFeatureNavigationProperty *navigationProperty;
@property (nonatomic, assign) BOOL navigationBarHidden;
@property (nonatomic, assign) BOOL valid;
@end

NS_ASSUME_NONNULL_END
