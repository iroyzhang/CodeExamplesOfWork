//
//  FUDrawerToolbarModel.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/12.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FUToolbarNode;
@class FUToolbarDrawerNode;

@interface FUDrawerToolbarModel : NSObject
@property (nonatomic, strong) FUToolbarNode *root;
@property (nonatomic, strong) FUToolbarDrawerNode *activeDrawerNode;

- (instancetype)initWithRoot:(FUToolbarNode *)root;
@end

NS_ASSUME_NONNULL_END
