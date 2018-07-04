//
//  JXYChatOtherItemView.m
//  JXYChatDemo
//
//  Created by longmaster39 on 2017/8/9.
//  Copyright © 2017年 longmaster39. All rights reserved.
//

#import "JXYChatOtherItemView.h"
#import "JXYUICommon.h"

@implementation JXYChatOtherItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.textColor = UIColorFromRGB(0x6f7378);
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.text = self.title;
    [self.titleLabel sizeToFit];
    
    self.imageView.image = self.icon;
    [self.imageView sizeToFit];
    
    self.imageView.frame = CGRectMake((self.width - self.imageView.width) / 2, (self.height - self.imageView.height - 7 - self.titleLabel.height) / 2, self.imageView.width, self.imageView.height);
    self.titleLabel.frame = CGRectMake((self.width - self.titleLabel.width) / 2, self.imageView.bottom + 7, self.titleLabel.width, self.titleLabel.height);
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.imageView.image = self.passIcon;
    } else {
        self.imageView.image = self.icon;
    }
}

-(void)prepareForReuse
{
    self.passIcon = nil;
    self.icon = nil;
    self.title = nil;
}

@end
