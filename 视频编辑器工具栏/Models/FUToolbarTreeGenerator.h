//
//  FUToolbarTreeGenerator.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/8.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FUFeatureNode;
@class FUToolbarNode;
@class FUToolbarDrawerNode;
@class FUFeatureDrawerNode;
@class FUFeatureItem;

@interface FUToolbarTreeGenerator : NSObject
- (FUToolbarNode *)toolbarTreeForFeatureTree:(FUFeatureNode *)featureTree featureObjects:(NSDictionary *)featureObjects;
- (FUToolbarDrawerNode *)toolbarDrawerNodeForFeatureDrawerNode:(FUFeatureDrawerNode *)featureDrawerNode featureObjects:(NSDictionary *)featureObjects;
@end

NS_ASSUME_NONNULL_END
