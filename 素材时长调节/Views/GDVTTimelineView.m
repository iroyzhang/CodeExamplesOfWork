//
//  GDVTTimelineView.m
//  GDMVideoEdit
//
//  Created by buze on 2021/11/23.
//

#import "GDVTTimelineView.h"
#import <Masonry/Masonry.h>
#import <GDFoundation/GDDefine.h>
#import "GDVTTimelineViewCell.h"
#import "GDVTTimelineViewModel.h"
#import "GDVTTimelineViewConfiguration.h"
#import "GDVTTimelineFrame.h"

@interface GDVTTimelineView() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

/// 集合视图
@property (nonatomic, strong) UICollectionView *collectionView;

/// 遮罩图层
@property (nonatomic, strong) CALayer *overlayLayer;

/// 临时缓存的帧序列
@property (nonatomic, copy) NSArray<GDVTTimelineFrame *> *cachedFrames;

/// 正在拖拽
@property (nonatomic, assign) BOOL isDragging;

@end

@implementation GDVTTimelineView

// MARK: - Lifecycle

- (instancetype)initWithViewModel:(GDVTTimelineViewModel *)viewModel {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _viewModel = viewModel;
        [self setupSubviews];
    }
    return self;
}

- (void)dealloc {
    [self.collectionView removeObserver:self forKeyPath:@"contentSize"];
}

// MARK: - Public

- (void)seekToTime:(long)time animated:(BOOL)animated {
    CGFloat offset = [self.viewModel offsetForTime:time];
    CGPoint newOffset = CGPointMake(offset, self.contentOffset.y);
    
    if (CGPointEqualToPoint(self.contentOffset, newOffset)) {
        return;
    }
    
    [self.collectionView setContentOffset:newOffset animated:animated];
}

- (void)seekWithOffset:(CGPoint)offset {
    CGPoint newOffset = CGPointMake(self.collectionView.contentOffset.x + offset.x, self.collectionView.contentOffset.y + offset.y);
    
    if (newOffset.x < self.viewModel.minContentOffset) {
        newOffset.x = self.viewModel.minContentOffset;
    }
    
    if (newOffset.x > self.viewModel.maxContentOffset) {
        newOffset.x = self.viewModel.maxContentOffset;
    }
    
    if (CGPointEqualToPoint(self.contentOffset, newOffset)) {
        return;
    }
    
    [self.collectionView setContentOffset:newOffset];
}

- (void)reloadData {
    [self reloadDataWithSeekTime:0];
}

- (void)reloadDataWithSeekTime:(long)seekTime {
    [self.viewModel setNeedUpdate];
    
    GDWeakify(self);
    [self.viewModel fetchTimelineFrames:^(NSArray<GDVTTimelineFrame *> *frames) {
        GDStrongify(self);
        self.cachedFrames = frames;
        [self reloadCollectionView];
        [self seekToTime:seekTime animated:NO];
    }];
}

- (void)reloadDataByCache {
    GDWeakify(self);
    [self.viewModel fetchTimelineFrames:^(NSArray<GDVTTimelineFrame *> *frames) {
        GDStrongify(self);
        self.cachedFrames = frames;
        [self reloadCollectionView];
    }];
}

- (void)reloadCollectionView {
    [self.collectionView reloadData];
    if ([self.delegate respondsToSelector:@selector(timelineViewDidReloadData:)]) {
        [self.delegate timelineViewDidReloadData:self];
    }
}

- (void)addSubviewToScrollView:(UIView *)subview {
    if (!subview) { return; }
    [self.collectionView addSubview:subview];
}

- (CGRect)visibleRect {
    UIEdgeInsets contentInset = self.collectionView.contentInset;
    CGPoint contentOffset = self.collectionView.contentOffset;
    CGFloat visibleOriginX = contentInset.left + contentOffset.x;
    CGFloat visibleHeight = CGRectGetHeight(self.collectionView.bounds);
    CGFloat visibleWidth = CGRectGetWidth(self.collectionView.bounds);
    
    CGRect rect = CGRectMake(visibleOriginX, 0, visibleWidth, visibleHeight);
    
    return rect;
}

// MARK: - Private Setup

- (void)setupSubviews {
    [self setupCollectionView];
    [self setupOverlayLayer];
    [self setupKVO];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = _viewModel.viewConfiguration.itemSpacing;
    flowLayout.minimumLineSpacing = 0.0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = UIColor.whiteColor;
    [_collectionView registerClass:GDVTTimelineViewCell.class forCellWithReuseIdentifier:NSStringFromClass(GDVTTimelineViewCell.class)];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.contentInset = _viewModel.viewConfiguration.contentInset;
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setupOverlayLayer {
    CALayer *overlayLayer = [[CALayer alloc] init];
    overlayLayer.cornerRadius = 4.0;
    overlayLayer.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.03].CGColor;
    overlayLayer.borderWidth = 1.0;
    overlayLayer.borderColor = [UIColor.blackColor colorWithAlphaComponent:0.03].CGColor;
    [_collectionView.layer addSublayer:overlayLayer];
    _overlayLayer = overlayLayer;
}

