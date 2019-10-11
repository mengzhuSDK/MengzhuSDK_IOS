//
//  MZPlayerControlView.h
//  MZKitDemo
//
//  Created by Cage  on 2019/10/9.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MZPlayerControlViewProtocol <NSObject>

//
-(void)avatarDidClick:(id)playInfo;
-(void)reportButtonDidClick:(id)playInfo;
-(void)shareButtonDidClick:(id)playInfo;
-(void)likeButtonDidClick:(id)playInfo;
-(void)onlineListButtonDidClick:(id)playInfo;
-(void)shoppingBagDidClick:(id)playInfo;
//
-(void)attentionButtonDidClick:(id)playInfo;
-(void)closeButtonDidClick:(id)playInfo;
-(void)chatUserDidClick:(id)playInfo;


@end
@interface MZPlayerControlView : UIView

@property (nonatomic ,weak) id<MZPlayerControlViewProtocol> playerDelegate;

-(void)playVideoWithLiveIDString:(NSString *)liveString;
-(void)updateUIWithAvatarURLString:(NSString *)avatar name:(NSString *)name;
-(void)playerShutDown;
@end


