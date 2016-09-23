//
//  CatEyesView.m
//  miaoShow
//
//  Created by 汪凯 on 16/9/22.
//  Copyright © 2016年 汪凯. All rights reserved.
//

#import "CatEyesView.h"
#import "LiveListModel.h"
@interface CatEyesView()
@property (weak, nonatomic) IBOutlet UIView *playView;
/** 直播播放器 */
@property (nonatomic, strong) IJKFFMoviePlayerController *moviePlayer;
@end

@implementation CatEyesView
+ (instancetype)catEarView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.playView.layer.cornerRadius = self.playView.height * 0.5;
    self.playView.layer.masksToBounds = YES;
}
- (void)setLive:(LiveListModel *)live
{
    _live = live;
    
    // 设置只播放视频, 不播放声音
    // github详解: https://github.com/Bilibili/ijkplayer/issues/1491#issuecomment-226714613
    
    IJKFFOptions *option = [IJKFFOptions optionsByDefault];
    [option setPlayerOptionValue:@"1" forKey:@"an"];
    // 开启硬解码
    [option setPlayerOptionValue:@"1" forKey:@"videotoolbox"];
    IJKFFMoviePlayerController *moviePlayer = [[IJKFFMoviePlayerController alloc] initWithContentURLString:live.flv withOptions:option];
    
    moviePlayer.view.frame = self.playView.bounds;
    // 填充fill
    moviePlayer.scalingMode = IJKMPMovieScalingModeAspectFill;
    // 设置自动播放
    moviePlayer.shouldAutoplay = YES;
    
    [self.playView addSubview:moviePlayer.view];
    
    [moviePlayer prepareToPlay];
    self.moviePlayer = moviePlayer;
}

- (void)removeFromSuperview
{
    if (_moviePlayer) {
        [_moviePlayer shutdown];
        [_moviePlayer.view removeFromSuperview];
        _moviePlayer = nil;
    }
    [super removeFromSuperview];
}

- (IBAction)coverBtnClick:(id)sender {
    if (self.CoverBtnClickBlock) {
        self.CoverBtnClickBlock();
    }
}


@end
