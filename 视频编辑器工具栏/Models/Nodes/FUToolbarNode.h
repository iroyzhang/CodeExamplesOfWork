//
//  FUToolbarNode.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/1.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FUToolbarItem;
@class FUToolbarDrawerNode;

typedef NS_ENUM(NSUInteger, FUToolbarNodeStyle) {
    FUToolbarNodeStyleTree,
    FUToolbarNodeStyleDrawer,
};

@interface FUToolbarNode : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) FUToolbarItem *value;
@property (nonatomic, copy,) NSArray<FUToolbarNode *> *childNodes;
@property (nonatomic, strong) FUToolbarDrawerNode *drawerNode;
@property (nonatomic, assign) FUToolbarNodeStyle style;

+ (instancetype)treeNodeWithName:(NSString *)name value:(FUToolbarItem *)value childNodes:(NSArray<FUToolbarNode *> *)childNodes;
+ (instancetype)drawerNodeWithName:(NSString *)name value:(FUToolbarItem *)value drawerNode:(FUToolbarDrawerNode *)drawerNode;
@end

NS_ASSUME_NONNULL_END
