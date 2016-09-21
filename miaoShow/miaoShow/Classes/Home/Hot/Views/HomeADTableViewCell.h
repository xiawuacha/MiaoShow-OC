//
//  HomeADTableViewCell.h
//  miaoShow
//
//  Created by 汪凯 on 16/9/21.
//  Copyright © 2016年 汪凯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LiveADModel;
@interface HomeADTableViewCell : UITableViewCell<XRCarouselViewDelegate>
/** 顶部AD数组 */
@property (nonatomic, strong) NSArray *topADs;
/** 点击图片的block */
@property (nonatomic, copy) void (^imageClickBlock)(LiveADModel *topAD);
@end
