//
//  MZFaceKeyboard.m
//  MZKitDemo
//
//  Created by 李风 on 2020/8/18.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZFaceKeyboard.h"

#define NumPerLine 7
#define Lines    3
#define FaceSize  24
/*
 ** 两边边缘间隔
 */
#define EdgeDistance 20
/*
 ** 上下边缘间隔
 */
#define EdgeInterVal 20

@interface MZFaceKeyboard()

@end

@implementation MZFaceKeyboard

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

//给faces设置位置
- (void)loadFacialView:(int)page size:(CGSize)size {
    int maxRow = 5;
    int maxCol = 8;
    CGFloat itemWidth = self.frame.size.width / maxCol;
    CGFloat itemHeight = self.frame.size.height / maxRow;
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setBackgroundColor:[UIColor clearColor]];
    [deleteButton setFrame:CGRectMake((maxCol - 1) * itemWidth, (maxRow - 1) * itemHeight, itemWidth, itemHeight)];
    NSString *deleteImagePath = [NSString stringWithFormat:@"%@/mz_faceDelete",[[MZEmojiLabel getEmojiBundle] bundlePath]];
    [deleteButton setImage:[UIImage imageNamed:deleteImagePath] forState:UIControlStateNormal];
    deleteButton.tag = 10000;
    [deleteButton addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setFrame:CGRectMake((maxCol - 2) * itemWidth - 10, (maxRow - 1) * itemHeight + 5, itemWidth + 10, itemHeight - 10)];
    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setBackgroundColor:[UIColor colorWithRed:10 / 255.0 green:82 / 255.0 blue:104 / 255.0 alpha:1.0]];
    [self addSubview:sendButton];
    
    for (int row = 0; row < maxRow; row++) {
        for (int col = 0; col < maxCol; col++) {
            int index = row * maxCol + col;
            if (index < [_faces count]) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setBackgroundColor:[UIColor clearColor]];
                [button setFrame:CGRectMake(col * itemWidth, row * itemHeight, itemWidth, itemHeight)];
                [button.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:29.0]];
                [button setTitle: [_faces objectAtIndex:(row * maxCol + col)] forState:UIControlStateNormal];
                button.tag = row * maxCol + col;
                [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
            }
            else{
                break;
            }
        }
    }
}

- (void)loadFaceWithPageIndex:(NSInteger)index {
    // 水平间隔
    CGFloat horizontalInterval = (CGRectGetWidth(self.bounds)-NumPerLine*FaceSize -2*EdgeDistance)/(NumPerLine-1);
    // 上下垂直间隔
    CGFloat verticalInterval = (CGRectGetHeight(self.bounds)-2*EdgeInterVal -Lines*FaceSize)/(Lines-1);
    
    verticalInterval -= 10;
        
    for (int i = 0; i<Lines; i++) {
        for (int x = 0;x<NumPerLine;x++) {
            UIButton *expressionButton =[UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:expressionButton];
            [expressionButton setFrame:CGRectMake(x*FaceSize+EdgeDistance+x*horizontalInterval,
                                                  i*FaceSize +i*verticalInterval+EdgeInterVal,
                                                  FaceSize,
                                                  FaceSize)];
            
            if (i*7+x+1 ==21) {
                NSString *deleteImagePath = [NSString stringWithFormat:@"%@/mz_faceDelete",[[MZEmojiLabel getEmojiBundle] bundlePath]];
                [expressionButton setBackgroundImage:[UIImage imageNamed:deleteImagePath] forState:UIControlStateNormal];
                   expressionButton.tag = 10000;
                //加一个虚按钮   便于删除按钮灵活
                UIButton *delButton = [UIButton buttonWithType:UIButtonTypeCustom];
                CGRect rect = expressionButton.frame;
                rect.origin.x -= 10;
                rect.origin.y -= 10;
                rect.size.width += 20;
                rect.size.height += 20;
                delButton.frame = rect;
                delButton.tag = 10000;
                [delButton addTarget:self
                              action:@selector(selected:)
                    forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:delButton];
                
                
            }else{
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString *imageStr = [NSString stringWithFormat:@"%@/Expression_%d",[[MZEmojiLabel getEmojiBundle] bundlePath],
                                          (int)index*20+i*7+x+1];
                    UIImage *image = [UIImage imageNamed:imageStr];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        expressionButton.tag = 20*index+i*7+x+1;
                        [expressionButton addTarget:self
                                             action:@selector(faceClick:)
                                   forControlEvents:UIControlEventTouchUpInside];
                    [expressionButton setBackgroundImage:image
                                                    forState:UIControlStateNormal];
                    });
                });
                
            }
            
        }
    }
    
}

- (void)faceClick:(UIButton *)button {
    if (button.tag == 10000 && _delegate) {
        [_delegate deleteSelected:nil];
    }else{
        
        NSString *expressstring = [NSString stringWithFormat:@"Expression_%ld",(long)button.tag];
        
        NSString *faceName;
        for (int j = 0; j<[[_faceDic allValues]count]-1; j++)
        {
            NSString *value = [[_faceDic allValues] objectAtIndex:j];
            if ([value isEqualToString:expressstring])
            {
                faceName = [[_faceDic allKeys] objectAtIndex:j];
                break;
            }
            //            if ([[_faceDic objectForKey:[[_faceDic allKeys]objectAtIndex:j]]
            //                 isEqualToString:[NSString stringWithFormat:@"%@",expressstring]])
            //            {
            //                faceName = [[_faceDic allKeys]objectAtIndex:j];
            //                break;
            //            }
        }
        
        //    NSString *str = [_faceDic objectAtIndex:button.tag];
        if (_delegate) {
            [_delegate selectedFacialView:faceName];
        }
    }
}

-(void)selected:(UIButton*)bt
{
    if (bt.tag == 10000 && _delegate) {
        [_delegate deleteSelected:nil];
    }else{
        NSString *str = [_faces objectAtIndex:bt.tag];
        if (_delegate) {
            [_delegate selectedFacialView:str];
        }
    }
}

- (void)sendAction:(id)sender
{
    if (_delegate) {
        [_delegate sendFace];
    }
}

@end
