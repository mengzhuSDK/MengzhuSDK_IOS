//
//  MZMediaGesturesView.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/6/15.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, Direction) {
    DirectionLeftOrRight,
    DirectionUpOrDown,
    DirectionNone
};


@protocol MZMediaGesturesViewDelegate <NSObject>
@optional
//移动
-(void)touchesMovedWith:(CGPoint)point;
//开始
-(void)touchesBeganWith:(CGPoint)point;
//结束
-(void)touchesEndWith:(CGPoint)point;
//取消
-(void)touchesCancelWith:(CGPoint)point;
@end


@interface MZMediaGesturesView : UIView

@property(nonatomic,assign) id<MZMediaGesturesViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
