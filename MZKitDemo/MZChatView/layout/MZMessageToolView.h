//
//  VHMessageToolView.h
//  vhall1
//
//  Created by vhallrd01 on 14-6-20.
//  Copyright (c) 2014年 vhallrd01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZMessageTextView.h"
//#import "DXFaceView.h"
//#import "MZBarrageSwitch.h"

#define kInputTextViewMinHeight 32
#define kInputTextViewMaxHeight 32
#define kHorizontalPadding 56
#define kVerticalPadding 6

typedef enum : NSUInteger {
    MZMessageToolBarTypeAllBtn = 1,//有顶部toolBar的,且含有表情、输入框、发送按钮
    MZMessageToolBarTypeNoBar,//没有顶部toolBar的
    MZMessageToolBarTypeOnlyTextView,//只有输入框
    MZMessageToolBarTypeOnlyEmoji,//只有表情按钮
    MZMessageToolBarTypeOnlySend,//只有发送按钮
    MZMessageToolBarTypeOnlyTextAndSend,//只有输入框和发送按钮
    MZMessageToolBarTypeoOther,
} MZMessageToolBarType;

@protocol MZMessageToolBarDelegate <NSObject>
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

@interface MZMessageToolView : UIView<UITextViewDelegate>
{
    CGFloat _previousTextViewContentHeight;//上一次inputTextView的contentSize.height
}

@property (strong, nonatomic) UIView *toolBackGroundView;

@property (strong, nonatomic) MZMessageTextView *msgTextView;

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
@property (strong, nonatomic) UIView *faceView;

@property (nonatomic ,copy)NSString *userName;
@property (nonatomic ,copy)NSString *joinID;

/**
 *  底部扩展页面
 */
@property (nonatomic,assign) BOOL isShowButtomView;
@property (strong, nonatomic) UIView *activityButtomView;//当前活跃的底部扩展页面

@property (nonatomic,assign) MZMessageToolBarType type;

@property(nonatomic,copy)NSString * tempString;
/**
 *  弹幕开关
 */
@property (nonatomic,assign) BOOL isHaveBarrageView;
//@property (nonatomic ,strong) MZBarrageSwitch *barrageSwitch;

+(CGFloat)defaultHeight;

-(BOOL)endEditing:(BOOL)force;

-(void)beginFaceViewInView;


- (id)initWithFrame:(CGRect)frame type:(MZMessageToolBarType)type;//type为2要用下面这个
//MZMessageToolBarTypeNoBar 要用下面这个
- (id)initWithFrame:(CGRect)frame type:(MZMessageToolBarType)type textView:(MZMessageTextView *)textView;

- (void)addKeyBoardNoti;
- (void)removeKeyBoardNoti;

-(void)sendButtonTouchUpInside;
@end
