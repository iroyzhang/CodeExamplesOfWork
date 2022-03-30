//
//  FUDrawerToolbarController.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/12.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUDrawerToolbarController.h"
#import "FUDrawerToolbarView.h"
#import "FUDrawerToolbarViewModel.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "FUMainAndSliderDrawerToolbar.h"
#import "FUToolbarNode.h"
#import "FUToolbarModel.h"
#import "FUDrawerToolbarModel.h"
#import "FUToolbarFilterCell.h"
#import "FUToolbarSquareNormalCell.h"
#import "FUToolbarColorPaletteCell.h"
#import "FUToolbarFormatCell.h"
#import "FUToolbarColorCell.h"
#import "FUToolbarResourceCell.h"
#import "FUToolbarGifCell.h"
#import "FUToolbarSpeedCell.h"
#import "FUFeatureState.h"
#import "FUToolbarItem.h"
#import "TransformConstants.h"
#import "FUToolbarDrawerSegmentedNode.h"
#import "FUFeatureTreeNavigationState.h"
#import "FUFeatureNavigationProperty.h"
#import "FUStickersPageViewController.h"
#import "FUFaceTrackViewController.h"
#import "FUSurfaceTrackBar.h"
#import <Masonry/Masonry.h>
#import "FUProgress.h"
#import "FUProgressView.h"
#import "FUSurfaceTrackViewModel.h"
#import "FUAudiosPageViewController.h"
#import "FUAudiosViewModel.h"
#import "FUAlertView.h"
#import "FUSegmentedView.h"
#import "FUAlbumController.h"
#import "FUAlbumViewSettings.h"
#import "FUMyAudiosViewController.h"
#import "FUHueAdjustDrawerToolbar.h"

static CGFloat const kFloatingDrawerHeight = 120;
static CGFloat const kNavigatedViewHeight = 400;

@interface FUDrawerToolbarController () <FUDrawerToolbarViewDataSource, FUDrawerToolbarViewDelegate, FUStickersPageViewControllerDelegate, FUSurfaceTrackBarDelegate, FUAlertViewDelegate>
@property (nonatomic, strong) FUToolbarDrawerNode *drawerNode;
@property (nonatomic, strong) FUToolbarDrawerNode *currentNode;
@property (nonatomic, weak) UIViewController *floatingViewController;
@property (nonatomic, weak) UIViewController *navigatedViewController;
@property (nonatomic, strong) FUSurfaceTrackBar *surfaceTrackBar;
@property (nonatomic, assign) BOOL surfaceTrackBarHidden;
@property (nonatomic, strong) FUProgressView *progressView;
@property (nonatomic, strong) FUAlertView *alertView;
@end

@implementation FUDrawerToolbarController

#pragma mark - Init

- (instancetype)initWithViewModel:(FUDrawerToolbarViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)loadView {
    FUDrawerToolbarView *toolbarView = [[FUDrawerToolbarView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    toolbarView.dataSource = self;
    toolbarView.delegate = self;
    self.drawerToolbarView = toolbarView;
    self.view = toolbarView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSurfaceTrackBar];
    [self bindViewModel];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.navigatedViewController) {
//        [self dismissNavigatedViewControllerAniamted:animated];
        if ([self.navigatedViewController isKindOfClass:[FUStickersPageViewController class]]) {
            [self.viewModel.stickersViewHidden sendNext:@(YES)];
            self.viewModel.faceTrackViewModel.stickersViewHidden = YES;
        }
    }
}

- (void)setupSurfaceTrackBar {
    _surfaceTrackBar = [[FUSurfaceTrackBar alloc] init];
    _surfaceTrackBar.delegate = self;
    [self.view addSubview:_surfaceTrackBar];
    [_surfaceTrackBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.view);
        make.height.equalTo(@66);
    }];
    
    [self hideSurfaceTrackBar];
}

#pragma mark - Custom Accessors

- (FUProgressView *)progressView {
    if (!_progressView) {
        NSURL *jsonURL = [[NSBundle mainBundle] URLForResource:@"progress_loading" withExtension:@"json"];
        _progressView = [FUProgressView showInKeyWindowWithAnimationJsonURL:jsonURL];
    }
    return _progressView;
}

- (FUAlertView *)alertView {
    if (!_alertView) {
        _alertView = [FUAlertView showInWindow];
        _alertView.delegate = self;
    }
    return _alertView;
}

- (FUToolbarDrawerNode *)drawerNode {
    return _viewModel.activeDrawerNode;
}

#pragma mark - Binds

