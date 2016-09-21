//
//  LiveADModel.h
//  miaoShow
//
//  Created by 汪凯 on 16/9/21.
//  Copyright © 2016年 汪凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveADModel : NSObject

@property (nonatomic, assign) NSInteger lrCurrent;

@property (nonatomic, assign) NSInteger hiddenVer;
/** 个性签名 */
@property (nonatomic, copy) NSString *signatures;

@property (nonatomic, copy) NSString *link;

@property (nonatomic, copy) NSString *title;
/** 倒计时 */
@property (nonatomic, assign) NSInteger cutTime;

@property (nonatomic, copy) NSString *adsmallpic;
/** 主播ID */
@property (nonatomic, assign) NSInteger useridx;
/** 大图 */
@property (nonatomic, copy) NSString *bigpic;
/** 主播头像 */
@property (nonatomic, copy) NSString *smallpic;
/** 主播名 */
@property (nonatomic, copy) NSString *myname;
/** 直播流 */
@property (nonatomic, copy) NSString *flv;

@property (nonatomic, copy) NSString *contents;
/** AD序号 */
@property (nonatomic, assign) NSInteger orderid;
/** 房间号 */
@property (nonatomic, assign) NSInteger roomid;
/** AD图片 */
@property (nonatomic, copy) NSString *imageUrl;
/** 当前状态 */
@property (nonatomic, assign) NSInteger state;
/** 新增时间 */
@property (nonatomic, copy) NSString *addTime;
/** 所在服务器号 */
@property (nonatomic, assign) NSInteger serverid;
/** 所在城市 */
@property (nonatomic, copy) NSString *gps;

@end
