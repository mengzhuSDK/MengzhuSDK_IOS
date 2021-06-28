//
//  MZSDKConfig.h
//  MZKitDemo
//
//  Created by 李风 on 2020/9/28.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#ifndef MZSDKConfig_h
#define MZSDKConfig_h

/// SDK的测试环境还是正式环境，1=测试环境，0=正式环境，无特殊情况下请使用正式环境
#define MZ_is_debug 0//切换测试环境和正式环境

#if MZ_is_debug

#define MZSDK_AppID @""
#define MZSDK_SecretKey @""
#define MZSDK_ChannelId @""//此值只有推流才使用

#else

#define MZSDK_AppID @"2020121810103437745"
#define MZSDK_SecretKey @"x6Kfsjsx89f1fcumHUVsd0u7u1z4EDjdx9d2jWsh9bB8EH70i9IYfeA79WV7WHH1"
#define MZSDK_ChannelId @"2443981"//此值只有推流才使用

#endif

#endif /* MZSDKConfig_h */