- (void)bindViewModel {
    @weakify(self);
    
    RACSignal *presentationModelSignal = RACObserve(self, viewModel.presentationModel);
    [presentationModelSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        FUDrawerToolbarModel *toolbarModel = (FUDrawerToolbarModel *)x;
        [self presentOrDimissWithNewNode:toolbarModel.activeDrawerNode];
    }];
    _viewModel.selectedMainToolbarItem = [self mainToolbarItemSelected];
    _viewModel.selectedSubToolbarItem = [self subToolbarItemSelected];
    _viewModel.selectedSegmentToolbarItem = [self segmentToolbarItemSelected];
    _viewModel.selectedAudioRecordButton = [self selectedAudioRecordButton];
    _viewModel.sliderValueChanged = [self sliderValueChanged];
    _viewModel.hueAdjustSliderValueChanged = [self hueAdjustSliderValueChanged];
    _viewModel.selectedSegmentControl = [self selectedSegmentedControl];
    _viewModel.reselectSurfaceTrackButtonTapped = [self reselectSurfaceTrackSignal];
    _viewModel.selectedStickerInfo = [self selectedStickerInfoSignal];
    _viewModel.speedKeyframeButtonTapped = [self speedKeyframeButtonDidTapped];
    _viewModel.speedResetButtonTapped = [self speedRestButtonDidTapped];
    
    [self.viewModel.featureCompositionProcessModel subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        FUFeatureNavigationProperty *navigationProperty = self.viewModel.navigationProperty;
        if (!self.viewModel.featureState.navigationState.activeNodeIndexPath) {
            if (navigationProperty.type == FUFeatureNavigationTypeClose || navigationProperty.type == FUFeatureNavigationTypeReplaceTrackSticker) {
                if ([self.navigatedViewController isKindOfClass:[FUStickersPageViewController class]]) {
                    [self.viewModel.stickersViewHidden sendNext:@(YES)];
                    self.viewModel.faceTrackViewModel.stickersViewHidden = YES;
                }
                [self dismissNavigatedViewControllerAniamted:YES];
            }
        }
    }];
    
    [self.viewModel.sliderViewModelSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.drawerToolbarView reloadSlider];
    }];
    
    [self.viewModel.hueAdjustSliderViewModelSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.drawerToolbarView reloadHueAdjustSliderWithViewModel:x];
    }];
    
    RAC(_viewModel, animating) = RACObserve(_drawerToolbarView, isAnimating);
    
    RACSignal *navigation = RACObserve(_viewModel, navigationProperty);
    [navigation subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (![x isKindOfClass:[FUFeatureNavigationProperty class]]) { return; }
        FUFeatureNavigationProperty *navigationProperty = (FUFeatureNavigationProperty *)x;
        [self handleNavigationProperty:navigationProperty];
    }];
    
    [_viewModel.navigateToClose subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self navigationToClose];
    }];
    
    [_viewModel.surfaceTrackCompleted subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self showSurfaceTrackBar];
    }];
    
    RACSubject *progressSubject = _viewModel.faceTrackViewModel.progressSubject;
    [progressSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([x isKindOfClass:[FUProgress class]]) {
                FUProgress *progress = (FUProgress *)x;
                switch (progress.state) {
                    case FUProgressStateProgress:
                        if (!self.floatingViewController.view.isHidden) {
                            self.floatingViewController.view.hidden = YES;
                        }
                        [self.progressView configureWithProgress:progress];
                        [self.progressView setCancelButtonHidden:YES];
                        break;
                    case FUProgressStateDone:
                        if (self.floatingViewController.view.isHidden) {
                            self.floatingViewController.view.hidden = NO;
                        }
                        [self hideProgressView];
                        break;
                    default:
                        break;
                }
            }
        });
    }];
    
    [_viewModel.navigateToBack subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self dismissFloatingViewControllerAniamted:YES];
        [self dismissNavigatedViewControllerAniamted:YES];
    }];
    
    [_viewModel.audiosViewModel.addAudioItem subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self dismissNavigatedViewControllerAniamted:YES];
    }];
    
    [_viewModel.speedKeyframeStatus subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSNumber *statusNumber = (NSNumber *)x;
        FUKeyFrameButtonStatus status = (FUKeyFrameButtonStatus)statusNumber.unsignedIntegerValue;
        [self.drawerToolbarView updateSpeedKeyframeButtonWithStatus:status];
    }];
}

- (void)bindSurfaceTrackViewModelWithFaceTrackViewController:(FUStickersPageViewController *)controller{
    RACSignal *stickerSelectedSignal = [self rac_signalForSelector:@selector(stickersPageViewController:didSelectedSticker:onPurpose:) fromProtocol:@protocol(FUStickersPageViewControllerDelegate)];
    stickerSelectedSignal = [stickerSelectedSignal map:^id _Nullable(RACTwoTuple *value) {
        FUTrackSticker *sticker = value.second;
        return sticker;
    }];

    stickerSelectedSignal = [stickerSelectedSignal takeUntil:controller.rac_willDeallocSignal];
    _viewModel.surfaceTrackViewModel.stickerSelectedSignal = stickerSelectedSignal;
}

- (void)bindFaceTrackViewModelWithFaceTrackViewController:(FUFaceTrackViewController *)controller{
    
    RACSignal *stickerSelectedSignal = [self rac_signalForSelector:@selector(stickersPageViewController:didSelectedSticker:onPurpose:) fromProtocol:@protocol(FUStickersPageViewControllerDelegate)];
    stickerSelectedSignal = [stickerSelectedSignal map:^id _Nullable(RACTwoTuple *value) {
        FUTrackSticker *sticker = value.second;
        return sticker;
    }];
    
    stickerSelectedSignal = [stickerSelectedSignal takeUntil:controller.rac_willDeallocSignal];
    _viewModel.faceTrackViewModel.stickerSelectedSignal = stickerSelectedSignal;
    
    RACSignal *updateViewSelectedStickerSignal = RACObserve(_viewModel, faceTrackViewModel.updateViewSelectedStickerSignal);
    updateViewSelectedStickerSignal = [updateViewSelectedStickerSignal switchToLatest];
    updateViewSelectedStickerSignal = [updateViewSelectedStickerSignal deliverOnMainThread];
    updateViewSelectedStickerSignal = [updateViewSelectedStickerSignal takeUntil:controller.rac_willDeallocSignal];
    [updateViewSelectedStickerSignal subscribeNext:^(id  _Nullable x) {
        if ([self.navigatedViewController isKindOfClass:[FUStickersPageViewController class]]) {
            FUStickersPageViewController *stickersViewController = (FUStickersPageViewController *)self.navigatedViewController;
            [stickersViewController selectTrackSticker:x];
        }
    }];
}

- (RACSignal *)mainToolbarItemSelected {
    RACSignal *mainToolbarItemSelected = [self rac_signalForSelector:@selector(drawerToolbarView:didSelectedInMainCollectionView:atIndexPath:) fromProtocol:@protocol(FUDrawerToolbarViewDelegate)];
    mainToolbarItemSelected = [mainToolbarItemSelected map:^id _Nullable(id  _Nullable value) {
        RACTuple *tuple = (RACTuple *)value;
        return tuple.third;
    }];
    return mainToolbarItemSelected;;
}

