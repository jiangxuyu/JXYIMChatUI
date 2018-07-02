//
//  ChatInputBox.h
//  JXYChatDemo
//
//  Created by longmaster39 on 2017/7/6.
//  Copyright © 2017年 longmaster39. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "JXYChatBarMoreView.h"
#import "JXYChatProperty.h"

typedef void (^ChatInputBoxClickBlock)(UIButton *_Nullable button, NSInteger index);

@protocol JXYChatInputBoxDelegate <NSObject>

- (void)jxy_changChatInputBoxChangForY:(CGFloat)height withDurtion:(CGFloat)durtion;

- (void)jxy_resultInfoReturn:(JXYChatProperty *_Nullable)property;

@end

@interface JXYChatInputBox : UIView <UITextViewDelegate,UIGestureRecognizerDelegate,JXYChatBarMoreViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

/**
 输入框输入字数限制
 */
@property(nonatomic, assign) int textCountMax;

@property(nonatomic, copy) NSString * _Nullable text;

@property(nullable, nonatomic, weak) id <JXYChatInputBoxDelegate> delegate;


- (void)jxy_createChatInputBox:(CGRect)rect
     andChatInputBoxClickBlock:(ChatInputBoxClickBlock _Nullable )chatInputBoxClick
                       andView:(UIView *_Nullable)view;

- (void)dismiss;

- (void)reloadRoomState;

@end
