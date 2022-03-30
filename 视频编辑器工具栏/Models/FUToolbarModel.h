//
//  FUToolbarModel.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/3.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FUToolbarNode;

typedef NS_ENUM(NSUInteger, FUToolbarBackLevel) {
    FUToolbarBackLevelNone,
    FUToolbarBackLevelSub,
    FUToolbarBackLevelDrawer,
};

@interface FUToolbarModel : NSObject <NSCopying>
@property (nonatomic, strong) FUToolbarNode *root;
@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;
@property (nonatomic, assign) NSUInteger style;
@property (nonatomic, assign) FUToolbarBackLevel backLevel;
@property (nonatomic, assign) BOOL persistentScrolling;

- (instancetype)initWithRoot:(FUToolbarNode *)root selectedItemIndexPath:(NSIndexPath *)selectedItemIndexPath style:(NSUInteger)style backLevel:(FUToolbarBackLevel)backLevel persistentScrolling:(BOOL)persistentScrolling;
@end

NS_ASSUME_NONNULL_END
