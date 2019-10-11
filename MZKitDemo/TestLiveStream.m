//
//  TestLiveStream.m
//  MZLiveSDK
//
//  Created by 孙显灏 on 2018/10/19.
//  Copyright © 2018年 孙显灏. All rights reserved.
//

#import "TestLiveStream.h"
#import "Constant.h"
//请修改此地址
static NSString *sRtmpUrl = @"rtmp://push.live.t.zmengzhu.com/mz/b89669465a1e020100081773?auth_key=1566322935-0-0-224c71aee788eb3c1ffc5e63bbe6a6bd";

@interface TestLiveStream()<MZAVCaptureDelegate,UITextFieldDelegate>{
    MZPushStreamManager *_manager;
}
//按钮
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *switchBtn;
@property (nonatomic,strong)UIButton *filterBtn;
@property (nonatomic,strong) UIButton *murroringBtn;


//状态
@property (nonatomic, strong) UILabel *stateLabel;

//预览
@property (nonatomic, strong) UIView *preview;

@property (nonatomic, weak) ViewController *viewController;
@property (nonatomic, assign) BOOL isFilter;
@property (nonatomic,assign)BOOL isMirroring;
@property (nonatomic, strong)UITextField        *fields;
@end
@implementation TestLiveStream
-(UIView *)preview{
    if (!_preview) {
        _preview = [UIView new];
        _preview.frame = self.viewController.view.bounds;
        [self.viewController.view addSubview:_preview];
        [self.viewController.view sendSubviewToBack:_preview];
    }
    return _preview;
}

-(instancetype)initWithViewController:(ViewController *)viewCtl{
    
    if (self = [super init]) {
        self.viewController = viewCtl;
        _manager=[[MZPushStreamManager alloc]init:MZAudioEncoderTypeHWAACLC videoEncoderType:MZVideoEncoderTypeHWH264];
        [self createUI];
    }
    
    return self;
}

-(void) createUI{
    self.preview.backgroundColor=[UIColor blueColor];
    [self.preview addSubview: _manager.preview];
    _manager.preview.center = self.preview.center;
    
    self.stateLabel = [[UILabel alloc] init];
    self.stateText = @"未连接";
    [self.viewController.view addSubview:self.stateLabel];
    
    self.startBtn = [[UIButton alloc] init];
    [self.startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.startBtn.backgroundColor = [UIColor blackColor];
    [self.startBtn setTitle:@"开始直播" forState:UIControlStateNormal];
    [self.startBtn addTarget:self action:@selector(onStartClick) forControlEvents:UIControlEventTouchUpInside];
    [self.viewController.view addSubview:self.startBtn];
    
    self.startBtn.layer.borderWidth = 0.5;
    self.startBtn.layer.borderColor = [[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1] CGColor];
    self.startBtn.layer.cornerRadius = 5;
    
    self.switchBtn = [[UIButton alloc] init];
    UIImage *switchImage = [self imageWithPath:@"camera_switch.png" scale:2];
    switchImage = [switchImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.switchBtn setImage:switchImage forState:UIControlStateNormal];
    [self.switchBtn setTintColor:[UIColor whiteColor]];
    [self.switchBtn addTarget:self action:@selector(onSwitchClick) forControlEvents:UIControlEventTouchUpInside];
    [self.viewController.view addSubview:self.switchBtn];
    self.filterBtn=[[UIButton alloc]init];
    [self.filterBtn setTitle:@"美颜" forState:UIControlStateNormal];
    [self.filterBtn addTarget:self action:@selector(onFilterClick) forControlEvents:UIControlEventTouchUpInside];
    [self.viewController.view addSubview:self.filterBtn];
    self.murroringBtn=[[UIButton alloc]init];
    [self.murroringBtn setTitle:@"镜像" forState:UIControlStateNormal];
    [self.murroringBtn addTarget:self action:@selector(onMirroring) forControlEvents:UIControlEventTouchUpInside];
    [self.viewController.view addSubview:self.murroringBtn];
    
}
-(UIImage *)imageWithPath:(NSString *)path scale:(CGFloat)scale{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:path ofType:nil];
    if (imagePath) {
        NSData *imgData = [NSData dataWithContentsOfFile:imagePath];
        if (imgData) {
            UIImage *image = [UIImage imageWithData:imgData scale:scale];
            return image;
        }
    }
    
    return nil;
}

