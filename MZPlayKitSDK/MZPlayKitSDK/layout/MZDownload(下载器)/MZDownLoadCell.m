//
//  MZDownLoadCell.m
//  批量下载和m3u8批量下载
//
//  Created by 李风 on 2020/3/23.
//  Copyright © 2020 李风. All rights reserved.
//

#import "MZDownLoadCell.h"
#import <AVKit/AVKit.h>
#import "MZVerticalPlayerViewController.h"
#import "MZDownLoadProgressView.h"

@interface MZDownLoadCell()
@property (nonatomic, strong) UIButton *menuButton;//菜单
@property (nonatomic, strong) UILabel *progressLabel;//进度百分比
@property (nonatomic, strong) MZDownLoadProgressView *progressView;//进度条

@property (nonatomic, strong) UIImageView *iconImageView;//任务图标
@property (nonatomic, strong) UILabel *nameLabel;//任务名字

@property (nonatomic, strong) MZDownLoader *loader;//任务模型

@end

@implementation MZDownLoadCell

- (void)dealloc {
    NSLog(@"cell销毁啦");
    // 移除cell的代理
    [[MZDownLoaderCenter shareInstanced] removeDelegateWithLoader:self.loader];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 12, 97, 55)];
        self.iconImageView.image = [UIImage imageNamed:@"cover_default"];
        self.iconImageView.layer.cornerRadius = 7.0;
        self.iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.iconImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImageView.right + 9, 10, UIScreen.mainScreen.bounds.size.width - 16 - 97 - 18, 34)];
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.nameLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(16, 135 - 10 - 44 - 1, UIScreen.mainScreen.bounds.size.width - 16, 1)];
        line.backgroundColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1];
        [self.contentView addSubview:line];
        
        self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.menuButton.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width - 90, 135 - 10 - 6 - 32, 70, 32);
        [self.menuButton setTitle:@"下载" forState:UIControlStateNormal];
        [self.menuButton setTitleColor:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1] forState:UIControlStateNormal];
        [self.menuButton addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.menuButton];
        self.menuButton.layer.borderColor = [UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1].CGColor;
        self.menuButton.layer.borderWidth = 1.0;
        self.menuButton.layer.cornerRadius = 8;
        self.menuButton.layer.masksToBounds = YES;
        
        self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.left, line.top - 17, UIScreen.mainScreen.bounds.size.width - self.nameLabel.left - 9, 12)];
        self.progressLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:10];//普通
        self.progressLabel.backgroundColor = [UIColor clearColor];
        self.progressLabel.textColor = [UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1];
        [self.contentView addSubview:self.progressLabel];
        
        self.progressView = [[MZDownLoadProgressView alloc] initWithFrame:CGRectMake(self.nameLabel.left, self.progressLabel.top - 4 - 5,  UIScreen.mainScreen.bounds.size.width - self.nameLabel.left - 9, 4) color:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1]];
        self.progressView.progress = 0;
        [self.contentView addSubview:self.progressView];
        
        UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 135 - 10, UIScreen.mainScreen.bounds.size.width, 10)];
        spaceView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:spaceView];
        
    }
    return self;
}

- (void)update:(MZDownLoader *)loader {
    self.loader = loader;
    // 给cell添加当前任务的监听
    [[MZDownLoaderCenter shareInstanced] addDelegateWithTarget:self loader:self.loader];
    // 获取任务的下载地址
    self.nameLabel.text = [[MZDownLoaderCenter shareInstanced] getTaskM3U8DownLoadURLString:self.loader];
    // 获取任务的缓存的进度
    CGFloat progress = ([[MZDownLoaderCenter shareInstanced] getTaskCacheProgress:self.loader] * 100);
    NSString *str = [NSString stringWithFormat:@"%.2f%%",progress];

    self.progressLabel.text = str;
    self.progressView.progress = progress/100;
    // 获取任务的状态
    MZDownLoaderState state = [[MZDownLoaderCenter shareInstanced] getTaskState:self.loader];
    
    if (state == MZDownLoaderState_Finish) {
        [self.menuButton setTitle:@"播放" forState:UIControlStateNormal];
        self.progressLabel.text = [NSString stringWithFormat:@"total：%@",[[MZDownLoaderCenter shareInstanced] getFileSize:self.loader]];
        self.progressView.progress = 1.0;
    } else if (state == MZDownLoaderState_Stop || state == MZDownLoaderState_Pause || state == MZDownLoaderState_Fail) {
        [self.menuButton setTitle:@"继续" forState:UIControlStateNormal];
    } else if (state == MZDownLoaderState_Wait) {
        [self.menuButton setTitle:@"等待" forState:UIControlStateNormal];
    } else if (state == MZDownLoaderState_Downloading) {
        [self.menuButton setTitle:@"暂停" forState:UIControlStateNormal];
    }
}

