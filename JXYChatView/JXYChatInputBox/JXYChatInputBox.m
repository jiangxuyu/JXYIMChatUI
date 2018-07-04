//
//  ChatInputBox.m
//  JXYChatDemo
//
//  Created by longmaster39 on 2017/7/6.
//  Copyright © 2017年 longmaster39. All rights reserved.
//

#import "JXYChatInputBox.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "JXYUICommon.h"


#define DEFAUT_BTN_TAG 1001300
#define CALL_HELF_DOC_TAG 1001400

#define JxyMainScreenRect       _superView.frame
#define JxyTextViewSize         CGSizeMake(self.width - 2 * ([UIImage imageNamed:@"chat_inputview_vioce"].size.width + 10), 34)
#define JxyToolMoreBarHeight    200
#define GestureRecognizerTag    10001000


@implementation JXYChatInputBox
{
    UIView *_toolBar;
    UIView *_textBgView;
    UILabel *_vocieView;
    UIImageView *_recordingAnimationView;
    UIImageView *_recordingView;
    UIImageView *_textBgImgView;
    UITextView *_textView;
    UIButton *_toolButton;
    UIButton *_voiceButton;
    ChatInputBoxClickBlock _chatInputBoxClick;
    UITapGestureRecognizer *_singleTapGR;
    CGRect _rect;
    CGRect _rectSelfBeforeVoice;
    CGRect _rectTextBgBeforeVoice;
    CGRect _keyboardF;
    CGSize _containSize;
    CGFloat _height;
    UIView *_superView;
    NSNotificationCenter *_notification;
    JXYChatBarMoreView *_chatMoreView;
    JXYChatProperty *_newAudioProperty;
    NSArray *_toolTitleStrArr;
    UILongPressGestureRecognizer *_longPressGesture;
    UILabel *_recordingTitleLabel;
    
    double _duration;
    BOOL _isShowToolBar;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:_notification];
    _notification = nil;
    [self removeObserver:self forKeyPath:@"self.frame"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.text = nil;
        self.textCountMax = 200;
        _keyboardF = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 0, 0);
        _duration = 0.25f;
        self.layer.borderColor = UIColorFromRGB(0xe1e1e1).CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.shadowColor = UIColorFromRGB(0x858585).CGColor;
        self.layer.shadowOpacity = .1;
    }
    return self;
}

#pragma mark - ***************** UI ****************
- (void)setTextCountMax:(int)textCountMax
{
    if (textCountMax) {
        _textCountMax = textCountMax;
    }
}

- (void)jxy_createChatInputBox:(CGRect)rect
     andChatInputBoxClickBlock:(ChatInputBoxClickBlock _Nullable )chatInputBoxClick
                       andView:(UIView *_Nullable)view
{
    _superView = view;
    _chatInputBoxClick = chatInputBoxClick;
    [self createChatBox:rect];
    [self createMoreToolBar];
    [self setUpForDismissKeyboard];
}

