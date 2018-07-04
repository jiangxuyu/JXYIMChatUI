//
//  JXYChatViewCell.m
//  JXYChatDemo
//
//  Created by longmaster39 on 2017/8/1.
//  Copyright © 2017年 longmaster39. All rights reserved.
//

#import "JXYChatViewCell.h"
#import "ChatButtonView.h"
#import "JXYImageButton.h"
#import "SavaPhotoView.h"
#import "JXYUICommon.h"
#import <Photos/Photos.h>

@implementation JXYChatViewCell
{
    UIView *_appointmentWarnView;
    UILabel *_jxyMessageContentLabel;
    UILabel *_jxyMessageVoiceTimeLabel;
    UIImageView *_jxyMessageContentImageView;
    UITapGestureRecognizer *_cardTapGesture;
    UILongPressGestureRecognizer *_cardLongGesture;
    UIView *_systemMessageView;
    UILabel *_systemMessageLabel;
    UIImageView *_animationImageView;
    ChatButtonView *_chatButtonView;
    UIActivityIndicatorView *_activityIndicator;
    BOOL _isSelectAudioPlay;
    SavaPhotoView *_saveToast;
}

- (void)dealloc
{
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _isSelectAudioPlay = NO;
        
        _jxyMessageContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _jxyMessageContentLabel.hidden = YES;
        _jxyMessageContentLabel.numberOfLines = 0;
        _jxyMessageContentLabel.font = [UIFont systemFontOfSize:JXY_MESSAGE_FONT];
        [_jxyChatContentView addSubview:_jxyMessageContentLabel];
        
        _jxyMessageVoiceTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _jxyMessageVoiceTimeLabel.hidden = YES;
        _jxyMessageVoiceTimeLabel.numberOfLines = 1;
        _jxyMessageVoiceTimeLabel.font = [UIFont systemFontOfSize:JXY_VOICETIME_FONT];
        _jxyMessageVoiceTimeLabel.textColor = UIColorFromRGB(0x999999);
        [self addSubview:_jxyMessageVoiceTimeLabel];
        
        _animationImageView = [UIImageView new];
        _animationImageView.contentMode = UIViewContentModeScaleAspectFill;
        _animationImageView.animationDuration = 1.5;
        _animationImageView.animationRepeatCount = 0;
        [_jxyChatContentView addSubview:_animationImageView];
        
        _jxyMessageContentImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _jxyMessageContentImageView.hidden = YES;
        _jxyMessageContentImageView.userInteractionEnabled = YES;
        [_jxyChatContentView addSubview:_jxyMessageContentImageView];
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, JXY_VOICE_CONTENT_HEIGHT / 2, JXY_VOICE_CONTENT_HEIGHT / 2)];
        _activityIndicator.backgroundColor = [UIColor clearColor];
        _activityIndicator.hidden = YES;
        
        _cardTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageContentViewTouch:)];
        _cardLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(messageContentViewTouch:)];
        
        _saveToast = [SavaPhotoView new];
        
        _chatButtonView = [ChatButtonView new];
        _chatButtonView.chatButtonViewClick = ^(NSInteger index, NSString *title) {
            if ([title isEqualToString:@"保存到本地"]) {
                
            }
        };
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setData];
    [self setUIFrame];
}

- (void)setJxyChatProperty:(JXYChatProperty *)jxyChatProperty
{
    [super setJxyChatProperty:jxyChatProperty];
}

