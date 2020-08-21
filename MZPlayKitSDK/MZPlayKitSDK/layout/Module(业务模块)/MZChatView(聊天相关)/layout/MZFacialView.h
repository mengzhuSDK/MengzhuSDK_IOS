//
//  MZFacialView.h
//  MZKitDemo
//
//  Created by 李风 on 2020/8/18.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZFaceKeyboard.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MZFacialViewDelegate <MZFaceKeyboardDelegate>

@optional
- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete;
- (void)sendFace;

@end

@interface MZFacialView : UIView<MZFaceKeyboardDelegate,UIScrollViewDelegate>

@property (nonatomic,   weak) id <MZFacialViewDelegate> delegate;

@property (nonatomic, strong) UIScrollView *faceScrollView;
@property (nonatomic, strong) UIPageControl *facePageControl;

// 字符串是否是表情
- (BOOL)stringIsFace:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