- (void)createChatBox:(CGRect)rect
{
    UIImage *leftVoiceBtnImg = [UIImage imageNamed:@"chat_inputview_vioce"];
    UIImage *leftTextBtnImg = [UIImage imageNamed:@"chat_inputview_text"];
    NSArray *rightButtonImgs = @[[UIImage imageNamed:@"chat_inputview_more_icon"]];
    NSArray *rightButtonImgClicks = @[[UIImage imageNamed:@"chat_inputview_more_icon_pass"]];;
    
    _rect = CGRectMake(0, JxyMainScreenRect.size.height - 50, JxyMainScreenRect.size.width, 50);
    self.frame = _rect;
    
    _height = _rect.size.height;
    CGFloat leftButtonWidth = [UIImage imageNamed:@"chat_inputview_vioce"].size.width + 10;
    CGFloat rightButtonWidth = (_rect.size.width - leftButtonWidth - JxyTextViewSize.width) / rightButtonImgs.count;
    
    UIButton *leftBtn = [JXYUICommon jxy_createButton:CGRectMake(0, 0, leftButtonWidth, _height) setNormalTitle:nil setNormalImage:leftVoiceBtnImg setClickTitle:nil setClickImage:nil setNormalBackgroundImage:nil setClickBackgroundImage:nil setButtonStyle:JXYButtonStyleForDefaut];
    [leftBtn setImage:leftTextBtnImg forState:UIControlStateSelected];
    leftBtn.tag = DEFAUT_BTN_TAG;
    leftBtn.selected = NO;
    [leftBtn addTarget:self action:@selector(onChatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
    _voiceButton = leftBtn;
    
    NSDictionary *textViewDic = [JXYUICommon jxy_createTextView:CGRectMake(leftButtonWidth, (_height - JxyTextViewSize.height) / 2, JxyTextViewSize.width, JxyTextViewSize.height) setBackgroundImage:[UIImage imageNamed:@"chat_inputview_text_view_bg"] setPlaceholder:nil setFont:[UIFont systemFontOfSize:15] setDelegate:self];
    _textView = [textViewDic objectForKey:JXYTextViewOrFieldReturnKey];
    _textBgImgView = [textViewDic objectForKey:JXYTextViewOrFieldReturnBgImageViewKey];
    _textBgView = [textViewDic objectForKey:JXYTextViewOrFieldReturnBgViewKey];
    [self addSubview:_textBgView];
    
    _vocieView = [JXYUICommon jxy_createLabel:CGRectMake(0, 0, _textBgView.frame.size.width, _textBgView.frame.size.height) setText:@"按住说话" setTextColor:UIColorFromRGB(0x666666) setTextAlignment:NSTextAlignmentCenter setFont:[UIFont systemFontOfSize:15] setLabelStyle:JXYLabelStyleDefaut];
    _vocieView.hidden = YES;
    _vocieView.userInteractionEnabled = YES;
    [_textBgView addSubview:_vocieView];
    
    _recordingAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    _recordingAnimationView.backgroundColor = UIColorFromRGA(0x000000, .5);
    _recordingAnimationView.center = _superView.center;
    _recordingAnimationView.hidden = YES;
    _recordingAnimationView.layer.masksToBounds = YES;
    _recordingAnimationView.layer.cornerRadius = 5;
    [_superView addSubview:_recordingAnimationView];
    
    _recordingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150 - 32)];
    _recordingView.image = [UIImage imageNamed:@"chat_voice_input_1"];
    _recordingView.contentMode = UIViewContentModeCenter;
    [_recordingAnimationView addSubview:_recordingView];

    _recordingTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _recordingView.bottom, 130, 20)];
    _recordingTitleLabel.text = @"手指上滑，取消发送";
    _recordingTitleLabel.font = [UIFont systemFontOfSize:14];
    _recordingTitleLabel.textColor = UIColorFromRGB(0xffffff);
    _recordingTitleLabel.layer.masksToBounds = YES;
    _recordingTitleLabel.layer.cornerRadius = 2;
    [_recordingAnimationView addSubview:_recordingTitleLabel];
    
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onGetVoice:)];
    [_vocieView addGestureRecognizer:_longPressGesture];
    
    for (int i = 0; i < rightButtonImgs.count; i++) {
        UIButton *rightBtn = [JXYUICommon jxy_createButton:CGRectMake(_textBgView.frame.origin.x + _textBgView.frame.size.width + i * rightButtonWidth, 0, rightButtonWidth, _height) setNormalTitle:nil setNormalImage:rightButtonImgs[i] setClickTitle:nil setClickImage:rightButtonImgClicks[i] setNormalBackgroundImage:nil setClickBackgroundImage:nil setButtonStyle:JXYButtonStyleForDefaut];
        rightBtn.tag = DEFAUT_BTN_TAG + i + 1;
        rightBtn.selected = NO;
        [rightBtn addTarget:self action:@selector(onChatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
        if (i == 1) {
            _toolButton = rightBtn;
        }
    }
    
    [_superView addSubview:self];
    [_superView bringSubviewToFront:self];
}

- (void)createMoreToolBar
{
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + self.frame.size.height, JxyMainScreenRect.size.width, JxyToolMoreBarHeight)];
    [_superView addSubview:_toolBar];
    
    [self addObserver:self forKeyPath:@"self.frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];

    [self setData];
}

- (void)setData
{
    if (_chatMoreView) {
        [_chatMoreView removeFromSuperview];
    }
    _chatMoreView = [[JXYChatBarMoreView alloc] initWithFrame:CGRectMake(0, 0, _toolBar.frame.size.width, _toolBar.frame.size.height)];
    _chatMoreView.delegate = self;
    [_toolBar addSubview:_chatMoreView];
    
    NSArray *toolIconStrArr;
    NSArray *toolIconPassStrArr;
    
    _toolTitleStrArr = @[@"图片",@"拍摄"];
    toolIconStrArr = @[@"chat_toolbar_photo_icon",@"chat_toolbar_camera_icon"];
    toolIconPassStrArr = @[@"chat_toolbar_photo_icon_pass",@"chat_toolbar_camera_icon_pass"];
    
    NSMutableDictionary *toolDic = [NSMutableDictionary new];
    for (int i = 0; i < toolIconStrArr.count; i++) {
        NSMutableDictionary *imgDic = [[NSMutableDictionary alloc] initWithObjects:@[toolIconPassStrArr[i]] forKeys:@[toolIconStrArr[i]]];
        NSMutableDictionary *titleImageDic = [[NSMutableDictionary alloc] initWithObjects:@[imgDic] forKeys:@[_toolTitleStrArr[i]]];
        [toolDic setObject:titleImageDic forKey:@(i)];
    }
    _chatMoreView.toolDic = toolDic;
}

