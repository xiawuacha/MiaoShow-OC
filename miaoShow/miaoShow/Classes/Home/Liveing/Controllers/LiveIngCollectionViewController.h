//
//  LiveIngCollectionViewController.h
//  miaoShow
//
//  Created by 汪凯 on 16/9/21.
//  Copyright © 2016年 汪凯. All rights reserved.
//

#import <UIKit/UIKit.h>


//控制器继承自UICollectionViewController  是为了方便上啦或者下拉切换另一个直播

@interface LiveIngCollectionViewController : UICollectionViewController
/** 直播 */
@property (nonatomic, strong) NSArray *lives;
/** 当前的index */
@property (nonatomic, assign) NSUInteger currentIndex;
@end
