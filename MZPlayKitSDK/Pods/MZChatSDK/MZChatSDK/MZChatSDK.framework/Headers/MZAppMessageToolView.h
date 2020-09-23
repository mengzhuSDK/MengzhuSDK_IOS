//
//  VHMessageToolView.h
//  vhall1
//
//  Created by vhallrd01 on 14-6-20.
//  Copyright (c) 2014年 vhallrd01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZChatPrefixHeader.h"
#import "DXFaceView.h"
#import "MZBarrageSwitch.h"

#define kInputTextViewMinHeight 32*MZ_RATE
#define kInputTextViewMaxHeight 32*MZ_RATE
#define kHorizontalPadding 56*MZ_RATE
#define kVerticalPadding 6*MZ_RATE

@protocol MZAppMessageToolBarDelegate <NSObject>
//专门为播放器（可以发弹幕消息的）
- (void)didSendText:(NSString *)text userName:(NSString *)userName joinID:(NSString *)joinID isBarrage:(BOOL)isBarrage;
//其他播放器（不可以发弹幕消息的）
- (void)didSendText:(NSString *)text userName:(NSString *)userName joinID:(NSString *)joinID;
@optional
//- (void)barrageSwithChanged:(BOOL)result;
- (void)didChangeFrameToHeight:(CGFloat)toHeight;

- (void)cancelTextView;

-(void)textViewDidChangedCallBack:(UITextView *)textView;

@end

@interface MZAppMessageToolView : UIView <UITextViewDelegate,DXFaceDelegate>
{
    CGFloat _previousTextViewContentHeight;//上一次inputTextView的contentSize.height
}

@property (strong, nonatomic) UIView *toolBackGroundView;

@property (strong, nonatomic) MZMessageTextView *msgTextView;

@property (strong, nonatomic) UIButton *sendButton;

@property (nonatomic,assign) CGFloat maxTextInputViewHeight;

@property (weak, nonatomic) id<MZAppMessageToolBarDelegate> delegate;
@property (assign, nonatomic) BOOL isCanHaveBarrage;//是否允许有弹幕开关（目前只有横竖播放器，发直播页面有弹幕，其他没有）
@property (strong, nonatomic) UIButton *smallButton;
@property (strong, nonatomic) UIButton *emojiCenterView;
@property (nonatomic,assign) CGRect faceRect;
@property(nonatomic,assign) int  maxLength;//最大字符个数

/**
 *  表情的附加页面
 */
@property (strong, nonatomic) UIView *faceView;

@property (nonatomic ,copy)NSString *userName;
@property (nonatomic ,copy)NSString *joinID;

/**
 *  底部扩展页面
 */
@property (nonatomic,assign) BOOL isShowButtomView;
@property (strong, nonatomic) UIView *activityButtomView;//当前活跃的底部扩展页面

@property (nonatomic,assign) NSInteger type;

@property(nonatomic,copy)NSString * tempString;
/**
 *  弹幕开关
 */
@property (nonatomic,assign) BOOL isHaveBarrageView;
@property (nonatomic ,strong) MZBarrageSwitch *barrageSwitch;

+(CGFloat)defaultHeight;

-(BOOL)endEditing:(BOOL)force;

-(void)beginFaceViewInView;


- (id)initWithFrame:(CGRect)frame type:(NSInteger)type;//这个是type为0或3，type为2要用下面这个

- (id)initWithFrame:(CGRect)frame type:(NSInteger)type textView:(MZMessageTextView *)textView;

- (void)addKeyBoardNoti;
- (void)removeKeyBoardNoti;

-(void)sendButtonTouchUpInside;
@end
