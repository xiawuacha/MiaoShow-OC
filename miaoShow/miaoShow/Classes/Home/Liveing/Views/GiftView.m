//
//  GiftView.m
//  miaoShow
//
//  Created by 汪凯 on 16/9/23.
//  Copyright © 2016年 汪凯. All rights reserved.
//

#import "GiftView.h"

@interface GiftView ()

@end
@implementation GiftView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
    
}
-(void)setup{

    self.backgroundColor = KColor(35, 35, 35);
    self.alpha = 0.4;
    
    
    CGFloat wh = (self.width-25)/4;
    CGFloat margin = 5;
    CGFloat x = 0;
    CGFloat y = 0;
    for (int i=0; i<4; i++) {
        x = margin + (margin + wh) * i;
        //实际这里应该是一个封装的view
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, wh, wh)];
        button.tag = i;
        [button setTitle:self.gifts[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }


}
- (void)click:(UIButton *)sender
{
    if (self.clickToolBlock) {
        self.clickToolBlock(sender.tag);
    }
}
- (NSArray *)gifts
{
    return @[@"跑车", @"战斗机", @"客机", @"鲜花"];
}
@end