- (void)reloadRoomState
{
    [self setData];
}

#pragma mark - *************** protorl **************
#pragma mark - JXYChatBarMoreViewDelegate
- (void)jxy_selectItemAtItemName:(NSString *)itemName
{
    if ([itemName isEqualToString:@"图片"]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:nil];
            }];
        } else {
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:nil];
        }
    } else if ([itemName isEqualToString:@"拍摄"]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:nil];;
            }];
        } else {
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker  animated:YES completion:nil];;
        }
    }
}

#pragma mark - IHAudioRecorderDelegate
- (void)ih_audioRecorderPowerChange:(int)power
{
    CGPoint touchPoint = [_longPressGesture locationInView:_vocieView];
    if (!_recordingAnimationView.hidden && touchPoint.y > 0) {
        switch (power) {
            case 1:
                _recordingView.image = [UIImage imageNamed:@"chat_voice_input_1"];
                break;
            case 2:
                _recordingView.image = [UIImage imageNamed:@"chat_voice_input_2"];
                break;
            case 3:
                _recordingView.image = [UIImage imageNamed:@"chat_voice_input_3"];
                break;
            case 4:
                _recordingView.image = [UIImage imageNamed:@"chat_voice_input_4"];
                break;
            case 5:
                _recordingView.image = [UIImage imageNamed:@"chat_voice_input_5"];
                break;
            case 6:
                _recordingView.image = [UIImage imageNamed:@"chat_voice_input_6"];
                break;
            case 7:
                _recordingView.image = [UIImage imageNamed:@"chat_voice_input_7"];
                break;
            case 8:
                _recordingView.image = [UIImage imageNamed:@"chat_voice_input_8"];
                break;
                
            default:
                break;
        }
        
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage]) {
        picker.delegate = nil;
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        JXYChatProperty *newImageProperty = [JXYChatProperty new];
        newImageProperty.messageType = JXYMessageTypeSelf;
        newImageProperty.messageContentType = JXYMessageContentTypeImage;
        newImageProperty.messageContentFilePath = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
        [newImageProperty createNewFileName];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(jxy_resultInfoReturn:)]) {
            [self.delegate jxy_resultInfoReturn:newImageProperty];
        }
    }
}

