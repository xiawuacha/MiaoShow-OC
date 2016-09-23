//
//  OtheAnchorView.m
//  miaoShow
//
//  Created by 汪凯 on 16/9/22.
//  Copyright © 2016年 汪凯. All rights reserved.
//

#import "OtheAnchorView.h"
#import "User.h"

@interface  OtheAnchorView ()
@property (weak, nonatomic)  UIScrollView *ScrollView;//观众视图


@end

@implementation OtheAnchorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

-(void)setup{

    UIScrollView* ScrollView =[[UIScrollView alloc] initWithFrame:self.bounds];
    ScrollView.showsHorizontalScrollIndicator =NO;
    ScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:ScrollView];
    self.ScrollView = ScrollView;
    
    
    }
-(void)setAudienceUsers:(NSArray *)audienceUsers{
    _audienceUsers = audienceUsers;

    self.ScrollView.contentSize = CGSizeMake( 0,(self.ScrollView.width + DefaultMargin) * audienceUsers.count + DefaultMargin);
    CGFloat width = self.ScrollView.width - 10;
    CGFloat y = 0;
    for (int i = 0; i<audienceUsers.count; i++) {
        y = 0 + (DefaultMargin + width) * i;
        UIImageView *userView = [[UIImageView alloc] initWithFrame:CGRectMake(5, y, width, width)];
        userView.layer.cornerRadius = width * 0.5;
        userView.layer.masksToBounds = YES;
        User *user = audienceUsers[i];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:user.photo] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                userView.image = [UIImage circleImage:image borderColor:[UIColor whiteColor] borderWidth:1];
            });
        }];
        // 设置监听
        userView.userInteractionEnabled = YES;
        [userView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickaudienceUsers:)]];
        userView.tag = i;
        [self.ScrollView addSubview:userView];
        
    }


}
#pragma mark  其他主播点击
-(void)clickaudienceUsers:(UITapGestureRecognizer *)tapGes{
  
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyClickOtherAnchor object:nil userInfo:@{@"user" : self.audienceUsers[tapGes.view.tag]}];  //需要传一个主播模型
    
    
}

@end
