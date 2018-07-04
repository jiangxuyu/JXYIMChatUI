//
//  JXYChatView.m
//  JXYChatDemo
//
//  Created by longmaster39 on 2017/7/31.
//  Copyright © 2017年 longmaster39. All rights reserved.
//

#import "JXYChatView.h"
#import "JXYChatViewCell.h"
#import "JXYChatInputBox.h"
#import "JXYUICommon.h"

@interface JXYChatView()<UITableViewDelegate, UITableViewDataSource, JXYChatInputBoxDelegate>

@end

@implementation JXYChatView
{
    JXYChatInputBox *_chatInputBox;
    UIButton *_setCureDtBtn;
    UITableView *_jxyChatTabelView;
    NSMutableArray *_talkHistoryArr;
    NSMutableArray *_pageHistoryArr;
    NSMutableArray *_messageSendingArr;
    JXYChatProperty *_messageContent;
    BOOL _needSendMessage;
    int _pageIndex;
    long long _pageSeqId;
    UIButton *_bottomBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self jxy_getData];
        [self setSubviews:frame];
        _needSendMessage = NO;
        _pageSeqId = 0;
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    [_chatInputBox dismiss];
    [self removeSubviews];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)jxy_getData
{
    if (_talkHistoryArr) {
        [_talkHistoryArr removeAllObjects];
    }else {
        _talkHistoryArr = [NSMutableArray new];
    }
    
    if (_messageSendingArr) {
        [_messageSendingArr removeAllObjects];
    } else {
        _messageSendingArr = [NSMutableArray new];
    }
}


#pragma mark -  UI
- (void)setSubviews:(CGRect)frame
{
    _jxyChatTabelView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _jxyChatTabelView.backgroundColor = UIColorFromRGB(0xeeeeee);
    _jxyChatTabelView.delegate = self;
    _jxyChatTabelView.dataSource = self;
    _jxyChatTabelView.separatorStyle = NO;
    [self addSubview:_jxyChatTabelView];
    
    if (!_chatInputBox) {
        _chatInputBox = [JXYChatInputBox new];
        _chatInputBox.delegate = self;
        [_chatInputBox jxy_createChatInputBox:CGRectZero andChatInputBoxClickBlock:^(UIButton * _Nullable button, NSInteger index) {
        } andView:self];
        _jxyChatTabelView.height = self.height - _chatInputBox.height;
    }
}

#pragma mark - Action
- (void)createNewMessageCell:(JXYMessageType)messageType andMessage:(NSObject *)message
{
    JXYChatProperty *property = [JXYChatProperty new];
    property.messageType = JXYMessageTypeOther;
    
    [self jxy_addChatCell:property];
}

