//
//  FUSpeedKeyFrameButton.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2021/6/30.
//  Copyright © 2021 Faceunity. All rights reserved.
//

#import "FUSpeedKeyFrameButton.h"
#import "FUTheme.h"
#import "FUToolbarIconNames.h"

@implementation FUSpeedKeyFrameButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = FUTheme.stateBarControlBackgroundColor;
        self.layer.cornerRadius = 13.0;
        self.layer.masksToBounds = YES;
        self.status = FUKeyFrameButtonStatusAbleToAdd;
    }
    return self;
}

- (void)setStatus:(FUKeyFrameButtonStatus)status {
    [super setStatus:status];
    [self setTitle:nil forState:UIControlStateNormal];
    self.hidden = NO;
    switch (status) {
        case FUKeyFrameButtonStatusAbleToAdd:
            self.enabled = YES;
            [self setImage:[UIImage imageNamed:FUToolbarIconNames.keyframeAdd] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:[FUToolbarIconNames selectedNameWithIconName:FUToolbarIconNames.keyframeAdd]] forState:UIControlStateSelected];
            break;
        case FUKeyFrameButtonStatusDisableToAdd:
            self.enabled = NO;
            [self setImage:[UIImage imageNamed:FUToolbarIconNames.keyframeRemove] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:[FUToolbarIconNames selectedNameWithIconName:FUToolbarIconNames.keyframeRemove]] forState:UIControlStateSelected];
            break;
        case FUKeyFrameButtonStatusAbleToDelete:
            self.hidden = NO;
            self.enabled = YES;
            [self setImage:[UIImage imageNamed:FUToolbarIconNames.keyframeRemove] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:[FUToolbarIconNames selectedNameWithIconName:FUToolbarIconNames.keyframeRemove]] forState:UIControlStateSelected];
            break;
    }
}

@end
