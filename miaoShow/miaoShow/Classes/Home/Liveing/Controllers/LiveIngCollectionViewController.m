//
//  LiveIngCollectionViewController.m
//  miaoShow
//
//  Created by 汪凯 on 16/9/21.
//  Copyright © 2016年 汪凯. All rights reserved.
//

#import "LiveIngCollectionViewController.h"
#import "LivingFlowLayout.h"
#import "LivingViewCell.h"
#import "UserView.h"
@interface LiveIngCollectionViewController ()
@property (nonatomic, weak) UserView *userView;
@end

@implementation LiveIngCollectionViewController

static NSString * const reuseIdentifier = @"LivingViewCell";

-(instancetype)init{
    //自定义一个LivingFlowLayout   设置collectionCell 为屏幕大小
    return [super initWithCollectionViewLayout:[[LivingFlowLayout alloc] init]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
   
}
- (UserView *)userView
{
    if (!_userView) {
        UserView *userView = [UserView userView];
        [self.collectionView addSubview:userView];
        _userView = userView;
        
        [userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.width.equalTo(@(KScreenWidth));
            make.height.equalTo(@(KScreenHeight));
        }];
        userView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [userView setCloseBlock:^{
            [UIView animateWithDuration:0.5 animations:^{
                self.userView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished) {
                [self.userView removeFromSuperview];
                self.userView = nil;
            }];
        }];
        
    }
    return _userView;
}




#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}





@end
