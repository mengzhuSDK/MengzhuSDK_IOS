//
//  MZFaceKeyboard.h
//  MZKitDemo
//
//  Created by 李风 on 2020/8/18.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MZFaceKeyboardDelegate <NSObject>

@optional
- (void)selectedFacialView:(NSString *)str;
- (void)deleteSelected:(NSString * _Nullable)str;
- (void)sendFace;

@end

@interface MZFaceKeyboard : UIView

@property (nonatomic,   weak) id<MZFaceKeyboardDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *faces;//表情数组

@property (strong, nonatomic) NSDictionary *faceDic;//表情字典

-(void)loadFacialView:(int)page size:(CGSize)size;

-(void)loadFaceWithPageIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