- (void)setData
{
    if (self.jxyChatProperty.messageType == JXYMessageTypeSystem) {
        _systemMessageLabel.text = self.jxyChatProperty.messageContentText;
    } else {
        switch (self.jxyChatProperty.messageContentType) {
            case JXYMessageContentTypeText:
            {
                [_jxyChatContentView addGestureRecognizer:_cardLongGesture];
                [_jxyChatContentView removeGestureRecognizer:_cardTapGesture];
                
                _jxyMessageContentLabel.text = self.jxyChatProperty.messageContentText;
            }
                break;
            case JXYMessageContentTypeImage:
            {
                if (self.jxyChatProperty.messageType == JXYMessageTypeSelf) {
                    NSURL *imageAssetUrl = [NSURL URLWithString:self.jxyChatProperty.messageContentFilePath];
                    PHFetchResult*result = [PHAsset fetchAssetsWithALAssetURLs:@[imageAssetUrl] options:nil];
                    PHAsset *asset = [result firstObject];
                    PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
                    
                    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:phImageRequestOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                        _jxyMessageContentImageView.image = [UIImage imageWithData:imageData];
                        
                    }];

                }
                [_jxyMessageContentImageView addGestureRecognizer:_cardLongGesture];
                [_jxyMessageContentImageView addGestureRecognizer:_cardTapGesture];
            }
                break;
            case JXYMessageContentTypeVoice:
            {
                [_jxyChatContentView addGestureRecognizer:_cardTapGesture];
                [_jxyChatContentView removeGestureRecognizer:_cardLongGesture];
                
                _jxyMessageVoiceTimeLabel.text = [NSString stringWithFormat:@"%d%@" ,(int)self.jxyChatProperty.imAudioLength,@"\""];
                [_jxyMessageVoiceTimeLabel sizeToFit];
                
                NSMutableArray *animationImages = [NSMutableArray new];
                NSString* imageName;
                if (self.jxyChatProperty.messageType == JXYMessageTypeSelf) {
                    _animationImageView.image = [UIImage imageNamed:@"chat_voice_play_right_03"];
                } else if (self.jxyChatProperty.messageType == JXYMessageTypeOther) {
                    _animationImageView.image = [UIImage imageNamed:@"chat_voice_play_left_03"];
                }
                for (int i = 1; i <= 3; i++) {
                    if (self.jxyChatProperty.messageType == JXYMessageTypeSelf) {
                        imageName = [NSString stringWithFormat:@"chat_voice_play_right_0%d",i];
                    } else if (self.jxyChatProperty.messageType == JXYMessageTypeOther) {
                        imageName = [NSString stringWithFormat:@"chat_voice_play_left_0%d",i];
                    }
                    
                    UIImage *image = [UIImage imageNamed:imageName];
                    [animationImages addObject:image];
                }
                _animationImageView.size = _animationImageView.image.size;
                _animationImageView.animationImages = animationImages;
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)setUIFrame
{
    CGSize textMessageSize = [self.jxyChatProperty.messageContentText boundingRectWithSize:CGSizeMake(JXY_MESSAGE_CONTENT_WIDTH_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:JXY_MESSAGE_FONT]} context:nil].size;
    [self hiddenSubviews];
    if (self.jxyChatProperty.messageType == JXYMessageTypeSelf) {
        _jxyRoleNameLabel.hidden = YES;
        _jxyHeaderImageView.hidden = NO;
        _jxyChatContentView.hidden = NO;
        [_jxyChatContentView hiddenSubviews];
        switch (self.jxyChatProperty.messageContentType) {
            case JXYMessageContentTypeText:
            {
                _jxyMessageContentLabel.hidden = NO;
                _jxyChatContentView.frame = CGRectMake(_jxyHeaderImageView.left - 5 - textMessageSize.width - 30, _jxyHeaderImageView.top + 5, textMessageSize.width + 30, textMessageSize.height + 30);
                _jxyMessageContentLabel.frame = CGRectMake(self.jxyChatProperty.messageType == JXYMessageTypeSelf ? 10 : 20, 15, textMessageSize.width, textMessageSize.height);
                _jxyChatContentView.backgroundColor = UIColorFromRGB(0x45aef8);
                _jxyMessageContentLabel.textColor = UIColorFromRGB(0xffffff);
                [self addSubview:_activityIndicator];
                _activityIndicator.left = _jxyChatContentView.left - 5 - _activityIndicator.width;
                _activityIndicator.centerY = _jxyChatContentView.centerY;
            }
                break;
                
            case JXYMessageContentTypeImage:
            {
                _jxyChatContentView.backgroundColor = UIColorFromRGB(0xffffff);
                _jxyMessageContentImageView.hidden = NO;
                _jxyChatContentView.frame = CGRectMake(_jxyHeaderImageView.left - 5 - thumbnailImageSize.width, _jxyHeaderImageView.top + 5, thumbnailImageSize.width, thumbnailImageSize.height);
                _jxyMessageContentImageView.frame = CGRectMake(0, 0, thumbnailImageSize.width, thumbnailImageSize.height);
                [_jxyMessageContentImageView addSubview:_activityIndicator];
                _activityIndicator.centerX = _jxyMessageContentImageView.width / 2;
                _activityIndicator.centerY = _jxyMessageContentImageView.height / 2;
            }
                break;
                
            case JXYMessageContentTypeVoice:
            {
                
            }
                break;
        
            default:
                break;
                
        }
        _jxyChatContentView = [UIView createMaskLayerWithView:_jxyChatContentView withArrowsDirection:ArrowsDirectionRight withPosition:CGPointMake(_jxyChatContentView.width, 15) withCornerRadius:5];
        _jxyChatContentView.layer.shadowColor = UIColorFromRGB(0x858585).CGColor;
        _jxyChatContentView.layer.shadowOpacity = .1;
    } else if (self.jxyChatProperty.messageType == JXYMessageTypeOther) {
        _jxyRoleNameLabel.hidden = NO;
        _jxyHeaderImageView.hidden = NO;
        _jxyChatContentView.hidden = NO;
        [_jxyChatContentView hiddenSubviews];
        switch (self.jxyChatProperty.messageContentType) {
            case JXYMessageContentTypeText:
            {
                _jxyMessageContentLabel.hidden = NO;
                _jxyChatContentView.frame = CGRectMake(_jxyHeaderImageView.right + 5, _jxyRoleNameLabel.bottom + 5, textMessageSize.width + 30, textMessageSize.height + 30);
                _jxyMessageContentLabel.frame = CGRectMake(self.jxyChatProperty.messageType == JXYMessageTypeSelf ? 10 : 20, 15, textMessageSize.width, textMessageSize.height);
                _jxyChatContentView.backgroundColor = UIColorFromRGB(0xffffff);
                _jxyMessageContentLabel.textColor = UIColorFromRGB(0x333333);
            }
                break;
                
            case JXYMessageContentTypeImage:
            {
                _jxyMessageContentImageView.hidden = NO;
                _jxyChatContentView.frame = CGRectMake(_jxyHeaderImageView.right + 5, _jxyRoleNameLabel.bottom + 5, thumbnailImageSize.width, thumbnailImageSize.height);
                _jxyMessageContentImageView.frame = CGRectMake(0, 0, thumbnailImageSize.width, thumbnailImageSize.height);
                _jxyChatContentView.backgroundColor = UIColorFromRGB(0xffffff);
                [_jxyMessageContentImageView addSubview:_activityIndicator];
                _activityIndicator.centerX = _jxyMessageContentImageView.width / 2;
                _activityIndicator.centerY = _jxyMessageContentImageView.height / 2;
            }
                break;
                
            case JXYMessageContentTypeVoice:
            {
                _animationImageView.hidden = NO;
                _jxyMessageVoiceTimeLabel.hidden = NO;
                _jxyChatContentView.frame = CGRectMake(_jxyHeaderImageView.right + 5, _jxyRoleNameLabel.bottom + 5, 85, JXY_VOICE_CONTENT_HEIGHT);
                _jxyChatContentView.backgroundColor = UIColorFromRGB(0xa0e75a);
                _jxyMessageVoiceTimeLabel.frame  = CGRectMake(_jxyChatContentView.right + 5, _jxyChatContentView.top + (_jxyChatContentView.height - _jxyMessageVoiceTimeLabel.height) / 2, _jxyMessageVoiceTimeLabel.width, _jxyMessageVoiceTimeLabel.height);
                _animationImageView.centerX = _jxyChatContentView.width / 2;
                _animationImageView.centerY = _jxyChatContentView.height / 2;
                [self addSubview:_activityIndicator];
                _activityIndicator.left = _jxyChatContentView.right + 5;
                _activityIndicator.centerY = _jxyMessageContentImageView.height / 2;
            }
                break;
            
            default:
                break;
        }
        _jxyChatContentView = [UIView createMaskLayerWithView:_jxyChatContentView withArrowsDirection:ArrowsDirectionLeft withPosition:CGPointMake(0, 15) withCornerRadius:5];
    }
}

