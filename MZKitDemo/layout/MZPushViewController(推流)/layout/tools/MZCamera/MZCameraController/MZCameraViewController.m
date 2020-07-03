//
//  MZCameraViewController.m
//  MengZhu
//
//  Created by vhall on 16/12/2.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import "MZCameraViewController.h"
#import "MZCameraHelperView.h"
#import "UIViewController+MZShowMessage.h"

@interface MZCameraViewController ()<UIGestureRecognizerDelegate>
{
    UIView * _preView;
    MZCameraHelperView * _camera;
    UIButton * _swapBtn;
    UIButton * _flashBtn;
    UIView * _bgView;
    UIButton * _cancelBtn;
    UIButton * _usePhotoBtn;
    UIButton * _reTakeBtn;
    UIImageView * _imgeView;
    UIView * _shotImageView;
    UIView * _shotTopView;
    UIView * _shotBottomView;
    CGFloat    _currentScale;
    CGFloat    _mLastScale;
}
@end

@implementation MZCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self layoutUI];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
     [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [_camera startRuning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
     [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [_camera stopRuning];
}

-(void)setRatio:(CGFloat)ratio
{
    _ratio = ratio;
    if (self.isAllSizeImage) {
        _shotImageView.frame = CGRectMake(0, _imgeView.height / 2.0 - _imgeView.width / ratio / 2, _imgeView.width, _imgeView.width / ratio);
        _shotTopView.frame = CGRectMake(0, -_imgeView.height + _shotImageView.top, _shotImageView.width, _imgeView.height);
        _shotBottomView.frame = CGRectMake(0, _shotImageView.bottom, _shotImageView.width, _imgeView.height);
    }
}

- (void)layoutUI
{
    if(self.ratio <= 0){
        self.ratio = 16 / 9;
    }
    _preView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, MZ_SW, MZ_SH - kTopHeight - 125)];
    [self.view addSubview:_preView];
    _camera = [[MZCameraHelperView alloc]initWithMZCameraHelperView:CGRectMake(0, 0, _preView.width, _preView.height)];
    [_preView insertSubview:_camera atIndex:0];
    [self addPreViewGestureRecognizer];
    
    _swapBtn = [[UIButton alloc]initWithFrame:CGRectMake(MZ_SW - 45, 0, 40, 35)];
    [_swapBtn setImage:[UIImage imageNamed:@"MZCameraSwap"] forState:UIControlStateNormal];
    [_swapBtn addTarget:self action:@selector(swapCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_swapBtn];
    [_camera swapCamera:!self.isFontCamera];
    _swapBtn.selected = [_camera getCurrentCameraIsBack];

    _flashBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 0, 40, 40)];
    [_flashBtn setImage:[UIImage imageNamed:@"MZCameraFlash"] forState:UIControlStateNormal];
    _flashBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_flashBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [_flashBtn addTarget:self action:@selector(flashBtn:) forControlEvents:UIControlEventTouchUpInside];
    _flashBtn.hidden = !_swapBtn.selected;
    _flashBtn.selected = _swapBtn.selected;
    [self.view addSubview:_flashBtn];
    
    _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, MZ_SH - 65 , 50, 35)];
    _cancelBtn.backgroundColor = [UIColor clearColor];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBtn];
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(self.view.width / 2.0 - 32.5, _cancelBtn.center.y - 32.5, 65, 65)];
    _bgView.backgroundColor = self.view.backgroundColor;
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = _bgView.width / 2.0;
    _bgView.layer.borderColor = [UIColor whiteColor].CGColor;
    _bgView.layer.borderWidth = 5;
    [self.view addSubview:_bgView];
    
    UIButton * takePhotoBtn = [[UIButton alloc]initWithFrame:CGRectMake(7.5, 7.5, 50, 50)];
    [takePhotoBtn setBackgroundImage:[MZGlobalTools imageWithColor:MakeColorRGBA(0xffffff, 1.0) size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [takePhotoBtn setBackgroundImage:[MZGlobalTools imageWithColor:MakeColorRGBA(0xffffff, 0.7) size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
    [takePhotoBtn setBackgroundImage:[MZGlobalTools imageWithColor:MakeColorRGBA(0xffffff, 0.7) size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
    takePhotoBtn.layer.masksToBounds = YES;
    takePhotoBtn.layer.cornerRadius = takePhotoBtn.width / 2.0;
    [takePhotoBtn addTarget:self action:@selector(getImage) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:takePhotoBtn];
    
    _imgeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80, MZ_SW, MZ_SH - 160)];
    _imgeView.hidden = YES;
    [self.view addSubview:_imgeView];
    
    if (!self.isAllSizeImage) {
//        红色框框
        _shotImageView = [[UIView alloc]initWithFrame:CGRectMake(0, _imgeView.height / 2.0 - _imgeView.width * 9 / 16.0 / 2, _imgeView.width, _imgeView.width * 9 / 16.0)];
        _shotImageView.layer.masksToBounds = YES;
        _shotImageView.layer.borderWidth = 1.5;
        _shotImageView.hidden = _imgeView.hidden;
        _shotImageView.layer.borderColor = MakeColorRGB(0xff5b29).CGColor;
        [_imgeView addSubview:_shotImageView];
        _imgeView.clipsToBounds = YES;
        
        _shotTopView = [[UIView alloc]initWithFrame:CGRectMake(0, -_imgeView.height + _shotImageView.top, _shotImageView.width, _imgeView.height)];
        _shotTopView.backgroundColor = MakeColorRGBA(0x000000, 0.4);
        _shotTopView.hidden = YES;
        [_imgeView addSubview:_shotTopView];
        
        _shotBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _shotImageView.bottom, _shotImageView.width, _imgeView.height)];
        _shotBottomView.hidden = YES;
        _shotBottomView.backgroundColor = MakeColorRGBA(0x000000, 0.4);
        [_imgeView addSubview:_shotBottomView];
    }
    _shotImageView.frame = CGRectMake(0, _imgeView.height / 2.0 - _imgeView.width / self.ratio / 2, _imgeView.width, _imgeView.width / self.ratio);
    _shotTopView.frame = CGRectMake(0, -_imgeView.height + _shotImageView.top, _shotImageView.width, _imgeView.height);
    _shotBottomView.frame = CGRectMake(0, _shotImageView.bottom, _shotImageView.width, _imgeView.height);
    
    _reTakeBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, MZ_SH - 55 , 50, 35)];
    _reTakeBtn.backgroundColor = [UIColor clearColor];
    [_reTakeBtn setTitle:@"重拍" forState:UIControlStateNormal];
    [_reTakeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_reTakeBtn addTarget:self action:@selector(showPhoto) forControlEvents:UIControlEventTouchUpInside];
    _reTakeBtn.hidden = YES;
    [self.view addSubview:_reTakeBtn];
    
    _usePhotoBtn = [[UIButton alloc]initWithFrame:CGRectMake(MZ_SW - 95, MZ_SH - 55 , 85, 35)];
    _usePhotoBtn.backgroundColor = [UIColor clearColor];
    [_usePhotoBtn setTitle:@"使用照片" forState:UIControlStateNormal];
    [_usePhotoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_usePhotoBtn addTarget:self action:@selector(usePhoto) forControlEvents:UIControlEventTouchUpInside];
    _usePhotoBtn.hidden = YES;
    [self.view addSubview:_usePhotoBtn];
}