- (RACSignal *)subToolbarItemSelected {
    RACSignal *subToolbarItemSelected = [self rac_signalForSelector:@selector(drawerToolbarView:didSelectedInSubCollectionView:atIndexPath:) fromProtocol:@protocol(FUDrawerToolbarViewDelegate)];
    subToolbarItemSelected = [subToolbarItemSelected map:^id _Nullable(id  _Nullable value) {
        RACTuple *tuple = (RACTuple *)value;
        return tuple.third;
    }];
    return subToolbarItemSelected;
}

- (RACSignal *)segmentToolbarItemSelected {
    RACSignal *segmentedToolbarItemSelected = [self rac_signalForSelector:@selector(drawerToolbarView:didSelectedInSegmentedCollectionView:atIndexPath:) fromProtocol:@protocol(FUDrawerToolbarViewDelegate)];
    segmentedToolbarItemSelected = [segmentedToolbarItemSelected map:^id _Nullable(id  _Nullable value) {
        RACTuple *tuple = (RACTuple *)value;
        NSIndexPath *indexpath = (NSIndexPath *)tuple.third;
        NSUInteger segmentIndex = [self.drawerToolbarView currentSegmentedIndex];
        return [RACTuple tupleWithObjects:indexpath, @(segmentIndex), nil];
    }];
    return segmentedToolbarItemSelected;;
}

- (RACSignal *)sliderValueChanged {
    RACSignal *sliderValueChanged = [self rac_signalForSelector:@selector(drawerToolbarView:sliderValueChanged:isFinished:) fromProtocol:@protocol(FUDrawerToolbarViewDelegate)];
    sliderValueChanged = [sliderValueChanged map:^id _Nullable(id  _Nullable value) {
        RACTuple *tuple = (RACTuple *)value;
        return tuple;
    }];
    return sliderValueChanged;
}

- (RACSignal *)hueAdjustSliderValueChanged {
    FUHueAdjustDrawerToolbar *hueAdjustDrawerToolbar = _drawerToolbarView.hueAdjustDrawerToolbar;
    RACSignal *sliderValueChanged = [hueAdjustDrawerToolbar rac_signalForSelector:@selector(sliderValueChanged:forType:isFinished:)];
    sliderValueChanged = [sliderValueChanged map:^id _Nullable(id  _Nullable value) {
        return value;
    }];
    return sliderValueChanged;
}

- (RACSignal *)selectedSegmentedControl {
    RACSignal *selectedSegmentedControl = [self rac_signalForSelector:@selector(drawerToolbarView:segmentedControlDidSelectedAtIndex:) fromProtocol:@protocol(FUDrawerToolbarViewDelegate)];
    selectedSegmentedControl = [selectedSegmentedControl map:^id _Nullable(id  _Nullable value) {
        return value;
    }];
    return selectedSegmentedControl;
}

- (RACSignal *)selectedAudioRecordButton {
    RACSignal *selectedAudioRecordButton = [self rac_signalForSelector:@selector(drawerToolbarView:audioRecordButtonDidTapped:) fromProtocol:@protocol(FUDrawerToolbarViewDelegate)];
    selectedAudioRecordButton = [selectedAudioRecordButton map:^id _Nullable(id  _Nullable value) {
        return value;
    }];
    return selectedAudioRecordButton;
}

- (RACSignal *)speedKeyframeButtonDidTapped {
    RACSignal *speedKeyframeButtonDidTapped = [self rac_signalForSelector:@selector(drawerToolbarView:speedKeyframeButtonDidTapped:) fromProtocol:@protocol(FUDrawerToolbarViewDelegate)];
    speedKeyframeButtonDidTapped = [speedKeyframeButtonDidTapped map:^id _Nullable(id  _Nullable value) {
        return value;
    }];
    return speedKeyframeButtonDidTapped;
}

- (RACSignal *)speedRestButtonDidTapped {
    RACSignal *speedRestButtonDidTapped = [self rac_signalForSelector:@selector(drawerToolbarView:speedRestButtonDidTapped:) fromProtocol:@protocol(FUDrawerToolbarViewDelegate)];
    speedRestButtonDidTapped = [speedRestButtonDidTapped map:^id _Nullable(id  _Nullable value) {
        return value;
    }];
    return speedRestButtonDidTapped;
}

- (RACSignal *)reselectSurfaceTrackSignal {
    RACSignal *reselectSurfaceTrackSignal = [self rac_signalForSelector:@selector(surfaceTrackBar:reselectButtonTapped:) fromProtocol:@protocol(FUSurfaceTrackBarDelegate)];
    reselectSurfaceTrackSignal = [reselectSurfaceTrackSignal map:^id _Nullable(id  _Nullable value) {
        return nil;
    }];
    return reselectSurfaceTrackSignal;
}

- (RACSignal *)selectedStickerInfoSignal {
    RACSignal *selectedStickerInfo = [self rac_signalForSelector:@selector(stickersPageViewController:didSelectedSticker:onPurpose:) fromProtocol:@protocol(FUStickersPageViewControllerDelegate)];
    selectedStickerInfo = [selectedStickerInfo map:^id _Nullable(id  _Nullable value) {
        RACTuple *tupe = (RACTuple *)value;
        return [RACTuple tupleWithObjects:tupe.second, tupe.third, nil];
    }];
    return selectedStickerInfo;
}

#pragma mark - Navigation

