//
//  CareViewController.m
//  miaoShow
//
//  Created by 汪凯 on 16/9/21.
//  Copyright © 2016年 汪凯. All rights reserved.
//

#import "CareViewController.h"

@interface CareViewController ()
@property (weak, nonatomic) IBOutlet UIButton *toSeeBtn;

@end

@implementation CareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.toSeeBtn.layer.borderWidth = 1;
    self.toSeeBtn.layer.borderColor = KeyColor.CGColor;
    self.toSeeBtn.layer.cornerRadius = self.toSeeBtn.height * 0.5;
    [self.toSeeBtn.layer masksToBounds];
    
    [self.toSeeBtn setTitleColor:KeyColor forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)toOther:(id)sender {
    //通知 切换到热门
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyToseeBigWorld object:nil];
}



@end
