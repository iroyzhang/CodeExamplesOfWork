//
//  FUToolbarNode.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/1.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUToolbarNode.h"

@implementation FUToolbarNode

+ (instancetype)treeNodeWithName:(NSString *)name value:(FUToolbarItem *)value childNodes:(NSArray<FUToolbarNode *> *)childNodes {
    FUToolbarNode *node = [[FUToolbarNode alloc] init];
    node.style = FUToolbarNodeStyleTree;
    node.name = name;
    node.value = value;
    node.childNodes = childNodes;
    return node;
}

+ (instancetype)drawerNodeWithName:(NSString *)name value:(FUToolbarItem *)value drawerNode:(FUToolbarDrawerNode *)drawerNode {
    FUToolbarNode *node = [[FUToolbarNode alloc] init];
    node.style = FUToolbarNodeStyleDrawer;
    node.name = name;
    node.value = value;
    node.drawerNode = drawerNode;
    return node;
}

@end
