//
//  FUDrawerToolbarController.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/12.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FUDrawerToolbarViewModel;
@class FUDrawerToolbarView;
@class RACSignal;

@interface FUDrawerToolbarController : UIViewController
@property (nonatomic, strong) FUDrawerToolbarViewModel *viewModel;
@property (nonatomic, strong) FUDrawerToolbarView *drawerToolbarView;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithViewModel:(FUDrawerToolbarViewModel *)viewModel;
@end

NS_ASSUME_NONNULL_END
