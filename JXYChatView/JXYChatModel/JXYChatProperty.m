//
//  JXYChatProperty.m
//  JXYChatDemo
//
//  Created by longmaster39 on 2017/8/1.
//  Copyright © 2017年 longmaster39. All rights reserved.
//

#import "JXYChatProperty.h"

@implementation JXYChatProperty
@synthesize sendId;
@synthesize msgId;
@synthesize msgSeqId;
@synthesize sendRole;
@synthesize selfRole;
@synthesize messageContentText;
@synthesize messageContentFileName;
@synthesize messageContentFilePath;
@synthesize imCureDt;
@synthesize imRefuseReason;
@synthesize msgIndexPath;
@synthesize imAudioLength;

- (id)init
{
    if (self = [super init])
    {
        self.sendId = 0;
        self.sendRole = 0;
        self.selfRole = 1;
        self.messageContentText = @"";
        self.messageContentFileName = @"";
        self.messageContentFilePath = @"";
        self.imCureDt = @"";
        self.imRefuseReason = @"";
        self.localTime = @"";
        self.imAudioLength = 0.00;
        self.msgIndexPath = nil;
        self.msgSeqId = 0;
        self.msgId = 0;
        self.sendTime = 0;
    }
    return self;
}

- (void)setMessageType:(JXYMessageType)messageType
{
    _messageType = messageType;
    if (messageType == JXYMessageTypeSelf) {
        if (!self.localTime || [self.localTime isEqual: @""]) {
            NSDateFormatter *dateFormatter;
            if (!dateFormatter) {
                dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            }
            NSString *timeStr = [dateFormatter stringFromDate:[NSDate date]];
            self.localTime = timeStr;
        }
    
    }
}

- (void)createNewFileName
{
    NSString *fileName;
    
    switch (self.messageContentType) {
        case JXYMessageContentTypeImage:
        {
            fileName = [NSString stringWithFormat:@"image%@.jpg", [NSDate date]];
        }
            break;
            
        case JXYMessageContentTypeVoice:
        {
            fileName = [NSString stringWithFormat:@"audio%@.wav", [NSDate date]];
        }
            break;
            
        default:
            break;
    }
    
    self.messageContentFileName  = fileName;
}

+ (long long)getTimeIntervalFromString:(NSString *)localTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *timeDate = [dateFormatter dateFromString:localTime];
    return  (long)[timeDate timeIntervalSince1970];
}

- (void)dealloc
{
    self.messageContentText = nil;
    self.messageContentFilePath = nil;
    self.messageContentFileName = nil;
    self.localTime = nil;
    self.msgIndexPath = nil;
}

@end
