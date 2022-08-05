//
//  MZSocketIOClient.m
//  MengZhu
//
//  Created by vhall on 16/7/1.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import "MZSocketIOClient.h"
#import "MZSIOSocket.h"

typedef void(^MZSocketCreatBlock)(BOOL);

@interface MZSocketIOClient()
@property(nonatomic,strong) MZSIOSocket *socketIO;//SocketIO

@property(nonatomic,assign) BOOL isFirstSend;
@end

@implementation MZSocketIOClient

- (void)dealloc {
    self.socketIO = nil;
//    NSLog(@"dealloc MZSocketIOClient");
}

- (MZSocketIOClient *)initWithURLString:(NSString*)URLString socketToken:(NSString*)token creatResult:(void(^)(BOOL result))creatResult {
    self = [super init];
    if (self) {
        URLString = [NSString stringWithFormat:@"%@?",URLString];
        self.isFirstSend = YES;

        [MZSIOSocket socketWithHost:URLString Token:token response: ^(MZSIOSocket *socket) {
            if ([socket isKindOfClass:[MZSIOSocket class]]) {
                self.socketIO = socket;
                NSLog(@"SocketIO 链接成功 %@", socket);
                creatResult(YES);
            }
            else{
                self.socketIO = nil;
                self.isFirstSend = YES;
                NSLog(@"SocketIO 链接失败 %@", socket);
                creatResult(NO);
            }
        }];
    }
    return self;
}

/// 发送事件
- (void)sendSocketMessageWithEvent:(NSString *)event content:(NSArray *)content {
    if (self.socketIO && self.socketIO.isConnected == YES) {
        if (self.isFirstSend == YES) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.isFirstSend = NO;
                NSLog(@"SocketIO 是链接状态， 发送 %@ 事件", event);
                [self.socketIO emit:event args:content];
            });
        } else {
            NSLog(@"SocketIO 是链接状态， 发送 %@ 事件", event);
            [self.socketIO emit:event args:content];
        }
    }
}

- (void)close {
    if (self.socketIO) {
        [self.socketIO close];
        self.socketIO = nil;
//        NSLog(@"SocketIO 断开链接");
    }
}

@end
