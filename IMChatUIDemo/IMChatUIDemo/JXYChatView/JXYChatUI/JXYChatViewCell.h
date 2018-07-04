//
//  JXYChatViewCell.h
//  JXYChatDemo
//
//  Created by longmaster39 on 2017/8/1.
//  Copyright © 2017年 longmaster39. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatBaseViewCell.h"


@interface JXYChatViewCell : ChatBaseViewCell<UIAlertViewDelegate>

- (void)startSendingAnimation;
- (void)stopSendingAnimation;

@end
