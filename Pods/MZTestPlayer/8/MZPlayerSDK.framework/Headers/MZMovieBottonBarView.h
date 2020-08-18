//
//  MZMovieBottonBarView.h
//  MengZhu
//
//  Created by 李伟 on 2018/8/14.
//  Copyright © 2018年 www.mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZSlider.h"
#import <MZCoreSDKLibrary/MZCoreSDKLibrary.h>

@interface MZMovieBottonBarView : UIView

@property (nonatomic ,strong)UIButton *playPauseBtn;
@property (nonatomic ,strong)UILabel *timeElapsedLabel;
@property (nonatomic ,strong)UILabel *timeRemainingLabel;
@property (nonatomic ,strong)MZSlider *durationSlider;
@property (nonatomic ,strong)UIButton *fullscreenBtn;
@property (nonatomic ,strong)UILabel    *division;
@property (nonatomic ,strong)MZAnimationView   *voiceAnimationView;



-(void)updateLayoutIsVoice:(BOOL)isLive isVoice:(BOOL)isVoice;
- (instancetype)initWithFrame:(CGRect)frame isFullScreen:(BOOL)isFullScreen;
//有片头视频的变换
//-(void)updateLayoutWithIsPlayingAD:(BOOL)isPlayingAD;
@end