-(void) onLayout{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    self.stateLabel.frame = CGRectMake(30, 130, 100, 30);
    
    self.startBtn.frame = CGRectMake(40, screenSize.height - 150 - 40, screenSize.width - 80, 40);
    
    self.switchBtn.frame = CGRectMake(screenSize.width - 30 - self.switchBtn.currentImage.size.width, 130, self.switchBtn.currentImage.size.width, self.switchBtn.currentImage.size.height);
    
    self.preview.frame = self.viewController.view.bounds;
    _manager.preview.frame = self.preview.bounds;
    self.filterBtn.frame=CGRectMake(self.stateLabel.frame.origin.x, self.stateLabel.frame.origin.y+50, 100, 30);
    self.murroringBtn.frame=CGRectMake(self.stateLabel.frame.origin.x, self.filterBtn.frame.origin.y+50, 100, 30);
    
    self.fields=[[UITextField alloc]init];
    self.fields.frame=CGRectMake(0, NavY+NavH+20, self.startBtn.frame.size.width, 30);
    self.fields.borderStyle = UITextBorderStyleRoundedRect;
    self.fields.delegate = self;
    self.fields.backgroundColor=[UIColor redColor];
    [self.viewController.view addSubview:self.fields];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
    
}

-(void) setStateText:(NSString *)stateText{
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:stateText
                                                                          attributes:@{
                                                                                       NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                       NSStrokeColorAttributeName: [UIColor blackColor],
                                                                                       NSStrokeWidthAttributeName: @(-0.5)
                                                                                       }];
    self.stateLabel.attributedText = attributeString;
}

-(void)avCapture:(mz_rtmp_state)fromState toState:(mz_rtmp_state)toState{
    switch (toState) {
        case mz_rtmp_state_idle: {
            self.startBtn.enabled = YES;
            [self.startBtn setTitle:@"开始直播" forState:UIControlStateNormal];
            self.stateText = @"未连接";
            break;
        }
        case mz_rtmp_state_connecting: {
            self.startBtn.enabled = NO;
            self.stateText = @"连接中";
            break;
        }
        case mz_rtmp_state_opened: {
            self.startBtn.enabled = YES;
            self.stateText = @"正在直播";
            break;
        }
        case mz_rtmp_state_connected: {
            self.stateText = @"连接成功";
            break;
        }
        case mz_rtmp_state_closed: {
            self.startBtn.enabled = YES;
            self.stateText = @"已关闭";
            break;
        }
        case mz_rtmp_state_error_write: {
            self.stateText = @"写入错误";
            break;
        }
        case mz_rtmp_state_error_open: {
            self.stateText = @"连接错误";
            self.startBtn.enabled = YES;
            break;
        }
        case mz_rtmp_state_error_net: {
            self.stateText = @"网络不给力";
            self.startBtn.enabled = YES;
            break;
        }
    }
}

-(void) onStartClick{
    if (_manager.isCapturing) {
        [self.startBtn setTitle:@"开始直播" forState:UIControlStateNormal];
        [_manager stopCapture];
    }else{
        if(self.fields.text!=nil&&![self.fields.text isEqualToString:@""]){
            sRtmpUrl=self.fields.text;
        }
        if ([_manager startCaptureWithRtmpUrl:sRtmpUrl]) {
            [self.startBtn setTitle:@"停止直播" forState:UIControlStateNormal];
        }
    }
}
//前后摄像头切换
-(void) onSwitchClick{
    [_manager switchCamera];
    
}
//切换美颜
-(void) onFilterClick{
    if(!self.isFilter){
        [_manager setBeautyFace:NO];
        self.isFilter=YES;
    }else{
        [_manager setBeautyFace:YES];
        self.isFilter=NO;
    }
}
//切换镜像
-(void) onMirroring{
    if(!self.isMirroring){
        [_manager setMirroring:NO];
        self.isMirroring=YES;
    }else{
        [_manager setMirroring:YES];
        self.isMirroring=NO;
    }
}

@end
