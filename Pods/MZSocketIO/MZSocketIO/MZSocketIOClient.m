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

        [MZSIOSocket socketWithHost:URLString Token:token response: ^(MZSIOSocket *socket) {
            self.socketIO = socket;
            if (self.socketIO) {
                NSLog(@"SocketIO 链接成功 %@ %@",URLString,token);
                creatResult(YES);
            }
            else{
                NSLog(@"SocketIO 链接失败 %@ %@",URLString,token);
                creatResult(NO);
            }
        }];
    }
    return self;
}

/// 发送事件
- (void)sendSocketMessageWithEvent:(NSString *)event content:(NSArray *)content {
    if (self.socketIO) {
        [self.socketIO emit:event args:content];
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
