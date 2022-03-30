//
//  FUToolbarModel.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/3.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUToolbarModel.h"

@implementation FUToolbarModel

#pragma mark - Init

- (instancetype)initWithRoot:(FUToolbarNode *)root selectedItemIndexPath:(NSIndexPath *)selectedItemIndexPath style:(NSUInteger)style backLevel:(FUToolbarBackLevel)backLevel persistentScrolling:(BOOL)persistentScrolling {
    self = [super init];
    if (self) {
        _root = root;
        _selectedItemIndexPath = selectedItemIndexPath;
        _style = style;
        _backLevel = backLevel;
        _persistentScrolling = persistentScrolling;
    }
    return self;
}

#pragma mark - NSCopying

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    FUToolbarModel *newModel = [[FUToolbarModel alloc] initWithRoot:_root selectedItemIndexPath:_selectedItemIndexPath style:_style backLevel:_backLevel persistentScrolling:_persistentScrolling];
    return newModel;
}

@end
