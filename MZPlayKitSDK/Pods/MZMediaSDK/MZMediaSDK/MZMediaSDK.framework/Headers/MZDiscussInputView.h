//
//  MZDiscussInputView.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/8/20.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZDiscussInputView : UIView

@property (nonatomic, strong) UIButton *isAnonymousButton;//是否匿名的button
@property (nonatomic, strong) UITextField *discussTF;//输入的textField
@property (nonatomic, strong) UIButton *sendButton;//提问按钮

@property (nonatomic, assign) int inputMaxWord;//问题可输入最大字数

- (instancetype)initWithFrame:(CGRect)frame sendHandle:(void(^)(BOOL isAnonymous, NSString *question))sendHandle;

@end

NS_ASSUME_NONNULL_END
