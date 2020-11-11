
#import <UIKit/UIKit.h>


#if MZHeight
#else

#define MZHeight [UIScreen mainScreen].bounds.size.height

#endif

#if MZWidth
#else

#define MZWidth [UIScreen mainScreen].bounds.size.width

#endif



#define MZFrameRight(frame) (frame.origin.x + frame.size.width)
#define MZFrameLeft(frame) (frame.origin.x)
#define MZFrameTop(frame) (frame.origin.y)
#define MZFrameBottom(frame) (frame.origin.y + frame.size.height)
#define MZFrameCenterY(frame) (frame.origin.y + frame.size.height/2)
#define MZFrameCenterX(frame) (frame.origin.x + frame.size.width/2)


@interface UIView (MZExtend)


@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;


@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat radius;


@property (nonatomic, assign) CGFloat   insideCenterX;
@property (nonatomic, assign) CGFloat   insideCenterY;
@property (nonatomic, assign) CGPoint   insideCenter;


/**
 *  自动从xib创建视图
 */
+(instancetype)viewFromXIB;


/*
 *  计算frame
 */
+(CGRect)frameWithW:(CGFloat)w h:(CGFloat)h center:(CGPoint)center;


/**
 *  添加一组子view：
 */
-(void)addSubviewsWithArray:(NSArray *)subViews;


/**
 *  批量移除视图
 *
 *  @param views 需要移除的视图数组
 */
+(void)removeViews:(NSArray *)views;

/**
 *  添加边框:四边
 */
-(void)setBorder:(UIColor *)color width:(CGFloat)width;



/**
 *  获取viewController
 */
- (UIViewController*)viewController;


/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawDashLine:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

/**
 *  查找NVG 的分割线 ---- navigationBar
 */
+ (UIImageView*)findHairlineImageViewUnder:(UIView*)view;



#pragma mark - subView操作
/**
 *  查找指定类型的subView 每个族列只有一次有效
 */
- (void)fintSubView:(Class)classs action:(void(^)(NSArray *subViews))actionBlock;


///变成圆角

-(instancetype)roundChangeWithRadius:(CGFloat)radius;


void runNSNumberXxxForLib();

- (void)addBottomLineLineHeight:(CGFloat)lineHeight;

- (void)addBottomLine;
- (void)addShortBottomLine;
-(void)addCustomBottomLineWithLeftRange:(CGFloat)LeftRange rightRange:(CGFloat)rightRange;

- (void)mz_setBackgroundImage:(UIImage *)image;
@end
