//
//  FUToolbarViewModel.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/3.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUToolbarViewModel.h"
#import "FUToolbarTreeGenerator.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "FUFeatureState.h"
#import "FUToolbarModel.h"
#import "FUToolbarNode.h"
#import "FUFeatureNode.h"
#import "FUFeatureItem.h"
#import "FUFeatureTreeNavigationState.h"

@implementation FUToolbarViewModel

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        _toolbarTreeGenerator = [[FUToolbarTreeGenerator alloc] init];
        _navigationBarHidden = YES;
        [self setupNodePressedSignal];
        [self setupNavigationStateSignals];
    }
    return self;
}
-(void)setPresentationModel:(FUToolbarModel *)presentationModel{
   _presentationModel = presentationModel;
}
#pragma mark - Setups

- (void)setupNodePressedSignal {
    RACSignal *selectedToolbarItemSignal = RACObserve(self, selectedToolbarItem);
    selectedToolbarItemSignal = [selectedToolbarItemSignal switchToLatest];
    selectedToolbarItemSignal = [selectedToolbarItemSignal map:^id _Nullable(id  _Nullable value) {
        NSIndexPath *indexPath = (NSIndexPath *)value;
        NSArray<FUFeatureNode *> *childNodes = self.featureState.navigationState.featureTree.childNodes;
        if (indexPath.row < childNodes.count) {
            FUFeatureNode *pressedNode = childNodes[indexPath.row];
            return [RACTuple tupleWithObjects:pressedNode, indexPath, nil];
        } else {
            return [RACTupleNil tupleNil];
        }
    }];
    _nodePressed = selectedToolbarItemSignal;
    
    RACSignal *toolbarBackButtonTappedSignal = RACObserve(self, toolbarBackButtonTapped);
    toolbarBackButtonTappedSignal = [toolbarBackButtonTappedSignal switchToLatest];
    _backPressed = toolbarBackButtonTappedSignal;
}

- (void)setupNavigationStateSignals {
    RACSignal *featureStateSignal = RACObserve(self, featureState);
    featureStateSignal = [featureStateSignal ignore:nil];
    featureStateSignal = [featureStateSignal replayLast];
    RACSignal *newToolbarModelSignal = [featureStateSignal map:^id _Nullable(id  _Nullable value) {
        FUFeatureState *featureState = (FUFeatureState *)value;
        FUFeatureNode *featureTree = featureState.navigationState.featureTree;
        FUToolbarNode *toolbarTree = [self.toolbarTreeGenerator toolbarTreeForFeatureTree:featureTree featureObjects:[self featureObjects]];
        FUToolbarBackLevel backLevel = [self backLevelWithTreeDepth:featureTree.depth];
        FUToolbarModel *toolbarModel = [[FUToolbarModel alloc] initWithRoot:toolbarTree selectedItemIndexPath:featureState.navigationState.activeNodeIndexPath style:0 backLevel:backLevel persistentScrolling:NO];
        return toolbarModel;
    }];
    RAC(self, presentationModel) = newToolbarModelSignal;
    
    RACSignal *navigationCloseButtonTapped = RACObserve(self, navigationCloseButtonTapped);
    navigationCloseButtonTapped = [navigationCloseButtonTapped switchToLatest];
    _navigateToClose = navigationCloseButtonTapped;
    
    RACSignal *navigationNextButtonTapped = RACObserve(self, navigationNextButtonTapped);
    navigationNextButtonTapped = [navigationNextButtonTapped switchToLatest];
    _navigateToNext = navigationNextButtonTapped;
}

#pragma mark - Custom Accessors

- (FUToolbarNode *)currentNode {
    FUFeatureNode *featureTree = _featureState.navigationState.featureTree;
    FUToolbarNode *toolbarTree = [self.toolbarTreeGenerator toolbarTreeForFeatureTree:featureTree featureObjects:[self featureObjects]];
    return toolbarTree;
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    _navigationBarHidden = navigationBarHidden;
}

#pragma mark - Helpers

- (FUToolbarBackLevel)backLevelWithTreeDepth:(FUFeatureNodeDepth)depth {
    FUToolbarBackLevel backLevel = FUToolbarBackLevelNone;
    switch (depth) {
        case FUFeatureNodeDepth0:
            backLevel = FUToolbarBackLevelNone;
            break;
        case FUFeatureNodeDepth1:
        case FUFeatureNodeDepth2:
            backLevel = FUToolbarBackLevelSub;
            break;
    }
    return backLevel;
}

- (NSDictionary *)featureObjects {
    NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
    MTLModel<FUProcessModel> *processModel = self.featureState.processModel;
    if (processModel) {
        [tempDictionary setObject:processModel forKey:NSStringFromClass([processModel class])];
    }
    
    NSUUID *selectedID = self.featureState.compositionProcessModel.selectedID;
    id<FUProcessSubLayer> object = [self.featureState.compositionProcessModel.composition objectByIdentifier:selectedID];
    if ([object isKindOfClass:[FUTransition class]]) {
        [tempDictionary setObject:object forKey:NSStringFromClass([FUTransition class])];
    }
    
    return [tempDictionary copy];
}

@end