#pragma mark - TextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if (textView.text && (![textView.text isEqualToString:@""] || ![textView.text isEqualToString:@"\n"])) {
            JXYChatProperty *newTextMessage = [JXYChatProperty new];
            newTextMessage.messageContentText = textView.text;
            newTextMessage.messageType = JXYMessageTypeSelf;
            newTextMessage.messageContentType = JXYMessageContentTypeText;
            if (self.delegate && [self.delegate respondsToSelector:@selector(jxy_resultInfoReturn:)]) {
                [self.delegate jxy_resultInfoReturn:newTextMessage];
            }
            textView.text = @"";
            [self textViewDidChange:textView];
            return NO;
        }
    }
    if (range.location >= _textCountMax) {
        return NO;
    } else {
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    [textView flashScrollIndicators];
    self.text = textView.text;
    static CGFloat textViewHeightMax = 100;
    CGRect textFrame = textView.frame;
    CGSize constraintSize = CGSizeMake(textFrame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height >= textViewHeightMax) {
        size.height = textViewHeightMax;
        textView.scrollEnabled = YES;
    } else {
        textView.scrollEnabled = NO;
    }
    
    if (size.height > _containSize.height && _containSize.height > 0) {
        CGFloat changeHeight = size.height - _containSize.height;
        _rect = CGRectMake(_rect.origin.x, self.frame.origin.y - changeHeight, _rect.size.width, _rect.size.height + changeHeight);
        self.frame = _rect;
        [_notification postNotificationName:@"buttonChangeFrame" object:self];
    } else if (size.height < _containSize.height) {
        CGFloat changeHeight = _containSize.height - size.height;
        _rect = CGRectMake(_rect.origin.x, self.frame.origin.y + changeHeight, _rect.size.width, _rect.size.height - changeHeight);
        self.frame = _rect;
        [_notification postNotificationName:@"buttonChangeFrame" object:self];
    }
    CGRect toolBarnewframe = _toolBar.frame;
    toolBarnewframe.origin.y = self.frame.origin.y + self.frame.size.height;
    _toolBar.frame = toolBarnewframe;
    textView.frame = CGRectMake(textFrame.origin.x, textFrame.origin.y, textFrame.size.width, size.height);
    _textBgView.height = size.height;
    _textBgImgView.height = size.height;
    _containSize = size;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"self.frame"]) {
        CGRect oldframe = CGRectFromString([NSString stringWithFormat:@"%@",[change objectForKey:NSKeyValueChangeOldKey]]);
        CGRect newframe = CGRectFromString([NSString stringWithFormat:@"%@",[change objectForKey:NSKeyValueChangeNewKey]]);
        CGRect toolBarnewframe = _toolBar.frame;
        toolBarnewframe.origin.y = self.frame.origin.y + self.frame.size.height;
        _toolBar.frame = toolBarnewframe;
        if (self.delegate && [self.delegate respondsToSelector:@selector(jxy_changChatInputBoxChangForY:withDurtion:)]) {
            CGFloat changeHeight = newframe.origin.y - oldframe.origin.y;
            [self.delegate jxy_changChatInputBoxChangForY:changeHeight withDurtion:_duration];
        }
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_toolBar]) {
        return NO;
    }
    return YES;
}

#pragma mark - **************** action **************
- (void)onChatBtnClick:(UIButton *)button
{
    button.selected = !button.selected;
    _chatInputBoxClick(button,button.tag - DEFAUT_BTN_TAG);
    if (button.tag == DEFAUT_BTN_TAG) {
        if (button.selected) {
            _rectSelfBeforeVoice = self.frame;
            _rectTextBgBeforeVoice = _textBgView.frame;
            CGFloat changeHeight = self.frame.size.height - _height;
            CGRect selfRect = self.frame;
            selfRect.size.height = _height;
            selfRect.origin.y = self.frame.origin.y + changeHeight;
            self.frame = selfRect;
            CGRect textBgRect = _textBgView.frame;
            textBgRect.size.height = JxyTextViewSize.height;
            _textBgView.frame = textBgRect;
            _textView.hidden = YES;
            _vocieView.hidden = NO;
            if (_isShowToolBar) {
                [self tapAnywhereToDismissKeyboard:nil];
            } else {
                [self.superview endEditing:YES];
            }
        } else {
            _textView.hidden = NO;
            _vocieView.hidden = YES;
            self.frame = CGRectMake(0, JxyMainScreenRect.size.height - _rectSelfBeforeVoice.size.height, _rectSelfBeforeVoice.size.width, _rectSelfBeforeVoice.size.height);
            _textBgView.frame = _rectTextBgBeforeVoice;
            [_textView becomeFirstResponder];
        }
        [_notification postNotificationName:@"buttonChangeFrame" object:self];
    } if (button.tag == DEFAUT_BTN_TAG + 1) {
        _voiceButton.selected = NO;
        if (!_isShowToolBar) {
            button.selected = YES;
        }
        if (button.selected) {
            if (_textView.hidden == YES) {
                _textView.hidden = NO;
                _vocieView.hidden = YES;
                self.frame = CGRectMake(0, JxyMainScreenRect.size.height - _rectSelfBeforeVoice.size.height, _rectSelfBeforeVoice.size.width, _rectSelfBeforeVoice.size.height);
                _textBgView.frame = _rectTextBgBeforeVoice;
            }
            _isShowToolBar = YES;
            CGRect selfRect = self.frame;
            selfRect.origin.y = JxyMainScreenRect.size.height - self.frame.size.height - JxyToolMoreBarHeight;
            __weak typeof (self)weak_self = self;
            [_textView resignFirstResponder];
            [UIView animateWithDuration:_duration animations:^{
                weak_self.frame = selfRect;
            } completion:^(BOOL finished) {
                [weak_self.superview addGestureRecognizer:_singleTapGR];
            }];
        } else {
            _isShowToolBar = NO;
            [_textView becomeFirstResponder];
        }
    }
    
}

