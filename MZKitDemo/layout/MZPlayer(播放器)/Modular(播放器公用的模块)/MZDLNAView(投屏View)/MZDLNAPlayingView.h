//
//  MZDLNAPlayingView.h
//  MZKitDemo
//
//  Created by 李风 on 2020/5/12.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MZDLNAControlTypePlay,
    MZDLNAControlTypePause,
    MZDLNAControlTypeChange,
    MZDLNAControlTypeExit,
} MZDLNAControlType;

typedef void(^MZDLNAControlBlock)(MZDLNAControlType type);

NS_ASSUME_NONNULL_BEGIN

@interface MZDLNAPlayingView : UIView

@property (nonatomic,   copy) NSString *title;

@property (nonatomic,   copy) MZDLNAControlBlock controlBlock;

@end

NS_ASSUME_NONNULL_END
