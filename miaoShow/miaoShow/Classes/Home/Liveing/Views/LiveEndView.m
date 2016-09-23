//
//  LiveEndView.m
//  miaoShow
//
//  Created by 汪凯 on 16/9/22.
//  Copyright © 2016年 汪凯. All rights reserved.
//

#import "LiveEndView.h"

@interface LiveEndView()
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;
@property (weak, nonatomic) IBOutlet UIButton *lookOtherBtn;
@property (weak, nonatomic) IBOutlet UIButton *careBtn;

@end

@implementation LiveEndView
+ (instancetype)liveEndView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self maskRadius:self.quitBtn];
    [self maskRadius:self.lookOtherBtn];
    [self maskRadius:self.careBtn];
}
- (void)maskRadius:(UIButton *)btn
{
    btn.layer.cornerRadius = btn.height * 0.5;
    btn.layer.masksToBounds = YES;
    if (btn != self.careBtn) {
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = KeyColor.CGColor;
    }
}
- (IBAction)care:(UIButton *)sender {
    [sender setTitle:@"关注成功" forState:UIControlStateNormal];
    if (self.careBlock) {
        self.careBlock();
    }
}
- (IBAction)lookOther {
    [self removeFromSuperview];
    if (self.lookOtherBlock) {
        self.lookOtherBlock();
    }
}
- (IBAction)quit {
    if (self.quitBlock) {
        self.quitBlock();
    }
}


@end
