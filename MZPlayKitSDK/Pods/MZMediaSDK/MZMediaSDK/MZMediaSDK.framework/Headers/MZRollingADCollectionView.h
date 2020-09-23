//
//  MZRollingADCollectionView.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/9/10.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZRollingADModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MZRollingADCollectionViewProtocal<NSObject>
- (void)rollingADCollectionViewCurrentDisplayPageNumber:(NSInteger)pageNumber;
- (void)rollingADCollectionViewSelectedRollingADModel:(MZRollingADModel *)adModel;
- (void)rollingADCollectionViewPauseTimerForDragging;
- (void)rollingADCollectionViewStartTimerForEndDragging;
@end

@interface MZRollingADCollectionView : UICollectionView
@property (nonatomic,   weak) id<MZRollingADCollectionViewProtocal> pageDelegate;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

NS_ASSUME_NONNULL_END
