//
//  LivingViewCell.h
//  miaoShow
//
//  Created by 汪凯 on 16/9/21.
//  Copyright © 2016年 汪凯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LiveListModel;
@interface LivingViewCell : UICollectionViewCell
/** 直播 */
@property (nonatomic, strong) LiveListModel *live;
/** 相关的直播或者主播 */
@property (nonatomic, strong) LiveListModel *relateLive;
/** 父控制器 */
@property (nonatomic, weak) UIViewController *parentVc;
/** 点击关联主播 */
@property (nonatomic, copy) void (^clickRelatedLive)();
@end
