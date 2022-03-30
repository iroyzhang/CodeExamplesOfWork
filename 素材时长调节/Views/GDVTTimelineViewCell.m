//
//  GDVTTimelineViewCell.m
//  GDMVideoEdit
//
//  Created by buze on 2021/11/25.
//

#import "GDVTTimelineViewCell.h"
#import <Masonry/Masonry.h>

@implementation GDVTTimelineViewCell

// MARK: - Lifecyle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupThumbnailImageView];
    }
    return self;
}

// MARK: - Override

- (void)prepareForReuse {
    [super prepareForReuse];
    [self removeRoundedCorners];
    _thumbnailImageView.image = nil;
}

// MARK: - Public

- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    self.layer.mask = shape;
}

- (void)removeRoundedCorners {
    if (self.layer.mask) {
        self.layer.mask = nil;
    }
}

// MARK: - Private Setup

- (void)setupThumbnailImageView {
    _thumbnailImageView = [[UIImageView alloc] init];
    _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
    _thumbnailImageView.clipsToBounds = YES;
    [self.contentView addSubview:_thumbnailImageView];
    [_thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

@end