- (void)startSendingAnimation
{
    if (self.jxyChatProperty.sendState == MsgStateIsSending) {
        [_activityIndicator startAnimating];
        self.reSendBtn.hidden = YES;
        if (self.jxyChatProperty.messageContentType == JXYMessageContentTypeImage) {
            _activityIndicator.hidden = NO;
        } else if (self.jxyChatProperty.messageContentType == JXYMessageContentTypeVoice) {
            _jxyMessageVoiceTimeLabel.hidden = YES;
            _activityIndicator.hidden = NO;
        }
    }
}

- (void)stopSendingAnimation
{
    if (self.jxyChatProperty.sendState != MsgStateIsSending) {
        [_activityIndicator stopAnimating];
        if (self.jxyChatProperty.messageContentType == JXYMessageContentTypeImage) {
            _activityIndicator.hidden = YES;
        } else if (self.jxyChatProperty.messageContentType == JXYMessageContentTypeVoice) {
            if (self.jxyChatProperty.sendState == MsgStateSendFailForMsg || self.jxyChatProperty.sendState == MsgStateSendFail) {
                _jxyMessageVoiceTimeLabel.hidden = YES;
            } else {
                _jxyMessageVoiceTimeLabel.hidden = NO;
            }
            _activityIndicator.hidden = YES;
        }
    }
}


- (void)messageContentViewTouch:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == _cardTapGesture) {
        switch (self.jxyChatProperty.messageContentType) {
            case JXYMessageContentTypeVoice:
            {
                
                
            }
                break;
        
            case JXYMessageContentTypeImage:
            {
            
            }
                break;
                
            default:
                break;
        }
    } else if (gestureRecognizer == _cardLongGesture) {
        switch (self.jxyChatProperty.messageContentType) {
            case JXYMessageContentTypeImage:
                [_chatButtonView showChatButtonView:_jxyChatContentView InPoint:CGPointMake(_jxyChatContentView.centerX, _jxyChatContentView.top) withButtonTitles:@"保存到本地", nil];
                break;
                
            default:
                break;
        }
    }
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    self.jxyChatProperty = nil;
    _animationImageView.image = nil;
    _jxyMessageContentImageView.image = nil;
    [_animationImageView stopAnimating];
}


@end
