//
//  FUToolbarController.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/1.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUToolbarController.h"
#import "FUToolbarView.h"
#import "FUToolbarCollectionViewLayout.h"
#import "FUToolbarModel.h"
#import "FUTheme.h"
#import "FUToolbarNode.h"
#import "FUToolbarItem.h"
#import "FUToolbarNormalCell.h"
#import "FUToolbarColorCell.h"
#import "FUToolbarFilterCell.h"
#import "FUToolbarColorPaletteCell.h"
#import "FUToolbarSpeedCell.h"
#import <Masonry/Masonry.h>
#import "FUIdentifiersOrganizer.h"
#import "FUToolbarViewModel.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "FUFeatureState.h"
#import "FUFeatureTreeNavigationState.h"
#import "TransformConstants.h"
#import "FUNavigationToolbar.h"
#import "FUFeatureNavigationProperty.h"

@interface FUToolbarController () <FUToolbarViewDataSource, FUToolbarViewDelegate, FUNavigationToolbarViewDelegate>
@property (nonatomic, strong) FUToolbarView *toolbarView;
@property (nonatomic, strong) FUNavigationToolbar *navigationToolbar;
@property (nonatomic, assign) FUToolbarBackLevel currentBackLevel;
@end

@implementation FUToolbarController

#pragma mark - Init

- (instancetype)initWithViewModel:(FUToolbarViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)loadView {
    FUToolbarView *toolbarView = [[FUToolbarView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    _toolbarView = toolbarView;
    self.view = toolbarView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self bindViewModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_toolbarView reloadData];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [_toolbarView reloadData];
}

#pragma mark - Setups

- (void)setupView {
    [self setupToolbarView];
    [self setupNavigationToolbar];
}

- (void)setupToolbarView {
    _toolbarView.dataSource = self;
    _toolbarView.delegate = self;
}

- (void)setupNavigationToolbar {
    _navigationToolbar = [[FUNavigationToolbar alloc] init];
    _navigationToolbar.nextButton.hidden = YES;
    _navigationToolbar.delegate = self;
    _navigationToolbar.hidden = YES;
    [self.view addSubview:_navigationToolbar];
    [_navigationToolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@(FUSubToolbarHeight));
    }];
}

#pragma mark - Bind

- (void)bindViewModel {
    RACSignal *presentationModelSignal = RACObserve(self, viewModel.presentationModel);
    [presentationModelSignal subscribeNext:^(id  _Nullable x) {
        [self reloadDataWithModel:(FUToolbarModel *)x];
    }];
    
    _viewModel.selectedToolbarItem = [self itemSelected];
    _viewModel.toolbarBackButtonTapped = [self backButtonTapped];
    
    [_viewModel.featureCompositionProcessModel subscribeNext:^(id  _Nullable x) {
        [self reloadData];
    }];
    
    RACSignal *navigationProperty = RACObserve(self, viewModel.navigationProperty);
    [navigationProperty subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass:[FUFeatureNavigationProperty class]]) {
            [self showNavigationBarWithProperty:x];
        }
    }];
    
    RACSignal *navigationCloseButtonTapped = [self rac_signalForSelector:@selector(navigationToolbarViewDidTappedCloseButton:) fromProtocol:@protocol(FUNavigationToolbarViewDelegate)];
    navigationCloseButtonTapped = [navigationCloseButtonTapped map:^id _Nullable(id  _Nullable value) {
        return self.viewModel.navigationProperty;
    }];
    _viewModel.navigationCloseButtonTapped = navigationCloseButtonTapped;
    
    RACSignal *navigationNextButtonTapped = [self rac_signalForSelector:@selector(navigationToolbarViewDidTappedNextButton:) fromProtocol:@protocol(FUNavigationToolbarViewDelegate)];
    navigationNextButtonTapped = [navigationNextButtonTapped map:^id _Nullable(id  _Nullable value) {
        return self.viewModel.navigationProperty;
    }];
    _viewModel.navigationNextButtonTapped = navigationNextButtonTapped;
    
    RACSignal *navigationBarHidden = RACObserve(_viewModel, navigationBarHidden);
    [navigationBarHidden subscribeNext:^(id  _Nullable x) {
        BOOL hidden = ((NSNumber *)x).boolValue;
        self.navigationToolbar.hidden = hidden;
    }];
    
    RACSignal *validSignal = RACObserve(self, viewModel.valid);
    validSignal = [validSignal deliverOnMainThread];
    @weakify(self);
    [validSignal subscribeNext:^(NSNumber *validValue) {
        @strongify(self);
        
        BOOL valid = validValue.boolValue;
        self.view.userInteractionEnabled = valid;
    }];
}

- (void)reloadDataWithModel:(FUToolbarModel *)toolbarModel {
    FUToolbarViewLevel newLevel;
    switch (toolbarModel.backLevel) {
        case FUToolbarBackLevelNone:
            newLevel = FUToolbarViewLevelMain;
            break;
        case FUToolbarBackLevelSub:
            newLevel = FUToolbarViewLevelSub;
            break;
        default:
            newLevel = FUToolbarViewLevelMain;
            break;
    }
    if (self.toolbarView.currentLevel != newLevel) {
        [self.toolbarView showToolbarWithLevel:newLevel];
    }
    
    [self reloadData];
}