- (void)swapCamera:(UIButton *)btn
{
    BOOL isBack = btn.selected;
    btn.selected = !isBack;
    _flashBtn.hidden = !btn.selected;
    [_camera swapCamera:btn.selected];
}

- (void)flashBtn:(UIButton *)btn
{
    BOOL isFlash= btn.selected;
    btn.selected = !isFlash;
    [_camera setCameraFlashIsOpen:btn.selected];
}

- (void)getImage
{
    __weak typeof(self) weakSelf = self;
    [_camera captureImageBlock:^(UIImage *image) {
        if (image) {
            [weakSelf showImageView:image];
        }
    }];

}

- (void)showImageView:(UIImage *)image
{
    [_camera  stopRuning];
    [self removeViewGestureRecognizer:_preView];
    [self addVeiwGestureRecognizer];
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _camera.hidden = YES;
        _cancelBtn.hidden = YES;
        _swapBtn.hidden = YES;
        _bgView.hidden = YES;
    } completion:^(BOOL finished) {
        _imgeView.image = image;
        _imgeView.hidden = NO;
        _shotImageView.hidden = NO;
        _shotTopView.hidden = NO;
        _shotBottomView.hidden = NO;
        _reTakeBtn.hidden = NO;
        _usePhotoBtn.hidden = NO;
    }];
}

