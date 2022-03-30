//
//  GDVTSelectionRange.m
//  GDMVideoEdit
//
//  Created by buze on 2021/11/29.
//

#import "GDVTSelectionRange.h"
#import "NSObject+YYModel.h"

@implementation GDVTSelectionRange

// MARK: - Lifecylcle

- (instancetype)initWithLocation:(CGFloat)location length:(CGFloat)length {
    self = [super init];
    if (self) {
        _location = location;
        _length = length;
    }
    return self;
}

// MARK: - NSObject

- (BOOL)isEqual:(id)other {
    return [self modelIsEqual:other];
}

- (NSUInteger)hash {
    return @(_location).hash ^ @(_length).hash;
}

// MARK: - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[GDVTSelectionRange alloc] initWithLocation:self.location length:self.length];
}

@end
