//
//  GDVTElementDurationAdjustViewModel.m
//  GDMVideoEdit
//
//  Created by buze on 2021/11/29.
//

#import "GDVTElementDurationAdjustViewModel.h"
#import "GDVEBaseCoat.h"
#import "GDVTTimelineViewModel.h"
#import "GDVTTimelineDurationSelectionViewModel.h"
#import "GDVTTimelineViewConfiguration.h"
#import "GDVTSelectionRange.h"
#import "GDTimeRange.h"
#import "GDVETimelineCoat+ElementEdit.h"

@interface GDVTElementDurationAdjustViewModel()

/// 时间比例
@property (nonatomic, assign, readonly) CGFloat timeRatio;

@end

@implementation GDVTElementDurationAdjustViewModel

// MARK: - Lifecycle

- (instancetype)initWithTimelineCoat:(GDVETimelineCoat *)timelineCoat elementCoat:(GDVEBaseCoat *)elementCoat intervalPerFrame:(long)intervalPerFrame imagePerFrameSize:(CGSize)imagePerFrameSize {
    self = [super init];
    if (self) {
        _timelineCoat = timelineCoat;
        _elementCoat = elementCoat;
        _intervalPerFrame = intervalPerFrame;
        _imagePerFrameSize = imagePerFrameSize;
        _isCurrentSelectionRangeInitialized = NO;
        _timelineViewModel = [[GDVTTimelineViewModel alloc] initWithTimelineCoat:timelineCoat viewConfiguration:[[GDVTTimelineViewConfiguration alloc] init] intervalPerFrame:intervalPerFrame imagePerFrameSize:imagePerFrameSize];
        _durationSelectionViewModel = [[GDVTTimelineDurationSelectionViewModel alloc] initWithCoat:elementCoat timelineViewModel:_timelineViewModel];
    }
    return self;
}

// MARK: - Public

- (GDTimeRange *)timeRangeForSelectionRange:(GDVTSelectionRange *)selectionRange {
    CGFloat ratio = self.timeRatio;
    CGFloat delay = selectionRange.location / ratio;
    CGFloat duration = selectionRange.length / ratio;
    
    GDTimeRange *mainTrackTimeRange = [self mainTrackTimeRange];
    // 控制时间范围不超过主轴范围
    if (delay < mainTrackTimeRange.delay) {
        delay = mainTrackTimeRange.delay;
    }
    if (duration > mainTrackTimeRange.duration) {
        duration = mainTrackTimeRange.duration;
    }
    
    GDTimeRange *timeRange = [[GDTimeRange alloc] init];
    timeRange.delay = delay;
    timeRange.duration = duration;
    
    return timeRange;
}

- (void)clampSelectionRangeLocation:(CGFloat)increment {
    if (increment == 0.0) { return; }
    
    GDVTSelectionRange *oldSelectionRange = self.currentSelectionRange;
    CGFloat endPoint = oldSelectionRange.location + oldSelectionRange.length;
    
    CGFloat locationToUpdate = oldSelectionRange.location + increment;
    CGFloat minLocation = [self minLocation];
    if (locationToUpdate < minLocation) {
        locationToUpdate = minLocation;
    }
    
    CGFloat lengthToUpdate = endPoint - locationToUpdate;
    CGFloat minLength = [self minLength];
    if (lengthToUpdate < minLength) {
        lengthToUpdate = minLength;
        locationToUpdate = endPoint - lengthToUpdate;
    }
    
    GDVTSelectionRange *newSelectionRange = [[GDVTSelectionRange alloc] initWithLocation:locationToUpdate length:lengthToUpdate];
    _currentSelectionRange = newSelectionRange;
    self.selectionRangeChanged(newSelectionRange);
}

