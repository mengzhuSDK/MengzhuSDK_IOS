//
//  MZTopLeftLabel.m
//  MengZhu
//
//  Created by vhall.com on 2017/12/14.
//  Copyright © 2017年 www.mengzhu.com. All rights reserved.
//

#import "MZTopLeftLabel.h"

@implementation MZTopLeftLabel

- (id)initWithFrame:(CGRect)frame {
    
    return [super initWithFrame:frame];
    
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    
    textRect.origin.y = bounds.origin.y;
    
    return textRect;
    
}

-(void)drawTextInRect:(CGRect)requestedRect {
    
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    
    [super drawTextInRect:actualRect];
    
}

@end
