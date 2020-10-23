//
//  NSObject+MZTimer.h
//  MZCoreSDKLibrary
//
//  Created by 李风 on 2020/9/27.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 @brief 时间定时器，可以自动屏蔽循环引用的问题
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MZTimer)

/**
    启动定时器，避免重复引用的问题
 
    @param  observer            跟定时器绑定的观察的对象（观察的对象销毁的时候,定时器也销毁）
    @param  timeInterval        每次事件的间隔（秒）
    @param  handle              创建的定时器的回调（dispatch_source_t timer）
 */
- (void)dispatchTimer:(id)observer timeInterval:(NSTimeInterval)timeInterval handle:(void(^)(dispatch_source_t timer))handle;

/**
    启动定时器，避免重复引用的问题
 
    @param  observer          跟定时器绑定的观察的对象（观察的对象销毁的时候,定时器也销毁）
    @param  timeInterval      每次事件的间隔（秒）
    @param  selector          定时器定时执行的方法
 */
- (void)addTimer:(id)observer timeInterval:(NSTimeInterval)timeInterval selector:(SEL)selector ;

@end

NS_ASSUME_NONNULL_END
