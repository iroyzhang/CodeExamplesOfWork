//
//  FUToolbarTreeGenerator.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/8.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUToolbarTreeGenerator.h"
#import "FUFeatureNode.h"
#import "FUToolbarNode.h"
#import "FUFeatureItem.h"
#import "FUToolbarItem.h"
#import "FUToolbarDrawerNode.h"
#import "FUFeatureDrawerNode.h"
#import "FUToolbarDrawerNode.h"
#import "FUFeatureDrawerNode.h"
#import "FUFeatureProperty.h"
#import "FUValueFormatter.h"
#import "FUFeartureDrawerSliderNode.h"
#import "FUToolbarDrawerSliderNode.h"
#import "FUFeatureDrawerSegmentedNode.h"
#import "FUToolbarDrawerSegmentedNode.h"
#import "FUFeatureDynamicIconProperty.h"
#import "FUHueAdjustProcessModel.h"
#import "FUCompositionProcessModel.h"
#import "FUComposition.h"
#import "FUFeatureState.h"
#import "FUFeaturePresetAnimationProperty.h"
#import "FUFrameModel.h"
#import "FUAnimationModel.h"
#import "FUFeatureDisableProperty.h"
#import "FUToneGradientColorInfo.h"

@implementation FUToolbarTreeGenerator

#pragma mark - Public Methods

- (FUToolbarNode *)toolbarTreeForFeatureTree:(FUFeatureNode *)featureTree featureObjects:(NSDictionary *)featureObjects {
    NSString *name = featureTree.name;
    FUToolbarItem *value = [self toolbarItemForFeatureItem:featureTree.value featureObjects:featureObjects];
    
    if (featureTree.style == FUFeatureNodeStyleDrawer) {
        FUToolbarDrawerNode *drawerNode = [self toolbarDrawerNodeForFeatureDrawerNode:featureTree.drawerNode featureObjects:featureObjects];
        return [FUToolbarNode drawerNodeWithName:name value:value drawerNode:drawerNode];
    } else {
        NSMutableArray *childNodes = [NSMutableArray new];
        for (FUFeatureNode *childFeatureNode in featureTree.childNodes) {
            FUToolbarNode *node = [self toolbarNodeForFeatureNode:childFeatureNode featureObjects:featureObjects];
            [childNodes addObject:node];
        }
        return [FUToolbarNode treeNodeWithName:name value:value childNodes:[childNodes copy]];
    }
}

- (FUToolbarDrawerNode *)toolbarDrawerNodeForFeatureDrawerNode:(FUFeatureDrawerNode *)featureDrawerNode featureObjects:(NSDictionary *)featureObjects {
    FUToolbarDrawerNode *drawerNode = [[FUToolbarDrawerNode alloc] init];
    drawerNode.name = featureDrawerNode.name;
    drawerNode.style = (FUToolbarDrawerNodeStyle)featureDrawerNode.style;
    
    NSMutableArray<FUToolbarItem *> *mainItems = [NSMutableArray new];
    for (FUFeatureNode *mainChildNode in featureDrawerNode.mainChildNodes) {
        FUToolbarItem *item = [self toolbarItemForFeatureItem:mainChildNode.value featureObjects:featureObjects];
        [mainItems addObject:item];
    }
    drawerNode.mainItems = [mainItems copy];
    
    NSMutableArray<FUToolbarItem *> *subItems = [NSMutableArray new];
    for (FUFeatureNode *subChildNode in featureDrawerNode.subChildNodes) {
        FUToolbarItem *item = [self toolbarItemForFeatureItem:subChildNode.value featureObjects:featureObjects];
        [subItems addObject:item];
    }
    drawerNode.subItems = [subItems copy];
    
    drawerNode.mainTitle = featureDrawerNode.mainName;
    drawerNode.subTitile = featureDrawerNode.subName;
    
    if (featureDrawerNode.sliderNode) {
        FUFeartureDrawerSliderNode *featureSliderNode = featureDrawerNode.sliderNode;
        FUValueFormatter *valueFormatter = featureDrawerNode.valueFormatter;
        float value = [valueFormatter formatValue:@(featureSliderNode.value)].floatValue;
        float minimumValue = [valueFormatter formatValue:@(featureSliderNode.minimumValue)].floatValue;
        float maximumValue = [valueFormatter formatValue:@(featureSliderNode.maximumValue)].floatValue;
        FUToolbarDrawerSliderNode *toolbarSliderNode = [[FUToolbarDrawerSliderNode alloc] initWithValue:value minimumValue:minimumValue maximumValue:maximumValue continuous:featureDrawerNode.sliderNode.isContinuous displayFormat:featureDrawerNode.sliderNode.displayFormat];
        drawerNode.sliderNode = toolbarSliderNode;
    }
    
    NSMutableArray<FUToolbarDrawerSegmentedNode *> *segmentedNodes = [NSMutableArray new];
    if (featureDrawerNode.segmentedNodes && featureDrawerNode.segmentedNodes.count > 0) {
        for (FUFeatureDrawerSegmentedNode *featureDrawerSegmentedNode in featureDrawerNode.segmentedNodes) {
            FUToolbarDrawerSegmentedNode *node = [self toolbarDrawerSegmentedNodeForFeatureSegmentedNode:featureDrawerSegmentedNode featureObjects:featureObjects];
            [segmentedNodes addObject:node];
        }
    }
    drawerNode.segmentedNodes = segmentedNodes;
    
    return drawerNode;
}

