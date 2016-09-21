//
//  LiveListModel.h
//  miaoShow
//
//  Created by 汪凯 on 16/9/21.
//  Copyright © 2016年 汪凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveListModel : NSObject
/** 直播流地址 */
@property (nonatomic, copy) NSString *flv;

@property (nonatomic, assign) NSInteger grade;
/** 主播名 */
@property (nonatomic, copy) NSString *myname;
/** 主播头像 */
@property (nonatomic, copy) NSString *smallpic;
/** 服务器id */
@property (nonatomic, assign) NSInteger serverid;
/** 直播房间号码 */
@property (nonatomic, assign) NSInteger roomid;
/** 所在城市 */
@property (nonatomic, copy) NSString *gps;
/** 星级 */
@property (nonatomic, assign) NSInteger starlevel;

@property (nonatomic, assign) NSInteger level;
/** 个性签名 */
@property (nonatomic, copy) NSString *signatures;
/** 直播图 */
@property (nonatomic, copy) NSString *bigpic;
/** 用户ID */
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) NSInteger curexp;

@property (nonatomic, assign) NSInteger useridx;

@property (nonatomic, copy) NSString *familyName;

@property (nonatomic, assign) NSInteger gender;
/** 朝阳群众数目 */
@property (nonatomic, assign) NSInteger allnum;


/** starImage */
@property (nonatomic, strong) UIImage    *starImage;

@end
