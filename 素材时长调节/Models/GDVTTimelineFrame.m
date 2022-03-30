//
//  GDVTTimelineFrame.m
//  GDMVideoEdit
//
//  Created by buze on 2021/11/25.
//

#import "GDVTTimelineFrame.h"
#import <YYKit/NSObject+YYModel.h>

@implementation GDVTTimelineFrame

// MARK: - Lifecycle

- (instancetype)initWithIdentifier:(NSString *)identifier
                   assetIdentifier:(NSString *)assetIdentifier
                        frameIndex:(NSUInteger)frameIndex
                        frameWidth:(CGFloat)frameWidth {
    self = [super init];
    if (self) {
        _identifier = [identifier copy];
        _assetIdentifier = [assetIdentifier copy];
        _frameIndex = frameIndex;
        _frameWidth = frameWidth;
    }
    return self;
}

// MARK: - NSObject

- (BOOL)isEqual:(id)other
{
    return [self modelIsEqual:other];
}

- (NSUInteger)hash
{
    return [self modelHash];;
}

// MARK: - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[GDVTTimelineFrame alloc] initWithIdentifier:[_identifier copy] assetIdentifier:[_assetIdentifier copy] frameIndex:_frameIndex frameWidth:_frameWidth];
}


@end
