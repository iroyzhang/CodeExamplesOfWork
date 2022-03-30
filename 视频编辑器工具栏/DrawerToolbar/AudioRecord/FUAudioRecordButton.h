//
//  FUAudioRecordButton.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/8/26.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FUAudioRecordStatus) {
    FUAudioRecordStatusPause,
    FUAudioRecordStatusPlaying,
};

@interface FUAudioRecordButton : UIButton
@property (nonatomic, assign) FUAudioRecordStatus recordStatus;
@end

NS_ASSUME_NONNULL_END