- (void)showPhoto
{
    [_camera startRuning];
    [self removeViewGestureRecognizer:_shotImageView];
    [self addPreViewGestureRecognizer];
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _imgeView.hidden = YES;
        _shotImageView.hidden = YES;
        _shotBottomView.hidden = YES;
        _shotTopView.hidden = YES;
        _reTakeBtn.hidden = YES;
        _usePhotoBtn.hidden = YES;
    } completion:^(BOOL finished) {
        _camera.hidden = NO;
        _cancelBtn.hidden = NO;
        _swapBtn.hidden = NO;
        _bgView.hidden = NO;
    }];
}

- (void)usePhoto
{
    UIImage * allSizeImage = _imgeView.image;
   UIImage * clipImage = [_camera clipImageInRect:CGRectMake(_shotImageView.left, _shotImageView.top, _shotImageView.width, _shotImageView.height) image:allSizeImage];
    if (self.block) {
        if (self.isAllSizeImage) {
            self.block(nil,allSizeImage);
        }
        else {
            self.block(clipImage,allSizeImage);
        }
        
        [self dismiss];
    }
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addPreViewGestureRecognizer
{
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(doPinchPreView:)];
    [_preView addGestureRecognizer:pinch];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_preView addGestureRecognizer:singleTap];
}

- (void)removeViewGestureRecognizer:(UIView *)view
{
    for (UIGestureRecognizer * gestureRecognizer in _preView.gestureRecognizers) {
        [view removeGestureRecognizer:gestureRecognizer];
    }
    _currentScale = 0;
    _mLastScale = 0;
}

- (void)doPinchPreView:(UIPinchGestureRecognizer*)pinch
{
    BOOL isIPhone4 = ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO);
    if (isIPhone4)
    {
        [self showTextView:self.view message:@"该设备不支持变焦"];
        return;
    }
    _currentScale += [pinch scale] - _mLastScale;
    _mLastScale    = [pinch scale];
    
    if (pinch.state == UIGestureRecognizerStateEnded)
    {
        _mLastScale = 1.0;
    }
    if (_currentScale <= 1.0f)
    {
        _currentScale = 1.0f;
    }
    else if(_currentScale >= 5.0f)
    {
        _currentScale = 5.0f;
    }
    [_camera setCameraScale:_currentScale];
}

-(void)handleSingleTap:(UITapGestureRecognizer*)sender
{
    //处理单击操作
    CGPoint point = [sender locationInView:self.view];
    [_camera setCameraFocus:point];
}

- (void)addVeiwGestureRecognizer
{
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(doPan:)];
    _imgeView.userInteractionEnabled = YES;
    pan.delegate = self;
    [_shotImageView addGestureRecognizer:pan];

}

- (void)doPan:(UIPanGestureRecognizer *)pan
{
    CGPoint pt = [pan translationInView:_shotImageView];
    pan.view.center = CGPointMake(pan.view.center.x +pt.x , pan.view.center.y+pt.y);
    if (pan.view.left < 0 || pan.view.left > 0) {
        [UIView animateWithDuration:0.2 animations:^{
            pan.view.center = CGPointMake(pan.view.center.x - pt.x, pan.view.center.y);
        } completion:^(BOOL finished) { }];
    }
    
    if (pan.view.top < 0 || pan.view.bottom > _imgeView.height) {
        [UIView animateWithDuration:0.2 animations:^{
            pan.view.center = CGPointMake(pan.view.center.x, pan.view.center.y - pt.y);
        } completion:^(BOOL finished) {}];
    }
    //每次移动完，将移动量置为0，否则下次移动会加上这次移动量
    [pan setTranslation:CGPointMake(0, 0) inView:self.view];
    _shotTopView.frame = CGRectMake(0, -_imgeView.height + _shotImageView.top, _shotImageView.width, _imgeView.height);
     _shotBottomView.frame = CGRectMake(0, _shotImageView.bottom, _shotImageView.width, _imgeView.height);
    if (pan.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"pan.view == %f", pan.view.center.x);
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    NSLog(@"translation == %f", translation.x);
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