- (void)downloaderStart:(MZDownLoader *)download {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.menuButton setTitle:@"暂停" forState:UIControlStateNormal];
    });
}

- (void)downloaderPause:(MZDownLoader *)download {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.menuButton setTitle:@"继续" forState:UIControlStateNormal];
    });
}

-(void)downloaderFinished:(MZDownLoader *)download{
    NSLog(@"这个任务下载完成了，按钮变成播放吧");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.menuButton setTitle:@"播放" forState:UIControlStateNormal];
        self.progressLabel.text = [NSString stringWithFormat:@"total：%@",[[MZDownLoaderCenter shareInstanced] getFileSize:self.loader]];
        self.progressView.progress = 1.0f;
    });
}

-(void)downloaderFailed:(MZDownLoader *)download{
    
}

-(void)downloader:(MZDownLoader *)download Progress:(double)progess{
//    NSLog(@"progress = %f",progess);
    NSString *str = [NSString stringWithFormat:@"%.2f%%",progess*100];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressLabel.text = str;
        self.progressView.progress = progess;
    });
}


- (void)menuClick:(UIButton *)sender {
//    sender.enabled = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        sender.enabled = YES;
//    });
    if ([sender.titleLabel.text isEqualToString:@"播放"]) {
        [self play];
    } else if ([sender.titleLabel.text isEqualToString:@"继续"]) {
        if ([self start]) {
            [sender setTitle:@"暂停" forState:UIControlStateNormal];
        } else {
            [sender setTitle:@"等待" forState:UIControlStateNormal];
        }
    } else if ([sender.titleLabel.text isEqualToString:@"等待"]) {
        [self pause];

        [sender setTitle:@"继续" forState:UIControlStateNormal];
    } else if ([sender.titleLabel.text isEqualToString:@"暂停"]) {
        [self pause];
        [sender setTitle:@"继续" forState:UIControlStateNormal];
    }
}

- (void)play {
    // 获取任务的本地播放地址
    [[MZDownLoaderCenter shareInstanced] getLocalPlayM3U8URLString:self.loader handle:^(NSString * _Nonnull m3u8URLString, NSString * _Nonnull errorString) {
        if (errorString.length) {
            NSLog(@"errorString = %@",errorString);
        } else {
            
            [MZSDKBusinessManager setDebug:YES];

            MZUser *user=[[MZUser alloc] init];
            user.appID = MZSDK_AppID;//线上模拟环境(这里需要自己填一下)
            user.secretKey = MZSDK_SecretKey;
            [MZBaseUserServer updateCurrentUser:user];
            
            MZVerticalPlayerViewController *liveVC = [[MZVerticalPlayerViewController alloc]init];
            liveVC.mvURLString = m3u8URLString;
            [[self viewController].navigationController pushViewController:liveVC animated:YES];
            
            return;
            
        }
    }];

    return;
    
//    [[MZDownLoaderCenter shareInstanced] getLocalM3U8Url:self.loader handle:^(NSURL * _Nonnull m3u8Url, NSString * _Nonnull errorString) {
//        if (errorString.length) {
//            NSLog(@"errorString = %@",errorString);
//        } else {
//            NSString *serverM3U8URLString = [[MZDownLoaderCenter shareInstanced] getTaskM3U8DownLoadURLString:self.loader];
//            NSLog(@"本地服务器 - 播放的URL地址为 = %@， 下载地址为 - %@", m3u8Url,serverM3U8URLString);
//
//            return;
//            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:m3u8Url];
//            AVPlayerViewController *ctr = [[AVPlayerViewController alloc] init];
//            ctr.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
//            ctr.modalPresentationStyle = UIModalPresentationFullScreen;
//            [[self viewController] presentViewController:ctr animated:YES completion:^{
//                [ctr.player play];
//            }];
//        }
//    }];
}

- (BOOL)start {
    if ([[MZDownLoaderCenter shareInstanced] start:self.loader] == NO) {
        NSLog(@"超过 你设置的同时下载的任务 个数");
        return NO;
    }
    return YES;
}

- (void)pause {
    [[MZDownLoaderCenter shareInstanced] pause:self.loader];
}

- (UIViewController *)viewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

@end
