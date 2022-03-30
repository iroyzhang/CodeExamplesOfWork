//
//  FUToolbarController.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/1.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FUToolbarViewModel;

@interface FUToolbarController : UIViewController
@property (nonatomic, strong) FUToolbarViewModel *viewModel;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithViewModel:(FUToolbarViewModel *)viewModel;
@end

NS_ASSUME_NONNULL_END
