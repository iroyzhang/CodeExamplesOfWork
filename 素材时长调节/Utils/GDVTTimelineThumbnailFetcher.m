//
//  GDVTTimelineThumbnailFetcher.m
//  GDMVideoEdit
//
//  Created by buze on 2021/11/25.
//

#import "GDVTTimelineThumbnailFetcher.h"
#import <SDWebImage/SDImageCache.h>
#import <GDFoundation/GDDefine.h>
#import "GDVECoatSpeedCapability.h"
#import "GDVECoatTimeCapability.h"
#import "GDVEBaseCoat.h"
#import "GDVEPlaceholderCoat.h"
#import "GDVTTimelineFrame.h"
#import "GDVTTimelineFrameGenerator.h"
#import "GDVEResource.h"
#import "GDVEAssetUtils.h"
#import "GDVEPathUtils.h"

@interface GDVTTimelineThumbnailFetcher()

/// 图片缓存
@property (nonatomic, strong) SDImageCache *imageCache;

@end

@implementation GDVTTimelineThumbnailFetcher

// MARK: - Lifecycle

- (instancetype)initWithIntervalPerFrame:(long)intervalPerFrame {
    self = [super init];
    if (self) {
        _intervalPerFrame = intervalPerFrame;
        _imageCache = [[SDImageCache alloc] initWithNamespace:@"GDVTTimelineThumbnailFetcher"];
    }
    return self;
}

// MARK: - Public

- (void)fetchThumbnailForCoat:(GDVEBaseCoat *)coat
                   frameIndex:(NSUInteger)frameIndex
                         size:(CGSize)size
                   completion:(void (^)(GDVTTimelineFrame * _Nonnull, UIImage * _Nonnull))completion {
    
    GDVTTimelineFrame *timelineFrame = [GDVTTimelineFrameGenerator generateFramesForCoat:coat frameIndex:frameIndex frameWidth:size.width];
    NSString *key = [self keyForTimelineFrame:timelineFrame size:size];
    UIImage *cachedImage = [self.imageCache imageFromCacheForKey:key];
    if (cachedImage) {
        GDBlockCallInMain(completion, timelineFrame, cachedImage);
        return;
    }
    
    if (coat.type == GDVECoatTypePlaceholder) {
        UIImage *image = [GDVEResource imageNamed:@"video_edit_placeholder"];
        GDBlockCallInMain(completion, timelineFrame, image);
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        long delay = frameIndex * self.intervalPerFrame;
        long thumbnailTime = [self thumbnailTimeWithDelay:delay forCoat:coat];
        UIImage *image = [GDVEAssetUtils fetchThumbnailForMediaCoat:coat time:thumbnailTime size:size placeholderImage:nil];
        [self.imageCache storeImageToMemory:image forKey:key];
        GDBlockCallInMain(completion, timelineFrame, image);
    });
}

// MARK: - Private

- (long)thumbnailTimeWithDelay:(long)delay forCoat:(GDVEBaseCoat *)coat {
    CGFloat speed = 1.0;
    if ([coat conformsToProtocol:@protocol(GDVECoatSpeedCapability)]) {
        speed = [(id<GDVECoatSpeedCapability>)coat speed];
        
        if (speed <= 0.0) {
            speed = 1.0;
        }
    }
    
    long thumbnailTime = (delay - coat.timeRange.delay) / speed;
    
    if ([coat conformsToProtocol:@protocol(GDVECoatTimeCapability)]) {
        long  startTime = [(id<GDVECoatTimeCapability>)coat startTime];
        long endTime = [(id<GDVECoatTimeCapability>)coat endTime];
        
        thumbnailTime = thumbnailTime + startTime;
        
        if (thumbnailTime < startTime) {
            thumbnailTime = startTime;
        }
        
        if (thumbnailTime > endTime) {
            thumbnailTime = endTime;
        }
    }
    
    if (thumbnailTime < 0) {
        thumbnailTime = 0;
    }
    
    return thumbnailTime;
}

- (NSString *)keyForTimelineFrame:(GDVTTimelineFrame *)timelineFrame size:(CGSize)size {
    return [NSString stringWithFormat:@"gdvt_timeline_thumbnail_%@_%lu_%@", timelineFrame.assetIdentifier, timelineFrame.frameIndex, NSStringFromCGSize(size)];
}

@end
