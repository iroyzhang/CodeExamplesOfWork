//
//  FUToolbarCollectionViewLayout.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/2.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUToolbarCollectionViewLayout.h"

@implementation FUToolbarCollectionViewLayout

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

@end
