//
//  UIView+IH.m
//  IHKit
//
//  Created by yl on 16/10/24.
//  Copyright © 2016年 39hospital. All rights reserved.
//

#import "UIView+JXY.h"
#import "JXYUICommon.h"
#import <objc/runtime.h>

NSString * const BorderLayer = @"BorderLayer";

@implementation UIView (JXY)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

+ (UIView *)createMaskLayerWithView:(UIView *)view
                withArrowsDirection:(JXYArrowsDirection)direction
                       withPosition:(CGPoint)point
                   withCornerRadius:(CGFloat)cornerRadius
{
    CGFloat viewWidth = CGRectGetWidth(view.frame);
    CGFloat viewHeight = CGRectGetHeight(view.frame);
    
    CGFloat arrowsWidth = 12;
    CGFloat arrowsHeight = 8;
    
    CGPoint point1;
    CGPoint point2;
    CGPoint point3;
    
    CGPoint pointCorner1;
    CGPoint pointCorner2;
    CGPoint pointCorner3;
    CGPoint pointCorner4;
    CGPoint pointCorner5;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    switch (direction) {
        case ArrowsDirectionTop:
        {
            pointCorner1 = CGPointMake(cornerRadius, arrowsHeight);
            pointCorner2 = CGPointMake(viewWidth - cornerRadius, arrowsHeight);
            pointCorner3 = CGPointMake(viewWidth, viewHeight - cornerRadius);
            pointCorner4 = CGPointMake(cornerRadius, viewHeight);
            pointCorner5 = CGPointMake(0, arrowsHeight + cornerRadius);
            
            point1 = CGPointMake(point.x - arrowsWidth / 2, arrowsHeight);
            point2 = CGPointMake(point.x, 0);
            point3 = CGPointMake(point.x + arrowsWidth / 2, arrowsHeight);
            
        }
            break;
            
        case ArrowsDirectionBottom:
        {
            pointCorner1 = CGPointMake(cornerRadius, 0);
            pointCorner2 = CGPointMake(viewWidth - cornerRadius, 0);
            pointCorner3 = CGPointMake(viewWidth, viewHeight - cornerRadius - arrowsHeight);
            pointCorner4 = CGPointMake(cornerRadius, viewHeight - arrowsHeight);
            pointCorner5 = CGPointMake(0, cornerRadius);
            
            point1 = CGPointMake(point.x + arrowsWidth / 2, viewHeight - arrowsHeight);
            point2 = CGPointMake(point.x, viewHeight);
            point3 = CGPointMake(point.x - arrowsWidth / 2, viewHeight - arrowsHeight);
        }
            break;
            
        case ArrowsDirectionLeft:
        {
            pointCorner1 = CGPointMake(cornerRadius + arrowsHeight, 0);
            pointCorner2 = CGPointMake(viewWidth - cornerRadius, 0);
            pointCorner3 = CGPointMake(viewWidth, viewHeight - cornerRadius);
            pointCorner4 = CGPointMake(cornerRadius + arrowsHeight, viewHeight);
            pointCorner5 = CGPointMake(arrowsHeight, cornerRadius);
            
            point1 = CGPointMake(arrowsHeight, point.y + arrowsWidth / 2);
            point2 = CGPointMake(0, point.y);
            point3 = CGPointMake(arrowsHeight, point.y - arrowsWidth / 2);
        }
            break;
            
        case ArrowsDirectionRight:
        {
            pointCorner1 = CGPointMake(cornerRadius, 0);
            pointCorner2 = CGPointMake(viewWidth - cornerRadius - arrowsHeight, 0);
            pointCorner3 = CGPointMake(viewWidth - arrowsHeight, viewHeight - cornerRadius);
            pointCorner4 = CGPointMake(cornerRadius, viewHeight);
            pointCorner5 = CGPointMake(0, cornerRadius);
            
            point1 = CGPointMake(viewWidth - arrowsHeight, point.y - arrowsWidth / 2);
            point2 = CGPointMake(viewWidth, point.y);
            point3 = CGPointMake(viewWidth - arrowsHeight, point.y + arrowsWidth / 2);
        }
            break;
            
        default:
            break;
    }
    [path moveToPoint:pointCorner1];
    if (direction == ArrowsDirectionTop) {
        [path addLineToPoint:point1];
        [path addLineToPoint:point2];
        [path addLineToPoint:point3];
    }
    [path addLineToPoint:pointCorner2];
    [path addArcWithCenter:CGPointMake(pointCorner2.x,  pointCorner2.y + cornerRadius) radius:cornerRadius startAngle:1.5*M_PI endAngle:0 clockwise:YES];
    if (direction == ArrowsDirectionRight) {
        [path addLineToPoint:point1];
        [path addLineToPoint:point2];
        [path addLineToPoint:point3];
    }
    [path addLineToPoint:pointCorner3];
    [path addArcWithCenter:CGPointMake(pointCorner3.x - cornerRadius,  pointCorner3.y) radius:cornerRadius startAngle:0 endAngle:M_PI/2 clockwise:YES];
    if (direction == ArrowsDirectionBottom) {
        [path addLineToPoint:point1];
        [path addLineToPoint:point2];
        [path addLineToPoint:point3];
    }
    [path addLineToPoint:pointCorner4];
    [path addArcWithCenter:CGPointMake(pointCorner4.x,  pointCorner4.y - cornerRadius) radius:cornerRadius startAngle:M_PI/2  endAngle:M_PI clockwise:YES];
    if (direction == ArrowsDirectionLeft) {
        [path addLineToPoint:point1];
        [path addLineToPoint:point2];
        [path addLineToPoint:point3];
    }
    [path addLineToPoint:pointCorner5];
    [path addArcWithCenter:CGPointMake(pointCorner5.x + cornerRadius,  pointCorner5.y) radius:cornerRadius startAngle:M_PI  endAngle:1.5*M_PI clockwise:YES];
    
    [path closePath];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    
    for (CALayer *layer in view.layer.sublayers) {
        if ([objc_getAssociatedObject(layer, (__bridge const void * _Nonnull)(BorderLayer)) isEqualToString:@"BorderLayer"]) {
            [layer removeFromSuperlayer];
            break;
        }
    }
    CAShapeLayer *borderLayer=[CAShapeLayer layer];
    borderLayer.path = path.CGPath;
    borderLayer.fillColor  = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = UIColorFromRGB(0xe1e1e1).CGColor;
    borderLayer.lineWidth = 1;
    borderLayer.frame = view.bounds;
    objc_setAssociatedObject(borderLayer, (__bridge const void * _Nonnull)(BorderLayer), @"BorderLayer", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [view.layer addSublayer:borderLayer];
    
    view.layer.mask = layer;
    
    return view;
}

- (void)hiddenSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(hiddenView)];
}

- (void)removeSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)hiddenView
{
    self.hidden = YES;
}


@end