- (void)reloadData {
    [self.toolbarView reloadData];
}

#pragma mark - Navigation Bar

- (void)showNavigationBarWithProperty:(FUFeatureNavigationProperty *)property {
    self.navigationToolbar.hidden = !property.needNavigationBar;
    self.navigationToolbar.titleLabel.text = property.title;
}

- (void)hideNavigationBar {
    self.navigationToolbar.hidden = YES;
}

#pragma mark - Signals

- (RACSignal *)itemSelected {
    RACSignal *didSelectItemSignal = [self rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:) fromProtocol:@protocol(UICollectionViewDelegate)];
    didSelectItemSignal = [didSelectItemSignal map:^id _Nullable(id  _Nullable value) {
        RACTuple *tuple = (RACTuple *)value;
        return tuple.second;
    }];
    return didSelectItemSignal;
}

- (RACSignal *)backButtonTapped {
    RACSignal *backButtonTappedSignal = [self rac_signalForSelector:@selector(toolbarView:backButtonTapped:) fromProtocol:@protocol(FUToolbarViewDelegate)];
    return backButtonTappedSignal;
}

#pragma mark - Node

- (FUToolbarNode *)rootNode {
    return _viewModel.currentNode;
}

- (nullable NSIndexPath *)selectedIndexPath {
    return _viewModel.presentationModel.selectedItemIndexPath;
}

#pragma mark - Cell Creations

- (UICollectionViewCell *)cellForItem:(FUToolbarItem *)item atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    switch (item.style) {
        case FUToolbarItemStyleNormal:
            cell = [_toolbarView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FUToolbarNormalCell class]) forIndexPath:indexPath];
            break;
        case FUToolbarItemStyleColor:
            cell = [_toolbarView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FUToolbarColorCell class]) forIndexPath:indexPath];
            break;
        case FUToolbarItemStyleColorPalette:
            cell = [_toolbarView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FUToolbarColorPaletteCell class]) forIndexPath:indexPath];
            break;
        case FUToolbarItemStyleFilter:
            cell = [_toolbarView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FUToolbarFilterCell class]) forIndexPath:indexPath];
            break;
        case FUToolbarItemStyleSpeed:
            cell = [_toolbarView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FUToolbarSpeedCell class]) forIndexPath:indexPath];
            break;
        default:
            cell = [_toolbarView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FUToolbarNormalCell class]) forIndexPath:indexPath];
            break;
    }
    return cell;
}

- (CGSize)cellSizeForItem:(FUToolbarItem *)item {
    switch (item.style) {
        case FUToolbarItemStyleNormal:
            return CGSizeMake(FUToolbarCellSize, FUToolbarCellSize);
        case FUToolbarItemStyleFilter: case FUToolbarItemStyleSpeed:
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

#pragma mark - FUToolbarViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self rootNode].childNodes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<FUToolbarNode *> *childNodes = [self rootNode].childNodes;
    if (indexPath.row >= childNodes.count) {
        return [UICollectionViewCell new];
    }
    FUToolbarNode *node = childNodes[indexPath.row];
    FUToolbarItem *item = node.value;
    if ([[self selectedIndexPath] isEqual:indexPath]) {
        if (item.canHighlighted) {
            item.highlighted = YES;
        } else {
            item.highlighted = NO;
        }
    }
    
    UICollectionViewCell *cell = [self cellForItem:item atIndexPath:indexPath];
    if ([cell conformsToProtocol:@protocol(FUToolbarCell)]) {
        id<FUToolbarCell> toolbarCell = (id<FUToolbarCell>)cell;
        [toolbarCell configureWithToolbarItem:item];
    }
    
    return (UICollectionViewCell *)cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<FUToolbarNode *> *childNodes = [self rootNode].childNodes;
    if (indexPath.row >= childNodes.count) { return CGSizeZero; }
    FUToolbarItem *item = childNodes[indexPath.row].value;
    return [self cellSizeForItem:item];
}

#pragma mark - FUToolbarViewDelegate

- (void)toolbarView:(FUToolbarView *)toolbarView backButtonTapped:(FUToolbarBackButton *)backButton { }
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
         NSLog(fuStr(FUToolbarViewDelegate----didSelectItemAtIndexPath---::%@),indexPath);
}

#pragma mark - FUNavigationToolbarViewDelegate

- (void)navigationToolbarViewDidTappedCloseButton:(FUNavigationToolbar *)navigationToolbarView {
    if (_viewModel.navigationProperty.type != FUFeatureNavigationTypeFaceTrack) {
        [self hideNavigationBar];
    }
}

- (void)navigationToolbarViewDidTappedNextButton:(FUNavigationToolbar *)navigationToolbarView {
    
}

@end
