//
//  GDVTTimelineViewConfiguration.m
//  GDMVideoEdit
//
//  Created by buze on 2021/11/26.
//

#import "GDVTTimelineViewConfiguration.h"

@implementation GDVTTimelineViewConfiguration

// MARK: - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _contentHeight = [self defaultContentHeight];
        _contentInset = [self defaultContentInset];
        _itemSpacing = [self itemSpacing];
    }
    return self;
}

// MARK: - Private

- (CGFloat)defaultContentHeight {
    return 48.0;
}

- (UIEdgeInsets)defaultContentInset {
    CGFloat screenWidth = CGRectGetWidth(UIScreen.mainScreen.bounds);
    return UIEdgeInsetsMake(0, screenWidth / 2.0, 0, screenWidth / 2.0);
}

- (CGFloat)defaultItemSpacing {
    return 0.0;
}

@end
