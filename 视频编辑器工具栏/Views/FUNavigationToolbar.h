//
//  FUNavigationToolbar.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/8/5.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FUNavigationToolbar;

@protocol FUNavigationToolbarViewDelegate <NSObject>
- (void)navigationToolbarViewDidTappedCloseButton:(FUNavigationToolbar *)navigationToolbarView;
- (void)navigationToolbarViewDidTappedNextButton:(FUNavigationToolbar *)navigationToolbarView;
@end

@interface FUNavigationToolbar : UIView
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, weak) id<FUNavigationToolbarViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
