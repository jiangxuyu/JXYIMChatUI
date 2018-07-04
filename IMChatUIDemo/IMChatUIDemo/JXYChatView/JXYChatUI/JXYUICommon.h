//
//  JXYUICommon.h
//  JXYChatDemo
//
//  Created by longmaster39 on 2017/7/5.
//  Copyright © 2017年 longmaster39. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+JXY.h"
#import "UIImage+JXY.h"

//textFeild ---- key----
#define JXYTextViewOrFieldReturnBgViewKey        @"jxyTextViewOrFieldBgViewKey"
#define JXYTextViewOrFieldReturnBgImageViewKey   @"jxyTextViewOrFieldBgImageViewKey"
#define JXYTextViewOrFieldReturnKey              @"jxyTextViewOrFieldKey"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

typedef enum {
    JXYButtonStyleForDefaut = 0,                 //默认
    JXYButtonStyleForTopImgBottomTitle,          //上图下字
    JXYButtonStyleForTopTitleBottomImg,          //上字下图
    JXYButtonStyleForLeftImgRightTitle,          //左图右字
    JXYButtonStyleForRightImgLeftTitle           //左字右图
}JXYButtonStyle;

typedef enum {
    JXYLabelStyleDefaut = 0,
    JXYLabelStyleLabelSizeTofit,
}JXYLabelStyle;
typedef void (^ButtonClickBlock)(UIButton *_Nullable button);

/**
 *  JXYUICommon
 */
@interface JXYUICommon : NSObject<UITextViewDelegate>
/**
 整合创建UIButtond代码
 @param buttonStyle button样式（暂未实现）
 @return UIButton
 */
+ (UIButton *_Nullable)jxy_createButton:(CGRect)rect
                         setNormalTitle:(NSString *_Nullable)normalTitle
                         setNormalImage:(UIImage *_Nullable)normalImage
                          setClickTitle:(NSString *_Nullable)clickTitle
                          setClickImage:(UIImage *_Nullable)clickImage
               setNormalBackgroundImage:(UIImage *_Nullable)normalBackgroundImage
                setClickBackgroundImage:(UIImage *_Nullable)clickBackgroundImage
                         setButtonStyle:(JXYButtonStyle)buttonStyle;

/**
 整合创建UILabel代码
 @return UIButton
 */
+ (UILabel *_Nullable)jxy_createLabel:(CGRect)rect
                              setText:(NSString *_Nullable)text
                         setTextColor:(UIColor *_Nullable)textColor
                     setTextAlignment:(NSTextAlignment)textAlignment
                              setFont:(UIFont *_Nullable)font
                        setLabelStyle:(JXYLabelStyle)labelStyle;

/**
 整合创建UITextField代码
 @return Dic 通过key拿取对应的对象JXYTextViewOrFieldReturnBgViewKey ：为背景视图
                               JXYTextViewOrFieldReturnBgImageViewKey：背景图片背景视图
                               JXYTextViewOrFieldReturnKey ：为UITextField对象
 */
+ (NSDictionary *_Nullable)jxy_createTextField:(CGRect)rect
                            setBackgroundImage:(UIImage *_Nullable)backgroundImage
                                setPlaceholder:(NSString *_Nullable)placeholder
                                       setFont:(UIFont *_Nullable)font
                                   setDelegate:(id _Nullable)delegate;

+ (NSDictionary *_Nullable)jxy_createTextView:(CGRect)rect
                           setBackgroundImage:(UIImage *_Nullable)backgroundImage
                               setPlaceholder:(NSString *_Nullable)placeholder
                                      setFont:(UIFont *_Nullable)font
                                  setDelegate:(id _Nullable)delegate;

+ (UIAlertView *_Nullable)showCancelAndConfirmAlertWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message tag:(NSInteger)tag delegate:(id _Nullable )delegate;

@end
