//
//  FUAudioRecordButton.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/8/26.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUAudioRecordButton.h"
#import "FUToolbarIconNames.h"

@implementation FUAudioRecordButton

- (void)setRecordStatus:(FUAudioRecordStatus)recordStatus {
    _recordStatus = recordStatus;
    switch (recordStatus) {
        case FUAudioRecordStatusPause:
            [self setImage:[UIImage imageNamed:FUToolbarIconNames.recordStart] forState:UIControlStateNormal];
            break;
        case FUAudioRecordStatusPlaying:
            [self setImage:[UIImage imageNamed:FUToolbarIconNames.recordStop] forState:UIControlStateNormal];
            break;
    }
}

@end
