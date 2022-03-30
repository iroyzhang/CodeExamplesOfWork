//
//  FUTrackStickersViewController.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/8/4.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FUTrackStickersViewController;

@protocol FUTrackAssetsViewControllerDelegate <NSObject>
- (void)trackAssetsViewControllerBackButtonTapped:(FUTrackStickersViewController *)trackAssetsViewController;
- (void)trackAssetsViewControllerOkButtonTapped:(FUTrackStickersViewController *)trackAssetsViewController;
@end

@interface FUTrackStickersViewController : UIViewController
@property (nonatomic, weak) id<FUTrackAssetsViewControllerDelegate> delegate;

- (void)updateFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