- (void)handleNavigationProperty:(FUFeatureNavigationProperty *)navigationProperty {
    @weakify(self);
    switch (navigationProperty.type) {
        case FUFeatureNavigationTypeClose: {
            [self dismissFloatingViewControllerAniamted:YES];
            [self dismissNavigatedViewControllerAniamted:YES];
        }
            break;
        case FUFeatureNavigationTypeFaceTrack: {
            [_viewModel.faceTrackViewModel.model clear];
            FUFaceTrackViewController *faceTrackViewController = [[FUFaceTrackViewController alloc] initWithViewModel:_viewModel.faceTrackViewModel];
            [_viewModel.faceTrackViewModel.faceIDSelectedSignal subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                int faceID = ((NSNumber *)x).intValue;
                if (faceID < 0) {
                    [self dismissNavigatedViewControllerAniamted:YES];
                    return;
                }
                if ([self.navigatedViewController isKindOfClass:[FUStickersPageViewController class]]) {
                    return;
                }
                [self showTrackStickersViewController];
            }];
            faceTrackViewController.view.hidden = YES;
            [self showFloatingViewController:faceTrackViewController];
            [self bindFaceTrackViewModelWithFaceTrackViewController:faceTrackViewController];
        }
            break;
        case FUFeatureNavigationTypeNormalStickers: {
            FUStickersPageViewController *stickersViewController = [[FUStickersPageViewController alloc] init];
            stickersViewController.featureNavigationType = navigationProperty.type;
            stickersViewController.delegate = self;
            [self navigationViewController:stickersViewController height:FUTimelineViewHeight - FUSubToolbarHeight animated:true toolbarHidden:navigationProperty.toolbarHidden];
        }
            break;
        case FUFeatureNavigationTypeReplaceTrackSticker: {
            FUStickersPageViewController *stickersViewController = [[FUStickersPageViewController alloc] init];
            stickersViewController.featureNavigationType = navigationProperty.type;
            stickersViewController.delegate = self;
            [self navigationViewController:stickersViewController height:FUTimelineViewHeight - FUSubToolbarHeight animated:YES toolbarHidden:navigationProperty.toolbarHidden];
        }
            break;
        case FUFeatureNavigationTypeMusics: {
            BOOL needNewVC = YES;
            if ([self.navigatedViewController isKindOfClass:[FUAudiosPageViewController class]]) {
                FUAudiosPageViewController *audiosPageViewController = (FUAudiosPageViewController *)self.navigatedViewController;
                if (audiosPageViewController.audiosType == FUAudiosTypeSound) {
                    [audiosPageViewController refreshForMusics];
                    needNewVC = NO;
                }
            }
            
            if (!needNewVC) { return; }
            FUAudiosPageViewController *audiosPageViewController = [[FUAudiosPageViewController alloc] initWithViewModel:_viewModel.audiosViewModel];
            [audiosPageViewController refreshForMusics];
            [self navigationViewController:audiosPageViewController height:kNavigatedViewHeight animated:YES toolbarHidden:navigationProperty.toolbarHidden];
        }
            break;
        case FUFeatureNavigationTypeSounds: {
            BOOL needNewVC = YES;
            if ([self.navigatedViewController isKindOfClass:[FUAudiosPageViewController class]]) {
                FUAudiosPageViewController *audiosPageViewController = (FUAudiosPageViewController *)self.navigatedViewController;
                if (audiosPageViewController.audiosType == FUAudiosTypeMusic) {
                    [audiosPageViewController refreshForSounds];
                    needNewVC = NO;
                }
            }
            
            if (!needNewVC) { return; }
            
            FUAudiosPageViewController *audiosPageViewController = [[FUAudiosPageViewController alloc] initWithViewModel:_viewModel.audiosViewModel];
            [audiosPageViewController refreshForSounds];
            [self navigationViewController:audiosPageViewController height:kNavigatedViewHeight animated:YES toolbarHidden:navigationProperty.toolbarHidden];
        }
            break;
        case FUFeatureNavigationTypeMyAudios: {
            FUMyAudiosViewController *myAudiosViewController = [[FUMyAudiosViewController alloc] initWithViewModel:_viewModel.audiosViewModel];
            [self navigationViewController:myAudiosViewController height:kNavigatedViewHeight animated:YES toolbarHidden:navigationProperty.toolbarHidden];
        }
            break;
        default:
            break;
    }
}

- (void)navigationToClose {
    if (self.viewModel.navigationProperty.type == FUFeatureNavigationTypeFaceTrack) {
        self.alertView.title = fuStr(是否退出跟踪).fuLocalized;
    } else {
        [self dismissFloatingViewControllerAniamted:NO];
        [self dismissNavigatedViewControllerAniamted:NO];
    }
}

- (void)navigationToNextWithNavigationProperty:(FUFeatureNavigationProperty *)navigationProperty {
    switch (navigationProperty.type) {
        case FUFeatureNavigationTypeFaceTrack: {
            [self showTrackStickersViewController];
        }
            break;
        default:
            break;
    }
}

- (void)showTrackStickersViewController {
    FUStickersPageViewController *stickersViewController = [[FUStickersPageViewController alloc] init];
    stickersViewController.delegate = self;
    [self navigationViewController:stickersViewController height:FUTimelineViewHeight - kFloatingDrawerHeight animated:true toolbarHidden:YES];
}

- (void)showFloatingViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[self.floatingViewController class]]) { return; }
    
    CGFloat height = 0.0;
    CGFloat originY = 0.0;
    CGFloat bottomOffset = 0.0;
    if (self.navigatedViewController) {
        height = kFloatingDrawerHeight;
        bottomOffset = CGRectGetHeight(self.navigatedViewController.view.frame);
        originY = CGRectGetHeight(self.view.frame) - bottomOffset - height;
    } else {
        height = kFloatingDrawerHeight;
        bottomOffset = FUSubToolbarHeight;
        originY = CGRectGetHeight(self.view.frame) - bottomOffset - height;
    }
    
    
