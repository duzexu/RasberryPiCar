//
//  ADSocketLoger.m
//  ADRevealTools
//
//  Created by duzexu on 2017/3/10.
//
//

#import "ADSocketLoger.h"
#import "GCDAsyncSocket.h"

@interface ADSocketLoger ()<GCDAsyncSocketDelegate> {
    NSString *_host;
    NSString *_port;
}
@property (strong, nonatomic) GCDAsyncSocket *clientSocket;
@end

@implementation ADSocketLoger

+ (instancetype)sharedLogger {
    static dispatch_once_t onceToken;
    static ADSocketLoger *logger = nil;
    dispatch_once(&onceToken, ^{
        logger = [[self alloc] init];
    });
    return logger;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

- (void)dealloc {
    [self.clientSocket disconnect];
}

- (void)connectWithHost:(NSString *)host port:(NSString *)port {
    if (!self.clientSocket.isConnected) {
        _host = host;
        _port = port;
        [self.clientSocket connectToHost:host onPort:port.integerValue error:nil];
    }
}

- (void)reconect {
    [self connectWithHost:_host port:_port];
}

- (void)sendCommand:(ADCommond)commond {
    NSString *data;
    switch (commond) {
        case ADCommondForward:
            data = @"forward";
            break;
        case ADCommondBackward:
            data = @"backward";
            break;
        case ADCommondLeft:
            data = @"left";
            break;
        case ADCommondRight:
            data = @"right";
            break;
        case ADCommondTurnLeft:
            data = @"turn_left";
            break;
        case ADCommondTurnRight:
            data = @"turn_right";
            break;
        case ADCommondStop:
            data = @"stop";
            break;
        case ADCommondShutDown:
            data = @"shutdown";
            break;
        default:
        break;
    }
    
    [self.clientSocket writeData:[data dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}

- (void)sendCommandData:(NSData *)commond {
    [self.clientSocket writeData:commond withTimeout:-1 tag:1];
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    [self performSelector:@selector(reconect) withObject:nil afterDelay:5];
}

@end
