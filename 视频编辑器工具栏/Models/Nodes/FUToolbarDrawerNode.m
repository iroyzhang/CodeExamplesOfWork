//
//  FUToolbarDrawerModel.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/2.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUToolbarDrawerNode.h"

@implementation FUToolbarDrawerNode

- (BOOL)isEqual:(id)other
{
    FUToolbarDrawerNode *otherNode = (FUToolbarDrawerNode *)other;
    if (_style == otherNode.style && _name == otherNode.name) {
        return YES;
    } else {
        return NO;
    }
}

- (NSUInteger)hash
{
    return _name.hash ^ _style;
}

@end
