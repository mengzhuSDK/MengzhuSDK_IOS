//
//  MZKitDemo
//
//  Created by 李风 on 2020/5/12.
//  Copyright © 2020 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZCLUPnPAVPositionInfo : NSObject

@property (nonatomic, assign) float trackDuration;
@property (nonatomic, assign) float absTime;
@property (nonatomic, assign) float relTime;

- (void)setArray:(NSArray *)array;

@end


@interface MZCLUPnPTransportInfo : NSObject

@property (nonatomic, copy) NSString *currentTransportState;
@property (nonatomic, copy) NSString *currentTransportStatus;
@property (nonatomic, copy) NSString *currentSpeed;

- (void)setArray:(NSArray *)array;

@end


@interface NSString(UPnP)

+(NSString *)stringWithDurationTime:(float)timeValue;
- (float)durationTime;

@end
