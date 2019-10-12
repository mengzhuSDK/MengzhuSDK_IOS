//
//  MZPopView.h
//  MZKitDemo
//
//  Created by Cage  on 2019/9/28.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum {
    MZPopViewKickOut,
    MZPopViewReport
}MZPopViewType;
typedef void(^MZPopViewClickBlock)(id info);

@interface MZPopView : UIView
@property (nonatomic,assign) MZPopViewType viewType;
@property (nonatomic ,copy) MZPopViewClickBlock clickBlock;
@end

NS_ASSUME_NONNULL_END
