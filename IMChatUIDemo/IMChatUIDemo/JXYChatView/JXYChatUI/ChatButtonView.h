//
//  ChatButtonView.h
//  Doctor
//
//  Created by longmaster39 on 2017/8/16.
//  Copyright © 2017年 com.longmaster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXYChatProperty.h"

@interface ChatButtonView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, copy) void (^chatButtonViewClick)(NSInteger index, NSString *title);

- (void)showChatButtonView:(UIView *)view InPoint:(CGPoint)point withButtonTitles:(NSString *)buttonTitle,...NS_REQUIRES_NIL_TERMINATION;

@end
