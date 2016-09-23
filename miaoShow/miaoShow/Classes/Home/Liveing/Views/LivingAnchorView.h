//
//  LivingAnchorView.h
//  miaoShow
//
//  Created by 汪凯 on 16/9/22.
//  Copyright © 2016年 汪凯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User,LiveListModel;
@interface LivingAnchorView : UIView
+ (instancetype)LivingAnchorView;
/** 主播 */
@property(nonatomic, strong) User *user;
/** 直播 */
@property(nonatomic, strong) LiveListModel *live;
/** 点击开关  */
@property(nonatomic, copy)void (^clickDeviceShow)(bool selected);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wideConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabeTrailConstration;
@property (weak, nonatomic) IBOutlet UIButton *careBtn;//关注
@end
