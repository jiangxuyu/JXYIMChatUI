//
//  UIImage+JXY.m
//  DoctorPatientViewController
//
//  Created by lm on 16/6/23.
//  Copyright © 2016年 lm. All rights reserved.
//

#import "UIImage+JXY.h"

@implementation UIImage (JXY)

+ (UIImage *)bgImageWithNamed:(NSString *)imgName
{
    UIImage *bgImage = [UIImage imageNamed:imgName];
    bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width * 0.5 topCapHeight:bgImage.size.height * 0.5];
    
    return bgImage;
}

@end
