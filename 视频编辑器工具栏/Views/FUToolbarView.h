//
//  FUToolbarView.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/9.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FUToolbarCollectionView;
@class FUToolbarView;
@class FUMainToolbar;
@class FUSubToolbar;
@class FUToolbarBackButton;

typedef NS_ENUM(NSUInteger, FUToolbarViewLevel) {
    FUToolbarViewLevelMain,
    FUToolbarViewLevelSub,
};

@protocol FUToolbarViewDataSource <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@end

@protocol FUToolbarViewDelegate <UICollectionViewDelegate>
@optional
- (void)toolbarView:(FUToolbarView *)toolbarView backButtonTapped:(FUToolbarBackButton *)backButton;
@end

@interface FUToolbarView : UIView
@property (nonatomic, strong) FUToolbarCollectionView *mainToolbar;
@property (nonatomic, strong) FUToolbarCollectionView *subToolbar;
@property (nonatomic, strong) FUToolbarBackButton *backButton;
@property (nonatomic, weak) id<FUToolbarViewDataSource> dataSource;
@property (nonatomic, weak) id<FUToolbarViewDelegate> delegate;
@property (nonatomic, assign, readonly) FUToolbarViewLevel currentLevel;

- (void)reloadData;
- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (void)showToolbarWithLevel:(FUToolbarViewLevel)level;
@end

NS_ASSUME_NONNULL_END
