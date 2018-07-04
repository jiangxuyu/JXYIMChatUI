//
//  JXYUICommon.m
//  JXYChatDemo
//
//  Created by longmaster39 on 2017/7/5.
//  Copyright © 2017年 longmaster39. All rights reserved.
//

#import "JXYUICommon.h"

@implementation JXYUICommon

+ (UIButton *_Nullable)jxy_createButton:(CGRect)rect
                         setNormalTitle:(NSString *_Nullable)normalTitle
                         setNormalImage:(UIImage *_Nullable)normalImage
                          setClickTitle:(NSString *_Nullable)clickTitle
                          setClickImage:(UIImage *_Nullable)clickImage
               setNormalBackgroundImage:(UIImage *_Nullable)normalBackgroundImage
                setClickBackgroundImage:(UIImage *_Nullable)clickBackgroundImage
                         setButtonStyle:(JXYButtonStyle)buttonStyle
{
    UIButton *jxy_button = [UIButton buttonWithType:UIButtonTypeCustom];
    jxy_button.frame = rect;
    [jxy_button setTitle:normalTitle forState:UIControlStateNormal];
    [jxy_button setTitle:clickTitle forState:UIControlStateHighlighted];
    [jxy_button setImage:normalImage forState:UIControlStateNormal];
    if (clickImage) {
        [jxy_button setImage:clickImage forState:UIControlStateHighlighted];
    }
    if (normalBackgroundImage) {
        [jxy_button setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
    }
    if (clickBackgroundImage) {
        [jxy_button setBackgroundImage:clickBackgroundImage forState:UIControlStateHighlighted];
    }
    
    return jxy_button;
}

+ (UILabel *_Nullable)jxy_createLabel:(CGRect)rect
                              setText:(NSString *_Nullable)text
                         setTextColor:(UIColor *_Nullable)textColor
                     setTextAlignment:(NSTextAlignment)textAlignment
                              setFont:(UIFont *_Nullable)font
                        setLabelStyle:(JXYLabelStyle)labelStyle
{
    UILabel *jxy_label = [[UILabel alloc] initWithFrame:CGRectZero];
    jxy_label.text = text;
    jxy_label.textColor = textColor;
    jxy_label.font = font;
    jxy_label.textAlignment = textAlignment;
    
    switch (labelStyle) {
        case JXYLabelStyleDefaut:
            jxy_label.frame = rect;
            break;
        case JXYLabelStyleLabelSizeTofit:
            [jxy_label sizeToFit];
            jxy_label.frame = CGRectMake(rect.origin.x, rect.origin.y, jxy_label.frame.size.width, jxy_label.frame.size.height);
            break;
        default:
            break;
    }
    
    return jxy_label;
}

+ (NSDictionary *_Nullable)jxy_createTextField:(CGRect)rect
                            setBackgroundImage:(UIImage *_Nullable)backgroundImage
                                setPlaceholder:(NSString *_Nullable)placeholder
                                       setFont:(UIFont *_Nullable)font
                                   setDelegate:(id _Nullable)delegate
{
    NSMutableDictionary *returnDic = [NSMutableDictionary new];
    UIView *textView = [[UIView alloc] initWithFrame:rect];
    if (backgroundImage) {
        UIImageView *textBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:backgroundImage.size.width * 0.5 topCapHeight:backgroundImage.size.height * 0.5];
        textBg.image = backgroundImage;
        [textView addSubview:textBg];
        [returnDic setObject:textBg forKey:JXYTextViewOrFieldReturnBgImageViewKey];
    }
    UITextField *jxy_textField = [[UITextField alloc] initWithFrame:CGRectMake(3, 0, rect.size.width - 3, rect.size.height)];
    jxy_textField.borderStyle = UITextBorderStyleNone;
    jxy_textField.font = font;
    jxy_textField.placeholder = placeholder;
    jxy_textField.autocorrectionType = UITextAutocorrectionTypeNo;
    jxy_textField.keyboardType = UIKeyboardTypeDefault;
    jxy_textField.returnKeyType = UIReturnKeyDone;
    jxy_textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    jxy_textField.delegate = delegate;
    [textView addSubview:jxy_textField];
    
    [returnDic setObject:textView forKey:JXYTextViewOrFieldReturnBgViewKey];
    [returnDic setObject:jxy_textField forKey:JXYTextViewOrFieldReturnKey];
    
    return returnDic;
}

+ (NSDictionary *_Nullable)jxy_createTextView:(CGRect)rect
                           setBackgroundImage:(UIImage *_Nullable)backgroundImage
                               setPlaceholder:(NSString *_Nullable)placeholder
                                      setFont:(UIFont *_Nullable)font
                                  setDelegate:(id _Nullable)delegate
{
    NSMutableDictionary *returnDic = [NSMutableDictionary new];
    UIView *textView = [[UIView alloc] initWithFrame:rect];
    if (backgroundImage) {
        UIImageView *textBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:backgroundImage.size.width * 0.5 topCapHeight:backgroundImage.size.height * 0.5];
        textBg.image = backgroundImage;
        [textView addSubview:textBg];
        [returnDic setObject:textBg forKey:JXYTextViewOrFieldReturnBgImageViewKey];
    }
    UITextView *jxy_textView = [[UITextView alloc] initWithFrame:CGRectMake(3, 0, rect.size.width - 3, rect.size.height)];
    jxy_textView.font = font;
    jxy_textView.backgroundColor = [UIColor clearColor];
    jxy_textView.autocorrectionType = UITextAutocorrectionTypeNo;
    jxy_textView.keyboardType = UIKeyboardTypeDefault;
    jxy_textView.returnKeyType = UIReturnKeyDone;
    jxy_textView.scrollEnabled = YES;
    jxy_textView.delegate = delegate;
    [textView addSubview:jxy_textView];
    
    [returnDic setObject:textView forKey:JXYTextViewOrFieldReturnBgViewKey];
    [returnDic setObject:jxy_textView forKey:JXYTextViewOrFieldReturnKey];

    
    return returnDic;
}

+ (UIAlertView *_Nullable)showCancelAndConfirmAlertWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message tag:(NSInteger)tag delegate:(id _Nullable )delegate
{
    UIAlertView *unShieldDocAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    unShieldDocAlert.tag = tag;
    [unShieldDocAlert dismissWithClickedButtonIndex:0 animated:YES];
    [unShieldDocAlert show];
    
    return unShieldDocAlert;
}


@end
