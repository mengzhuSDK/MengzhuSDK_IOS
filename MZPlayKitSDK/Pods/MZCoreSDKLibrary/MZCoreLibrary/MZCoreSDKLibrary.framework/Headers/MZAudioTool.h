//
//  MZAudioTool.h
//  MZCoreSDKLibrary
//
//  Created by 李风 on 2020/9/28.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, MZAlertSoundType) {
    MZAlertSoundTypeMute = 1,             // 静音
    MZAlertSoundTypeRingtone,             // 铃声
    MZAlertSoundTypeShock,                // 震动
    MZAlertSoundTypeBlend,                // 混合（震动+铃声）
};


@interface MZAudioTool : NSObject

/// 播放 铃声 soundID为空，传nil，就会自动创建一个soundID返回
+ (SystemSoundID)playSoundType:(MZAlertSoundType)alertSoundType soundID:(SystemSoundID)soundID;

/// 停止播放铃声
+ (void)stopSystemSound:(SystemSoundID)soundID;

/// 播放震动
+ (void)playShock;

@end

NS_ASSUME_NONNULL_END
