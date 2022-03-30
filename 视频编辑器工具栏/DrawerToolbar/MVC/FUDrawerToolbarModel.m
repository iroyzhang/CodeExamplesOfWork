//
//  FUDrawerToolbarModel.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/12.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUDrawerToolbarModel.h"
#import "FUToolbarNode.h"

@implementation FUDrawerToolbarModel

- (instancetype)initWithRoot:(FUToolbarNode *)root {
    self = [super init];
    if (self) {
        _root = root;
    }
    return self;
}

@end
