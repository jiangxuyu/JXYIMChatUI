//
//  ChatBaseViewCell.h
//  Doctor
//
//  Created by longmaster39 on 2017/8/23.
//  Copyright © 2017年 com.longmaster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXYChatProperty.h"

#define JXY_HEADERVIEW_WIDTH           41
#define JXY_CELLTOP_EMPTY_HEIGHT       20
#define JXY_VOICE_CONTENT_HEIGHT       45
#define JXY_MESSAGE_FONT               14
#define JXY_ROLENAME_FONT              10
#define JXY_VOICETIME_FONT             14
#define JXY_SYSTEM_MESSAGE_FONT        12
#define JXY_MESSAGE_CONTENT_WIDTH_MAX  [UIScreen mainScreen].bounds.size.width - 15 - 41 - 5 - 64

@interface ChatBaseViewCell : UITableViewCell
{
    UIView *_jxyChatContentView;
    UILabel *_jxyRoleNameLabel;
    UIImageView *_jxyHeaderImageView;
}

@property (nonatomic, strong) JXYChatProperty *jxyChatProperty;
@property (nonatomic, strong) UIButton *reSendBtn;
@property (nonatomic, copy) void (^reSendClick)(JXYChatProperty *property);

+ (CGFloat)heightForcell:(JXYChatProperty *)model;

@end
