//
//  ChatButtonView.m
//  Doctor
//
//  Created by longmaster39 on 2017/8/16.
//  Copyright © 2017年 com.longmaster. All rights reserved.
//

#import "ChatButtonView.h"
#import "JXYUICommon.h"
#define BUTTON_TITLE_FONT   15
#define BUTTON_TITLE_COLOR  0xffffff
#define BUTTON_TAG          10001000

@implementation ChatButtonView
{
    NSMutableArray *_btnArr;
    NSMutableArray *_titleArr;
    UIWindow *_keyWindow;
    UIView *_touchView;
    UITapGestureRecognizer *_dissTap;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (!_btnArr) {
            _btnArr = [NSMutableArray new];
        } else {
            [_btnArr removeAllObjects];
        }
        for (int i = 0; i < 4; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = BUTTON_TAG + i;
            btn.hidden = YES;
            btn.height = 39;
            btn.titleLabel.font = [UIFont systemFontOfSize:BUTTON_TITLE_FONT];
            btn.backgroundColor = UIColorFromRGA(0x000000, .8);
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [_btnArr addObject:btn];
        }
        self.height = 39;
        self.width = 0;
        _keyWindow = [UIApplication sharedApplication].keyWindow;
        _touchView = [[UIView alloc] initWithFrame:_keyWindow.frame];
        _touchView.hidden = YES;
        [_keyWindow addSubview:_touchView];
        _dissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenButtonView)];
        [_touchView addGestureRecognizer:_dissTap];
    }
    return self;
}

- (void)showChatButtonView:(UIView *)view InPoint:(CGPoint)point withButtonTitles:(NSString *)buttonTitle,...NS_REQUIRES_NIL_TERMINATION
{
    CGRect rect = [view convertRect: view.bounds toView:_keyWindow];
    _touchView.hidden = NO;
    if(self.isShowing)
    {
        return;
    }
    if (!_titleArr) {
        _titleArr = [NSMutableArray new];
    } else {
        [_titleArr removeAllObjects];
    }
    [_keyWindow addSubview:self];
    
    self.width = 0;
    
    va_list arguments;
    id eachObject;
    if (buttonTitle) {
        NSLog(@"%@",buttonTitle);
        [_titleArr addObject:buttonTitle];
        va_start(arguments, buttonTitle);
        while ((eachObject = va_arg(arguments, id))) {
            NSLog(@"%@",eachObject);
            [_titleArr addObject:(NSString *)eachObject];
        }
        va_end(arguments);
    }
    
    if (_titleArr.count == 0) {
        return;
    }
    UIButton *beforeBtn;
    for (int i = 0; i < _titleArr.count; i++) {
        UIButton *btn = _btnArr[i];
        [btn setTitle:_titleArr[i] forState:UIControlStateNormal];
        btn.width = [self calculateButtonWidth:_titleArr[i]];
        if (i == 0) {
            btn.left = 0;
        } else {
            beforeBtn = (UIButton *)_btnArr[i - 1];
            btn.left = beforeBtn.right + 1;
        }
        btn.hidden = NO;
        btn.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
        self.width = self.width + btn.width + i * 1;
    }
    self.top = rect.origin.y - self.height;
    self.centerX = rect.origin.x + rect.size.width / 2 - 15;
    [UIView createMaskLayerWithView:self withArrowsDirection:ArrowsDirectionBottom withPosition:CGPointMake(self.width / 2, self.height) withCornerRadius:5];
    NSLog(@"%@",self.superview);
    self.isShowing = YES;
    self.hidden = NO;
}

- (void)hiddenButtonView
{
    self.hidden = YES;
    self.isShowing = NO;
    _touchView.hidden = YES;
}

- (void)buttonClick:(UIButton *)button
{
    self.chatButtonViewClick(button.top - BUTTON_TAG, button.titleLabel.text);
    [self hiddenButtonView];
}

- (float)calculateButtonWidth:(NSString *)title
{
    CGSize titleSize = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:BUTTON_TITLE_FONT],NSFontAttributeName, nil]];
    
    return titleSize.width + 30;
}


@end
