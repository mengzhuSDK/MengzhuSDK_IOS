//
//  MZVerticalPlayerViewController.h
//  MZKitDemo
//
//  Created by 李风 on 2020/6/17.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZVerticalPlayerViewController : UIViewController
@property (nonatomic ,copy) NSString *ticket_id;

@property (nonatomic ,copy) NSString *mvURLString;//下载到本地的视频播放地址

//@property (nonatomic ,copy) NSString *UID;
//@property (nonatomic ,copy) NSString *name;
//@property (nonatomic ,copy) NSString *avatar;
@end

NS_ASSUME_NONNULL_END
