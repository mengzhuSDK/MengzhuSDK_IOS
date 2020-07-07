//
//  MZKitDemo
//
//  Created by 李风 on 2020/5/12.
//  Copyright © 2020 Apple. All rights reserved.
//

#ifndef MZCLUPnP_h
#define MZCLUPnP_h

#import "MZCLUPnPServer.h"
#import "MZCLUPnPRenderer.h"
#import "MZCLUPnPDevice.h"
#import "MZCLUPnPAVPositionInfo.h"

#ifdef DEBUG
#define CLLog(s, ... ) NSLog( @"[%@ in line %d] => %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define CLLog(s, ... )
#endif

//IPv4下的多播地址
static NSString *ssdpAddres = @"239.255.255.250";
//IPv4下的SSDP端口
static UInt16   ssdpPort = 1900;

static NSString *serviceType_AVTransport        = @"urn:schemas-upnp-org:service:AVTransport:1";
static NSString *serviceType_RenderingControl   = @"urn:schemas-upnp-org:service:RenderingControl:1";

static NSString *serviceId_AVTransport          = @"urn:upnp-org:serviceId:AVTransport";
static NSString *serviceId_RenderingControl     = @"urn:upnp-org:serviceId:RenderingControl";


static NSString *unitREL_TIME = @"REL_TIME";
static NSString *unitTRACK_NR = @"TRACK_NR";

#endif /* MZCLUPnP_h */
