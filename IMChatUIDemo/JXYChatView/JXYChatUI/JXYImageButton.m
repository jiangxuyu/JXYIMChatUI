//
//  ImageButton.m
//  ImageButton
//
//  Created by longmaster39 on 16/10/10.
//  Copyright © 2016年 longmaster39. All rights reserved.
//

#import "JXYImageButton.h"

@implementation JXYImageButton
{
    ButtonStyle _buttonStyle;
    UIImage *_btnImage;
    UIColor *_titleTextColor;
    UIFont *_titleFont;
    NSString *_btnTitleString;
    CGFloat _spaceBetweenImgAndTitle;
    CGSize _imgSize;
    CGSize _titleSize;
}

- (instancetype)initButtonWithFrame:(CGRect)frame
                          withImage:(UIImage *)image
                          withTitle:(NSString *)title
                  withTitleTextFont:(UIFont *)font
                     withTitleColor:(UIColor *)color
        withSpaceBetweenImgAndTitle:(CGFloat)distance
                    withButtonStyle:(ButtonStyle)buttonStyle
{
    self = [super initWithFrame:frame];
    if (self) {
        _btnImage = image;
        _btnTitleString = title;
        _titleFont = font;
        _titleTextColor = color;
        _buttonStyle = buttonStyle;
        _spaceBetweenImgAndTitle = distance;
            
        _imgSize = _btnImage.size;
        _titleSize = [_btnTitleString sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_titleFont,NSFontAttributeName, nil]];
        
        [self setAttribute];
    }
    return self;
}

- (void)setAttribute
{
    self.titleLabel.font = _titleFont;
    [self setTitleColor:_titleTextColor forState:UIControlStateNormal];
    [self setImage:_btnImage forState:UIControlStateNormal];
    [self setTitle:_btnTitleString forState:UIControlStateNormal];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect imgRect;
    CGFloat imgX;
    CGFloat imgY;
    CGFloat imgHeight;
    CGFloat imgWidth;
    
    switch (_buttonStyle) {
        case ButtonStyleForTopImgBottomTitle:
        {
            imgX = contentRect.size.width / 2 - _imgSize.width / 2;
            imgY = (contentRect.size.height - _imgSize.height - _titleSize.height - _spaceBetweenImgAndTitle) / 2;
            imgHeight = _imgSize.height;
            imgWidth = _imgSize.width;
        }
            break;
            
        case ButtonStyleForTopTitleBottomImg:
        {
            imgX = contentRect.size.width / 2 - _imgSize.width / 2;
            imgY = (contentRect.size.height - _imgSize.height - _titleSize.height - _spaceBetweenImgAndTitle) / 2 + _titleSize.height + _spaceBetweenImgAndTitle;
            imgHeight = _imgSize.height;
            imgWidth = _imgSize.width;
        }
            break;

        case ButtonStyleForLeftImgRightTitle:
        {
            imgX = (contentRect.size.width - _imgSize.width - _titleSize.width - _spaceBetweenImgAndTitle) / 2;
            imgY = contentRect.size.height / 2 - _imgSize.height / 2;
            imgHeight = _imgSize.height;
            imgWidth = _imgSize.width;
        }
            break;
            
            
        case ButtonStyleForRightImgLeftTitle:
        {
            imgX = (contentRect.size.width - _imgSize.width - _titleSize.width - _spaceBetweenImgAndTitle) / 2 + _titleSize.width + _spaceBetweenImgAndTitle;
            imgY = contentRect.size.height / 2 - _imgSize.height / 2;
            imgHeight = _imgSize.height;
            imgWidth = _imgSize.width;

        }
            break;
            
        default:
            break;
    }
    imgRect = CGRectMake(imgX, imgY, imgWidth, imgHeight);
    return imgRect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect titleRect;
    CGFloat titleX;
    CGFloat titleY;
    CGFloat titleHeight;
    CGFloat titleWidth;
    switch (_buttonStyle) {
        case ButtonStyleForTopImgBottomTitle:
        {
            titleX = contentRect.size.width / 2 - _titleSize.width / 2;
            titleY = (contentRect.size.height - _imgSize.height - _titleSize.height - _spaceBetweenImgAndTitle) / 2 + _imgSize.height + _spaceBetweenImgAndTitle;
            titleHeight = _titleSize.height;
            titleWidth = _titleSize.width;
        }
            break;
            
        case ButtonStyleForTopTitleBottomImg:
        {
            titleX = contentRect.size.width / 2 - _titleSize.width / 2;
            titleY = (contentRect.size.height - _imgSize.height - _titleSize.height - _spaceBetweenImgAndTitle) / 2;
            titleHeight = _titleSize.height;
            titleWidth = _titleSize.width;

        }
            break;
            
            
        case ButtonStyleForLeftImgRightTitle:
        {
            titleX = (contentRect.size.width - _imgSize.width - _titleSize.width - _spaceBetweenImgAndTitle) / 2 + _imgSize.width + _spaceBetweenImgAndTitle;
            titleY = contentRect.size.height / 2 - _titleSize.height / 2;
            titleHeight = _titleSize.height;
            titleWidth = _titleSize.width;

        }
            break;
            
            
        case ButtonStyleForRightImgLeftTitle:
        {
            titleX = (contentRect.size.width - _imgSize.width - _titleSize.width - _spaceBetweenImgAndTitle) / 2;
            titleY = contentRect.size.height / 2 - _titleSize.height / 2;
            titleHeight = _titleSize.height;
            titleWidth = _titleSize.width;

        }
            break;
            
        default:
            break;
    }

    titleRect = CGRectMake(titleX, titleY, titleWidth, titleHeight);
    return titleRect;
}



@end
