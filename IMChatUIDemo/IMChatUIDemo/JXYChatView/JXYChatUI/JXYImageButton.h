//
//  ImageButton.h
//  ImageButton
//
//  Created by longmaster39 on 16/10/10.
//  Copyright © 2016年 longmaster39. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXYImageButton : UIButton

typedef enum {
    ButtonStyleForTopImgBottomTitle = 0,      //上图下字
    ButtonStyleForTopTitleBottomImg,          //上字下图
    ButtonStyleForLeftImgRightTitle,          //左图右字
    ButtonStyleForRightImgLeftTitle           //左字右图
}ButtonStyle;                          

- (instancetype)initButtonWithFrame:(CGRect)frame
                          withImage:(UIImage *)image
                          withTitle:(NSString *)title
                  withTitleTextFont:(UIFont *)font
                     withTitleColor:(UIColor *)color
        withSpaceBetweenImgAndTitle:(CGFloat)distance
                    withButtonStyle:(ButtonStyle)buttonStyle;


@end
