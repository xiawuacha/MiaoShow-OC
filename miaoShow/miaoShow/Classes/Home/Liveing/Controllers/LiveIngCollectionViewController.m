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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.collectionView.backgroundColor = [UIColor whiteColor];

    [self.collectionView registerClass:[LivingViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    RefreshGifHeader *header = [RefreshGifHeader headerWithRefreshingBlock:^{
        [self.collectionView.mj_header endRefreshing];
        self.currentIndex++;
        if (self.currentIndex == self.lives.count) {
            self.currentIndex = 0;
        }
        [self.collectionView reloadData];
    }];
    header.stateLabel.hidden = NO;
    [header setTitle:@"下拉切换另一个主播" forState:MJRefreshStatePulling];
    [header setTitle:@"下拉切换另一个主播" forState:MJRefreshStateIdle];
    self.collectionView.mj_header = header;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickUser:) name:kNotifyClickUser object:nil];
   
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ClickOtherAnchor:) name:kNotifyClickOtherAnchor object:nil];
}
- (void)clickUser:(NSNotification *)notify
{
    if (notify.userInfo[@"user"] != nil) {
        User *user = notify.userInfo[@"user"];
        self.userView.user = user;
        [UIView animateWithDuration:0.5 animations:^{
            self.userView.transform = CGAffineTransformIdentity;
        }];
    }
}
- (UserView *)userView
{
    if (!_userView) {
        UserView *userView = [UserView userView];
        [self.collectionView addSubview:userView];
        _userView = userView;
        
        [userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.width.equalTo(@(KScreenWidth*0.8));
            make.height.equalTo(@(KScreenWidth));
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
    LivingViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.parentVc = self;  //此处将自己控制器 传给cell 的好处就是  可以在cell 中做很多控制器才能做的是  (添加东西  退出等)
    cell.live = self.lives[self.currentIndex];
    NSUInteger relateIndex = self.currentIndex;
    if (self.currentIndex + 1 == self.lives.count) {
        relateIndex = 0;
    }else{
        relateIndex += 1;
    }
    cell.relateLive = self.lives[relateIndex];
    [cell setClickRelatedLive:^{
        self.currentIndex += 1;
        [self.collectionView reloadData]; //此处刷新currentIndex
    }];

    
    return cell;
}
#pragma mark   点击了同频道主播
-(void)ClickOtherAnchor:(NSNotification *)notify{

    NSLog(@"notify=====%@",notify);//User 模型
}




@end