//    viewController.view.frame = CGRectMake(0, originY, self.view.bounds.size.width, height);
    [self.view addSubview:viewController.view];
    [viewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.equalTo(self.view);
       make.height.equalTo(@(height));
       make.bottom.equalTo(self.view).offset(-bottomOffset);
    }];
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    
    _floatingViewController = viewController;
}

- (void)dismissFloatingViewControllerAniamted:(BOOL)animated {
    if (!self.floatingViewController) { return; }
    UIViewController *controller = self.floatingViewController;
    
    CGFloat height = controller.view.frame.size.height;
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            controller.view.transform = CGAffineTransformMakeTranslation(0, height);
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [controller.view removeFromSuperview];
            [controller removeFromParentViewController];
        }];
    } else {
        controller.view.transform = CGAffineTransformMakeTranslation(0, height);
        [controller.view removeFromSuperview];
        [controller removeFromParentViewController];
    }
    
    self.floatingViewController = nil;
}

- (void)navigationViewController:(UIViewController *)viewController height:(CGFloat)height animated:(BOOL)animated toolbarHidden:(BOOL)toolbarHidden {
    BOOL needPresent = YES;
    if (self.navigatedViewController) {
        if ([viewController isKindOfClass:[self.navigatedViewController class]]) {
            needPresent = NO;
        }
        [self dismissNavigatedViewControllerAniamted:YES];
    }
    
    if (!needPresent) { return; }

    CGFloat bottomOffset = height;
    if (!toolbarHidden) {
        bottomOffset = height - FUSubToolbarHeight;
    }
    [self.view addSubview:viewController.view];
    [viewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(height));
        make.bottom.equalTo(self.view).with.offset(bottomOffset);
    }];
    [self.view layoutIfNeeded];
    
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [viewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.height.equalTo(@(height));
                make.bottom.equalTo(self.view).with.offset(bottomOffset - height);
            }];
            if (self.floatingViewController) {
                [self.floatingViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.view);
                    make.height.equalTo(@(kFloatingDrawerHeight));
                    make.bottom.equalTo(viewController.view.mas_top);
                }];
            }
            
            [self.view layoutIfNeeded];

        }];
    } else {
        [viewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(@(height));
            make.bottom.equalTo(self.view).with.offset(bottomOffset - height);
        }];
    }
    
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    self.navigatedViewController = viewController;
    self.viewModel.toolbarHidden = YES;
    
    if ([viewController isKindOfClass:[FUStickersPageViewController class]]) {
        [_viewModel.stickersViewHidden sendNext:@(NO)];
        _viewModel.faceTrackViewModel.stickersViewHidden = NO;
    }
}

- (void)dismissNavigatedViewControllerAniamted:(BOOL)animated {
    if (!self.navigatedViewController) { return; }
    UIViewController *controller = self.navigatedViewController;

    
    CGFloat height = controller.view.frame.size.height;
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [controller.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.height.equalTo(@(height));
                make.bottom.equalTo(self.view).offset(height);
            }];
            if (self.floatingViewController) {
                [self.floatingViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.view);
                    make.height.equalTo(@(kFloatingDrawerHeight));
                    make.bottom.equalTo(self.view).offset(-FUSubToolbarHeight);
                }];
                
                if ([self.floatingViewController isKindOfClass:[FUFaceTrackViewController class]]) {
                    FUFaceTrackViewController *faceTrackViewController = (FUFaceTrackViewController *)self.floatingViewController;
                    faceTrackViewController.titleLabel.hidden = NO;
                }
            }
            
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            [controller.view removeFromSuperview];
            [controller removeFromParentViewController];
        }];
    } else {
//        controller.view.transform = CGAffineTransformMakeTranslation(0, height);
        [controller.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(@(height));
            make.bottom.equalTo(self.view).offset(height);
        }];
        
        [controller.view removeFromSuperview];
        [controller removeFromParentViewController];
        if (self.floatingViewController) {
            [self.floatingViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.height.equalTo(@(kFloatingDrawerHeight));
                make.bottom.equalTo(self.view).offset(-FUSubToolbarHeight);
            }];
            if ([self.floatingViewController isKindOfClass:[FUFaceTrackViewController class]]) {
                FUFaceTrackViewController *faceTrackViewController = (FUFaceTrackViewController *)self.floatingViewController;
                faceTrackViewController.titleLabel.hidden = NO;
            }
        }
    }
    
    self.navigatedViewController = nil;
    
    if (self.surfaceTrackBarHidden) {
        self.viewModel.toolbarHidden = NO;
    }

}

#pragma mark - Present or Dismiss

- (void)presentOrDimissWithNewNode:(FUToolbarDrawerNode *)newNode {
    if (newNode) {
        [self presentToolbarWithNode:newNode];
        [self dismissNavigatedViewControllerAniamted:YES];
        [self dismissFloatingViewControllerAniamted:YES];
    } else {
        [self dismissToolbar];
    }
}

- (void)presentToolbarWithNode:(FUToolbarDrawerNode *)node {
    FUDrawerToolbarStyle style = [self drawerToolbarStyleWithNodeStyle:node.style];
    if (style == self.drawerToolbarView.currentStyle) {
        if (![node.name isEqualToString:_currentNode.name]) {
            [self.drawerToolbarView reloadSegmentedControl];
            [self.drawerToolbarView reloadToolbarRestPositionIfNeed:YES];
        } else {
            [self.drawerToolbarView reloadToolbarRestPositionIfNeed:NO];
        }
    } else {
        [self.drawerToolbarView showDrawerWithStyle:style];
        [self.drawerToolbarView reloadSegmentedControl];
    }
    [self.drawerToolbarView reloadSlider];
    _currentNode = node;
}

