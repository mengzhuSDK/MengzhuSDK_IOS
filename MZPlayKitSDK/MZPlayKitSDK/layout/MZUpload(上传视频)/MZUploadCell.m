//
//  MZUploadCell.m
//  MZKitDemo
//
//  Created by 李风 on 2020/10/13.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZUploadCell.h"
#import "MZUploadProgressView.h"

@interface MZUploadCell()
@property (nonatomic, strong) UIButton *menuButton;//菜单
@property (nonatomic, strong) UILabel *progressLabel;//进度百分比
@property (nonatomic, strong) MZUploadProgressView *progressView;//进度条

@property (nonatomic, strong) UIImageView *iconImageView;//任务图标
@property (nonatomic, strong) UILabel *nameLabel;//任务名字

@property (nonatomic, strong) MZUploadVideoModel *loader;//任务模型
@end

@implementation MZUploadCell

- (void)dealloc {
    if (self.loader.progressBlock) {
        self.loader.progressBlock = nil;
    }
    NSLog(@"cell释放了，记得销毁block监听");
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
        self.menuButton.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width - 120, 135 - 10 - 6 - 32, 100, 32);
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
        
        self.progressView = [[MZUploadProgressView alloc] initWithFrame:CGRectMake(self.nameLabel.left, self.progressLabel.top - 4 - 5,  UIScreen.mainScreen.bounds.size.width - self.nameLabel.left - 9, 4) color:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1]];
        self.progressView.progress = 0;
        [self.contentView addSubview:self.progressView];
        
        UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 135 - 10, UIScreen.mainScreen.bounds.size.width, 10)];
        spaceView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:spaceView];
        
    }
    return self;
}

- (void)update:(MZUploadVideoModel *)loader {
    self.loader = loader;

    self.nameLabel.text = loader.file_name;
    
    // 获取任务的状态
    MZUploadVideoState state = self.loader.state;
    
    if (state == MZUploadVideoState_NoStart || state == MZUploadVideoState_Cancel) {
        [self.menuButton setTitle:@"开始上传" forState:UIControlStateNormal];
    } else if (state == MZUploadVideoState_Cancel) {
        [self.menuButton setTitle:@"已经取消" forState:UIControlStateNormal];
    } else if (state == MZUploadVideoState_Fail) {
        [self.menuButton setTitle:@"上传失败" forState:UIControlStateNormal];
    } else if (state == MZUploadVideoState_Finish) {
        [self.menuButton setTitle:@"已完成" forState:UIControlStateNormal];
    } else if (state == MZUploadVideoState_Uploading) {
        [self.menuButton setTitle:@"暂停" forState:UIControlStateNormal];
    } else if (state == MZUploadVideoState_Pause) {
        [self.menuButton setTitle:@"继续上传" forState:UIControlStateNormal];
    }
    
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f%%",loader.progress*100];
    self.progressView.progress = loader.progress;
    if (loader.progress >= 1)  {
        self.progressLabel.text = [NSString stringWithFormat:@"total：%.2f M",self.loader.file_size/1024.0/1024.0];
    }
    
    __weak typeof(self) weakSelf = self;
    self.loader.progressBlock = ^(int64_t totalByteSent, int64_t totalBytesExpectedToSend, CGFloat progress) {
        NSLog(@"cell的任务进度 = %f",progress);
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.progressLabel.text = [NSString stringWithFormat:@"%.2f%%",progress*100];
            weakSelf.progressView.progress = progress;
        });
    };
    
    self.loader.resultBlock = ^(id  _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"任务上传失败 file_name = %@, error = %@, errorMessage = %@",weakSelf.loader.file_name,error.domain,error.userInfo[@"ErrorMessage"]);
                if (weakSelf.loader.state == MZUploadVideoState_Fail) {
                    [weakSelf.menuButton setTitle:@"上传失败" forState:UIControlStateNormal];
                }
            } else {
                NSLog(@"任务上传完成 file_name = %@, file_size = %lld",weakSelf.loader.file_name, weakSelf.loader.file_size);
                [weakSelf.menuButton setTitle:@"已完成" forState:UIControlStateNormal];
                weakSelf.progressLabel.text = [NSString stringWithFormat:@"total：%.2f M",weakSelf.loader.file_size/1024.0/1024.0];
                weakSelf.progressView.progress = 1.0f;
            }
        });
    };
}

/// 按钮点击
- (void)menuClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"开始上传"] || [sender.titleLabel.text isEqualToString:@"继续上传"] || [sender.titleLabel.text isEqualToString:@"已经取消"] || [sender.titleLabel.text isEqualToString:@"上传失败"]) {
        [self start];
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
    } else if ([sender.titleLabel.text isEqualToString:@"暂停"]) {
        [sender setTitle:@"继续上传" forState:UIControlStateNormal];
        [self pause];
    }
}

/// 开始上传
- (void)start {
    [[MZUploadVideoManager shareInstanced] resumeTask:self.loader];
}

/// 暂停上传
- (void)pause {
    [[MZUploadVideoManager shareInstanced] pauseTask:self.loader finish:^{
        NSLog(@"暂停成功");
    }];
}

/// cell进入复用池
- (void)prepareForReuse {
    [super prepareForReuse];
    NSLog(@"cell复用前，记得销毁block监听");
    if (self.loader.progressBlock) {
        self.loader.progressBlock = nil;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