#pragma mark - Private Methods

- (FUToolbarNode *)toolbarNodeForFeatureNode:(FUFeatureNode *)featureNode featureObjects:(NSDictionary *)featureObjects {
    FUToolbarItem *value = [self toolbarItemForFeatureItem:featureNode.value featureObjects:featureObjects];
    if (featureNode.style == FUToolbarNodeStyleDrawer) {
        FUToolbarDrawerNode *drawerNode = [self toolbarDrawerNodeForFeatureDrawerNode:featureNode.drawerNode featureObjects:featureObjects];
        return [FUToolbarNode drawerNodeWithName:featureNode.name value:value drawerNode:drawerNode];
    } else {
        return [FUToolbarNode treeNodeWithName:featureNode.name value:value childNodes:[NSArray new]];
    }
}

- (FUToolbarItem *)toolbarItemForFeatureItem:(FUFeatureItem *)featureItem featureObjects:(NSDictionary *)featureObjects {
    FUToolbarItemStyle itemStyle = [self toolbarItemStyleForFeatureItemType:featureItem.type];
    FUToolbarItem *toolbarItem = [[FUToolbarItem alloc] initWithTitle:featureItem.title
                                                                value:featureItem.value
                                                             iconName:featureItem.iconName
                                                           cornerName:featureItem.cornerName
                                                                style:itemStyle];
    toolbarItem.imageName = featureItem.imageName;
    toolbarItem.canHighlighted = featureItem.canHighlighted;
    toolbarItem.isArrangeable = featureItem.isArrangeable;
    toolbarItem.resource = featureItem.resource;
    toolbarItem.gradientBaseColorName = featureItem.gradientBaseColorName;
    
    if (featureItem.toneGradientColorInfo) {
        if ([featureObjects.allKeys containsObject:NSStringFromClass(featureItem.toneGradientColorInfo.scopeProperty.objectClass)]) {
            toolbarItem.toneGradientColorName = featureItem.toneGradientColorInfo.colorName;
            id selectionObject = [featureObjects objectForKey:NSStringFromClass(featureItem.toneGradientColorInfo.scopeProperty.objectClass)];
            id value = [selectionObject valueForKeyPath:featureItem.toneGradientColorInfo.scopeProperty.keyPath];
            toolbarItem.toneGradientColorScope = ((NSNumber *)value).floatValue;
        }
    }
    
    if (featureObjects.count > 0) {
        if (featureItem.presetAnimationProperty) {
            FUFeaturePresetAnimationProperty *presetAnimationProperty = featureItem.presetAnimationProperty;
            NSString *key = NSStringFromClass([FUFrameModel class]);
            if ([featureObjects.allKeys containsObject:key]) {
                FUFrameModel *frameModel = (FUFrameModel *)featureObjects[key];
                NSArray *presetAnimations = frameModel.animations;
                if (presetAnimations.count == 0) {
                    if (featureItem.presetAnimationProperty.name.value == 0) {
                        if (featureItem.canHighlighted) {
                            toolbarItem.highlighted = YES;
                        }
                    }
                } else {
                    __block BOOL isExistAnimation = NO;
                    [presetAnimations enumerateObjectsUsingBlock:^(FUAnimationModel *presetAnimationModel, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (presetAnimationModel.animationType.value == presetAnimationProperty.type.value) {
                            isExistAnimation = YES;
                        }
                    }];
                    for (NSUInteger index = 0; index < presetAnimations.count; index++) {
                        FUAnimationModel *presetAnimationModel = presetAnimations[index];
                        if (!isExistAnimation) {
                            if (presetAnimationProperty.name.value == 0 && featureItem.canHighlighted) {
                                toolbarItem.highlighted = YES;
                            }
                        } else {
                            if ([presetAnimationModel.animationType isEqual:presetAnimationProperty.type]) {
                                if ([presetAnimationModel.name isEqual:presetAnimationProperty.name] && featureItem.canHighlighted) {
                                    toolbarItem.highlighted = YES;
                                }
                            }
                        }
                    }
                }
            }
        } else if (featureItem.valueProperty) {
            FUFeatureProperty *valueProperty = featureItem.valueProperty;
            NSString *valuePropertyObjectKey = NSStringFromClass(valueProperty.objectClass);
            
            if ([featureObjects.allKeys containsObject:valuePropertyObjectKey]) {
                id updateSelectionObject = [featureObjects objectForKey:valuePropertyObjectKey];
                id value = [updateSelectionObject valueForKeyPath:valueProperty.keyPath];
                id featureValue = featureItem.value;
                
                if (featureItem.isDynamicValue) {
                    featureItem.value = value;
                } else if (value && ([value isEqual:featureValue])) {
                    if (featureItem.canHighlighted) {
                        toolbarItem.highlighted = YES;
                    }
                }
                
                // 如果是字体，都转成中文进行比较
                if ([valueProperty.keyPath isEqualToString:@"fontName"]) {
                    NSString *valueChinese;
                    NSString *featureValueChinese;
                    if ([value isKindOfClass:[NSString class]]) {
                        valueChinese = (NSString *)value;
                        if ([NSString isEnglish:valueChinese]) {
                            valueChinese = [NSString convertFontNameToChinese:valueChinese];
                        }
                    }
                    if ([featureValue isKindOfClass:[NSString class]]) {
                        featureValueChinese = (NSString *)featureValue;
                        if ([NSString isEnglish:featureValueChinese]) {
                            featureValueChinese = [NSString convertFontNameToChinese:featureValueChinese];
                        }
                    }
                    if (valueChinese && featureValueChinese && [valueChinese isEqualToString:featureValueChinese]) {
                        if (featureItem.canHighlighted) {
                            toolbarItem.highlighted = YES;
                        }
                    }
                }
            }
        } else if (featureItem.isArrangeable) {
            NSString *featureStateKey = NSStringFromClass([FUFeatureState class]);
            if ([featureObjects.allKeys containsObject:featureStateKey]) {
                FUFeatureState *featureState = (FUFeatureState *)featureObjects[featureStateKey];
                FUComposition *composition = featureState.compositionProcessModel.composition;
                NSUUID *selectedID = featureState.compositionProcessModel.selectedID;
                if (selectedID) {
                    NSDictionary *levels = [composition levelsAtTime:featureState.seekTime];
                    if ([levels.allKeys containsObject:selectedID] && levels.allKeys.count > 1) {
                        NSInteger levelForSelectedID = [composition levelForIdentifier:selectedID];
                        NSArray *allLevels = levels.allValues;
                        allLevels = [allLevels sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
                            if (obj1.intValue < obj2.intValue) return NSOrderedAscending;
                            return NSOrderedDescending;
                        }];
                        NSUInteger index = [allLevels indexOfObject:@(levelForSelectedID)];
                        
                        NSInteger selectedIndex = ((NSNumber *)featureItem.value).integerValue;
                        if (index + 1 == selectedIndex) {
                            if (featureItem.canHighlighted) {
                                toolbarItem.highlighted = YES;
                            }
                        }
                    }
                }
            }
        }
        
        if (featureItem.sliderProperty) {
            FUFeatureSliderProperty *sliderProperty = featureItem.sliderProperty;
            NSString *sliderObjectKey = NSStringFromClass(sliderProperty.objectClass);
            if ([featureObjects.allKeys containsObject:sliderObjectKey]) {
                id sliderObject = [featureObjects objectForKey:sliderObjectKey];
                id value = [sliderObject valueForKeyPath:sliderProperty.keyPath];
                toolbarItem.adjustable = YES;
                FUValueFormatter *valueFormatter = featureItem.valueFormatter;
                NSNumber *sliderValue = [valueFormatter formatValue:(NSNumber *)value];
                toolbarItem.displayFormat = featureItem.displayFormat;
                toolbarItem.sliderValue = sliderValue;
            }
        }
         
        if (featureItem.dynamicIconProperty) {
            FUFeatureDynamicIconProperty *iconProperty = featureItem.dynamicIconProperty;
            NSString *valuePropertyObjectKey = NSStringFromClass(iconProperty.objectClass);
            if ([featureObjects.allKeys containsObject:valuePropertyObjectKey]) {
                id featureObject = [featureObjects objectForKey:valuePropertyObjectKey];
                id value = [featureObject valueForKeyPath:iconProperty.valueKeyPath];
                NSString *iconValuePath = [NSString stringWithFormat:fuStr(%@), value];
                NSString *iconName = [iconProperty iconNameForValuePath:iconValuePath];
                NSString *iconTitle = [iconProperty titleForValuePath:iconValuePath];
                if (iconName) {
                    toolbarItem.iconName = iconName;
                }
                if (iconTitle) {
                    toolbarItem.title = iconTitle;
                }
            }
        }
        
        if (featureItem.disableProperty) {
            FUFeatureDisableProperty *disableProperty = featureItem.disableProperty;
            NSString *valuePropertyObjectKey = NSStringFromClass(disableProperty.objectClass);
            if ([featureObjects.allKeys containsObject:valuePropertyObjectKey]) {
                id featureObject = [featureObjects objectForKey:valuePropertyObjectKey];
                id value = [featureObject valueForKeyPath:disableProperty.keyPath];
                if ([value isEqual:disableProperty.value]) {
                    toolbarItem.disabled = YES;
                }
            }
        }
    }
    
    return toolbarItem;
}

