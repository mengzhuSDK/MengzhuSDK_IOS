//
//  MZRedPackagePresenter.h
//  MZKitDemo
//
//  Created by 李风 on 2021/6/21.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol  MZRedPackagePresenterProtocol<NSObject>
- (void)giveRedEnvelopePresenterCanSubmit;
- (void)giveRedEnvelopePresenterCanNotSubmit;

- (void)giveRedEnvelopePresenterShowAlertViewWithString:(NSString *)alertString;

- (void)giveRedEnvelopePresenterMoneyTextFieldIsLegal:(BOOL)isLegal;
- (void)giveRedEnvelopePresenterNumTextFieldIsLegal:(BOOL)isLegal;

@end

@interface MZRedPackagePresenter : NSObject

- (instancetype)initWithDelegate:(id<MZRedPackagePresenterProtocol>) delegate;

- (void)checkValidityWithMoney:(NSString *)moneyString :(NSString *)countString isMoneyTextField:(BOOL)isMoneyTF isRandom:(BOOL)isRandom;

@end

NS_ASSUME_NONNULL_END