- (void)setupKVO {
    [_collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

// MARK: - Private

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (![cell isKindOfClass:GDVTTimelineViewCell.class] || indexPath.row >= self.cachedFrames.count) { return; }
    
    GDVTTimelineViewCell *timelineViewCell = (GDVTTimelineViewCell *)cell;
    GDVTTimelineFrame *frame = self.cachedFrames[indexPath.row];
    timelineViewCell.timelineFrame = frame;
    [self addCornerToCell:timelineViewCell atIndexPath:indexPath];
}

- (void)addCornerToCell:(GDVTTimelineViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [cell removeRoundedCorners];
    
    if (self.cachedFrames.count <= 1) {
        [cell addRoundedCorners:UIRectCornerAllCorners withRadii:CGSizeMake(4.0, 4.0)];
    } else {
        if (indexPath.row == 0) {
            [cell addRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft withRadii:CGSizeMake(4.0, 4.0)];
        } else if (indexPath.row == self.cachedFrames.count - 1) {
            [cell addRoundedCorners:UIRectCornerTopRight | UIRectCornerBottomRight withRadii:CGSizeMake(4.0, 4.0)];
        }
    }
}

- (void)updateOverlayLayerFrame {
    CGFloat collectionViewHeight = CGRectGetHeight(self.collectionView.bounds);
    CGFloat originY = (collectionViewHeight - self.viewModel.viewConfiguration.contentHeight) / 2.0;
    CGRect newFrame = CGRectMake(0, originY, self.contentSize.width, self.viewModel.viewConfiguration.contentHeight);
    self.overlayLayer.frame = newFrame;
}

// MARK: - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context {
    if(object == self.collectionView){
        if ([keyPath isEqualToString:@"contentSize"]) {
            [self updateOverlayLayerFrame];
        }
    }
}

// MARK: - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cachedFrames.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.cachedFrames.count) { return [UICollectionViewCell new];}

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(GDVTTimelineViewCell.class) forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

// MARK: - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![cell isKindOfClass:GDVTTimelineViewCell.class]) { return; }
    
    GDVTTimelineViewCell *timelineViewCell = (GDVTTimelineViewCell *)cell;
    GDVTTimelineFrame *timelineFrame = timelineViewCell.timelineFrame;
    
    if (!timelineFrame) { return; }
    
    [self.viewModel fetchThumbnailForTimelineFrame:timelineFrame size:self.viewModel.imagePerFrameSize completion:^(GDVTTimelineFrame * _Nonnull timelineFrameForImage, UIImage * _Nonnull image) {
        if ([timelineFrame isEqual:timelineFrameForImage]) {
            timelineViewCell.thumbnailImageView.image = image;
        }
    }];
}

// MARK: - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat collectionViewHeight = CGRectGetHeight(collectionView.bounds);
    CGFloat verticalInset = (collectionViewHeight - self.viewModel.viewConfiguration.contentHeight) / 2.0;
    return UIEdgeInsetsMake(verticalInset, 0, verticalInset, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.cachedFrames.count) { return CGSizeZero; }
    GDVTTimelineFrame *timelineFrame = self.cachedFrames[indexPath.row];
    return CGSizeMake(timelineFrame.frameWidth, self.viewModel.viewConfiguration.contentHeight);
}

// MARK: - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isDragging && [self.delegate respondsToSelector:@selector(timelineViewDidScroll:)]) {
        [self.delegate timelineViewDidScroll:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (self.isDragging && [self.delegate respondsToSelector:@selector(timelineViewDidScroll:)]) {
            [self.delegate timelineViewDidScroll:self];
        }
        self.isDragging = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.isDragging && [self.delegate respondsToSelector:@selector(timelineViewDidScroll:)]) {
        [self.delegate timelineViewDidScroll:self];
    }
    self.isDragging = NO;
}

// MARK: - Custom Accessors

- (void)setViewModel:(GDVTTimelineViewModel *)viewModel {
    _viewModel = viewModel;
}

- (UIEdgeInsets)contentInset {
    return self.collectionView.contentInset;
}

- (CGSize)contentSize {
    return self.collectionView.contentSize;
}

- (CGPoint)contentOffset {
    return self.collectionView.contentOffset;
}

@end
