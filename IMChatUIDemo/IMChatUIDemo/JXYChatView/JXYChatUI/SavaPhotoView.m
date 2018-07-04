//
//  SavaPhotoView.m
//  Doctor
//
//  Created by longmaster39 on 2017/9/13.
//  Copyright © 2017年 com.longmaster. All rights reserved.
//

#import "SavaPhotoView.h"
#import "JXYUICommon.h"

@implementation SavaPhotoView
{
    UIImageView *_imageView;
    UILabel *_titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.hidden = YES;
        self.frame = CGRectMake(0, 0, 200, 150);
        self.backgroundColor = UIColorFromRGA(0x000000, .5);
        self.hidden = YES;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.center = window.center;
        [window addSubview:self];
        
        UIImage *image = [UIImage imageNamed:@"chat_save_photo_success"];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - image.size.width) /2, 30, image.size.width, image.size.height)];
        _imageView.image = image;
        _imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _imageView.bottom + 30, self.width - 20, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = UIColorFromRGB(0xffffff);
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.layer.cornerRadius = 2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)showToastWithTitle:(NSString *)title
{
    _titleLabel.text = title;
    self.hidden = NO;
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:3];
}

- (void)dismiss
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
    self.hidden = YES;
    _titleLabel.text = @"";
}
@end