- (void)dismissToolbar {
    id object = [self.viewModel.featureState.compositionProcessModel.composition objectByIdentifier:self.viewModel.featureState.compositionProcessModel.selectedID];
    if (![object isKindOfClass:[FUTransition class]]) {
        [self.drawerToolbarView hideDrawer];
        _currentNode = nil;
    } else {
        FUTransition *transition = (FUTransition *)object;
        if (transition.processModel.transitionType.groupType == FUTransitionGroupTypeNone) {
            [self.drawerToolbarView hideDrawer];
            _currentNode = nil;
        }
    }
}

- (FUDrawerToolbarStyle)drawerToolbarStyleWithNodeStyle:(FUToolbarDrawerNodeStyle)nodeStyle {
    switch (nodeStyle) {
        case FUToolbarDrawerNodeStyleMainAndSlider:
            return FUDrawerToolbarStyleMainAndSlider;
        case FUToolbarDrawerNodeStyleMain:
            return FUDrawerToolbarStyleMain;
        case FUToolbarDrawerNodeStyleSlider:
            return FUDrawerToolbarStyleSlider;
        case FUToolbarDrawerNodeStyleMainAndSegmented:
            return FUDrawerToolbarStyleMainAndSegmented;
        case FUToolbarDrawerNodeStyleMainAndSub:
            return FUDrawerToolbarStyleMainAndSub;
        case FUToolbarDrawerNodeStyleSegmentedAndSlider:
            return FUDrawerToolbarStyleSegmentedAndSlider;
        case FUToolbarDrawerNodeStyleRecord:
            return FUDrawerToolbarStyleRecord;
        case FUToolbarDrawerNodeStyleHueAdjust:
            return FUDrawerToolbarStyleHueAdjust;
        case FUToolbarDrawerNodeStyleMainAndSliderAndButton:
            return FUDrawerToolbarStyleMainAndSliderAndButton;
        default:
            return FUDrawerToolbarStyleMainAndSlider;
    }
}

- (void)showSurfaceTrackBar {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.surfaceTrackBarHidden =  NO;
        self.surfaceTrackBar.hidden = NO;
        self.viewModel.toolbarHidden = YES;
    });
}

- (void)hideSurfaceTrackBar {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.surfaceTrackBarHidden = YES;
        self.surfaceTrackBar.hidden = YES;
        self.viewModel.toolbarHidden = NO;
    });
}

#pragma mark - Helpers

- (nullable FUToolbarDrawerSegmentedNode *)currentSegmentedNode {
    NSUInteger segmentedIndex = [_drawerToolbarView currentSegmentedIndex];
    NSArray *segmentedNodes = [self drawerNode].segmentedNodes;
    if (segmentedIndex >= segmentedNodes.count) {
        segmentedIndex = 0;
    }
    
    FUToolbarDrawerSegmentedNode *selectedNode = nil;
    if (segmentedIndex < segmentedNodes.count) {
        selectedNode = segmentedNodes[segmentedIndex];
    }
    
    return selectedNode;
}

- (NSIndexPath *)currentSelectedMainItemIndexPath {
    NSIndexPath *indexPath = _viewModel.featureState.navigationState.activeMainDrawerNodeIndexPath;
    return indexPath;
}

- (NSIndexPath *)currentSelectedSubItemIndexPath {
    NSIndexPath *indexPath = _viewModel.featureState.navigationState.activeSubDrawerNodeIndexPath;
    return indexPath;
}

- (NSIndexPath *)currentSegmentedDrawerNodeIndexPath {
    NSIndexPath *indexPath = _viewModel.featureState.navigationState.activeSegmentedDrawerNodeIndexPath;
    return indexPath;
}

- (void)hideAlertView {
    [_alertView hide];
    _alertView = nil;
}

- (void)hideProgressView {
    [_progressView hide];
    _progressView = nil;
}

- (BOOL)isExistItemSelectedInMainItems {
    NSArray<FUToolbarItem *> *mainItems = self.drawerNode.mainItems;
    BOOL isSelected = NO;
    for (FUToolbarItem *toolbarItem in mainItems) {
        if (toolbarItem.highlighted) {
            isSelected = YES;
            break;
        }
    }
    return isSelected;
}

- (BOOL)isExistItemSelectedInSubItems {
    NSArray<FUToolbarItem *> *subItems = self.drawerNode.subItems;
    BOOL isSelected = NO;
    for (FUToolbarItem *toolbarItem in subItems) {
        if (toolbarItem.highlighted) {
            isSelected = YES;
            break;
        }
    }
    return isSelected;
}

#pragma mark - Cell

- (__kindof UICollectionViewCell *)cellForItem:(FUToolbarItem *)item inCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    switch (item.style) {
        case FUToolbarItemStyleNormal:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([
            FUToolbarSquareNormalCell class]) forIndexPath:indexPath];
            break;
        case FUToolbarItemStyleFilter:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FUToolbarFilterCell class]) forIndexPath:indexPath];
            break;
        case FUToolbarItemStyleColor:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FUToolbarColorCell class]) forIndexPath:indexPath];
            break;
        case FUToolbarItemStyleColorPalette:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FUToolbarColorPaletteCell class]) forIndexPath:indexPath];
            break;
        case FUToolbarItemStyleFormat:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FUToolbarFormatCell class]) forIndexPath:indexPath];
            break;
        case FUToolbarItemStyleResource:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FUToolbarResourceCell class]) forIndexPath:indexPath];
            break;
        case FUToolbarItemStyleGif:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FUToolbarGifCell class]) forIndexPath:indexPath];
            break;
        case FUToolbarItemStyleSpeed:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FUToolbarSpeedCell class]) forIndexPath:indexPath];
            break;
    }
    
    if ([cell conformsToProtocol:@protocol(FUToolbarCell)]) {
        id<FUToolbarCell> toolbarCell = (id<FUToolbarCell>)cell;
        [toolbarCell configureWithToolbarItem:item];
    }
    
    return cell;
}

