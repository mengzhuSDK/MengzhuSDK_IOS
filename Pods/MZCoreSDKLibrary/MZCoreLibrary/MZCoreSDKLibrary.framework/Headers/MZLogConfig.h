//
//  MZCommentConfig.h
//  mengzhuIOS
//
//  Created by 孙显灏 on 2019/6/20.
//  Copyright © 2019 孙显灏. All rights reserved.
//

#ifndef MZLogConfig_h
#define MZLogConfig_h


#ifdef DEBUG // 调试状态, 打开LOG功能
#define NSLog(...) NSLog(__VA_ARGS__)
#else // 发布状态, 关闭LOG功能
#define NSLog(...)
#endif

#ifdef DEBUG // 调试状态, 打开LOG功能
# define MZLog(fmt, ...)   NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else  // 发布状态, 关闭LOG功能
# define MZLog(...);
#endif /* MZCommentConfig_h */
#endif
