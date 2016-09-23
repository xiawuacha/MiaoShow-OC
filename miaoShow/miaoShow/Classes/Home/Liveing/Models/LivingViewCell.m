//
//  LivingViewCell.m
//  miaoShow
//
//  Created by 汪凯 on 16/9/21.
//  Copyright © 2016年 汪凯. All rights reserved.
//

#import "LivingViewCell.h"
#import "LivingBottomToolView.h"
#import "LivingAnchorView.h"
#import "CatEyesView.h"
#import "LiveEndView.h"
#import "NSSafeObject.h"
#import "LiveListModel.h"
#import "OtheAnchorView.h"
#import <QuartzCore/CALayer.h>
#import "User.h"
#import "GiftView.h"
@interface LivingViewCell()
{
    BarrageRenderer *_renderer;
    NSTimer * _timer;
   
}
/** 直播开始前的占位图片 */
@property(nonatomic, weak) UIImageView *placeHolderView;
/** 直播播放器 */
@property (nonatomic, strong) IJKFFMoviePlayerController *moviePlayer;
/** 底部的工具栏 */
@property(nonatomic, weak) LivingBottomToolView *toolView;
/** 顶部主播相关视图 */
@property(nonatomic, weak) LivingAnchorView *anchorView;
/** 同类型直播视图 */
@property(nonatomic, weak) CatEyesView *catEyesView;
/** 同一个工会的主播/相关主播 */
@property(nonatomic, weak) UIImageView *otherView;
/** 同一个工会的主播 */
@property (nonatomic, weak) OtheAnchorView *otheAnchorView;
/** 礼物 view */
@property (nonatomic, weak) GiftView *giftView;
/** 直播结束的界面 */
@property (nonatomic, weak) LiveEndView *endView;
/** 粒子动画 */
@property(nonatomic, weak) CAEmitterLayer *emitterLayer;

@property (nonatomic, strong) NSMutableArray *loveArr;

@property (nonatomic, assign) NSInteger  state;

@property (nonatomic, strong) NSArray *otheAnchorUser;//同频道主播数据

@property (nonatomic, weak) NHPresentFlower *flower;

@end
@implementation LivingViewCell

#pragma mark  爱心弹出效果动画
- (CAEmitterLayer *)emitterLayer
{
    if (!_emitterLayer) {
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
        // 发射器在xy平面的中心位置
        emitterLayer.emitterPosition = CGPointMake(self.moviePlayer.view.frame.size.width-50,self.moviePlayer.view.frame.size.height-50);
        // 发射器的尺寸大小
        emitterLayer.emitterSize = CGSizeMake(40, 40);
        // 渲染模式
        emitterLayer.renderMode = kCAEmitterLayerUnordered;
        // 开启三维效果
        //    _emitterLayer.preservesDepth = YES;

        _emitterLayer = emitterLayer;
    }
    return _emitterLayer;
}


//===========================加载视图==================================
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.toolView.hidden = NO;
        _loveArr = [NSMutableArray array];
        self.state = 1;
        _renderer = [[BarrageRenderer alloc] init];
//        CGFloat top, CGFloat left, CGFloat bottom, CGFloat right
        _renderer.canvasMargin = UIEdgeInsetsMake(KScreenHeight * 0.6, 10, 20, KScreenWidth*0.3);
        //打开_renderer的交互
        _renderer.view.userInteractionEnabled = YES;
        [self.contentView addSubview:_renderer.view];
        [_renderer start];//默认是开始的
        NSSafeObject * safeObj = [[NSSafeObject alloc]initWithObject:self withSelector:@selector(autoSendBarrage)];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];
        
       
        
    }
    return self;
}
- (void)setLive:(LiveListModel *)live
{
    _live = live;
    self.anchorView.live = live;
    [self playWithFLV:live.flv placeHolderUrl:live.bigpic];
}
- (void)setRelateLive:(LiveListModel *)relateLive
{
    _relateLive = relateLive;
    // 设置相关主播
    if (relateLive) {
        self.catEyesView.live = relateLive;
    }else{
        self.catEyesView.hidden = YES;
    }
}

