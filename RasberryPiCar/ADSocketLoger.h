//
//  ADSocketLoger.h
//  ADRevealTools
//
//  Created by duzexu on 2017/3/10.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ADCommand) {
    ADCommandForward = 1,
    ADCommandBackward,
    ADCommandLeft,
    ADCommandRight,
    ADCommandTurnLeft,
    ADCommandTurnRight,
    ADCommandStop,
    ADCommandShutDown
};

@interface ADSocketLoger : NSObject

+ (instancetype)sharedLogger;
- (void)connectWithHost:(NSString *)host port:(NSString *)port;
- (void)sendCommand:(ADCommand)command;
- (void)sendCommandData:(NSData *)commond;

@end
