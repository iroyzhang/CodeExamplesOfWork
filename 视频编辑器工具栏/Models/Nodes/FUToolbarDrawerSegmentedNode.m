//
//  FUToolbarDrawerSegmentedNode.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/23.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUToolbarDrawerSegmentedNode.h"

@implementation FUToolbarDrawerSegmentedNode

- (instancetype)initWithTitle:(NSString *)title items:(NSArray<FUToolbarItem *> *)items {
    self = [super init];
    if (self) {
        _title = title;
        _items = items;
    }
    return self;
}

@end