#pragma mark  播放直播流
- (void)playWithFLV:(NSString *)flv placeHolderUrl:(NSString *)placeHolderUrl
{
    if (_moviePlayer) {
        if (_moviePlayer) {
            [self.contentView insertSubview:self.placeHolderView aboveSubview:_moviePlayer.view];
        }
        if (_catEyesView) {
            [_catEyesView removeFromSuperview];
            _catEyesView = nil;
        }
        [_moviePlayer shutdown];
        [_moviePlayer.view removeFromSuperview];
        _moviePlayer = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    // 如果切换主播, 取消之前的动画
    [self emitterLayerRemoveFromSuperlayer];
   
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:placeHolderUrl] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.parentVc showGifLoding:nil inView:self.placeHolderView];
            self.placeHolderView.image = [UIImage blurImage:image blur:0.8];
        });
    }];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [options setPlayerOptionIntValue:1  forKey:@"videotoolbox"];
    
    // 帧速率(fps) （可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
    [options setPlayerOptionIntValue:29.97 forKey:@"r"];
    // -vol——设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推
    [options setPlayerOptionIntValue:512 forKey:@"vol"];
    IJKFFMoviePlayerController *moviePlayer = [[IJKFFMoviePlayerController alloc] initWithContentURLString:flv withOptions:options];
    moviePlayer.view.frame = self.contentView.bounds;
    // 填充fill
    moviePlayer.scalingMode = IJKMPMovieScalingModeAspectFill;
    // 设置自动播放(必须设置为NO, 防止自动播放, 才能更好的控制直播的状态)
    moviePlayer.shouldAutoplay = NO;
    // 默认不显示
    moviePlayer.shouldShowHudView = NO;
    
    [self.contentView insertSubview:moviePlayer.view atIndex:0];
    
    [moviePlayer prepareToPlay];
    
    self.moviePlayer = moviePlayer;
    
    // 设置监听
    [self initObserver];
    
//    // 显示工会其他主播和类似主播
    [moviePlayer.view bringSubviewToFront:self.otherView];
    
    
}
-(void)emitterLayerRemoveFromSuperlayer{

    if (_emitterLayer) {
        [_emitterLayer removeFromSuperlayer];
        _emitterLayer = nil;
    }

}
-(void)initObserver{

    // 监听视频是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.moviePlayer];
    
}
- (void)didFinish
{
    NSLog(@"加载状态...%ld %ld %s", self.moviePlayer.loadState, self.moviePlayer.playbackState, __func__);
    // 因为网速或者其他原因导致直播stop了, 也要显示GIF
    if (self.moviePlayer.loadState & IJKMPMovieLoadStateStalled && !self.parentVc.gifView) {
        [self.parentVc showGifLoding:nil inView:self.moviePlayer.view];
        return;
    }
    //    方法：
    //      1、重新获取直播地址，服务端控制是否有地址返回。
    //      2、用户http请求该地址，若请求成功表示直播未结束，否则结束
    __weak typeof(self)weakSelf = self;
    [[NetWorkTool shareTool] GET:self.live.flv parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功%@, 等待继续播放", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败, 加载失败界面, 关闭播放器%@", error);
        [weakSelf.moviePlayer shutdown];
        [weakSelf.moviePlayer.view removeFromSuperview];
        weakSelf.moviePlayer = nil;
        weakSelf.endView.hidden = NO;
    }];
}

#pragma mark - notify method
- (void)stateDidChange
{
    if ((self.moviePlayer.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        if (!self.moviePlayer.isPlaying) {
            [self.moviePlayer play];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_placeHolderView) {
                    [_placeHolderView removeFromSuperview];
                    _placeHolderView = nil;
                    [self.moviePlayer.view addSubview:_renderer.view];
                }
                [self.parentVc hideGifLoding];
            });
        }else{
            // 如果是网络状态不好, 断开后恢复, 也需要去掉加载
            if (self.parentVc.gifView.isAnimating) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.parentVc hideGifLoding];
                });
                
            }
        }
    }else if (self.moviePlayer.loadState & IJKMPMovieLoadStateStalled){ // 网速不佳, 自动暂停状态
        [self.parentVc showGifLoding:nil inView:self.moviePlayer.view];
    }
}





