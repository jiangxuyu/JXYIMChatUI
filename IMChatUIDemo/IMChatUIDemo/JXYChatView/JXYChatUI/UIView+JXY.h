//
//  UIView+JXY.h
//  IHKit
//
//  Created by yl on 16/10/24.
//  Copyright © 2016年 39hospital. All rights reserved.
//

#import <UIKit/UIKit.h>

//对view进行相关的边框切图处理
#define DRAW_BORDER_WITH_RADIUS(view,width,color,radius) {\
    CLIP_VIEW_WITH_RADIUS(view, radius);\
    DRAW_BORDER(view,width,color);\
}

//对view进行边框设置：width 和 color
#define DRAW_BORDER(view,width,color) {\
    view.layer.borderWidth = width;\
    view.layer.borderColor = color.CGColor;\
}

//对view进行切除圆角：radius 圆角半径
#define CLIP_VIEW_WITH_RADIUS(view, radius){\
    view.layer.cornerRadius = radius;\
    view.layer.masksToBounds = YES;\
}

typedef enum {
    ArrowsDirectionTop = 0,
    ArrowsDirectionBottom,
    ArrowsDirectionLeft,
    ArrowsDirectionRight,
}JXYArrowsDirection;

@interface UIView (JXY)

@property (nonatomic) CGFloat left;        // Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;         // Shortcut for frame.origin.y
@property (nonatomic) CGFloat right;       // Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;      // Shortcut for frame.origin.y + frame.size.height

@property (nonatomic) CGFloat width;       // Shortcut for frame.size.width.
@property (nonatomic) CGFloat height;      // Shortcut for frame.size.height.
@property (nonatomic) CGFloat centerX;     // Shortcut for center.x
@property (nonatomic) CGFloat centerY;     // Shortcut for center.y

@property (nonatomic) CGPoint origin;      // Shortcut for frame.origin.
@property (nonatomic) CGSize  size;        // Shortcut for frame.size.

+ (UIView *)createMaskLayerWithView:(UIView *)view
                withArrowsDirection:(JXYArrowsDirection)direction
                       withPosition:(CGPoint)point
                   withCornerRadius:(CGFloat)cornerRadius;

- (void)hiddenSubviews;

- (void)removeSubviews;

@end