- (FUToolbarDrawerSegmentedNode *)toolbarDrawerSegmentedNodeForFeatureSegmentedNode:(FUFeatureDrawerSegmentedNode *)featureDrawerSegmentedNode featureObjects:(NSDictionary *)featureObjects {
    NSMutableArray<FUToolbarItem *> *toolbarItems = [NSMutableArray new];
    for (FUFeatureNode *node in featureDrawerSegmentedNode.items) {
        FUToolbarItem *item = [self toolbarItemForFeatureItem:node.value featureObjects:featureObjects];
        [toolbarItems addObject:item];
    }
    
    return [[FUToolbarDrawerSegmentedNode alloc] initWithTitle:featureDrawerSegmentedNode.title items:toolbarItems];
}

- (FUToolbarItemStyle)toolbarItemStyleForFeatureItemType:(FUFeatureItemType)featureItemType {
    switch (featureItemType) {
        case FUFeatureItemTypeNormal:
            return FUToolbarItemStyleNormal;
        case FUFeatureItemTypeColor:
            return FUToolbarItemStyleColor;
        case FUFeatureItemTypeColorPalette:
            return FUToolbarItemStyleColorPalette;
        case FUFeatureItemTypeFilter:
            return FUToolbarItemStyleFilter;
        case FUFeatureItemTypeFormat:
            return FUToolbarItemStyleFormat;
        case FUFeatureItemTypeResource:
            return FUToolbarItemStyleResource;
        case FUFeatureItemTypeGif:
            return FUToolbarItemStyleGif;
        case FUFeatureItemTypeSpeed:
            return FUToolbarItemStyleSpeed;
    }
}

@end
