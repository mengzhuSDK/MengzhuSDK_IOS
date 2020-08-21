//
//  MZCustomTapRecognizer.h
//  MZKitDemo
//
//  Created by LiWei on 2019/9/26.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZCustomTapRecognizer : UITapGestureRecognizer
@property(nonatomic,strong) NSString *focus_id;
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *fullName;
@property(nonatomic,strong) id tagID;
@end

NS_ASSUME_NONNULL_END
