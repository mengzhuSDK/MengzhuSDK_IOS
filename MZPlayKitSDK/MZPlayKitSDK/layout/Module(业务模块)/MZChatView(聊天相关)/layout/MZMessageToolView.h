//
//  VHMessageToolView.h
//  vhall1
//
//  Created by vhallrd01 on 14-6-20.
//  Copyright (c) 2014年 vhallrd01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZFacialView.h"

#define kInputTextViewMinHeight 32
#define kInputTextViewMaxHeight 32
#define kHorizontalPadding 56
#define kVerticalPadding 6

typedef enum : NSUInteger {
    MZMessageToolBarTypeAllBtn = 1,//含有表情，输入框，发送按钮
    MZMessageToolBarTypeOnlyTextView,//只有输入框
    MZMessageToolBarTypeOnlyEmoji,//只有表情按钮+输入框
    MZMessageToolBarTypeOnlySend,//只有发送按钮+输入框
} MZMessageToolBarType;

@protocol MZMessageToolBarDelegate <NSObject>
@optional
//专门为播放器（可以发弹幕消息的）
- (void)didSendText:(NSString *)text userName:(NSString *)userName joinID:(NSString *)joinID isBarrage:(BOOL)isBarrage;
//其他播放器（不可以发弹幕消息的）
- (void)didSendText:(NSString *)text userName:(NSString *)userName joinID:(NSString *)joinID;

//- (void)barrageSwithChanged:(BOOL)result;
- (void)didChangeFrameToHeight:(CGFloat)toHeight;

- (void)cancelTextView;

-(void)textViewDidChangedCallBack:(UITextView *)textView;

@end

@interface MZMessageToolView : UIView<UITextViewDelegate,MZFacialViewDelegate>
{
    CGFloat _previousTextViewContentHeight;//上一次inputTextView的contentSize.height
}

@property (nonatomic, assign) BOOL isBanned;//是否被禁言
@property (nonatomic, assign) BOOL isBarrage;// 弹幕开关
@property (nonatomic, assign, readonly) BOOL isOnlyHostMessage;//是否 只展示主播的聊天信息

@property (strong, nonatomic) UIView *toolBackGroundView;

@property (strong, nonatomic) MZSDKMessageTextView *msgTextView;

@property (strong, nonatomic) UIButton *sendButton;

@property (nonatomic,assign) CGFloat maxTextInputViewHeight;

@property (weak, nonatomic) id<MZMessageToolBarDelegate> delegate;

@property (strong, nonatomic) UIButton *smallButton;
@property (strong, nonatomic) UIButton *emojiCenterView;
@property (nonatomic,assign) CGRect faceRect;
@property(nonatomic,assign) int  maxLength;//最大字符个数

/**
 *  表情的附加页面
 */
@property (strong, nonatomic) MZFacialView *portraitFacialView;
@property (strong, nonatomic) MZFacialView *landspaceFacialView;

@property (nonatomic ,copy)NSString *userName;
@property (nonatomic ,copy)NSString *joinID;

/**
 *  底部扩展页面
 */
@property (nonatomic,assign) BOOL isShowButtomView;
@property (strong, nonatomic) UIView *activityButtomView;//当前活跃的底部扩展页面

@property (nonatomic,assign) MZMessageToolBarType type;

@property (nonatomic,copy)NSString * tempString;

@property (nonatomic,assign)BOOL isLive;//是否是直播

+ (CGFloat)defaultHeight;

- (BOOL)endEditing:(BOOL)force;

- (void)beginFaceViewInView;

// 初始化
- (id)initWithFrame:(CGRect)frame type:(MZMessageToolBarType)type;
// 初始化 - isShowHostButton 当前的输入框是否显示 只看主播 按钮
- (id)initWithFrame:(CGRect)frame type:(MZMessageToolBarType)type isShowHostButton:(BOOL)isShowHostButton;

- (id)initWithFrame:(CGRect)frame type:(MZMessageToolBarType)type textView:(MZSDKMessageTextView *)textView;

// 监听 是否 只展示主播的聊天信息 状态的更改
- (void)listenOnlyHostState:(void(^)(BOOL isOnlyHostMessage))listenState;

- (void)addKeyBoardNoti;
- (void)removeKeyBoardNoti;

- (void)sendButtonTouchUpInside;
@end
