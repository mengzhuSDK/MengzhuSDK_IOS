

#import <UIKit/UIKit.h>


@protocol SYMediaGesturesViewDelegate <NSObject>
//移动
-(void)touchesMovedWith:(CGPoint)point;
//开始
-(void)touchesBeganWith:(CGPoint)point;

@end


@interface SYMediaGesturesView : UIView

@property(nonatomic,assign) id<SYMediaGesturesViewDelegate>delegate;

@end
