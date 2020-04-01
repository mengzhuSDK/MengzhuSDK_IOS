//
//  MZDownLoadCell.m
//  批量下载和m3u8批量下载
//
//  Created by 李风 on 2020/3/23.
//  Copyright © 2020 李风. All rights reserved.
//

#import "MZDownLoadCell.h"
#import <AVKit/AVKit.h>
#import "PlayerViewController.h"

@interface MZDownLoadCell()
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UILabel *progressLabel;

@property (nonatomic, strong) MZDownLoader *loader;
@property (nonatomic, strong) PlayerViewController *playVC;
@end

@implementation MZDownLoadCell

- (void)dealloc {
    NSLog(@"cell销毁啦");
    // 移除cell的代理
    [[MZDownLoaderCenter shareInstanced] removeDelegateWithLoader:self.loader];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        self.textLabel.numberOfLines = 0;
        self.textLabel.font = [UIFont systemFontOfSize:17];

        self.detailTextLabel.textColor = [UIColor redColor];
        
        self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.menuButton.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width - 100, 40, 80, 64);
        [self.menuButton setTitle:@"下载" forState:UIControlStateNormal];
        [self.menuButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.menuButton addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.menuButton];
        
        self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 150, 44)];
        self.progressLabel.backgroundColor = [UIColor redColor];
        self.progressLabel.textColor = [UIColor whiteColor];
//        [self.contentView addSubview:self.progressLabel];
        
    }
    return self;
}

- (void)update:(MZDownLoader *)loader {
    self.loader = loader;
    // 给cell添加当前任务的监听
    [[MZDownLoaderCenter shareInstanced] addDelegateWithTarget:self loader:self.loader];
    // 获取任务的下载地址
    self.textLabel.text = [[MZDownLoaderCenter shareInstanced] getTaskM3U8DownLoadURLString:self.loader];
    // 获取任务的缓存的进度
    NSString *str = [NSString stringWithFormat:@"%.2f%%",([[MZDownLoaderCenter shareInstanced] getTaskCacheProgress:self.loader] * 100)];

    self.detailTextLabel.text = str;
    // 获取任务的状态
    MZDownLoaderState state = [[MZDownLoaderCenter shareInstanced] getTaskState:self.loader];
    
    if (state == MZDownLoaderState_Finish) {
        [self.menuButton setTitle:@"播放" forState:UIControlStateNormal];
        self.progressLabel.text = [NSString stringWithFormat:@"total：%@",[[MZDownLoaderCenter shareInstanced] getFileSize:self.loader]];
    } else if (state == MZDownLoaderState_Stop || state == MZDownLoaderState_Pause || state == MZDownLoaderState_Fail) {
        [self.menuButton setTitle:@"继续" forState:UIControlStateNormal];
    } else if (state == MZDownLoaderState_Wait) {
        [self.menuButton setTitle:@"等待" forState:UIControlStateNormal];
    } else if (state == MZDownLoaderState_Downloading) {
        [self.menuButton setTitle:@"暂停" forState:UIControlStateNormal];
    }
    
    if (state != MZDownLoaderState_Finish) {
        self.progressLabel.text = @"下载中";
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
    });
}

-(void)downloaderFailed:(MZDownLoader *)download{
    
}

-(void)downloader:(MZDownLoader *)download Progress:(double)progess{
//    NSLog(@"progress = %f",progess);
    NSString *str = [NSString stringWithFormat:@"%.2f%%",progess*100];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.detailTextLabel.text = str;
    });
}


- (void)menuClick:(UIButton *)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
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
            NSLog(@"记得播放前先实力化sdk并且验证");
            self.playVC = [[PlayerViewController alloc] init];
            self.playVC.mvUrl = m3u8URLString;
            [[self viewController] presentViewController:self.playVC animated:YES completion:nil];

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
