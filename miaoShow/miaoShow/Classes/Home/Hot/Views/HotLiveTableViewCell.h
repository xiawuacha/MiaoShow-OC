//
//  HotLiveTableViewCell.h
//  miaoShow
//
//  Created by 汪凯 on 16/9/21.
//  Copyright © 2016年 汪凯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LiveListModel;
@interface HotLiveTableViewCell : UITableViewCell
/** 直播 */
@property (nonatomic, strong) LiveListModel *live;
@end
