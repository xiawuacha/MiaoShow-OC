//
//  CatEyesView.h
//  miaoShow
//
//  Created by 汪凯 on 16/9/22.
//  Copyright © 2016年 汪凯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LiveListModel;
@interface CatEyesView : UIView
/** 主播/主播 */
@property(nonatomic, strong) LiveListModel *live;
+ (instancetype)catEarView;
/** 点击开关  */
@property(nonatomic, copy)void (^CoverBtnClickBlock)();
@end
