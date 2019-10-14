//
//  MZSocketIOClient.h
//  MengZhu
//
//  Created by vhall on 16/7/1.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol MZSocketIOClientDelegate <NSObject>

//- (void)didPptChange:(id)response;
//- (void)onCmdEvent:(id)response;

@end

typedef void(^socketCreatBlock)(BOOL);

@interface MZSocketIOClient : NSObject
@property (weak, nonatomic) id<MZSocketIOClientDelegate> delegate;
- (MZSocketIOClient*)initWithUrl:(NSString*)url socketToken:(NSString*)token;
-(void)sendSocketMessageWithEvent:(NSString *)event content:(NSArray *)content;
- (void)close;

@property (nonatomic ,copy)socketCreatBlock socketCreatBlock;
@end