- (void)onGetVoice:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == _longPressGesture) {
        CGPoint touchPoint = [gestureRecognizer locationInView:_vocieView];
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            _textBgImgView.image = [UIImage bgImageWithNamed:@"chat_inputview_text_view_bg_pass"];
            [[AVAudioSession sharedInstance]requestRecordPermission:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!granted) {
                        NSLog(@"无法访问麦克风、请检查");
                        return;
                    }
                });
            }];
            
            if (_newAudioProperty) {
                _newAudioProperty = nil;
            }
            _newAudioProperty = [JXYChatProperty new];
            _newAudioProperty.messageType = JXYMessageTypeSelf;
            _newAudioProperty.messageContentType = JXYMessageContentTypeVoice;
            [_newAudioProperty createNewFileName];
            
            _recordingAnimationView.hidden = NO;
        } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
            _recordingAnimationView.hidden = YES;
            if (touchPoint.y >= 0) {
                
            } else {
                _newAudioProperty = nil;
            }
            _recordingTitleLabel.text = @"手指上滑，取消发送";
            _recordingTitleLabel.backgroundColor = [UIColor clearColor];
            _textBgImgView.image = [UIImage bgImageWithNamed:@"chat_inputview_text_view_bg"];
        } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged){
            if (touchPoint.y < 0) {
                _recordingView.image = [UIImage imageNamed:@"chat_voice_input_cancel"];
                _recordingTitleLabel.text = @"松开手指，取消发送";
                _recordingTitleLabel.backgroundColor = UIColorFromRGB(0x9C3939);
            } else {
                _recordingView.image = [UIImage imageNamed:@"chat_voice_input_1"];
                _recordingTitleLabel.text = @"手指上滑，取消发送";
                _recordingTitleLabel.backgroundColor = [UIColor clearColor];
            }
        }
    }
}

- (void)dismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        _rect.origin.y = JxyMainScreenRect.size.height;
        self.frame = _rect;
    } completion:^(BOOL finished) {
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        [self removeFromSuperview];
    }];
}


#pragma mark - *************** other **************
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _isShowToolBar = NO;
}

- (void)keyboardFrameChange:(NSNotification *)notification
{
    if (notification.name == UIKeyboardWillShowNotification) {
        _isShowToolBar = NO;
        _toolButton.selected = NO;
    }
    NSDictionary *useInfo = notification.userInfo;
    // 动画的持续时间
    _duration = [useInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    _keyboardF = [useInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat changeHeightY = _superView.height - ([UIScreen mainScreen].bounds.size.height - _keyboardF.origin.y);
    
    if (_isShowToolBar) {
        return;
    }
    [UIView animateWithDuration:_duration animations:^{
        self.top = changeHeightY - self.height;
    }];
}

//隐藏键盘
- (void)setUpForDismissKeyboard {
    _notification = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tapAnywhereToDismissKeyboard:)];
    _singleTapGR = singleTapGR;
    _singleTapGR.delegate = self;
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    __weak __typeof(self)weak_self = self;
    __block float height = _height;
    [_notification addObserverForName:UIKeyboardWillShowNotification
                               object:nil
                                queue:mainQuene
                           usingBlock:^(NSNotification *note){
                               [weak_self.superview addGestureRecognizer:singleTapGR];
                               [weak_self keyboardFrameChange:note];
                           }];
    [_notification addObserverForName:UIKeyboardWillHideNotification
                               object:nil
                                queue:mainQuene
                           usingBlock:^(NSNotification *note){
                               [weak_self.superview removeGestureRecognizer:singleTapGR];
                               [weak_self keyboardFrameChange:note];
                           }];
    
    [_notification addObserverForName:@"buttonChangeFrame"
                               object:nil
                                queue:mainQuene
                           usingBlock:^(NSNotification * _Nonnull note) {
                               for (UIView *view in weak_self.subviews) {
                                   if ([view isKindOfClass:[UIButton class]]) {
                                       CGRect viewFrame = view.frame;
                                       viewFrame.origin.y = weak_self.frame.size.height - height;
                                       view.frame = viewFrame;
                                   }
                               }
                           }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    if (_isShowToolBar) {
        _toolButton.selected = NO;
        CGFloat changeHeightY = _superView.height - ([UIScreen mainScreen].bounds.size.height - _keyboardF.origin.y);
        [UIView animateWithDuration:_duration animations:^{
            self.top = changeHeightY - self.height;
            [self.superview removeGestureRecognizer:_singleTapGR];
        }];
        _isShowToolBar = NO;
    } else {
        _toolButton.selected = NO;
        [self.superview endEditing:YES];
    }
}

@end
