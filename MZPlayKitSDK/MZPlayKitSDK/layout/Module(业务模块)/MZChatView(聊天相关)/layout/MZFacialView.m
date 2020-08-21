//
//  MZFacialView.m
//  MZKitDemo
//
//  Created by 李风 on 2020/8/18.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZFacialView.h"
#import "MZFaceKeyboard.h"
#define FaceSectionBarHeight  36   // 表情下面控件
#define FacePageControlHeight 30  // 表情pagecontrol

@interface MZFacialView()
@property (nonatomic, strong) MZFaceKeyboard *faceKeyboard;
@property (nonatomic, strong) NSDictionary *faceDic;//表情字典
@end

@implementation MZFacialView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeView];
    }
    return self;
}

- (void)makeView {

    self.faceDic = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/mz_emoji_faceExpression.plist",[[MZEmojiLabel getEmojiBundle] bundlePath]]];

    int page = (self.faceDic.count % 20 > 0) ? (int)(self.faceDic.count / 20 + 1) : (int)(self.faceDic.count / 20);

    _faceScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _faceScrollView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f
                                                      green:247.0f/255.0f
                                                       blue:247.0f/255.0f
                                                      alpha:1.0f];
    _faceScrollView.delegate = self;
    [self addSubview:_faceScrollView];

    [_faceScrollView setPagingEnabled:YES];
    [_faceScrollView setShowsHorizontalScrollIndicator:NO];
    [_faceScrollView setContentSize:CGSizeMake(CGRectGetWidth(_faceScrollView.frame)*page,CGRectGetHeight(_faceScrollView.frame))];
    
    
    for (int i= 0; i<page; i++) {
        MZFaceKeyboard *faceView = [[MZFaceKeyboard alloc] initWithFrame:CGRectMake(i*CGRectGetWidth(self.bounds),0.0f,CGRectGetWidth(self.bounds),CGRectGetHeight(_faceScrollView.bounds))];
        faceView.faceDic = self.faceDic;
        [faceView loadFaceWithPageIndex:i];
        [_faceScrollView addSubview:faceView];
        faceView.delegate = self;
    }
    
    _facePageControl = [[UIPageControl alloc]init];
    [_facePageControl setFrame:CGRectMake(0,CGRectGetMaxY(_faceScrollView.frame) - 30,CGRectGetWidth(self.bounds),FacePageControlHeight)];
    [self addSubview:_facePageControl];
    [_facePageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [_facePageControl setCurrentPageIndicatorTintColor:[UIColor grayColor]];
    _facePageControl.numberOfPages = page;
    _facePageControl.currentPage   = 0;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:216.0f/255.0f
                                               green:216.0f/255.0f
                                                blue:216.0f/255.0f
                                               alpha:1.0f];
    [self addSubview:lineView];
}

#pragma mark  scrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = scrollView.contentOffset.x/UIScreen.mainScreen.bounds.size.width;
    _facePageControl.currentPage = page;
}


#pragma mark - MZFaceKeyboardDelegate
- (void)selectedFacialView:(NSString*)str {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedFacialView:isDelete:)]) {
        [self.delegate selectedFacialView:str isDelete:NO];
    }
}

- (void)deleteSelected:(NSString *)str {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedFacialView:isDelete:)]) {
        [self.delegate selectedFacialView:str isDelete:YES];
    }
}

- (void)sendFace {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendFace)]) {
        [self.delegate sendFace];
    }
}

#pragma mark - public
- (BOOL)stringIsFace:(NSString *)string {
    if ([self.faceKeyboard.faces containsObject:string]) {
        return YES;
    }
    return NO;
}

@end
