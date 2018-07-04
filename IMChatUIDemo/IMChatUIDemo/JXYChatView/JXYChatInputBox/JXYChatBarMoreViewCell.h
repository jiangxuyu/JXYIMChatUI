//
//  JXYChatBarMoreViewCell.h
//  JXYChatDemo
//
//  Created by longmaster39 on 2017/7/13.
//  Copyright © 2017年 longmaster39. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXYChatBarMoreViewCellDelegate <NSObject>

- (void)jxy_selectItemAtItemName:(NSString *_Nullable)itemName;

@end

@interface JXYChatBarMoreViewCell : UICollectionViewCell

@property(nonatomic, assign) NSInteger sectionNum;
@property(nonatomic, assign) int itemCount;
@property (nonatomic, strong) NSDictionary *_Nullable toolDic;

@property(nullable, nonatomic, weak) id <JXYChatBarMoreViewCellDelegate> delegate;

@end