- (CGSize)cellSizeForItem:(FUToolbarItem *)item {
    switch (item.style) {
        case FUToolbarItemStyleNormal:
            return CGSizeMake(FUToolbarCellSize, FUToolbarCellSize);
        case FUToolbarItemStyleFilter : case FUToolbarItemStyleSpeed:
            return CGSizeMake(FUToolbarCellSize, FUToolbarCellSize);
        case FUToolbarItemStyleColor:
            return CGSizeMake(FUToolbarCellSize, FUToolbarCellSize);
        case FUToolbarItemStyleColorPalette:
            return CGSizeMake(24.0, FUToolbarCellSize);
        case FUToolbarItemStyleFormat:
            return CGSizeMake(40.0, FUToolbarCellSize);
        case FUToolbarItemStyleResource:
            return CGSizeMake(FUToolbarCellSize, FUToolbarCellSize);
        case FUToolbarItemStyleGif:
            return CGSizeMake(FUToolbarCellSize, FUToolbarCellSize);
    }
}

#pragma mark - FUDrawerToolbarViewDataSource

- (NSInteger)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView numberOfItemsInMainCollectionView:(UICollectionView *)collectionView {
    return [self drawerNode].mainItems.count;
}

- (NSInteger)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView numberOfItemsInSubCollectionView:(UICollectionView *)collectionView {
    return [self drawerNode].subItems.count;
}

- (NSInteger)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView numberOfItemsInSegmentedCollectionView:(UICollectionView *)collectionView {
    return [self currentSegmentedNode].items.count;
}

- (NSArray<NSString *> *)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView titlesForSegmentControl:(FUSegmentedView *)segmentControl {
    NSMutableArray<NSString *> *titles = [NSMutableArray new];
    for (FUToolbarDrawerSegmentedNode *node in [self drawerNode].segmentedNodes) {
        [titles addObject:node.title];
    }
    return titles;
}

- (UICollectionViewCell *)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView getCellForMainCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.drawerNode.mainItems.count) { return [UICollectionViewCell new]; }
    FUToolbarItem *item = self.drawerNode.mainItems[indexPath.row];
    NSIndexPath *selectedIndexPath = [self currentSelectedMainItemIndexPath];
    if (selectedIndexPath.row >= self.drawerNode.mainItems.count) { return [UICollectionViewCell new]; }
    FUToolbarItem *selectedItem = self.drawerNode.mainItems[selectedIndexPath.row];
    BOOL isExistItemSelectedInMainItems = [self isExistItemSelectedInMainItems];
    if (!isExistItemSelectedInMainItems) {
        if (selectedIndexPath) {
            if ([selectedIndexPath isEqual:indexPath]) {
                if (item.canHighlighted) {
                    item.highlighted = YES;
                } else {
                    item.highlighted = NO;
                }
            } else {
                if (selectedItem.canHighlighted) {
                    item.highlighted = NO;
                }
            }
        }
    }
    
    FUSpeedType speedType = (FUSpeedType)(((NSNumber *)item.value).unsignedIntegerValue);
    BOOL shouldHideSpeedButtons = (speedType == FUSpeedTypeCommon) && item.highlighted;
    if (shouldHideSpeedButtons) {
        [drawerToolbarView hideSpeedButtonsWithFlag:YES];
    }
    
    UICollectionViewCell *cell = [self cellForItem:item inCollectionView:collectionView atIndexPath:indexPath];
    return cell;
}

- (UICollectionViewCell *)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView getCellForSubCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.drawerNode.subItems.count) { return [UICollectionViewCell new]; }
    FUToolbarItem *item = self.drawerNode.subItems[indexPath.row];
    NSIndexPath *selectedIndexPath = [self currentSelectedSubItemIndexPath];
    BOOL isExistItemSelectedInSubItems = [self isExistItemSelectedInSubItems];
    if (!isExistItemSelectedInSubItems) {
        if (selectedIndexPath) {
            if ([selectedIndexPath isEqual:indexPath]) {
                if (item.canHighlighted) {
                    item.highlighted = YES;
                } else {
                    item.highlighted = NO;
                }
            } else {
                item.highlighted = NO;
            }
        }
    }
    UICollectionViewCell *cell = [self cellForItem:item inCollectionView:collectionView atIndexPath:indexPath];
    return cell;
}

- (UICollectionViewCell *)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView getCellForSegmentedCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [self currentSegmentedNode].items.count) { return [UICollectionViewCell new]; }
    FUToolbarItem *item = [self currentSegmentedNode].items[indexPath.row];
    
    NSIndexPath *selectedIndexPath = [self currentSegmentedDrawerNodeIndexPath];
    if (selectedIndexPath) {
        if ([selectedIndexPath isEqual:indexPath]) {
            if (item.canHighlighted) {
                item.highlighted = YES;
            } else {
                item.highlighted = NO;
            }
        } else {
            item.highlighted = NO;
        }
    }
    
    UICollectionViewCell *cell = [self cellForItem:item inCollectionView:collectionView atIndexPath:indexPath];
    return cell;
}

- (CGSize)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView itemSizeForMainCollectionViewAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.drawerNode.mainItems.count) { return CGSizeMake(FUToolbarCellSize, FUToolbarCellSize); }
    FUToolbarItem *item = self.drawerNode.mainItems[indexPath.row];
    return [self cellSizeForItem:item];
}

- (CGSize)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView itemSizeForSubCollectionViewAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [self drawerNode].subItems.count) { return CGSizeMake(FUToolbarCellSize, FUToolbarCellSize); }
    FUToolbarItem *item = [self drawerNode].subItems[indexPath.row];
    return [self cellSizeForItem:item];
}

- (CGSize)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView itemSizeForSegmentedCollectionViewAtIndexPath:(NSIndexPath *)indexPath {
    FUToolbarItem *selectedItem = [self currentSegmentedNode].items[indexPath.row];
    return [self cellSizeForItem:selectedItem];
}