#pragma mark  自动弹幕
- (void)autoSendBarrage
{
    NSInteger spriteNumber = [_renderer spritesNumberWithName:nil];
    if (spriteNumber <= 50) { // 限制屏幕上的弹幕量
        [_renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionB2T]];
    }
}
#pragma mark - 弹幕描述符生产方法

long _index = 0;
/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = self.danMuText[arc4random_uniform((uint32_t)self.danMuText.count)];
    descriptor.params[@"textColor"] = KColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256));
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    //打开_renderer的交互
    _renderer.view.userInteractionEnabled = YES;
    descriptor.params[@"clickAction"] = ^{ //点击事件响应的前提是交互打开
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"弹幕被点击" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
        
    };
    return descriptor;
}

- (NSArray *)danMuText
{
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"danmu.plist" ofType:nil]];
}


//===========================懒加载   视图框架===========================

- (UIImageView *)placeHolderView
{
    if (!_placeHolderView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = self.contentView.bounds;
        imageView.image = [UIImage imageNamed:@"profile_user_414x414"];
        [self.contentView addSubview:imageView];
        _placeHolderView = imageView;
        [self.parentVc showGifLoding:nil inView:self.placeHolderView];
        // 强制布局
        [_placeHolderView layoutIfNeeded];
    }
    return _placeHolderView;
}


bool _isSelected = YES;
#pragma mark  底部栏
- (LivingBottomToolView *)toolView
{
    if (!_toolView) {
        LivingBottomToolView *toolView = [[LivingBottomToolView alloc] init];
        [toolView setClickToolBlock:^(LiveToolType type) {
            switch (type) {
                case LiveToolTypePublicTalk: //公聊
                    _isSelected = !_isSelected;
                    _isSelected ? [_renderer start] : [_renderer stop];
                    break;
                case LiveToolTypePrivateTalk://私聊
                    [self showInfo:@"私聊"];
                    break;
                case LiveToolTypeGift://礼物
//                    [self showInfo:@"礼物"];
                    [self giveGift];
                    break;
                case LiveToolTypeRank://排名
                    [self showInfo:@"排名"];
                    break;
                case LiveToolTypeShare://分享
                    [self showInfo:@"分享"];
                    break;
                case LiveToolTypeflower://分享
                    [self giveLove];
                    break;
                case LiveToolTypeClose://退出
                    [self quitOut];
                    break;
                default:
                    break;
            }
        }];
        [self.contentView insertSubview:toolView aboveSubview:self.placeHolderView];
        [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@-10);
            make.height.equalTo(@34);
        }];
        _toolView = toolView;
    }
    return _toolView;
}
-(void)giveLove{
    // 开始来访动画
    [self.emitterLayer setHidden:NO];
//
//            // 创建粒子
                // 发射单元
                CAEmitterCell *stepCell = [CAEmitterCell emitterCell];
                // 粒子的创建速率，默认为1/s
                stepCell.birthRate = 1;
                // 粒子存活时间
//                stepCell.lifetime = arc4random_uniform(4) + 1;
             stepCell.lifetime = 4;
                // 粒子的生存时间容差
                stepCell.lifetimeRange = 1.5;
                // 颜色
                // fire.color=[[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]CGColor];
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"good%d_30x30", arc4random_uniform(10)]];
                // 粒子显示的内容
                stepCell.contents = (id)[image CGImage];
                // 粒子的名字
                //            [fire setName:@"step%d", i];
                // 粒子的运动速度
                stepCell.velocity = arc4random_uniform(100) + 100;
                // 粒子速度的容差
                stepCell.velocityRange = 80;
                // 粒子在xy平面的发射角度
                stepCell.emissionLongitude = M_PI+M_PI_2;;
                // 粒子发射角度的容差
                stepCell.emissionRange = M_PI_2/6;
                // 缩放比例
                stepCell.scale = 0.4;
                [_loveArr addObject:stepCell];
    
            self.emitterLayer.emitterCells = _loveArr;
            [self.moviePlayer.view.layer insertSublayer:self.emitterLayer below:self.catEyesView.layer];
    //3秒后self.state的值自动改变
    [self performSelector:@selector(changeState) withObject:nil afterDelay:4];
    
    //用KVO监听self.state 的改变 如果改变了就遗传
    [self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)changeState{
    self. state = 2;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [self emitterLayerRemoveFromSuperlayer];
        [_loveArr removeAllObjects];
}
#pragma mark  退出
- (void)quitOut
{
    if (_catEyesView) {
        [_catEyesView removeFromSuperview];
        _catEyesView = nil;
    }
    
    if (_moviePlayer) {
        [self.moviePlayer shutdown];
        self.moviePlayer =nil;
        [self.moviePlayer.view removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    [_renderer stop];
    [_renderer.view removeFromSuperview];
    _renderer = nil;
    [self.parentVc dismissViewControllerAnimated:YES completion:nil];
}

- (LivingAnchorView *)anchorView
{
    if (!_anchorView) {
        _anchorView = [LivingAnchorView LivingAnchorView];
        [_anchorView setClickDeviceShow:^(bool isSelected) {
            if (_moviePlayer) {
//                _moviePlayer.shouldShowHudView = !isSelected;
                //关注按钮点击
#warning  TODO   关注
                //长度变化
                [UIView animateWithDuration:1.2 animations:^{
                   _anchorView.wideConstraint.constant = 140;
                    _anchorView. nameLabeTrailConstration.constant = 11;
                   [_anchorView layoutIfNeeded];
                    _anchorView.careBtn.hidden = !isSelected;
                }];
            }
        }];
        [self.contentView insertSubview:_anchorView aboveSubview:self.placeHolderView];
        [_anchorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@100);
            make.top.equalTo(@0);
        }];
       
    }
    return _anchorView;
}
- (CatEyesView *)catEyesView
{
    if (!_catEyesView) {
        CatEyesView *catEyesView = [CatEyesView catEarView];
//        [self.contentView insertSubview:catEyesView aboveSubview:self.placeHolderView];
        [self.moviePlayer.view addSubview:catEyesView];
        [catEyesView setCoverBtnClickBlock:^{
            [self clickCatEar];
        }];
        [catEyesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-30);
            make.centerY.equalTo(self.moviePlayer.view);
            make.width.height.equalTo(@98);
        }];
        _catEyesView = catEyesView;
    }
    return _catEyesView;
}
- (void)clickCatEar
{
    if (self.clickRelatedLive) {
        self.clickRelatedLive();
    }
}