- (void)clampSelectionRangeLength:(CGFloat)increment {
    if (increment == 0.0) { return; }
    
    GDVTSelectionRange *oldSelectionRange = self.currentSelectionRange;
    CGFloat lengthToUpdate = oldSelectionRange.length + increment;
    
    CGFloat minLength = [self minLength];
    if (lengthToUpdate < minLength) {
        lengthToUpdate = minLength;
    }
    
    CGFloat maxLength = [self maxLength];
    if (lengthToUpdate > maxLength) {
        lengthToUpdate = maxLength;
    }
    
    CGFloat newEnd = oldSelectionRange.location + lengthToUpdate;
    CGFloat maxEnd = [self maxEndPoint];
    if (newEnd > maxEnd) {
        lengthToUpdate = maxEnd - oldSelectionRange.location;
    }
    
    GDVTSelectionRange *newSelectionRange = [[GDVTSelectionRange alloc] initWithLocation:oldSelectionRange.location length:lengthToUpdate];
    _currentSelectionRange = newSelectionRange;
    self.selectionRangeChanged(newSelectionRange);
}

- (void)updateSelectionRangeLocationWithTranslationX:(CGFloat)translationX {
    if (translationX == 0.0) { return; }
    
    GDVTSelectionRange *oldSelectionRange = self.currentSelectionRange;
    CGFloat locationToUpdate = oldSelectionRange.location + translationX;
    
    CGFloat minLocation = [self minLocation];
    if (locationToUpdate < minLocation) {
        locationToUpdate = minLocation;
    }
    
    CGFloat length = oldSelectionRange.length;
    CGFloat maxLocation = [self maxLocationForLength:length];
    if (locationToUpdate > maxLocation) {
        locationToUpdate = maxLocation;
    }
    
    GDVTSelectionRange *newSelectionRange = [[GDVTSelectionRange alloc] initWithLocation:locationToUpdate length:length];
    _currentSelectionRange = newSelectionRange;
    self.selectionRangeChanged(newSelectionRange);
}

- (void)updateCurrentSelectionRange {
    if (self.isCurrentSelectionRangeInitialized) { return; }
    _currentSelectionRange = [self selectionRangeFromElementCoat];
    _isCurrentSelectionRangeInitialized = YES;
}

// MARK: - Private

- (GDVTSelectionRange *)selectionRangeFromElementCoat {
    long delay = self.elementCoat.timeRange.delay;
    long duration = self.elementCoat.timeRange.duration;
    
    CGFloat ratio = [self timeRatio];
    CGFloat location = delay * ratio;
    CGFloat length = duration * ratio;
    
    CGFloat minLocation = [self minLocation];
    if (location < minLocation) {
        location = minLocation;
    }
    
    CGFloat minLength = [self minLength];
    if (length < minLength) {
        length = minLength;
    }
    
    GDVTSelectionRange *range = [[GDVTSelectionRange alloc] initWithLocation:location length:length];
    
    return range;
}

- (CGFloat)minLocation {
    return 0.0;
}

- (CGFloat)maxLocationForLength:(CGFloat)length {
    CGFloat maxEnd = [self maxEndPoint];
    return maxEnd - length;
}

- (CGFloat)minLength {
    return 30.0;
}

- (CGFloat)maxLength {
    return [self.timelineViewModel contentWidth];
}

- (CGFloat)maxEndPoint {
    CGFloat endPoint = [self.timelineViewModel contentWidth];
    return endPoint;
}

- (GDTimeRange *)mainTrackTimeRange {
    GDTimeRange *timeRange = [[GDTimeRange alloc] init];
    timeRange.delay = 0;
    timeRange.duration = [self maxEndTimeOnMainTrack];
    return timeRange;
}

- (long)maxEndTimeOnMainTrack {
    NSUInteger mainTrackCount = [self.timelineCoat numberOfCoatsByServiceType:GDVECoatServiceTypeMainTrack];
    
    if (mainTrackCount <= 0) {
        return 0;
    }
    
    GDVEBaseCoat *lastMainTrack = [self.timelineCoat mainTrackCoatAtIndex:mainTrackCount - 1];
    long mainTrackEndTime = lastMainTrack.timeRange.endTime;
    return mainTrackEndTime;
}

// MARK: - Custom Accessors

- (CGFloat)timeRatio {
    return self.timelineViewModel.timeOffsetRatio;
}

@end
