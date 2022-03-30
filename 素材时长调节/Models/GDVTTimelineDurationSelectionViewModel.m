//
//  GDVTTimelineDurationSelectionViewModel.m
//  GDMVideoEdit
//
//  Created by buze on 2021/11/26.
//

#import "GDVTTimelineDurationSelectionViewModel.h"
#import <GDFoundation/GDDefine.h>
#import "GDVEBaseCoat.h"
#import "GDVETextCoat.h"
#import "GDVEWatermarkCoat.h"
#import "GDVEEffectCoat.h"
#import "GDVEStickerCoat.h"
#import "GDVEDynamicStickerCoat.h"
#import "GDVECoatTimeCapability.h"

@implementation GDVTTimelineDurationSelectionViewModel

// MARK: - Lifecycle

- (instancetype)initWithCoat:(GDVEBaseCoat *)coat timelineViewModel:(GDVTTimelineViewModel *)timelineViewModel {
    self = [super init];
    if (self) {
        _selectedCoat = coat;
        _timelineViewModel = timelineViewModel;
        _handlerWidth = 15.0;
        _borderWidth = 2.0;
    }
    return self;
}

// MARK: - Public

- (UIColor *)selectionViewColor {
    UIColor *color = GDColorHex(0xFFAB5D);
    
    if (self.selectedCoat.type == GDVECoatTypeText) {
        color = GDColorHex(0x5082FF);
    } else if (self.selectedCoat.type == GDVECoatTypeSticker ||
               self.selectedCoat.type == GDVECoatTypeDynamicSticker) {
        color = GDColorHex(0xFFAB5D);
    } else if (self.selectedCoat.type == GDVECoatTypeEffect) {
        color = GDColorHex(0xDE8CFB);
    } else if (self.selectedCoat.type == GDVECoatTypeWatermark) {
        color = GDColorHex(0xFFAB5D);
    }
    
    return color;
}

@end
