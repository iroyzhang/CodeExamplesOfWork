//
//  FUAudioRecordToolDrawerbar.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/8/26.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUDrawerToolbar.h"

NS_ASSUME_NONNULL_BEGIN

@class FUAudioRecordButton;

@interface FUAudioRecordToolDrawerbar : UIView <FUDrawerToolbar>
@property (nonatomic, strong) FUAudioRecordButton *recordButton;
@end

NS_ASSUME_NONNULL_END
