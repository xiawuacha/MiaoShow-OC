//
//  LiveEndView.h
//  miaoShow
//
//  Created by 汪凯 on 16/9/22.
//  Copyright © 2016年 汪凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveEndView : UIView

+ (instancetype)liveEndView;
/** 查看其他主播 */
@property (nonatomic, copy) void (^lookOtherBlock)();
/** 退出 */
@property (nonatomic, copy) void (^quitBlock)();
/** 关注 */
@property (nonatomic, copy) void (^careBlock)();
@end
