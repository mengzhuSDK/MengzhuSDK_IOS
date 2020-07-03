//
//  MZSmallPlayerView.m
//  MZKitDemo
//
//  Created by 李风 on 2020/5/11.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZSmallPlayerView.h"

typedef void(^MZ_Small_Finished)(void);

@interface MZSmallView : UIView
@property (nonatomic, copy) MZ_Small_Finished finished;
@property (nonatomic, strong) MZMediaPlayerView *show;

@property (nonatomic, assign) CGPoint lastTouchPt;

@end

@implementation MZSmallView

- (void)dealloc {
    NSLog(@"小窗口释放了");
}

- (void)layoutSubviews {
    self.show.frame = self.bounds;
    self.show.preview.frame = self.bounds;
}

- (instancetype)initWithFrame:(CGRect)frame show:(MZMediaPlayerView *)show finished:(MZ_Small_Finished)finished {
    self = [super initWithFrame:frame];
    if (self) {
        self.finished = finished;
        self.show = show;
        [self makeView];
    }
    return self;
}

- (void)makeView {

    self.show.frame = self.bounds;
    self.show.preview.frame = self.show.bounds;
    [self.show hideMediaControl];
    
    [self addSubview:self.show];
    
    self.userInteractionEnabled = YES;
    
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    view.userInteractionEnabled = YES;
    [self addSubview:view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [view addGestureRecognizer:tap];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"mz_small_close"] forState:UIControlStateNormal];
    [closeButton setFrame:CGRectMake(self.frame.size.width - 28, 0, 28, 28)];
    [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
}

- (void)hide {
    if (self.finished) {
        self.finished();
    }
    [self removeFromSuperview];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    self.lastTouchPt = [touch locationInView:self.superview];
}

//拖动窗口时移动窗口
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.superview];
    
    CGFloat offset_x = currentPoint.x - self.lastTouchPt.x;
    CGFloat offset_y = currentPoint.y - self.lastTouchPt.y;
    
    CGRect  destinationRect = CGRectOffset(self.frame, offset_x, offset_y);

    [self setFrame:destinationRect];
    self.lastTouchPt = currentPoint;
}

//移动到屏幕边界外时，需要移回屏幕内
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGFloat windowWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat windowHeight = UIScreen.mainScreen.bounds.size.height;
    CGRect  mainScreenRect = CGRectMake(0, 0, windowWidth, windowHeight);
    NSLog(@"frame = %@",NSStringFromCGRect(mainScreenRect));
    if(!CGRectContainsRect(mainScreenRect, self.frame)){
        CGFloat     offsetX =   0.0;
        CGFloat     offsetY =   0.0;
        if (windowWidth > windowHeight) {
            if (self.top < 0) {
                offsetY = fabs(self.top - 0);
            }
        } else {
            if(self.top < 20){
                offsetY = fabs(self.top - 20);
            }
        }
        if(self.bottom > windowHeight){
            offsetY = windowHeight - self.bottom;
        }
        if(self.left < 0){
            offsetX = fabs(self.left);
        }
        if(self.right > windowWidth){
            offsetX = windowWidth - self.right;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            [self setFrame:CGRectOffset(self.frame, offsetX, offsetY)];
        }];
    }
}

@end


@implementation MZSmallPlayerView

+ (void)show:(MZMediaPlayerView *)playView finished:(void(^)(void))finished {
    [self hide];
    
    CGFloat space = MZ_RATE;
    if (UIScreen.mainScreen.bounds.size.width > UIScreen.mainScreen.bounds.size.height) {
        space = MZ_FULL_RATE;
    }
    
    MZSmallView *smallView = [[MZSmallView alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width - 193*space - 20, 80, 193*space, 108*space) show:playView finished:finished];
    smallView.clipsToBounds = YES;
    smallView.userInteractionEnabled = YES;
    smallView.tag = 121;
    [UIApplication.sharedApplication.keyWindow addSubview:smallView];
}

+ (void)hide {
    MZSmallView *smallView = [UIApplication.sharedApplication.keyWindow viewWithTag:121];
    if (smallView) {
        [smallView hide];
    }
}


@end