#pragma mark  同一工会
- (UIImageView *)otherView
{
    if (!_otherView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"private_icon_70x70"]];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOther)]];
        [self.contentView insertSubview:imageView aboveSubview:self.placeHolderView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.catEyesView);
            make.bottom.equalTo(self.catEyesView.mas_top).offset(-40);
        }];
        _otherView = imageView;
    }
    return _otherView;
}


- (NSArray *)otheAnchorUser
{
    if (!_otheAnchorUser) {  //暂时用这个 数据  后面再换成实际网络获取到的数据
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"user.plist" ofType:nil]];
        _otheAnchorUser = [User mj_objectArrayWithKeyValuesArray:array];
    }
    return _otheAnchorUser;
}
#pragma mark 同工会点击
- (void)clickOther
{
    self.otheAnchorView.audienceUsers =   self.otheAnchorUser;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.otheAnchorView.hidden = NO;
        self.otheAnchorView.transform = CGAffineTransformMakeTranslation(-70, 0);
        
    } completion:^(BOOL finished) {

    }];
}
#pragma mark 送礼
-(void)giveGift{
    self.giftView.inter = 1;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.giftView.hidden = NO;
        self.giftView.transform = CGAffineTransformMakeTranslation(0, -120);
        
    } completion:^(BOOL finished) {
        
    }];
    

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:1.0 animations:^{
        self.otheAnchorView.transform = CGAffineTransformIdentity;
        self.giftView.transform = CGAffineTransformIdentity;
        
        } completion:^(BOOL finished) {
        self.otheAnchorView.hidden = YES;
        self.giftView.hidden = YES;
    }];
    
}
- (LiveEndView *)endView
{
    if (!_endView) {
        LiveEndView *endView = [LiveEndView liveEndView];
        [self.contentView addSubview:endView];
        [endView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        [endView setQuitBlock:^{
            [self quitOut];
        }];
        [endView setLookOtherBlock:^{
            [self clickCatEar];
        }];
        [endView setCareBlock:^{
            //关注  当前主播
#warning    TODO
        }];
        _endView = endView;
    }
    return _endView;
}

-(OtheAnchorView *)otheAnchorView{
    if (!_otheAnchorView ) {
       OtheAnchorView*otheAnchorView = [[OtheAnchorView alloc] initWithFrame:CGRectMake(KScreenWidth, 60, 60, 360)];
        otheAnchorView.hidden = YES;
        //添加最右边同频道主播视图
        [self.contentView addSubview:otheAnchorView ];
        [self.contentView bringSubviewToFront:otheAnchorView];

        _otheAnchorView = otheAnchorView;

//        otheAnchorView.transform = CGAffineTransformIdentity;
       
        
    }
    return _otheAnchorView;
}

-(GiftView*)giftView{

    if (!_giftView) {
        GiftView* giftView =[[GiftView alloc] initWithFrame:CGRectMake(0,KScreenHeight , KScreenWidth, 80)];
        [self.contentView addSubview:giftView];
        [giftView setClickToolBlock:^(LiveGiftType type) {
            switch (type) {
                case LiveGiftporsche://跑车
                    [self givePorscheGift];
                    break;
                case LiveGiftfighter://战斗机
                     [self givefighterGift];
                    break;
                case LiveGiftplane://客机
                    [self giveplaneGift];
                    break;
                case LiveGiftflower_a://鲜花
                    [self giveflower_aGift];
                    break;
                default:
                    break;
            }
        }];
        giftView.hidden =YES;
        _giftView = giftView;
    }
    return _giftView;
}
#pragma mark  跑车
-(void)givePorscheGift{
    NHCarViews *car = [NHCarViews loadCarViewWithPoint:CGPointZero];
    
    //数组中放CGRect数据，CGRect的x和y分别作为控制点的x和y，CGRect的width和height作为结束点的x和y
    //方法如下：数组内的每个元素代码一个控制点和结束点
    NSMutableArray *pointArrs = [[NSMutableArray alloc] init];
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 2;
    [pointArrs addObject:NSStringFromCGRect(CGRectMake(width, 300, width, 300))];
    //    pointArrs addObject:...添加更多的CGRect
    car.curveControlAndEndPoints = pointArrs;
    
    [car addAnimationsMoveToPoint:CGPointMake(0, 100) endPoint:CGPointMake(KScreenWidth +166, 500)];
    [self.contentView addSubview:car];
}
#pragma mark  战斗机
-(void)givefighterGift{
    NHFighterView *fighter = [NHFighterView loadFighterViewWithPoint:CGPointMake(10, 100)];
    //fighter.curveControlAndEndPoints 用法同carView一样
    [fighter addAnimationsMoveToPoint:CGPointMake(KScreenWidth, 60) endPoint:CGPointMake( -500, 600)];
    [self.contentView addSubview:fighter];
}
#pragma mark  客机
-(void)giveplaneGift{
    NHPlaneViews *plane = [NHPlaneViews loadPlaneViewWithPoint:CGPointMake(NHBounds.width + 232, 0)];
    //plane.curveControlAndEndPoints 用法同carView一样
    
    [plane addAnimationsMoveToPoint:CGPointMake(NHBounds.width, 100) endPoint:CGPointMake(-500, 410)];
    [self.contentView addSubview:plane];
}
#pragma mark 鲜花
-(void)giveflower_aGift{
    if (_flower == nil) {
        [self addFlowerView];
    }else{
        _flower.effect = NHSendEffectSpring;
        //_flower.scaleValue = @[@4.2,@3.5,@1.2,@3.8,@3.3,@3.0,@2.0,@1.0];
        [_flower continuePresentFlowers];
    }

}
- (void)addFlowerView{
    NHPresentFlower *flower = [[NHPresentFlower alloc] initWithFrame:CGRectMake(0, 200, KScreenWidth, 50)presentFlowerEffect:NHSendEffectShake];
    flower.autoHiddenTime = 5;
    [self.contentView addSubview:flower];
    _flower = flower;
}


@end
