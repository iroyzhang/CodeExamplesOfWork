//
//  FUAudioRecordToolDrawerbar.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/8/26.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUAudioRecordToolDrawerbar.h"
#import "FUToolbarIconNames.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "FUTheme.h"
#import "FUTemplateMethods.h"
#import <Masonry/Masonry.h>
#import "FUAudioRecordButton.h"

@interface FUAudioRecordToolDrawerbar()

@end

@implementation FUAudioRecordToolDrawerbar

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = FUTheme.drawerToolbarBackgroundColor;
    [FUTemplateMethods addDrawerStyleShadowForView:self];
    [self setupRecordButton];
}

- (void)setupRecordButton {
    _recordButton = [FUAudioRecordButton buttonWithType:UIButtonTypeCustom];
    _recordButton.recordStatus = FUAudioRecordStatusPause;
    [self addSubview:_recordButton];
    [_recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.center.equalTo(self);
    }];
}

#pragma mark - FUDrawerToolbar

- (CGFloat)defaultHeight {
    return 80;
}

- (CGFloat)fullHeight {
    return 80;
}

- (void)reloadData {
    
}

@end
