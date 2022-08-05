#import "MZSIOSocket.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "mzsocket.io.js.h"
#import <CommonCrypto/CommonCrypto.h>

#ifdef __IPHONE_8_0
#import <WebKit/WebKit.h>
#endif

static MZSIOSocket *socket = nil;

static NSString *SIOMD5(NSString *string) {
    const char *cstr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (unsigned int)strlen(cstr), result);
    
    return [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
};

@interface MZSIOSocket ()

@property (nonatomic, strong) NSThread *thread;
@property WKWebView *javascriptWebView;
@property (readonly) JSContext *javascriptContext;

@end

@implementation MZSIOSocket

// Generators
+ (void)socketWithHost:(NSString *)hostURL Token:(NSString *)token response:(void (^)(MZSIOSocket *))response {
    // Defaults documented with socket.io-client: https://github.com/Automattic/socket.io-client
    return [self socketWithHost: hostURL
         reconnectAutomatically: YES
                   attemptLimit: -1
                      withDelay: 1
                   maximumDelay: 5
                        timeout: 20
                          Token: token
                       response: response];
}

+ (void)socketWithHost:(NSString *)hostURL reconnectAutomatically:(BOOL)reconnectAutomatically attemptLimit:(NSInteger)attempts withDelay:(NSTimeInterval)reconnectionDelay maximumDelay:(NSTimeInterval)maximumDelay timeout:(NSTimeInterval)timeout Token:(NSString *)token response:(void (^)(MZSIOSocket *))response {
    return [self socketWithHost: hostURL
         reconnectAutomatically: YES
                   attemptLimit: -1
                      withDelay: 1
                   maximumDelay: 5
                        timeout: 20
                 withTransports: @[ @"polling", @"websocket" ]
                          Token: token
                       response: response];
}

+ (void)socketWithHost:(NSString *)hostURL reconnectAutomatically:(BOOL)reconnectAutomatically attemptLimit:(NSInteger)attempts withDelay:(NSTimeInterval)reconnectionDelay maximumDelay:(NSTimeInterval)maximumDelay timeout:(NSTimeInterval)timeout withTransports:(NSArray*)transports Token:(NSString *)token response:(void (^)(MZSIOSocket *))response {
    socket = [[MZSIOSocket alloc] init];
    socket.isConnected = NO;
    if (!socket) {
        dispatch_async(dispatch_get_main_queue(), ^{
            response(nil);
        });
        return;
    }
    
    NSString *pre = @"UI";
    NSString *web = @"WebView";
    socket.javascriptWebView = [[NSClassFromString([NSString stringWithFormat:@"%@%@",pre,web]) alloc] init];
    [socket.javascriptContext setExceptionHandler: ^(JSContext *context, JSValue *errorValue) {
        NSLog(@"JSError: %@", errorValue);
        NSLog(@"%@", [NSThread callStackSymbols]);
    }];
    
    
    __weak typeof(socket) weakSocket = socket;
//    socket.javascriptContext[@"window"][@"onload"] = ^() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        weakSocket.thread = [NSThread currentThread];
        [weakSocket.javascriptContext evaluateScript: mz_socket_io_js];
        [weakSocket.javascriptContext evaluateScript: mz_blob_factory_js];
        
        NSString *socketConstructor = mz_socket_io_js_constructor(hostURL,
                                                                  reconnectAutomatically,
                                                                  attempts,
                                                                  reconnectionDelay,
                                                                  maximumDelay,
                                                                  timeout,
                                                                  transports,
                                                                  token
                                                                  );
        
        weakSocket.javascriptContext[@"objc_socket"] = [weakSocket.javascriptContext evaluateScript: socketConstructor];
        if (![weakSocket.javascriptContext[@"objc_socket"] toObject]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                socket.isConnected = NO;
                response(nil);
            });
        }
        
        // Responders
        weakSocket.javascriptContext[@"objc_onConnect"] = ^() {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                socket.isConnected = YES;
                response(socket);
                if (weakSocket.onConnect)
                    weakSocket.onConnect();
            });
        };
        
        weakSocket.javascriptContext[@"objc_onConnectError"] = ^(NSDictionary *errorDictionary) {
            dispatch_async(dispatch_get_main_queue(), ^{
                socket.isConnected = NO;
                response(errorDictionary);
                if (weakSocket.onConnectError)
                    weakSocket.onConnectError(errorDictionary);
            });
        };
        
        weakSocket.javascriptContext[@"objc_onDisconnect"] = ^() {
            dispatch_async(dispatch_get_main_queue(), ^{
                socket.isConnected = NO;
                response(nil);
                if (weakSocket.onDisconnect)
                    weakSocket.onDisconnect();
            });
        };
        
        weakSocket.javascriptContext[@"objc_onError"] = ^(NSDictionary *errorDictionary) {
            dispatch_async(dispatch_get_main_queue(), ^{
                socket.isConnected = NO;
                response(errorDictionary);
                if (weakSocket.onError)
                    weakSocket.onError(errorDictionary);
            });
        };
        
        weakSocket.javascriptContext[@"objc_onReconnect"] = ^(NSInteger numberOfAttempts) {
            dispatch_async(dispatch_get_main_queue(), ^{
                socket.isConnected = NO;
                if (weakSocket.onReconnect)
                    weakSocket.onReconnect(numberOfAttempts);
            });
        };
        
        weakSocket.javascriptContext[@"objc_onReconnectionAttempt"] = ^(NSInteger numberOfAttempts) {
            dispatch_async(dispatch_get_main_queue(), ^{
                socket.isConnected = NO;
                if (weakSocket.onReconnectionAttempt)
                    weakSocket.onReconnectionAttempt(numberOfAttempts);
            });
        };
        
        weakSocket.javascriptContext[@"objc_onReconnectionError"] = ^(NSDictionary *errorDictionary) {
            dispatch_async(dispatch_get_main_queue(), ^{
                socket.isConnected = NO;
                if (weakSocket.onReconnectionError)
                    weakSocket.onReconnectionError(errorDictionary);
            });
        };
        
        [weakSocket.javascriptContext evaluateScript: @"objc_socket.on('connect', objc_onConnect);"];
        [weakSocket.javascriptContext evaluateScript: @"objc_socket.on('error', objc_onError);"];
        [weakSocket.javascriptContext evaluateScript: @"objc_socket.on('disconnect', objc_onDisconnect);"];
        [weakSocket.javascriptContext evaluateScript: @"objc_socket.on('reconnect', objc_onReconnect);"];
        [weakSocket.javascriptContext evaluateScript: @"objc_socket.on('reconnecting', objc_onReconnectionAttempt);"];
        [weakSocket.javascriptContext evaluateScript: @"objc_socket.on('reconnect_error', objc_onReconnectionError);"];
