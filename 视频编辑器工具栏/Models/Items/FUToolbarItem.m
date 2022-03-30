//
//  FUToolbarItem.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/1.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUToolbarItem.h"

@implementation FUToolbarItem

-(instancetype)initWithTitle:(NSString *)title
                       value:(id)value
                    iconName:(nullable NSString *)iconName
                  cornerName:(nullable NSString *)cornerName
                       style:(FUToolbarItemStyle)style {
    
    self = [super init];
    if (self) {
        _title = title;
        _value = value;
        _iconName = iconName;
        _cornerName = cornerName;
        _style = style;
        _disabled = false;
        _adjustable = false;
        _hidden = false;
        _highlighted = false;
        _canHighlighted = YES;
        _isArrangeable = NO;
    }
    return self;
}

@end