- (NSString *)mainTitleForDrawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView {
    return self.drawerNode.mainTitle;
}

- (NSString *)subTitleForDrawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView {
    return self.drawerNode.subTitile;
}

- (FUToolbarDrawerSliderNode *)sliderNodeForDrawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView {
    FUToolbarDrawerSliderNode *sliderNode = [self drawerNode].sliderNode;
    return sliderNode;
}

#pragma mark - FUDrawerToolbarViewDelegate

- (void)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView didSelectedInMainCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath {

    if ([self.drawerNode.name isEqualToString:@"Speed"]) {  // 如果点击速度
        if (self.drawerNode.mainItems.count > indexPath.row) {
            FUToolbarItem *item = self.drawerNode.mainItems[indexPath.row];
            // 选择常规，隐藏滑动条左右两侧的按钮
            FUSpeedType speedType = (FUSpeedType)((NSNumber *)item.value).unsignedIntegerValue;
            BOOL shouldHideSpeedButtons = speedType == FUSpeedTypeCommon;
            [self.drawerToolbarView hideSpeedButtonsWithFlag:shouldHideSpeedButtons];
        }
    }
}

- (void)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView didSelectedInSubCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath {
}

- (void)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView didSelectedInSegmentedCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath { }

- (void)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView sliderValueChanged:(NSNumber *)value { }

- (void)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView segmentedControlDidSelectedAtIndex:(NSUInteger)index {
    [_drawerToolbarView reloadToolbarRestPositionIfNeed:NO];
}

- (void)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView audioRecordButtonDidTapped:(FUAudioRecordButton *)audioRecordButton { }

- (void)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView speedKeyframeButtonDidTapped:(UIButton *)speedKeyframeButton { }

- (void)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView speedRestButtonDidTapped:(UIButton *)speedRestButton { }

#pragma mark - FUSurfaceTrackBarDelegate

- (void)surfaceTrackBar:(FUSurfaceTrackBar *)surfaceTrackBar reselectButtonTapped:(UIButton *)button {
    [self hideSurfaceTrackBar];
    [self.viewModel.surfaceTrackViewModel.model clear];
}

- (void)surfaceTrackBar:(FUSurfaceTrackBar *)surfaceTrackBar addStickerButtonTapped:(UIButton *)button {
    FUStickersPageViewController *stickersViewController = [[FUStickersPageViewController alloc] init];
    stickersViewController.featureNavigationType = FUFeatureNavigationTypeSurfaceTrack;
    stickersViewController.delegate = self;
    [self bindSurfaceTrackViewModelWithFaceTrackViewController:stickersViewController];
    [self navigationViewController:stickersViewController height:FUTimelineViewHeight animated:true toolbarHidden:YES];
}

#pragma mark - FUTrackStickersViewControllerDelegate

- (void)stickersPageViewControllerCollapseButtonTapped:(FUStickersPageViewController *)trackStickersViewController {
    [self dismissNavigatedViewControllerAniamted:YES];
    
    FUFeatureNavigationType navigationType = trackStickersViewController.featureNavigationType;
    
    if (navigationType != FUFeatureNavigationTypeSurfaceTrack && navigationType != FUFeatureNavigationTypeFaceTrack) {
        [_viewModel.stickersViewHidden sendNext:@(YES)];
        _viewModel.faceTrackViewModel.stickersViewHidden = YES;
    }
    
    if (navigationType == FUFeatureNavigationTypeFaceTrack || navigationType == FUFeatureNavigationTypeSurfaceTrack) {
        [_viewModel.deleteCurrentSticker sendNext:nil];
    }
    
    if ([_floatingViewController isKindOfClass:[FUFaceTrackViewController class]]) {
        [_viewModel.faceTrackViewModel removeCurrentSticker];
        [_viewModel.deleteCurrentSticker sendNext:nil];
    }
}

- (void)stickersPageViewControllerOkButtonTapped:(FUStickersPageViewController *)trackStickersViewController withTrackSticker:(nullable FUTrackSticker *)trackSticker {
    [_viewModel.faceTrackViewModel.model clear];
    [_viewModel.surfaceTrackViewModel.model clear];
    _viewModel.navigationBarHidden = YES;
    [self dismissFloatingViewControllerAniamted:NO];
    [self dismissNavigatedViewControllerAniamted:NO ];
    if (!_surfaceTrackBar.isHidden) {
        [self hideSurfaceTrackBar];
    }
    
    [_viewModel.stickersViewHidden sendNext:@(YES)];
    [_viewModel.stickersOKButtonTapped sendNext:@(YES)];
    _viewModel.faceTrackViewModel.stickersViewHidden = YES;
}

- (void)stickersPageViewController:(FUStickersPageViewController *)stickersPageViewController didSelectedSticker:(FUTrackSticker *)sticker onPurpose:(FUStickerPurpose)purpose {
    
}

- (void)stickersPageViewControllerWillAddStickerFromAlbum:(FUStickersPageViewController *)trackStickersViewController {
    FUAlbumViewSettings *settings = [FUAlbumViewSettings settingsWithImportType:FUImportTypeSticker];;
    FUAlbumController *photoController = [FUAlbumController albumViewControllerWithSettings:settings];
    [self presentViewController:photoController animated:YES completion:nil];
}

#pragma mark - FUAlertViewDelegate

- (void)alertViewDidOK:(FUAlertView *)alertView {
    if (_viewModel.navigationProperty.type == FUFeatureNavigationTypeFaceTrack) {
        [self dismissFloatingViewControllerAniamted:NO];
        [self dismissNavigatedViewControllerAniamted:NO];
        _viewModel.navigationBarHidden = YES;
    }
    [self hideAlertView];
    [_viewModel.stickersOKButtonTapped sendNext:@(YES)];
}

- (void)alertViewDidCancel:(FUAlertView *)alertView {
    [self hideAlertView];
}

@end
