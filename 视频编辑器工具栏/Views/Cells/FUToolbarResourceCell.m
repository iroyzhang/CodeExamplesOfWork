//
//  FUToolbarResourceCell.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/12/1.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUToolbarResourceCell.h"
#import "FUToolbarIconNames.h"
#import "FUToolbarItem.h"
#import "FUTheme.h"
#import "FUFontResourceDownloadView.h"
#import "FUFontResourceItem.h"
#import <Masonry/Masonry.h>

@interface FUToolbarResourceCell()
@property (nonatomic, strong) FUFontResourceDownloadView *downloadView;
@end

@implementation FUToolbarResourceCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDownloadView];
    }
    return self;
}

- (void)setupDownloadView {
    _downloadView = [[FUFontResourceDownloadView alloc] init];
    [self.contentView addSubview:_downloadView];
    [_downloadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)configureWithToolbarItem:(FUToolbarItem *)item {
    _item = item;
    RACSignal *downloadState = RACObserve(_item.resource, so_downloadState);
    @weakify(self);
    self.disposable =  [downloadState subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.state = self.item.resource.state;
    }];
}

- (void)setState:(FUResourceState)state {
    [self updateCellWithState:state];
}

- (void)updateCellWithState:(FUResourceState)state {
    // 对字体标题进行翻译
    self.titleLabel.text = _item.title;
    if (_item.imageName && ![_item.imageName isEqualToString:@""]) {
        self.thumbnailImageView.image = [UIImage imageNamed:_item.imageName];
    } else {
        self.thumbnailImageView.image = nil;
    }
    
    if (state == FUResourceStateAvailable) {
        if (_item.highlighted) {
            self.coverView.hidden = NO;
            self.contentView.backgroundColor = [UIColor colorWithRed:0.42 green:0.49 blue:1.0 alpha:1];
            if (_item.isAdjustable && _item.sliderValue) {
                self.valueLabel.text = [NSString stringWithFormat:fuStr(%ld), (long)_item.sliderValue.integerValue];
            }
        } else {
            self.coverView.hidden = YES;
            self.valueLabel.text = @"";
            self.contentView.backgroundColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.29 alpha:1.00];
        }
    } else {
        self.coverView.hidden = YES;
        self.valueLabel.text = @"";
        self.contentView.backgroundColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.29 alpha:1.00];
    }
    
    self.downloadView.state = state;
    
}

@end
