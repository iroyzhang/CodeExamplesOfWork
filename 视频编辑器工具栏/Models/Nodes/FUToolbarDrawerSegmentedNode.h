//
//  FUToolbarDrawerSegmentedNode.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/23.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FUToolbarItem;

@interface FUToolbarDrawerSegmentedNode : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray<FUToolbarItem *> *items;

- (instancetype)initWithTitle:(NSString *)title items:(NSArray<FUToolbarItem *> *)items;
@end

NS_ASSUME_NONNULL_END
