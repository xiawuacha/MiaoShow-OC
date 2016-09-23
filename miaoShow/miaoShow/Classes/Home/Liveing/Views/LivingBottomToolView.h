//
//  LivingBottomToolView.h
//  miaoShow
//
//  Created by 汪凯 on 16/9/22.
//  Copyright © 2016年 汪凯. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, LiveToolType) {
    LiveToolTypePublicTalk,
    LiveToolTypePrivateTalk,
    LiveToolTypeGift,
    LiveToolTypeRank,
    LiveToolTypeShare,
    LiveToolTypeflower,
    LiveToolTypeClose
};
@interface LivingBottomToolView : UIView
/** 点击工具栏  */
@property(nonatomic, copy)void (^clickToolBlock)(LiveToolType type);
@end
