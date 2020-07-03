//
//  MZLiveFinishViewController.m
//  MengZhu
//
//  Created by vhall on 16/6/27.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import "MZLiveFinishViewController.h"
#import "MZReadyLiveViewController.h"


//#import "MZChannelNewManagerViewController.h"
typedef enum {
    MZLiveFinishViewWXBtnTag,
    MZLiveFinishViewWXPYQBtnTag,
    MZLiveFinishViewWbBtnTag,
    MZLiveFinishViewQQBtnTag,
    MZLiveFinishViewBackBtnTag
}MZLiveFinishViewBtnTag;

@interface MZLiveFinishViewController ()
//{
//    UIImageView * _shareImageView;
////    UIButton *_setPlayBackBtn;
//}
@property (nonatomic ,strong)UIVisualEffectView *blurEffectBgView;
@property (nonatomic ,strong) UILabel *liveDurationLabel;
@property (nonatomic ,strong) UILabel *UVLabel;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *UIDLabel;
@property (nonatomic ,strong) UIImageView *avatarImageView;

@end

@implementation MZLiveFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseProperty];
    [self layoutUI];
    
}
- (void)setBaseProperty{
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendedLayoutIncludesOpaqueBars = YES;
}

// 支持设备自动旋转
- (BOOL)shouldAutorotate{
    return NO;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (void)layoutUI
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_finish"]];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurEffectBgView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.blurEffectBgView.frame = self.view.bounds;
    [self.view addSubview:self.blurEffectBgView];
    
//    star_finish
    UIImageView *starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_finish"]];
    [self.view addSubview:starImageView];
    starImageView.frame = CGRectMake((self.view.frame.size.width - 100)/.20, 82*MZ_RATE, 100*MZ_RATE, 100*MZ_RATE);
    
    UILabel *topLabel = [[UILabel alloc] init];
    [self.view addSubview:topLabel];
    topLabel.text = @"直播已结束";
    topLabel.textColor = MakeColorRGB(0xFFFFFF);
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.font = [UIFont fontWithName:@"PingFangSC" size: 24*MZ_RATE];
    topLabel.frame = CGRectMake(0, 195*MZ_RATE, self.view.frame.size.width, 30);
    
    UIView *containerView = [[UIView alloc] init];
    [self.view addSubview:containerView];
    containerView.backgroundColor = MakeColorRGBA(0x1D1B22, 0.4);
    [containerView roundChangeWithRadius:16*MZ_RATE];
    containerView.frame = CGRectMake((self.view.frame.size.width - 315*MZ_RATE)/2.0, 317*MZ_RATE, 315*MZ_RATE, 214*MZ_RATE);

    UIImageView *avatorImageView = [[UIImageView alloc] init];
    [self.view addSubview:avatorImageView];
    [avatorImageView roundChangeWithRadius:45*MZ_RATE];
    [avatorImageView setImage:[UIImage imageNamed:@"liveFinish_avator"]];
    avatorImageView.frame = CGRectMake((self.view.frame.size.width - 90*MZ_RATE)/2.0, containerView.frame.origin.y - 45*MZ_RATE, 90*MZ_RATE, 90*MZ_RATE);
    self.avatarImageView = avatorImageView;
    
    UILabel *topLabel1 = [[UILabel alloc] init];
    [self.view addSubview:topLabel1];
    topLabel1.text = @"快乐的咖啡豆";
    topLabel1.textColor = MakeColorRGB(0xFFFFFF);
    topLabel1.font = [UIFont systemFontOfSize:20*MZ_RATE];
    topLabel1.textAlignment = NSTextAlignmentCenter;
    topLabel1.frame = CGRectMake(0, containerView.frame.origin.y+52*MZ_RATE, self.view.frame.size.width, 30);
    self.nameLabel = topLabel1;
    
    UILabel *topLabel2 = [[UILabel alloc] init];
    self.UIDLabel = topLabel2;
    [self.view addSubview:topLabel2];
    topLabel2.text = @"ID：67581";
    topLabel2.textAlignment = NSTextAlignmentCenter;
    topLabel2.textColor = MakeColorRGBA(0xFFFFFF, 0.5);
    topLabel2.font = [UIFont systemFontOfSize:13*MZ_RATE];
    topLabel2.frame = CGRectMake(0, containerView.frame.origin.y+83*MZ_RATE, self.view.frame.size.width, 30);
    
    UILabel *topLabel3 = [[UILabel alloc] init];
    [self.view addSubview:topLabel3];
    topLabel3.textAlignment = NSTextAlignmentCenter;
    topLabel3.text = @"00:01:55";
    topLabel3.textColor = MakeColorRGB(0xFFFFFF);
    topLabel3.font = [UIFont systemFontOfSize:18*MZ_RATE];
    topLabel3.frame = CGRectMake(containerView.frame.origin.x, containerView.frame.origin.y+125*MZ_RATE, containerView.frame.size.width/2.0, 30);
    self.liveDurationLabel = topLabel3;
    
    UILabel *topLabel4 = [[UILabel alloc] init];
    [self.view addSubview:topLabel4];
    topLabel4.textAlignment = NSTextAlignmentCenter;
    topLabel4.text = @"直播时长";
    topLabel4.textColor = MakeColorRGBA(0xFFFFFF, 0.5);
    topLabel4.font = [UIFont systemFontOfSize:13*MZ_RATE];
    topLabel4.frame = CGRectMake(containerView.frame.origin.x, containerView.frame.origin.y+156*MZ_RATE, containerView.frame.size.width/2.0, 30);
    
    UILabel *topLabel5 = [[UILabel alloc] init];
    [self.view addSubview:topLabel5];
    topLabel5.textAlignment = NSTextAlignmentCenter;
    topLabel5.text = @"1471";
    topLabel5.textColor = MakeColorRGB(0xFFFFFF);
    topLabel5.font = [UIFont systemFontOfSize:18*MZ_RATE];
    topLabel5.frame = CGRectMake(topLabel4.frame.size.width+topLabel4.frame.origin.x, containerView.frame.origin.y+125*MZ_RATE, topLabel4.frame.size.width, 30);
    topLabel5.hidden = YES;
    
    UILabel *topLabel6 = [[UILabel alloc] init];
    [self.view addSubview:topLabel6];
    topLabel6.textAlignment = NSTextAlignmentCenter;
    topLabel6.text = @"关注量";
    topLabel6.textColor = MakeColorRGBA(0xFFFFFF, 0.5);
    topLabel6.font = [UIFont systemFontOfSize:13*MZ_RATE];
    topLabel6.frame = CGRectMake(topLabel5.frame.origin.x, containerView.frame.origin.y+156*MZ_RATE, topLabel5.frame.size.width, 30);
    topLabel6.hidden = YES;
    
    UILabel *topLabel7 = [[UILabel alloc] init];
    [self.view addSubview:topLabel7];
    topLabel7.textAlignment = NSTextAlignmentCenter;
    topLabel7.text = @"3.5万";
    topLabel7.textColor = MakeColorRGB(0xFFFFFF);
    topLabel7.font = [UIFont systemFontOfSize:18*MZ_RATE];
    topLabel7.frame = CGRectMake(topLabel3.frame.size.width+topLabel3.frame.origin.x, containerView.frame.origin.y+125*MZ_RATE, topLabel3.frame.size.width, 30);
    self.UVLabel = topLabel7;
    
    UILabel *topLabel8 = [[UILabel alloc] init];
    [self.view addSubview:topLabel8];
    topLabel8.textAlignment = NSTextAlignmentCenter;
    topLabel8.text = @"观看人数";
    topLabel8.textColor = MakeColorRGBA(0xFFFFFF, 0.5);
    topLabel8.font = [UIFont systemFontOfSize:13*MZ_RATE];
    topLabel8.frame = CGRectMake(topLabel7.frame.origin.x, containerView.frame.origin.y+156*MZ_RATE, topLabel7.frame.size.width, 30);
    
    CGFloat Yvalue = 22+2;
    if (IPHONE_X) {
        Yvalue+=22;
    }
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0,Yvalue, 60, 40)];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backToPreparation) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"navBar_left"] forState:UIControlStateNormal];

}
- (void)backToPreparation{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
    
    
//    for (UIViewController *subVC in self.navigationController.childViewControllers) {
//        if ([subVC isMemberOfClass:[MZReadyLiveViewController class]]) {
//            [self.navigationController popToViewController:subVC animated:YES];
//        }
//    }

}