//    };
});
    
    [socket.javascriptWebView loadHTMLString: @"<html/>" baseURL: nil];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        response(socket);
//    });
}

- (void)dealloc {

}

// Accessors
- (JSContext *)javascriptContext {
    return [socket.javascriptWebView valueForKeyPath: @"documentView.webView.mainFrame.javaScriptContext"];
}

// Event listeners
- (void)on:(NSString *)event callback:(void (^)(SIOParameterArray *args))function {
    NSString *eventID = SIOMD5(event);
    socket.javascriptContext[[NSString stringWithFormat: @"objc_%@", eventID]] = ^() {
        NSMutableArray *arguments = [NSMutableArray array];
        for (JSValue *object in [JSContext currentArguments]) {
            if ([object toObject]) {
                [arguments addObject: [object toObject]];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            function(arguments);
        });
    };
    
    NSString* script = [NSString stringWithFormat: @"objc_socket.on('%@', objc_%@);", event, eventID];
    [socket performSelector:@selector(evaluateScript:) onThread:socket.thread withObject:[script copy] waitUntilDone:NO];
}

// Emitters
- (void)emit:(NSString *)event {
    [socket emit: event args: nil];
}

- (void)emit:(NSString *)event args:(SIOParameterArray *)args {
    NSMutableArray *arguments = [NSMutableArray arrayWithObject: [NSString stringWithFormat: @"'%@'", event]];
    for (id arg in args) {
        if ([arg isKindOfClass: [NSNull class]]) {
            [arguments addObject: @"null"];
        }
        else if ([arg isKindOfClass: [NSString class]]) {
            [arguments addObject: [NSString stringWithFormat: @"'%@'", arg]];
        }
        else if ([arg isKindOfClass: [NSNumber class]]) {
            [arguments addObject: [NSString stringWithFormat: @"%@", arg]];
        }
        else if ([arg isKindOfClass: [NSData class]]) {
            NSString *dataString = [[NSString alloc] initWithData: arg encoding: NSUTF8StringEncoding];
            [arguments addObject: [NSString stringWithFormat: @"blob('%@')", dataString]];
        }
        else if ([arg isKindOfClass: [NSArray class]] || [arg isKindOfClass: [NSDictionary class]]) {
            if ([NSJSONSerialization isValidJSONObject:arg]) {
                [arguments addObject: [[NSString alloc] initWithData: [NSJSONSerialization dataWithJSONObject: arg options: 0 error: nil] encoding: NSUTF8StringEncoding]];
            } else {
                NSLog(@"SIOSocket serialization error at %@", NSStringFromSelector(_cmd));
            }
        }
    }
    
    NSString* script = [NSString stringWithFormat: @"objc_socket.emit(%@);", [arguments componentsJoinedByString: @", "]];
    [socket performSelector:@selector(evaluateScript:) onThread:socket.thread withObject:[script copy] waitUntilDone:NO];
}

- (void)evaluateScript:(NSString *)script {
    [socket.javascriptContext evaluateScript:script];
}

- (void)close {
//    [socket.javascriptWebView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString:@"about:blank"]]];
    [socket.thread cancel];
    socket.thread = nil;
//    [socket.javascriptWebView reload];
    socket.javascriptWebView = nil;
    socket = nil;
}

@end
