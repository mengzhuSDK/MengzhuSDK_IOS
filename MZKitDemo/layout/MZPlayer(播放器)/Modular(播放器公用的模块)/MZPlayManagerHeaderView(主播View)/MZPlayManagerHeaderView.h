//
//  MZPlayManagerHeaderView.h
//  MZKitDemo
//
//  Created by 李风 on 2020/5/14.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZPlayManagerHeaderView : UIView

@property (nonatomic, assign) BOOL isLive;//（是否是直播）直播/回放

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *numStr;
@property (nonatomic, strong) void(^clickBlock)(void);
@property (nonatomic, strong) void(^attentionClickBlock)(void);

@property (nonatomic, strong) UIButton *headerBtn;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UIButton *subBtn;
@property (nonatomic, strong) UIButton *attentionBtn;

@end

NS_ASSUME_NONNULL_END
