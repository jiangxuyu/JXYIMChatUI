//
//  JXYChatBarMoreView.h
//  JXYChatDemo
//
//  Created by longmaster39 on 2017/7/13.
//  Copyright © 2017年 longmaster39. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXYChatBarMoreViewDelegate <NSObject>

- (void)jxy_selectItemAtItemName:(NSString *_Nullable)itemName;

@end

@interface JXYChatBarMoreView : UIView

@property (nonatomic, assign) int itemCount;

@property (nonatomic, strong) NSDictionary *_Nullable toolDic;

@property(nullable, nonatomic, weak) id <JXYChatBarMoreViewDelegate> delegate;

@end
