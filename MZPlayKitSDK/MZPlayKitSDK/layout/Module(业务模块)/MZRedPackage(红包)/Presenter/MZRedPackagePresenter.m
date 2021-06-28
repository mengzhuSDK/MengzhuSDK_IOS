//
//  MZRedPackagePresenter.m
//  MZKitDemo
//
//  Created by 李风 on 2021/6/21.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import "MZRedPackagePresenter.h"

@interface MZRedPackagePresenter()
@property (nonatomic ,weak) id<MZRedPackagePresenterProtocol> delegate;
@end

@implementation MZRedPackagePresenter

- (instancetype)initWithDelegate:(id<MZRedPackagePresenterProtocol>) delegate {
    if (self == [super init]) {
        self.delegate = delegate;
    }
    return self;
}

- (void)checkValidityWithMoney:(NSString *)moneyString :(NSString *)countString isMoneyTextField:(BOOL)isMoneyTF isRandom:(BOOL)isRandom
{
//    区分0 和 未输入
    if (moneyString.length == 0) {
//        未输入
        moneyString = @"-1";
    }
    if (countString.length == 0) {
        countString = @"-1";
    }
    double money = [moneyString doubleValue];
    NSInteger count = [countString integerValue];
    
    if (isMoneyTF) {
        //    金额判断
        [self checkValidityForMoneyTextFieldWithMoney:money :count isRandom:isRandom];
        
    }else{
        //    个数判断
        [self checkValidityForNumTextFieldWithMoney:money :count isRandom:isRandom];
        
        
    }

}
- (void)checkValidityForMoneyTextFieldWithMoney:(double)money :(NSInteger)count isRandom:(BOOL)isRandom
{
    if(!isRandom && money * count > 50000.00){
        [self numLegal:YES];
        [self moneyLegal:NO];
        [self showRedViewWith:@"单次支付总额不可超过50000元"];
        
    }else{
        if (money > 50000.00) {
            [self numLegal:YES];
            [self moneyLegal:NO];
            [self showRedViewWith:@"单次支付总额不可超过50000元"];
        }else {
            if(!isRandom){
                if(money *count > 50000.00){
                    [self numLegal:YES];
                    [self moneyLegal:NO];
                    [self showRedViewWith:@"单次支付总额不可超过50000元"];
                }
            }
            [self moneyLegal:YES];
            if (money == -1) {
                if(count > 2000){
                    // 个数优先级最高 不需要再考虑金额
                    [self numLegal:NO];
                    [self showRedViewWith:@"一次最多发2000个红包"];
                }else{
                    [self numLegal:YES];
                    [self showRedViewWith:nil];
                }
            }else{
                //      0~50000  money 可能是0
                // 有数量  count不能仅输入0
                if(count > 2000){
                    // 个数优先级最高 不需要再考虑金额
                    [self numLegal:NO];
                    [self showRedViewWith:@"一次最多发2000个红包"];
                }else{
                    if (count == -1) {
                        // count为空
                        [self moneyLegal:YES];
                        [self numLegal:YES];
                        [self showRedViewWith:nil];
                    }else{
                        double singleMoney = isRandom ? money / (count * 1.0):money;
                        NSLog(@"singleMoney: %f",singleMoney);
                        NSLog(@"moneyaaa: %f",fabs(singleMoney));

                        if(singleMoney > 200.00){
                            [self moneyLegal:NO];
                            [self numLegal:NO];
                            [self showRedViewWith:@"单个红包金额不可超过200元"];
                        }else if(singleMoney < 0.01){
                            
                            [self moneyLegal:NO];
                            [self numLegal:NO];
                            [self showRedViewWith:@"单个红包金额不可低于0.01元"];
                        }else {
                            [self moneyLegal:YES];
                            [self numLegal:YES];
                            [self showRedViewWith:nil];
                        }
                        
                        
                    }
                }
            }
            
            
        }
    }
    
}
- (void)checkValidityForNumTextFieldWithMoney:(double)money :(NSInteger)count isRandom:(BOOL)isRandom
{
    //            单独判断 个数
    if (count > 2000) {
        [self moneyLegal:YES];
        [self numLegal:NO];
        [self showRedViewWith:@"一次最多发2000个红包"];
    }else{
        [self numLegal:YES];
        if (count == -1) {
            //        0~500
            if (money > 50000.00) {
                [self moneyLegal:NO];
                [self showRedViewWith:@"单次支付总额不可超过50000元"];
            }else {
                [self moneyLegal:YES];
                [self numLegal:YES];
                [self showRedViewWith:nil];
            }
        }else{
            if(!isRandom && money *count > 50000.00){
                [self moneyLegal:NO];
                [self showRedViewWith:@"单次支付总额不可超过50000元"];
            }else{
                if (money > 50000.00) {
                    [self moneyLegal:NO];
                    [self showRedViewWith:@"单次支付总额不可超过50000元"];
                }else {
                    if (money == -1) {
                        [self moneyLegal:YES];
                        [self numLegal:YES];
                        [self showRedViewWith:nil];
                    }else{
                        double singleMoney = isRandom ? money / (count * 1.0):money;
                        if(singleMoney > 200.00){
                            [self moneyLegal:NO];
                            [self numLegal:NO];
                            [self showRedViewWith:@"单个红包金额不可超过200元"];
                        }else if(singleMoney < 0.01){
                            
                            [self moneyLegal:NO];
                            [self numLegal:NO];
                            [self showRedViewWith:@"单个红包金额不可低于0.01元"];
                        }else {
                            [self moneyLegal:YES];
                            [self numLegal:YES];
                            [self showRedViewWith:nil];
                        }
                    }
                }
            }
        }
        
        
        
    }
    
}
- (void)numLegal:(BOOL)legal{
    if(self.delegate && [self.delegate respondsToSelector:@selector(giveRedEnvelopePresenterNumTextFieldIsLegal:)]){
        if (legal) {
            [self.delegate giveRedEnvelopePresenterNumTextFieldIsLegal:YES];
        }else{
            [self.delegate giveRedEnvelopePresenterNumTextFieldIsLegal:NO];
        }
    }
}
- (void)moneyLegal:(BOOL)legal{
    if(self.delegate && [self.delegate respondsToSelector:@selector(giveRedEnvelopePresenterMoneyTextFieldIsLegal:)]){
        if (legal) {
            [self.delegate giveRedEnvelopePresenterMoneyTextFieldIsLegal:YES];
        }else{
            [self.delegate giveRedEnvelopePresenterMoneyTextFieldIsLegal:NO];
        }
    }
}
- (void)showRedViewWith:(NSString *)alertString{
    if(self.delegate && [self.delegate respondsToSelector:@selector(giveRedEnvelopePresenterShowAlertViewWithString:)]){
        [self.delegate giveRedEnvelopePresenterShowAlertViewWithString:alertString];
    }
}

@end
