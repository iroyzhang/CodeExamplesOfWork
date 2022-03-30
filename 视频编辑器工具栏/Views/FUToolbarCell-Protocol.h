//
//  FUToolbarCell-Protocol.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/3.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FUToolbarItem;

@protocol FUToolbarCell <NSObject>
- (void)configureWithToolbarItem:(FUToolbarItem *)item;
@end

NS_ASSUME_NONNULL_END