- (void)backHome
{
    NSArray *childVCArr = self.navigationController.viewControllers;
    UIViewController *vc = childVCArr[childVCArr.count - 3];
    if([vc isKindOfClass:[MZReadyLiveViewController class]]){
        [self.navigationController.navigationBar setHidden:NO];
        [self.navigationController popToViewController:vc animated:NO];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
     self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController.navigationBar setHidden:NO];
}

-(BOOL)isOverTime:(NSString *)timeStr
{
    if (timeStr.length != 8) {
        return NO;
    }
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@":" withString:@""];
    for (int i = 0; i < timeStr.length - 2 ; i++) {
        NSString * tr = [timeStr substringWithRange:NSMakeRange(i, 1)];
        if (i < timeStr.length - 3) {
            if ([tr intValue] > 0) {
                return YES;
            }
        }
        else {
            if ([tr intValue] > 4) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"%@ dealloc",[[self class] description]);
}
- (void)setModel:(MZLiveFinishModel *)model{
    _model = model;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self updateSubviewsWithModel:model];
    });
}
-(void)updateSubviewsWithModel:(MZLiveFinishModel *)model{
    self.nameLabel.text = [MZUserServer currentUser].nickName;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[MZUserServer currentUser].avatar] placeholderImage:[UIImage imageNamed:@"liveFinish_avator"]];
    self.UIDLabel.text =[NSString stringWithFormat:@"ID:%@",[MZUserServer currentUser].userId] ;
    long seconds = [model.duration longLongValue] % 60;
    long minutes = ([model.duration longLongValue] / 60) % 60;
    long hours = [model.duration longLongValue] / 3600;
    self.liveDurationLabel.text = [NSString stringWithFormat:@"%0.2ld:%0.2ld:%0.2ld", hours, minutes, seconds];
    
    self.UVLabel.text = model.uv;
}
@end
