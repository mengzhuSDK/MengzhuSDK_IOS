//
//  MZKitDemo
//
//  Created by 李风 on 2020/5/12.
//  Copyright © 2020 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MZCLUPnPServiceType) {
    MZCLUPnPServiceAVTransport,       // @"urn:schemas-upnp-org:service:AVTransport:1"
    MZCLUPnPServiceRenderingControl,  // @"urn:schemas-upnp-org:service:RenderingControl:1"
};

@class MZCLUPnPDevice;
@interface MZCLUPnPAction : NSObject

// serviceType 默认 MZCLUPnPServiceAVTransport
@property (nonatomic, assign) MZCLUPnPServiceType serviceType;

- (instancetype)initWithAction:(NSString *)action;

- (void)setArgumentValue:(NSString *)value forName:(NSString *)name;

- (NSString *)getServiceType;

- (NSString *)getSOAPAction;

- (NSString *)getPostUrlStrWith:(MZCLUPnPDevice *)model;

- (NSString *)getPostXMLFile;

@end
