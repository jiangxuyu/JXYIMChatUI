//
//  ChatBaseViewCell.m
//  Doctor
//
//  Created by longmaster39 on 2017/8/23.
//  Copyright © 2017年 com.longmaster. All rights reserved.
//

#import "ChatBaseViewCell.h"
#import "JXYUICommon.h"
#import "JXYImageButton.h"


@implementation ChatBaseViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xeeeeee);
        
        _jxyHeaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - JXY_HEADERVIEW_WIDTH, JXY_CELLTOP_EMPTY_HEIGHT, JXY_HEADERVIEW_WIDTH, JXY_HEADERVIEW_WIDTH)];
        _jxyHeaderImageView.layer.cornerRadius = JXY_HEADERVIEW_WIDTH / 2;
        _jxyHeaderImageView.layer.masksToBounds = YES;
        _jxyChatContentView.layer.shadowOpacity = .1;
        _jxyHeaderImageView.backgroundColor = UIColorFromRGB(0x0e0e0e);
        
        [self addSubview:_jxyHeaderImageView];
        
        _jxyRoleNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _jxyRoleNameLabel.font = [UIFont systemFontOfSize:JXY_ROLENAME_FONT];
        [self addSubview:_jxyRoleNameLabel];
        
        _jxyChatContentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_jxyChatContentView];
        
        UIImage *sendFailedIcon = [UIImage imageNamed:@"chat_room_msg_send_failed"];
        _reSendBtn = [[JXYImageButton alloc] initButtonWithFrame:CGRectMake(0, 0, 50, sendFailedIcon.size.height + 5 + 10 + 2) withImage:sendFailedIcon withTitle:@"点击重发" withTitleTextFont:[UIFont systemFontOfSize:10] withTitleColor:UIColorFromRGB(0x666666) withSpaceBetweenImgAndTitle:5 withButtonStyle:ButtonStyleForTopImgBottomTitle];
        [_reSendBtn setImage:sendFailedIcon forState:UIControlStateNormal];
        _reSendBtn.hidden = YES;
        [_reSendBtn addTarget:self action:@selector(reSendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_reSendBtn];
    }
    
    return self;
}

- (void)reSendMessage:(UIButton *)btn
{
    if (self.jxyChatProperty.msgSeqId != 0) {
        self.reSendClick(self.jxyChatProperty);
    }
}

- (void)setJxyChatProperty:(JXYChatProperty *)jxyChatProperty
{
    _jxyChatProperty = jxyChatProperty;
    
    if (_jxyChatProperty.messageType == JXYMessageTypeSelf) {
        _jxyHeaderImageView.frame = CGRectMake(SCREEN_WIDTH - 15 - JXY_HEADERVIEW_WIDTH, JXY_CELLTOP_EMPTY_HEIGHT, JXY_HEADERVIEW_WIDTH, JXY_HEADERVIEW_WIDTH);
        _jxyRoleNameLabel.hidden = YES;
    } else {
        _jxyHeaderImageView.frame = CGRectMake(15, JXY_CELLTOP_EMPTY_HEIGHT, JXY_HEADERVIEW_WIDTH, JXY_HEADERVIEW_WIDTH);
        _jxyRoleNameLabel.frame = CGRectMake(_jxyHeaderImageView.right + 15, _jxyHeaderImageView.top + 5, SCREEN_WIDTH - _jxyHeaderImageView.right - 15, 12);
        _jxyRoleNameLabel.textAlignment = NSTextAlignmentLeft;
        _jxyRoleNameLabel.hidden = NO;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


+ (CGFloat)heightForcell:(JXYChatProperty *)model
{
    switch (model.messageContentType) {
        case JXYMessageContentTypeText:
        {
            CGSize textMessageSize = [model.messageContentText boundingRectWithSize:CGSizeMake(JXY_MESSAGE_CONTENT_WIDTH_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:JXY_MESSAGE_FONT]} context:nil].size;
            if (model.messageType == JXYMessageTypeSelf) {
                return JXY_CELLTOP_EMPTY_HEIGHT + 5 + textMessageSize.height + 30;
            } else if (model.messageType == JXYMessageTypeOther) {
                return JXY_CELLTOP_EMPTY_HEIGHT + 5 + 15 + textMessageSize.height + 30;
            }
        }
            break;
            
        case JXYMessageContentTypeImage:
        {
            if (model.messageType == JXYMessageTypeSelf) {
                return JXY_CELLTOP_EMPTY_HEIGHT + 5 + thumbnailImageSize.height;
            } else if (model.messageType == JXYMessageTypeOther) {
                return JXY_CELLTOP_EMPTY_HEIGHT + 5 + 15 + thumbnailImageSize.height;
            }
        }
            break;
            
        case JXYMessageContentTypeVoice:
        {
            if (model.messageType == JXYMessageTypeSelf) {
                return JXY_CELLTOP_EMPTY_HEIGHT + 5 + JXY_VOICE_CONTENT_HEIGHT;
            } else {
                return JXY_CELLTOP_EMPTY_HEIGHT + 5 + 15 + JXY_VOICE_CONTENT_HEIGHT;
            }
        }
            break;
            
            
        default:
            return 0;
            break;
    }
    return 0;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.jxyChatProperty = nil;
}

@end
