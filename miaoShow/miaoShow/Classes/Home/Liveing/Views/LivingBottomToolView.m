//
//  LivingBottomToolView.m
//  miaoShow
//
//  Created by 汪凯 on 16/9/22.
//  Copyright © 2016年 汪凯. All rights reserved.
//

#import "LivingBottomToolView.h"

@implementation LivingBottomToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{

    CGFloat wh = 34;
    CGFloat margin = 10;
        CGFloat x = 0;
        CGFloat y = 0;
    NSInteger count =self.tools.count;
    for (int i = 0; i<count; i++) {
        
        if (i<2) {
             x = margin + (margin + wh) * i;
        }else{
         x =KScreenWidth -(count-i)*(margin+wh) ;
        }
       
        UIImageView *toolView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, wh, wh)];
        toolView.userInteractionEnabled = YES;
        toolView.tag = i;
        toolView.image = [UIImage imageNamed:self.tools[i]];
        [toolView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
        [self addSubview:toolView];

    }
}

- (void)click:(UITapGestureRecognizer *)tapRec
{
    if (self.clickToolBlock) {
        self.clickToolBlock(tapRec.view.tag);
    }
}

- (NSArray *)tools
{
    return @[@"talk_public_40x40", @"talk_private_40x40", @"talk_sendgift_40x40", @"talk_rank_40x40", @"talk_share_40x40",@"good2_30x30", @"talk_close_40x40"];
}
@end
