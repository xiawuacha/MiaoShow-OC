//
//  GiftView.h
//  miaoShow
//
//  Created by 汪凯 on 16/9/23.
//  Copyright © 2016年 汪凯. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LiveGiftType) {
    LiveGiftporsche,
    LiveGiftfighter,
    LiveGiftplane,
    LiveGiftflower_a,

};

@interface GiftView : UIView


/** 点击工具栏  */
@property(nonatomic, copy)void (^clickToolBlock)(LiveGiftType type);
@property(nonatomic, assign)NSInteger inter;
@end