- (void)jxy_addChatCell:(JXYChatProperty *)property
{
    NSMutableArray *lastCellArr = [_talkHistoryArr lastObject];
    JXYChatProperty *firstProperty = (JXYChatProperty *)lastCellArr[0];
    NSIndexPath *lastIndexPath = nil;
    NSInteger row;
    NSDate *timeFirst = [[NSDate alloc] initWithTimeIntervalSince1970:[JXYChatProperty getTimeIntervalFromString:firstProperty.localTime]];
    NSDate *msgDate = [[NSDate alloc] initWithTimeIntervalSince1970:[JXYChatProperty getTimeIntervalFromString:property.localTime]];
    NSTimeInterval timeInterval = [msgDate timeIntervalSinceDate:timeFirst];
    if ((timeInterval >= 5 * 60) || lastCellArr.count >= 10 || !lastCellArr) {
        NSMutableArray *newCellArr = [NSMutableArray new];
        [newCellArr addObject:property];
        [_talkHistoryArr addObject:newCellArr];
        row = (NSInteger)newCellArr.count - 1;
        lastIndexPath = [NSIndexPath indexPathForRow:row inSection:_talkHistoryArr.count - 1];
    } else {
        [lastCellArr addObject:property];
        row = (NSInteger)lastCellArr.count - 1;
        lastIndexPath = [NSIndexPath indexPathForRow:row inSection:_talkHistoryArr.count - 1];
    }
    [_jxyChatTabelView reloadData];
    [_jxyChatTabelView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    property.msgIndexPath = lastIndexPath;
    
}


#pragma mark - JXYChatInputBoxDelegate
- (void)jxy_resultInfoReturn:(JXYChatProperty *)property
{
    if ([_messageSendingArr containsObject:property]) {
        [_messageSendingArr removeObject:property];
    }
    property.sendWrongBlock = ^(JXYChatProperty *property) {
    
    };
    if (property) {
        if (property.sendState != MsgStateSendFailForMsg && property.sendState != MsgStateSendFail && property.sendState != MsgStateIsSending) {
            property.sendState = MsgStateIsSending;
            if (property.messageContentType == JXYMessageContentTypeText && (!property.messageContentText || [property.messageContentText isEqual:@""])) {
                return;
            }

            [self jxy_addChatCell:property];
        }
        
        if (property.messageContentType != JXYMessageContentTypeVoice && property.messageContentType != JXYMessageContentTypeImage) {
            property.sendState = MsgStateIsSending;
        }
        [_messageSendingArr addObject:property];
        
    }
}

- (void)jxy_changChatInputBoxChangForY:(CGFloat)height withDurtion:(CGFloat)durtion
{
    _jxyChatTabelView.height = _jxyChatTabelView.height + height;
    _setCureDtBtn.top = _setCureDtBtn.top + height;
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _talkHistoryArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *cellArr = _talkHistoryArr[section];
    return cellArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *cellArr = _talkHistoryArr[indexPath.section];
    return [JXYChatViewCell heightForcell:cellArr[indexPath.row]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *sectionArr = _talkHistoryArr[section];
    JXYChatProperty *msg = [sectionArr firstObject];
    NSString *time = msg.localTime;
    NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
//    NSString *todayStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *dayStr;
    if (![time isEqualToString:@""]) {
        if ([time length] >= 16) {
            dayStr = [time substringToIndex:10];
        }
    }
    
    CGSize timeSectionSize = [time boundingRectWithSize:CGSizeMake(self.width - 50, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:JXY_SYSTEM_MESSAGE_FONT]} context:nil].size;
    
    UIView *tiemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,5 + 12 + 4 + 5)];
    [tableView addSubview:tiemView];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((tiemView.width - timeSectionSize.width) / 2 - 5, 5, timeSectionSize.width + 10, timeSectionSize.height + 4)];
    timeLabel.textColor = UIColorFromRGB(0xffffff);
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.text = time;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.layer.masksToBounds = YES;
    timeLabel.layer.cornerRadius = 5;
    timeLabel.layer.borderWidth = 1;
    timeLabel.layer.borderColor = UIColorFromRGB(0xDCDCDC).CGColor;
    timeLabel.backgroundColor = UIColorFromRGB(0xDCDCDC);
    [tiemView addSubview:timeLabel];
    
    return tiemView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5 + 12 + 4 + 5;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *cellArr = _talkHistoryArr[indexPath.section];
    JXYChatProperty *property = cellArr[indexPath.row];
    property.msgIndexPath = indexPath;
    
    switch (property.messageContentType) {
        case JXYMessageContentTypeImage:
        case JXYMessageContentTypeText:
        case JXYMessageContentTypeVoice:
        {
            static NSString *str = @"JXYChatViewCell";
            JXYChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (cell == nil) {
                cell = [[JXYChatViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            }
            [cell setNeedsLayout];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.jxyChatProperty = property;
            __block JXYChatViewCell *blockCell = cell;
            __weak typeof (self)weak_self = self;
            cell.reSendClick = ^(JXYChatProperty *property) {
                [blockCell startSendingAnimation];
                [weak_self jxy_resultInfoReturn:property];
            };
            
            return cell;
        }
            break;
            
        default:
            return [[UITableViewCell alloc] init];
            break;
    }
}

@end
