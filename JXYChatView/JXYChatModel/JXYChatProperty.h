//
//  JXYChatProperty.h
//  JXYChatDemo
//
//  Created by longmaster39 on 2017/8/1.
//  Copyright © 2017年 longmaster39. All rights reserved.
//

#import <Foundation/Foundation.h>
#define thumbnailImageSize CGSizeMake(88, 113)

typedef enum {
    JXYMessageTypeSelf = 0,
    JXYMessageTypeOther,
    JXYMessageTypeSystem,
}JXYMessageType;

typedef enum {
    JXYMessageContentTypeImage = 200,
    JXYMessageContentTypeText,
    JXYMessageContentTypeVoice,
}JXYMessageContentType;

typedef enum {
    MsgStateNotRead  = 0,     //未读
    MsgStateHasRead  = 1,     //已读
    MsgStateIsSending = 2,    //发送中
    MsgStateSendSuccess = 3,  //发送成功
    MsgStateSendFail    = 4,  //文件发送失败
    MsgStateSendFailForMsg = 5,  //文件发送成功，消息失败
} SmsMsgState;

@interface JXYChatProperty : NSObject

@property(nonatomic, assign) int sendId;
@property(nonatomic, assign) long long msgId;
@property(nonatomic, assign) long long msgSeqId;
@property(nonatomic, assign) int sendRole;
@property(nonatomic, assign) int selfRole;
@property(nonatomic, assign) JXYMessageType messageType;
@property(nonatomic, assign) JXYMessageContentType messageContentType;
@property(nonatomic, strong) NSString *messageContentText;
@property(nonatomic, strong) NSString *messageContentFileName;
@property(nonatomic, strong) NSString *messageContentFilePath;
@property(nonatomic, strong) NSString* imCureDt;
@property(nonatomic, strong) NSString* imRefuseReason;
@property(nonatomic, strong) NSString* localTime;
@property(nonatomic, assign) float imAudioLength;
@property(nonatomic, assign) int sendState;
@property(nonatomic, assign) int sendTime;
@property(nonatomic, strong) NSIndexPath *msgIndexPath;
@property (nonatomic, copy) void (^sendWrongBlock)(JXYChatProperty *property);

- (void)createNewFileName;
+ (long long)getTimeIntervalFromString:(NSString *)localTime;
@end
