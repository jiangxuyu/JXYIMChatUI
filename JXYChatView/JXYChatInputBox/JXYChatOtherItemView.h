//
//  JXYChatOtherItemView.h
//  JXYChatDemo
//
//  Created by longmaster39 on 2017/8/9.
//  Copyright © 2017年 longmaster39. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXYChatOtherItemView : UICollectionViewCell

@property (strong, nonatomic)  UIImage *icon;
@property (strong, nonatomic)  UIImage *passIcon;
@property (copy, nonatomic)    NSString *title;
@property (strong, nonatomic)  UIImageView *imageView;
@property (strong, nonatomic)  UILabel   *titleLabel;

@end
